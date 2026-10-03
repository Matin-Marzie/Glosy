import AsyncStorage from '@react-native-async-storage/async-storage';
import { changeLearningLanguageLimit, CHANGE_LEARNING_LANGUAGE_WINDOW_MS } from '../constants/App';

// Persisted (not just in memory) because the backend's limiter keeps
// counting across app restarts.
const STORAGE_KEY = 'learningLanguageChanges';

// In-memory copy of the change timestamps - AsyncStorage runs one operation
// at a time, so awaiting it during a switch would queue behind the new
// dictionary's multi-MB cache write and keep the switch spinner showing
// long after the switch itself finished. AsyncStorage is only the backup
// that survives restarts.
let changes = null;

// Loaded once, as soon as this module is imported, so it's ready before the
// first tap
const loadPromise = AsyncStorage.getItem(STORAGE_KEY)
  .then((raw) => {
    const stored = raw ? JSON.parse(raw) : [];
    return Array.isArray(stored) ? stored : [];
  })
  .catch((e) => {
    console.warn('[LanguageChangeLimit] Read failed:', e);
    return [];
  })
  .then((stored) => {
    // Keep any change recorded before the load finished
    changes = changes ? [...stored, ...changes] : stored;
  });

// Timestamps (ascending) of changes still inside the current window
function getRecentChanges() {
  const cutoff = Date.now() - CHANGE_LEARNING_LANGUAGE_WINDOW_MS;
  return (changes ?? []).filter((t) => t > cutoff);
}

/**
 * @returns {Promise<number>} ms until another change is allowed, 0 if allowed now
 */
export async function getLearningLanguageChangeWait() {
  if (changes === null) await loadPromise;
  const recent = getRecentChanges();
  if (recent.length < changeLearningLanguageLimit) return 0;
  // A slot frees up once the oldest change still counting leaves the window
  const oldestCounting = recent[recent.length - changeLearningLanguageLimit];
  return Math.max(0, oldestCounting + CHANGE_LEARNING_LANGUAGE_WINDOW_MS - Date.now());
}

// Synchronous - the persist runs in the background, nothing should wait on it
export function recordLearningLanguageChange() {
  changes = [...getRecentChanges(), Date.now()];
  AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(changes)).catch((e) => {
    console.warn('[LanguageChangeLimit] Write failed:', e);
  });
}

export function formatLearningLanguageChangeWait(waitMs) {
  const minutes = Math.ceil(waitMs / 60000);
  return `You've changed languages too many times. Please try again in ${minutes} minute${minutes === 1 ? '' : 's'}.`;
}
