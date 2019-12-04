//
//  MBPresentationControllerTransition.m
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBPresentationControllerTransition.h"

@interface MBPresentationControllerTransition ()

@property (nonatomic, assign) MBPresentationControllerTransitionType transitionType;
@property (nonatomic, assign) CGRect frame;

@end

@implementation MBPresentationControllerTransition

+ (instancetype)transitionWithTransitionType:(MBPresentationControllerTransitionType)type frame:(CGRect)frame
{
    MBPresentationControllerTransition *transition = [[MBPresentationControllerTransition alloc] init];
    transition.transitionType = type;
    transition.frame = frame;
    return transition;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.25 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_transitionType) {
        case MBPresentationControllerTransitionPresent:
            [self presentAnimation:transitionContext];
            break;
        case MBPresentationControllerTransitionDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    [containerView addSubview:toView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = self.frame;
    } completion:^(BOOL finished) {
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.frame = self.frame;
    [containerView addSubview:fromView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
    }];

}

@end
