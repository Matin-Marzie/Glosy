import { createContext, useState, useEffect, useContext, useCallback, useRef, useMemo } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { getDictionaryByCodes } from '../api/dictionary';
import { normalizeWord } from '../utils/wordNormalizer';
import { useProgress } from './ProgressContext';
import { useNetwork } from './NetworkContext';
import { useAuth } from './AuthContext';

const DICTIONARY_TTL = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds
const DICTIONARY_CACHE_PREFIX = 'dictionary:';

// The API (and the cache, which stores the raw API response) sends `words`
// as columnar JSON ({ columns, rows }) to avoid repeating the same keys
// across ~11k word objects. Expand it back to row objects once here so
// every other consumer (Wordle, WordOfWonders, VocabularySearchField, etc.)
// can keep reading `word.written_form` etc. as before.
function expandColumnarWords(words) {
  if (!words || Array.isArray(words)) return words ?? [];
  const { columns, rows } = words;
  if (!Array.isArray(columns) || !Array.isArray(rows)) return [];
  return rows.map((row) => {
    const obj = {};
    for (let i = 0; i < columns.length; i++) obj[columns[i]] = row[i];
    return obj;
  });
}

function expandDictionaryPayload(raw) {
  if (!raw) return raw;
  return { ...raw, words: expandColumnarWords(raw.words) };
}

/**
 * @typedef {Object} DictionaryContextType
 * @property {Object|null} dictionary - The dictionary data
 * @property {boolean} dictionaryLoading - Whether dictionary is loading
 * @property {string|null} dictionaryError - Error message if any
 * @property {(writtenForm: string) => Object[]} getWordsByWrittenForm - looks up dictionary word entries by written_form (normalized per the current learning language before hashing/comparing); homographs come back together in one array - disambiguate by id
 * @property {(learningCode: string, nativeCode: string) => Promise<Object|null>} fetchDictionary - Manual fetch function, returns dictionary data
 * @property {(learningCode: string, nativeCode: string) => Promise<boolean>} prefetchDictionary - Loads a pair's dictionary into memory (from a fresh cache or the network) without changing the current dictionary; resolves false if it couldn't be loaded
 * @property {() => void} clearDictionary - Drops the current dictionary (and shows loading) so it can be garbage collected before the next one is applied
 * @property {(learningCode: string, nativeCode: string) => boolean} applyPrefetchedDictionary - Synchronously makes a prefetched dictionary the current one - call it in the same synchronous block as the userProgress/vocabulary updates so they render together
 * @property {() => Promise<void>} reload - Reload current dictionary
 */

/** @type {import('react').Context<DictionaryContextType>} */
const DictionaryContext = createContext({});

export const DictionaryProvider = ({ children }) => {
  const { userProgress } = useProgress();
  const { isOnline } = useNetwork();
  const { hasCompletedOnboarding } = useAuth();

  const [dictionary, setDictionary] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const requestIdRef = useRef(0);

  // Dictionaries loaded by prefetchDictionary, keyed by cache key:
  // { raw, expanded, timestamp, fromCache }. Consumed by
  // applyPrefetchedDictionary (or fetchDictionary) so the same dictionary is
  // never downloaded, read or expanded twice.
  const prefetchedRef = useRef({});

  // The dictionary currently shown: { cacheKey, timestamp, expanded }. Lets
  // fetchDictionary skip pairs that are already loaded and fresh - otherwise
  // every re-run of the auto-fetch effect (isOnline flipping, onboarding
  // finishing, a language switch that already applied its dictionary)
  // re-read and re-expanded the whole multi-MB cache into a new object, and
  // every screen rebuilt its ~11k-word indexes for identical data.
  const loadedRef = useRef(null);

  const showDictionary = useCallback((cacheKey, expanded, timestamp) => {
    loadedRef.current = { cacheKey, timestamp, expanded };
    setDictionary(expanded);
  }, []);

  // Derive current language from userProgress
  const currentLang = useMemo(() => {
    return userProgress?.languages?.find(l => l.is_current_language) || null;
  }, [userProgress?.languages]);

  // Generate cache key for current language pair
  const getCacheKey = useCallback((learningCode, nativeCode) => {
    return `${DICTIONARY_CACHE_PREFIX}${learningCode}:${nativeCode}`;
  }, []);

  // Cache in the background - writing a multi-MB value is slow and
  // AsyncStorage runs one operation at a time, so awaiting it kept the UI
  // loading (and queued every other AsyncStorage call behind it) after the
  // dictionary had already arrived. A failed write (e.g. size limits on
  // Android) must not throw away a good response either.
  const writeCache = useCallback((cacheKey, res) => {
    const payload = {
      data: res,
      timestamp: Date.now(),
    };
    AsyncStorage.setItem(cacheKey, JSON.stringify(payload))
      // Only one pair's dictionary is kept on the phone - the old one stays
      // until the new one is safely stored, then it's removed
      .then(async () => {
        const keys = await AsyncStorage.getAllKeys();
        const oldKeys = keys.filter((k) => k.startsWith(DICTIONARY_CACHE_PREFIX) && k !== cacheKey);
        if (oldKeys.length > 0) await AsyncStorage.multiRemove(oldKeys);
      })
      .catch((e) => {
        console.warn('[Dictionary] Cache write failed:', e);
      });
  }, []);

  // Core fetch function - can be called with explicit codes or uses currentLang
  // Returns the dictionary data (or null if failed)
  const fetchDictionary = useCallback(async (learningCode, nativeCode) => {
    if (!learningCode || !nativeCode) return null;

    const cacheKey = getCacheKey(learningCode, nativeCode);

    // --- Already showing this pair, still fresh: nothing to do ---
    const loaded = loadedRef.current;
    if (loaded?.cacheKey === cacheKey && Date.now() - loaded.timestamp < DICTIONARY_TTL) {
      return loaded.expanded;
    }

    setLoading(true);
    setError(null);

    const currentRequestId = ++requestIdRef.current;

    // --- Already loaded by prefetchDictionary ---
    const prefetched = prefetchedRef.current[cacheKey];
    if (prefetched) {
      delete prefetchedRef.current[cacheKey];
      if (requestIdRef.current === currentRequestId) {
        showDictionary(cacheKey, prefetched.expanded, prefetched.timestamp);
        setLoading(false);
      }
      if (!prefetched.fromCache) writeCache(cacheKey, prefetched.raw);
      return prefetched.expanded;
    }

    // --- Read cache safely ---
    let cached = null;
    try {
      const cachedStr = await AsyncStorage.getItem(cacheKey);
      cached = cachedStr ? JSON.parse(cachedStr) : null;
    } catch (e) {
      console.warn('[Dictionary] Cache parse failed:', e);
    }

    // --- Fresh cache: return early ---
    if (cached?.timestamp && Date.now() - cached.timestamp < DICTIONARY_TTL) {
      const expanded = expandDictionaryPayload(cached.data);
      if (requestIdRef.current === currentRequestId) {
        showDictionary(cacheKey, expanded, cached.timestamp);
        setLoading(false);
      }
      return expanded;
    }

    // --- Offline strategy ---
    if (!isOnline) {
      const expanded = cached?.data ? expandDictionaryPayload(cached.data) : null;
      if (requestIdRef.current === currentRequestId) {
        if (expanded) showDictionary(cacheKey, expanded, cached.timestamp);
        setLoading(false);
      }
      return expanded;
    }

    // --- Use stale cache while fetching ---
    if (cached?.data && requestIdRef.current === currentRequestId) {
      showDictionary(cacheKey, expandDictionaryPayload(cached.data), cached.timestamp);
    }

    try {
      const res = await getDictionaryByCodes(learningCode, nativeCode);

      // Race-condition guard
      if (requestIdRef.current !== currentRequestId) return null;

      console.log(`[Dictionary] Fetched ${learningCode}-${nativeCode}`);
      const expanded = expandDictionaryPayload(res);
      showDictionary(cacheKey, expanded, Date.now());
      writeCache(cacheKey, res);
      return expanded;
    } catch (err) {
      if (requestIdRef.current !== currentRequestId) return null;
      setError(err.message);
      return null;
    } finally {
      if (requestIdRef.current === currentRequestId) {
        setLoading(false);
      }
    }
  }, [getCacheKey, isOnline, writeCache, showDictionary]);

  // Used before switching the current language, so a failed download can
  // abort the switch while the current language and dictionary are untouched
  const prefetchDictionary = useCallback(async (learningCode, nativeCode) => {
    if (!learningCode || !nativeCode) return false;

    const cacheKey = getCacheKey(learningCode, nativeCode);
    if (prefetchedRef.current[cacheKey]) return true;

    // Expanded here, while the caller is still showing its spinner, so
    // applying it later is just a state update
    try {
      const cachedStr = await AsyncStorage.getItem(cacheKey);
      const cached = cachedStr ? JSON.parse(cachedStr) : null;
      if (cached?.timestamp && Date.now() - cached.timestamp < DICTIONARY_TTL) {
        prefetchedRef.current[cacheKey] = {
          raw: cached.data,
          expanded: expandDictionaryPayload(cached.data),
          timestamp: cached.timestamp,
          fromCache: true,
        };
        return true;
      }
    } catch (e) {
      console.warn('[Dictionary] Cache read failed:', e);
    }

    try {
      const res = await getDictionaryByCodes(learningCode, nativeCode);
      console.log(`[Dictionary] Fetched ${learningCode}-${nativeCode} (prefetch)`);
      prefetchedRef.current[cacheKey] = {
        raw: res,
        expanded: expandDictionaryPayload(res),
        timestamp: Date.now(),
        fromCache: false,
      };
      return true;
    } catch (err) {
      console.warn('[Dictionary] Prefetch failed:', err);
      return false;
    }
  }, [getCacheKey]);

  // Step 1 of a language switch: drop every reference this context holds to
  // the current dictionary, so once screens re-render with no dictionary
  // (a cheap render - nothing to index or list) the old words and every index
  // built from them can be garbage collected BEFORE the next dictionary is
  // applied. Applying the new one directly meant both dictionaries and both
  // sets of indexes were alive at once, which pushed the JS heap to its limit
  // and froze the app in back-to-back garbage collections.
  const clearDictionary = useCallback(() => {
    // Drop any in-flight fetch so it can't put a dictionary back
    requestIdRef.current++;
    loadedRef.current = null;
    setDictionary(null);
    setLoading(true);
    setError(null);
  }, []);

  const applyPrefetchedDictionary = useCallback((learningCode, nativeCode) => {
    const cacheKey = getCacheKey(learningCode, nativeCode);
    const prefetched = prefetchedRef.current[cacheKey];
    if (!prefetched) return false;

    delete prefetchedRef.current[cacheKey];
    // Drop any in-flight fetch for the old pair so it can't overwrite this
    requestIdRef.current++;
    showDictionary(cacheKey, prefetched.expanded, prefetched.timestamp);
    setLoading(false);
    setError(null);
    if (!prefetched.fromCache) writeCache(cacheKey, prefetched.raw);
    return true;
  }, [getCacheKey, showDictionary, writeCache]);

  // Reload function - refetches using current language
  const reload = useCallback(async () => {
    if (!currentLang) return;
    loadedRef.current = null; // force a real refetch
    await fetchDictionary(
      currentLang.learning_language.code,
      currentLang.native_language.code
    );
  }, [currentLang, fetchDictionary]);

  // Auto-fetch when current language changes (only if onboarding is completed)
  useEffect(() => {
    if (hasCompletedOnboarding && currentLang) {
      fetchDictionary(
        currentLang.learning_language.code,
        currentLang.native_language.code
      );
    }
  }, [
    hasCompletedOnboarding,
    currentLang?.learning_language?.code,
    currentLang?.native_language?.code,
    fetchDictionary,
  ]);

  // Bucket dictionary words by written_form (normalized per the current
  // learning language via utils/wordNormalizer.js - trim/case/diacritics
  // don't matter for identity) so string lookups (e.g. resolving the word
  // tapped in a reel subtitle, or a Wordle/WordOfWonders guess) are O(1)
  // instead of scanning the full ~11k-word list. Homographs (same
  // written_form, different word id - e.g. different meaning/POS) share a
  // bucket; callers with a known id should disambiguate within it.
  // Normalized per the dictionary's OWN language, not the current language
  // from userProgress - they change at different moments during a switch,
  // and keying on userProgress rebuilt the buckets for the old dictionary
  // under the new language's rules (wasted work) right before rebuilding
  // them again for the new one.
  const learningLanguageCode = dictionary?.language_code ?? currentLang?.learning_language?.code;

  const writtenFormBuckets = useMemo(() => {
    const map = Object.create(null);
    const words = dictionary?.words;
    if (!Array.isArray(words)) return map;

    for (const item of words) {
      const key = normalizeWord(item?.written_form, learningLanguageCode);
      if (!key) continue;
      if (!map[key]) map[key] = [];
      map[key].push(item);
    }

    return map;
  }, [dictionary, learningLanguageCode]);

  const getWordsByWrittenForm = useCallback((writtenForm) => {
    return writtenFormBuckets[normalizeWord(writtenForm, learningLanguageCode)] ?? [];
  }, [writtenFormBuckets, learningLanguageCode]);

  const value = useMemo(() => ({
    dictionary,
    dictionaryLoading: loading,
    dictionaryError: error,
    getWordsByWrittenForm,
    fetchDictionary,
    prefetchDictionary,
    clearDictionary,
    applyPrefetchedDictionary,
    reload,
  }), [dictionary, loading, error, getWordsByWrittenForm, fetchDictionary, prefetchDictionary, clearDictionary, applyPrefetchedDictionary, reload]);

  return (
    <DictionaryContext.Provider value={value}>
      {children}
    </DictionaryContext.Provider>
  );
};

// Custom hook to use the DictionaryContext
export const useDictionaryContext = () => {
  const context = useContext(DictionaryContext);
  if (!context) {
    throw new Error('useDictionaryContext must be used within a DictionaryProvider');
  }
  return context;
};

export default DictionaryContext;
