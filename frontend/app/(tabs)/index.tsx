import React, { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import { View, StyleSheet, Keyboard, Text, TouchableOpacity, ActivityIndicator } from 'react-native';
import { useRouter } from 'expo-router';
import { FontAwesome } from '@expo/vector-icons';
import { useAuth } from '@/context/AuthContext';
import { useVocabularyContext } from '@/context/VocabularyContext';
import { useSentenceContext } from '@/context/SentenceContext';
import { useDictionaryContext } from '@/context/DictionaryContext';
import FilterBottomSheetModal from '@/components/vocabulary/FilterBottomSheetModal';
import VocabularySearchField from '@/components/vocabulary/VocabularySearchField';
import VocabularyList from '@/components/vocabulary/VocabularyList';
import SentenceList from '@/components/sentences/SentenceList';
import { useColorScheme } from '@/components/useColorScheme';
import { DARK_COLORS, PRIMARY_COLOR } from '@/constants/App';

// Strips Arabic tashkeel (harakat, U+0610–U+061A and U+064B–U+065F) so that
// bare-consonant queries match fully-vowelled text, and vice versa.
// Written as \u escapes, not literal glyphs - the two ranges are disjoint,
// and it's too easy to swap an endpoint by mistake with invisible bidi
// characters typed directly in the source (which is exactly what happened
// before: the old literal-glyph regex had the ranges' end points crossed,
// producing two wide overlapping ranges that swallowed ordinary Arabic/Farsi
// letters too, not just diacritics - e.g. "خانه" reduced to "").
function normalizeQuery(text: string): string {
  return text.trim().toLowerCase().replace(/[\u0610-\u061A\u064B-\u065F]/g, '');
}

export default function HomeScreen() {
  const isDark = useColorScheme() === 'dark';
  const router = useRouter();
  const { forceSync } = useAuth();
  const { userVocabulary } = useVocabularyContext();
  const { userSentences } = useSentenceContext();
  const { dictionary, dictionaryLoading } = useDictionaryContext();
  const [search, setSearch] = useState('');
  // Only the debounced search result lives in state - "my words" (empty
  // search) is derived during render, see myWords below
  const [searchResults, setSearchResults] = useState<any[]>([]);
  const [isFilterModalOpen, setIsFilterModalOpen] = useState(false);
  // True only while a non-empty search query is debouncing/being computed -
  // the empty-query "my words" path is immediate, so it never sets this.
  const [isSearching, setIsSearching] = useState(false);
  // 'words' shows the vocabulary list (search/filter included); 'sentences'
  // shows sentences saved from reel subtitles.
  const [activeTab, setActiveTab] = useState('words');
  const debounceTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);
  // Bumped on pull-to-refresh so VocabularyListItem recomputes its "next
  // review in X" countdown against the current time - that display is
  // otherwise only recalculated when next_review_at itself changes (i.e.
  // after an actual review), so it goes stale the longer the list sits open.
  const [refreshedAt, setRefreshedAt] = useState(() => Date.now());
  const [isRefreshing, setIsRefreshing] = useState(false);
  // Pushes any pending local vocabulary changes to the backend (POST
  // /user/sync) before refreshing, so e.g. FSRS review state recorded
  // offline is flushed and next_review_at countdowns reflect the latest
  // synced state, not just stale local data.
  const handleRefresh = useCallback(async () => {
    setIsRefreshing(true);
    await forceSync();
    setRefreshedAt(Date.now());
    setIsRefreshing(false);
  }, [forceSync]);

  // Sort by created_at descending without re-allocating Date objects inside
  // the comparator (decorate-sort-undecorate) - a plain `new Date(...)`
  // comparator allocates twice per comparison, which adds up fast at
  // dictionary scale and was blocking the JS thread long enough to trip
  // VirtualizedList's "slow to update" warning.
  const sortByCreatedAtDesc = useCallback((items, getCreatedAt) => {
    return items
      .map((item) => ({ item, ts: new Date(getCreatedAt(item) || 0).getTime() }))
      .sort((a, b) => b.ts - a.ts)
      .map(({ item }) => item);
  }, []);

  const sortedSentences = useMemo(() => {
    const items = Object.entries(userSentences || {}).map(([id, entry]) => ({ id: Number(id), entry }));
    return sortByCreatedAtDesc(items, (sentenceItem) => sentenceItem.entry?.created_at);
  }, [userSentences, sortByCreatedAtDesc]);

  // Ref for filter bottom sheet modal
  const vocabularyFilterRef = useRef(null);

  // Callbacks
  const handleFilterOpen = useCallback(() => {
    Keyboard.dismiss();
    vocabularyFilterRef.current?.present();
  }, []);

  const handleFilterSheetChange = useCallback((index) => {
    setIsFilterModalOpen(index >= 0);
  }, []);

  const words = useMemo(() => dictionary?.words || [], [dictionary]);

  // id -> word lookup, built once per dictionary fetch (not per vocabulary
  // change) so deriving "my saved words" never has to scan the full
  // dictionary - only Object.keys(userVocabulary), which is normally far
  // smaller than the dictionary itself.
  // Keys are normalized to strings: words.id is a Postgres bigint, which
  // node-postgres returns as a string (no numeric precision loss) - so
  // word.id is already a string here. Map, unlike plain object access or
  // the `in` operator, does NOT coerce number/string keys as equal, so both
  // sides must be strings or a lookup with the "wrong" type silently misses.
  const wordsById = useMemo(() => {
    const map = new Map();
    for (const word of words) map.set(String(word.id), word);
    return map;
  }, [words]);

  // Each word's normalized written_form, computed once per dictionary instead
  // of on every keystroke. Search used to call normalizeQuery() (trim +
  // lowercase + diacritics-strip) on all ~11,000 words every single time the
  // debounce fired - the word's own text never changes, only the query does.
  // Built lazily on the first search, not on every dictionary change - most
  // dictionary loads (app start, language switch) never lead to a search,
  // and this is the most expensive index on the screen.
  const searchIndexRef = useRef<{ words: any[]; entries: { word: any; normalized: string; normalizedTranslations: string[] }[] } | null>(null);
  const getSearchIndex = useCallback(() => {
    let index = searchIndexRef.current;
    if (!index || index.words !== words) {
      index = {
        words,
        entries: words.map((word) => ({
          word,
          normalized: normalizeQuery(word.written_form ?? ''),
          normalizedTranslations: (word.translations ?? []).map((t) => normalizeQuery(t ?? '')),
        })),
      };
      searchIndexRef.current = index;
    }
    return index.entries;
  }, [words]);

  const query = normalizeQuery(search);
  const isQueryEmpty = !query;

  // User's vocabulary words (shown when search is empty), sorted by
  // created_at (newest first). Derived during render instead of copied into
  // state by an effect, so a vocabulary/dictionary change costs one render
  // and one pass, not two. Skipped while searching.
  const myWords = useMemo(() => {
    if (!isQueryEmpty || !userVocabulary) return [];
    const vocabularyWords = Object.keys(userVocabulary)
      .map((id) => wordsById.get(id))
      .filter(Boolean);
    return sortByCreatedAtDesc(vocabularyWords, (word) => userVocabulary[word.id]?.created_at);
  }, [isQueryEmpty, userVocabulary, wordsById, sortByCreatedAtDesc]);

  // Debounced search effect
  useEffect(() => {
    if (debounceTimeout.current) clearTimeout(debounceTimeout.current);

    if (!query) {
      setIsSearching(false);
      return;
    }

    // Show the spinner immediately (covers both the debounce wait and the
    // filter/sort itself), not just while the setTimeout callback runs.
    setIsSearching(true);

    debounceTimeout.current = setTimeout(() => {
      // Filter by search query using each word's precomputed normalized
      // form (see getSearchIndex) - only a cheap startsWith()/includes()
      // per word now, not a fresh normalize+compare on every keystroke.
      // Matches either the word's own spelling (prefix) or any of its
      // translations (substring) - so searching in your native language
      // finds the target-language word too.
      const filtered = getSearchIndex()
        .filter((entry) =>
          entry.normalized.startsWith(query) ||
          entry.normalizedTranslations.some((t) => t.includes(query))
        )
        .map((entry) => entry.word);

      setSearchResults(sortByCreatedAtDesc(filtered, (word) => userVocabulary?.[word.id]?.created_at));
      setIsSearching(false);
    }, 500);

    return () => clearTimeout(debounceTimeout.current ?? undefined);
  }, [query, getSearchIndex, userVocabulary, sortByCreatedAtDesc]);

  const filteredWords = isQueryEmpty ? myWords : searchResults;

  return (
    <View style={[styles.container, isDark && { backgroundColor: DARK_COLORS.background }]}>
      <View style={[styles.tabBar, isDark && { borderBottomColor: DARK_COLORS.border }]}>
        <TouchableOpacity
          style={[styles.tabButton, activeTab === 'words' && styles.tabButtonActive]}
          onPress={() => setActiveTab('words')}
        >
          <Text style={[styles.tabButtonText, isDark && { color: DARK_COLORS.textSecondary }, activeTab === 'words' && styles.tabButtonTextActive]}>
            Words
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tabButton, activeTab === 'sentences' && styles.tabButtonActive]}
          onPress={() => setActiveTab('sentences')}
        >
          <Text style={[styles.tabButtonText, isDark && { color: DARK_COLORS.textSecondary }, activeTab === 'sentences' && styles.tabButtonTextActive]}>
            Sentences
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.navIconButton}
          onPress={() => router.push('/letters')}
          hitSlop={12}
        >
          <FontAwesome name="font" size={18} color={isDark ? DARK_COLORS.textSecondary : '#9ca3af'} />
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.navIconButton}
          onPress={() => router.push('/videos')}
          hitSlop={12}
        >
          <FontAwesome name="youtube-play" size={18} color={isDark ? DARK_COLORS.textSecondary : '#9ca3af'} />
        </TouchableOpacity>
      </View>

      {activeTab === 'words' ? (
        <>
          <VocabularySearchField
            search={search}
            onSearchChange={setSearch}
            onFilterPress={handleFilterOpen}
            editable={!isFilterModalOpen}
          />

          {/* Only block on the first load - a background refresh of a stale
              cached dictionary keeps showing the list it already has */}
          {dictionaryLoading && words.length === 0 ? (
            <View style={styles.searchingContainer}>
              <ActivityIndicator size="large" color={PRIMARY_COLOR} />
              <Text style={[styles.loadingText, isDark && { color: DARK_COLORS.textSecondary }]}>
                Loading dictionary...
              </Text>
            </View>
          ) : isSearching ? (
            <View style={styles.searchingContainer}>
              <ActivityIndicator size="large" color={PRIMARY_COLOR} />
            </View>
          ) : (
            <VocabularyList
              words={filteredWords}
              refreshedAt={refreshedAt}
              refreshing={isRefreshing}
              onRefresh={handleRefresh}
            />
          )}

          {/* Filter Bottom Sheet Modal */}
          <FilterBottomSheetModal ref={vocabularyFilterRef} onSheetChange={handleFilterSheetChange} />
        </>
      ) : (
        <SentenceList sentences={sortedSentences} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  tabBar: {
    flexDirection: 'row',
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#e5e7eb',
  },
  tabButton: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
  },
  tabButtonActive: {
    borderBottomColor: PRIMARY_COLOR,
  },
  tabButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#9ca3af',
  },
  tabButtonTextActive: {
    color: PRIMARY_COLOR,
  },
  navIconButton: {
    paddingHorizontal: 16,
    justifyContent: 'center',
    alignItems: 'center',
  },
  searchingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    color: '#9ca3af',
  },
});
