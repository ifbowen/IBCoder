//
//  UIView+Gesture.m
//  Assassin
//
//  Created by Bowen on 2018/10/11.
//  Copyright © 2018 inke. All rights reserved.
//

#import "UIView+Gesture.h"
#import <objc/runtime.h>

@implementation UIView (Gesture)

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation UIView (draggable)

- (void)setPanGesture:(UIPanGestureRecognizer*)panGesture {
    objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer*)panGesture {
    return objc_getAssociatedObject(self, @selector(panGesture));
}

- (void)setDraggable:(BOOL)draggable {
    self.panGesture.enabled = draggable;
}

- (void)enableDragging {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:self];
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint location = [panGesture translationInView:self];
        CGAffineTransform transform = self.transform;
        CGAffineTransform tTransform = CGAffineTransformTranslate(transform, location.x, location.y);
        self.transform = tTransform;
        
    }
    [panGesture setTranslation:CGPointZero inView:self];
}

@end

@implementation UIView (rotatable)

- (void)setRotationGesture:(UIRotationGestureRecognizer *)rotationGesture {
    objc_setAssociatedObject(self, @selector(rotationGesture), rotationGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIRotationGestureRecognizer *)rotationGesture {
    return objc_getAssociatedObject(self, @selector(rotationGesture));
}

- (void)setRotatable:(BOOL)rotatable {
    self.rotationGesture.enabled = rotatable;
}

- (void)enableRotating {
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
    self.rotationGesture.cancelsTouchesInView = NO;
    self.rotationGesture.delegate = self;
    [self addGestureRecognizer:self.rotationGesture];
}

- (void)rotateGesture:(UIRotationGestureRecognizer *)rotateGesture {
    
    if (rotateGesture.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:self];
    }
    
    if (rotateGesture.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform transform = self.transform;
        transform = CGAffineTransformRotate(transform, rotateGesture.rotation);
        self.transform = transform;
        
    }
    rotateGesture.rotation = 0;
}

@end

@implementation UIView (scaleable)

- (void)setScaleGesture:(UIPinchGestureRecognizer *)scaleGesture {
    objc_setAssociatedObject(self, @selector(scaleGesture), scaleGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPinchGestureRecognizer *)scaleGesture {
    return objc_getAssociatedObject(self, @selector(scaleGesture));
}

- (void)setScaleable:(BOOL)scaleable {
    self.scaleGesture.enabled = scaleable;
}

- (void)enableScaling {
    self.scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleGesture:)];
    self.scaleGesture.cancelsTouchesInView = NO;
    self.scaleGesture.delegate = self;
    [self addGestureRecognizer:self.scaleGesture];
}

- (void)scaleGesture:(UIPinchGestureRecognizer *)pinchGesture {
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:self];
    }
    
    if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform transform = self.transform;
        transform = CGAffineTransformScale(transform, pinchGesture.scale, pinchGesture.scale);
        self.transform = transform;
    }
    pinchGesture.scale = 1;
}

@end
