export const APP_NAME = 'glosy';
export const APP_TAGLINE = 'Personalized Language Learning';
export const PRIMARY_COLOR = '#0f8690';

// Coins awarded for answering a reels spaced-repetition review prompt
// (ReviewFeedbackRow) - granted at most once per reel, see ReelsList's
// handleReviewRatingChange. Matches WordOfWonders' GAME_WIN_REWARD.
export const REVIEW_COIN_REWARD = 20;

// Max times a user can change their current learning language (switch or add)
// per window - each change can fetch a whole dictionary, so this keeps the
// client under the backend's dictionaryLimiter (20 requests / 15 min per IP).
// Same number as the backend, so there's no spare room for other dictionary
// fetches (onboarding, retries) in the same window.
export const changeLearningLanguageLimit = 20;
export const CHANGE_LEARNING_LANGUAGE_WINDOW_MS = 15 * 60 * 1000;

export const DARK_COLORS = {
  background: '#121212',
  surface: '#1c1c1c',
  border: '#333',
  text: '#fff',
  textSecondary: '#aaa',
  textMuted: '#888',
} as const;
