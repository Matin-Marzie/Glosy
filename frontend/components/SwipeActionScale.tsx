import React from 'react';
import type { StyleProp, ViewStyle } from 'react-native';
import Animated, { Extrapolation, interpolate, useAnimatedStyle } from 'react-native-reanimated';
import type { SharedValue } from 'react-native-reanimated';

interface SwipeActionScaleProps {
    translation: SharedValue<number>;
    threshold: number;
    style?: StyleProp<ViewStyle>;
    children?: React.ReactNode;
}

// Grows a swipe action's icon from half to full size as the row is dragged
// toward `threshold` - shared by every ReanimatedSwipeable row in the app.
export function SwipeActionScale({ translation, threshold, style, children }: SwipeActionScaleProps) {
    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ scale: interpolate(translation.value, [0, threshold], [0.5, 1], Extrapolation.CLAMP) }],
    }));

    return <Animated.View style={[style, animatedStyle]}>{children}</Animated.View>;
}
