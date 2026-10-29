import React, { useCallback, useRef, useState, memo } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Dimensions } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import ReanimatedSwipeable from 'react-native-gesture-handler/ReanimatedSwipeable';
import { SwipeActionScale } from '@/components/SwipeActionScale';
import { useSentenceContext } from '@/context/SentenceContext';
import { SENTENCE_ACTIONS } from '@/hooks/useSentences';
import { MASTERY_LEVELS } from '@/constants/Vocabulary';
import { useVibration } from '@/hooks/useVibration';
import { useColorScheme } from '@/components/useColorScheme';
import { DARK_COLORS } from '@/constants/App';

function SentenceItem({ sentenceId, entry }) {
    const isDark = useColorScheme() === 'dark';
    const { sentenceDispatch } = useSentenceContext();
    const vibrate = useVibration();
    const [isDeleting, setIsDeleting] = useState(false);
    const swipeableRef = useRef(null);

    const screenWidth = Dimensions.get('window').width;
    const swipeThreshold = screenWidth / 2;

    const handleRemove = useCallback(() => {
        if (isDeleting) return;
        setIsDeleting(true);
        vibrate(20, { type: 'button' });
        sentenceDispatch({
            type: SENTENCE_ACTIONS.REMOVE,
            payload: { sentenceId },
        });
    }, [sentenceId, sentenceDispatch, isDeleting]);

    const renderLeftActions = useCallback((progress, translation) => {
        return (
            <TouchableOpacity
                style={styles.deleteAction}
                onPress={() => {
                    handleRemove();
                    swipeableRef.current?.close();
                }}
            >
                <SwipeActionScale translation={translation} threshold={swipeThreshold} style={{ alignItems: 'center' }}>
                    <Ionicons name="trash-outline" size={24} color="#fff" />
                    <Text style={styles.deleteActionText}>Delete</Text>
                </SwipeActionScale>
            </TouchableOpacity>
        );
    }, [handleRemove, swipeThreshold]);

    if (isDeleting) {
        return null;
    }

    return (
        <ReanimatedSwipeable
            ref={swipeableRef}
            renderLeftActions={renderLeftActions}
            onSwipeableWillOpen={(direction) => {
                // ReanimatedSwipeable reports the left actions opening as 'right'
                if (direction === 'right') {
                    handleRemove();
                }
            }}
            leftThreshold={swipeThreshold}
            overshootLeft={false}
        >
            <View style={[styles.row, isDark && { backgroundColor: DARK_COLORS.surface, borderBottomColor: DARK_COLORS.border }]}>
                <View style={styles.textColumn}>
                    <Text style={[styles.text, isDark && { color: DARK_COLORS.text }]} numberOfLines={2}>
                        {entry.text || `Sentence #${sentenceId}`}
                    </Text>
                    {!!entry.translation && (
                        <Text style={[styles.translation, isDark && { color: DARK_COLORS.textSecondary }]} numberOfLines={2}>
                            {entry.translation}
                        </Text>
                    )}
                </View>
                <View style={styles.masteryBadge}>
                    <Text style={styles.masteryBadgeText}>{MASTERY_LEVELS[entry.mastery_level] || MASTERY_LEVELS[1]}</Text>
                </View>
            </View>
        </ReanimatedSwipeable>
    );
}

export default memo(SentenceItem);

const styles = StyleSheet.create({
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 14,
        paddingHorizontal: 16,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#e5e7eb',
        backgroundColor: '#fff',
    },
    textColumn: {
        flex: 1,
        marginRight: 10,
    },
    text: {
        fontSize: 15,
        fontWeight: '500',
        color: '#1f2937',
    },
    translation: {
        fontSize: 13,
        color: '#6b7280',
        fontStyle: 'italic',
        marginTop: 2,
    },
    masteryBadge: {
        paddingHorizontal: 10,
        paddingVertical: 5,
        borderRadius: 12,
        backgroundColor: '#007bff',
    },
    masteryBadgeText: {
        color: '#fff',
        fontSize: 11,
        fontWeight: '600',
    },
    deleteAction: {
        width: Dimensions.get('window').width / 2,
        backgroundColor: '#d32f2f',
        justifyContent: 'center',
        alignItems: 'center',
    },
    deleteActionText: {
        color: '#fff',
        fontSize: 12,
        fontWeight: '600',
        marginTop: 4,
    },
});
