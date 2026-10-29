import React, { useRef } from 'react';
import { View, Text, StyleSheet, Pressable, Dimensions } from 'react-native';
import { FontAwesome } from '@expo/vector-icons';
import ReanimatedSwipeable from 'react-native-gesture-handler/ReanimatedSwipeable';
import type { SwipeableMethods } from 'react-native-gesture-handler/ReanimatedSwipeable';
import type { SharedValue } from 'react-native-reanimated';
import { SwipeActionScale } from '@/components/SwipeActionScale';
import { DARK_COLORS, PRIMARY_COLOR } from '@/constants/App';
import type { Sentence, Token } from '../../../types/dialogue';

const SCREEN_WIDTH = Dimensions.get('window').width;
const SWIPE_THRESHOLD = SCREEN_WIDTH / 2;

interface SentenceRowProps {
    sentence: Sentence;
    isCurrentLine: boolean;
    isDark: boolean;
    isRightToLeft: boolean;
    isSaved: boolean;
    onPress: (sentence: Sentence) => void;
    onTokenPress: (token: Token) => void;
    onSavePress: (sentence: Sentence) => void;
}

export function SentenceRow({ sentence, isCurrentLine, isDark, isRightToLeft, isSaved, onPress, onTokenPress, onSavePress }: SentenceRowProps) {
    // Always kept in logical (reading) order - reversing this array before
    // wrapping would reverse the WHOLE sentence into lines (last words
    // filling the first line), not just the word order within each line.
    // `tokensRowRtl`'s flexDirection: 'row-reverse' below is what flips
    // each line right-to-left; flex-wrap still assigns words to lines in
    // array order regardless of row vs row-reverse, so line 1 always gets
    // the sentence's first words.
    const words = sentence.text
        .trim()
        .split(/\s+/)
        .map((word, index) => ({ word, position: index + 1 }));

    const swipeableRef = useRef<SwipeableMethods>(null);

    // Swipe right reveals this panel; crossing SWIPE_THRESHOLD auto-triggers
    // the same save/unsave toggle as the bookmark button, then snaps closed -
    // the row stays in the list either way, unlike a swipe-to-delete.
    const renderLeftActions = (_progress: SharedValue<number>, translation: SharedValue<number>) => {
        return (
            <View style={[styles.swipeAction, isSaved ? styles.swipeActionRemove : styles.swipeActionSave]}>
                <SwipeActionScale translation={translation} threshold={SWIPE_THRESHOLD} style={{ alignItems: 'center' }}>
                    <FontAwesome name={isSaved ? 'bookmark' : 'bookmark-o'} size={20} color="#fff" />
                    <Text style={styles.swipeActionText}>{isSaved ? 'Unsave' : 'Save'}</Text>
                </SwipeActionScale>
            </View>
        );
    };

    return (
        <ReanimatedSwipeable
            ref={swipeableRef}
            renderLeftActions={renderLeftActions}
            onSwipeableWillOpen={(direction) => {
                // ReanimatedSwipeable reports the left actions opening as 'right'
                if (direction === 'right') {
                    onSavePress(sentence);
                    swipeableRef.current?.close();
                }
            }}
            leftThreshold={SWIPE_THRESHOLD}
            overshootLeft={false}
        >
            <Pressable
                onPress={() => onPress(sentence)}
                style={[
                    styles.sentenceContainer,
                    isDark && { backgroundColor: DARK_COLORS.surface, borderColor: DARK_COLORS.border },
                    isCurrentLine && (isDark ? styles.sentenceContainerHighlightedDark : styles.sentenceContainerHighlighted),
                    isRightToLeft && styles.sentenceContainerRtl,
                ]}
            >
                <View style={[styles.sentenceRow, isRightToLeft && styles.sentenceRowRtl]}>
                    {/* Token buttons — not nested in Pressable to avoid touch conflicts */}
                    <View style={[styles.sentenceTextContainer, isRightToLeft && styles.sentenceTextContainerRtl]}>
                        <View style={[styles.tokensRow, isRightToLeft && styles.tokensRowRtl]}>
                            {words.map(({ word, position }) => {
                                const token = sentence.tokens?.find((t) => t.position === position);

                                if (!token) {
                                    return (
                                        <Text
                                            key={`${sentence.id}-${position}`}
                                            style={[styles.sentenceText, isDark && { color: DARK_COLORS.text }, isRightToLeft && styles.textRtl]}
                                        >
                                            {word}
                                        </Text>
                                    );
                                }

                                return (
                                    <Pressable
                                        key={`${sentence.id}-${position}`}
                                        style={styles.tokenButton}
                                        onPress={(event) => {
                                            event.stopPropagation();
                                            onTokenPress(token);
                                        }}
                                    >
                                        <Text style={[styles.tokenText, isDark && { color: DARK_COLORS.text }, isRightToLeft && styles.textRtl]}>{word}</Text>
                                    </Pressable>
                                );
                            })}
                        </View>
                    </View>

                    <View style={[styles.translationWrap, isRightToLeft && styles.translationWrapRtl]}>
                        <Text style={[styles.translationText, isDark && { color: DARK_COLORS.textSecondary }]}>{sentence.translation}</Text>
                    </View>
                </View>
            </Pressable>
        </ReanimatedSwipeable>
    );
}

const styles = StyleSheet.create({
    sentenceContainer: {
        backgroundColor: '#fff',
        borderRadius: 12,
        paddingHorizontal: 4,
        borderWidth: 1,
        borderColor: '#e5e7eb',
    },
    sentenceContainerRtl: {
        alignItems: 'flex-end',
    },
    sentenceRow: {
        flexDirection: 'row',
        alignItems: 'flex-start',
        padding: 12,
    },
    sentenceRowRtl: {
        flexDirection: 'row-reverse',
    },
    sentenceContainerHighlighted: {
        borderColor: '#3b82f6',
        backgroundColor: '#eff6ff',
        borderWidth: 2,
    },
    sentenceContainerHighlightedDark: {
        borderColor: '#3b82f6',
        backgroundColor: '#1e3a5f',
        borderWidth: 2,
    },
    sentenceTextContainer: {
        flex: 1,
        minWidth: 0,
    },
    sentenceTextContainerRtl: {
        alignItems: 'flex-end',
    },
    tokensRow: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        alignItems: 'center',
        gap: 4,
    },
    tokensRowRtl: {
        // Reverses word order within each wrapped line only - flex-wrap
        // still assigns words to lines in array order either way, so this
        // must NOT be paired with a reversed words array (see the comment
        // by `words` above) or whole lines end up swapped instead of words.
        flexDirection: 'row-reverse',
    },
    tokenButton: {
        paddingVertical: 2,
    },
    tokenText: {
        fontSize: 18,
        fontWeight: '500',
        color: '#1f2937',
    },
    sentenceText: {
        fontSize: 18,
        fontWeight: '500',
        color: '#1f2937',
        lineHeight: 26,
    },
    translationText: {
        fontSize: 16,
        color: '#6b7280',
        fontStyle: 'italic',
        lineHeight: 22,
        marginTop: 2,
        textAlign: 'left',
        writingDirection: 'ltr',
    },
    translationWrap: {
        marginLeft: 8,
        flexShrink: 1,
        maxWidth: '45%',
    },
    translationWrapRtl: {
        marginLeft: 0,
        marginRight: 8,
    },
    textRtl: {
        textAlign: 'right',
        writingDirection: 'rtl',
    },
    swipeAction: {
        justifyContent: 'center',
        alignItems: 'center',
        width: SCREEN_WIDTH / 2,
        borderRadius: 12,
    },
    swipeActionSave: {
        backgroundColor: PRIMARY_COLOR,
    },
    swipeActionRemove: {
        backgroundColor: '#e74c3c',
    },
    swipeActionText: {
        color: '#fff',
        fontSize: 12,
        fontWeight: '600',
        marginTop: 4,
    },
});
