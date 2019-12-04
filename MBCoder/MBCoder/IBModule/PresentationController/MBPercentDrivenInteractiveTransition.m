//
//  MBPercentDrivenInteractiveTransition.m
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBPercentDrivenInteractiveTransition.h"

@interface MBPercentDrivenInteractiveTransition ()

/**手势方向*/
@property (nonatomic, assign) MBInteractiveTransitionDirection direction;
/**手势类型*/
@property (nonatomic, assign) MBInteractiveTransitionType type;

@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, weak) UIViewController *destinationViewController;

@end

@implementation MBPercentDrivenInteractiveTransition

+ (instancetype)interactiveTransitionWithType:(MBInteractiveTransitionType)type direction:(MBInteractiveTransitionDirection)direction
{
    MBPercentDrivenInteractiveTransition *transition = [[MBPercentDrivenInteractiveTransition alloc] init];
    transition.type = type;
    transition.direction = direction;
    return transition;
}

- (void)setCurrentViewController:(UIViewController *)currentViewController destinationViewController:(UIViewController *)destinationViewController
{
    self.currentViewController = currentViewController;
    self.destinationViewController = destinationViewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    if (self.type == MBInteractiveTransitionTypePresent ||
        self.type == MBInteractiveTransitionTypePush) {
        [self.currentViewController.view addGestureRecognizer:pan];
    } else {
        [self.destinationViewController.view addGestureRecognizer:pan];
    }
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    CGFloat persent = 0.0;
    switch (_direction) {
        case MBInteractiveTransitionDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case MBInteractiveTransitionDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case MBInteractiveTransitionDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case MBInteractiveTransitionDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interation = YES;
            [self startGesture];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.interation = NO;
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture
{
    switch (self.type) {
        case MBInteractiveTransitionTypePresent:
            [self.currentViewController presentViewController:self.destinationViewController animated:YES completion:nil];
            break;
        case MBInteractiveTransitionTypeDismiss:
            [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MBInteractiveTransitionTypePush:
            [self.currentViewController.navigationController pushViewController:self.destinationViewController animated:YES];
            break;
        case MBInteractiveTransitionTypePop:
            [self.destinationViewController.navigationController popViewControllerAnimated:YES];
            break;
    }
}

@end
