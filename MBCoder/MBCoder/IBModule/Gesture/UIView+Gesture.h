//
//  UIView+Gesture.h
//  Assassin
//
//  Created by Bowen on 2018/10/11.
//  Copyright © 2018 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gesture)<UIGestureRecognizerDelegate>

@end

@interface UIView (draggable)

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)enableDragging;
- (void)setDraggable:(BOOL)draggable;

@end

@interface UIView (rotatable)

@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;

- (void)enableRotating;
- (void)setRotatable:(BOOL)rotatable;

@end

@interface UIView (scaleable)

@property (nonatomic, strong) UIPinchGestureRecognizer *scaleGesture;

- (void)enableScaling;
- (void)setScaleable:(BOOL)scaleable;


@end


NS_ASSUME_NONNULL_END
