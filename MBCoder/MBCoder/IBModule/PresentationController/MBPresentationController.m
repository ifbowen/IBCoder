//
//  MBPresentationController.m
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBPresentationController.h"
#import "MBPresentationControllerTransition.h"
#import "MBPercentDrivenInteractiveTransition.h"

@interface MBPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) MBPercentDrivenInteractiveTransition *dismissInteractiveTransition;
@property (nonatomic, strong) MBPercentDrivenInteractiveTransition *presentInteractiveTransition;

@end

@implementation MBPresentationController

#pragma mark - 重写方法

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentInteractiveTransition];
        [self dismissInteractiveTransition];
    }
    return self;
}

// 呈现过渡即将开始的时候被调用
- (void)presentationTransitionWillBegin
{
    self.dimmingView.alpha = 0.f;
    [self.containerView addSubview:self.dimmingView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.5f;
    } completion:nil];
}

// 在呈现过渡结束时被调用
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed){
        self.dimmingView = nil;
    }
}

// 消失过渡即将开始的时候被调用
- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:nil];
}

// 消失过渡完成之后调用
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
    }
}

// 返回目标控制器frame
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
}

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

#pragma mark - action

- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIContentContainer

// 控制器内容大小变化时调用
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController) {
        [self.containerView setNeedsLayout];
    }
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)  {
        return ((UIViewController*)container).preferredContentSize;
    } else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

/// 动画主管
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [MBPresentationControllerTransition transitionWithTransitionType:MBPresentationControllerTransitionPresent frame:self.frame];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [MBPresentationControllerTransition transitionWithTransitionType:MBPresentationControllerTransitionDismiss frame:self.frame];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.presentInteractiveTransition.interation ? self.presentInteractiveTransition : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.dismissInteractiveTransition.interation ? self.dismissInteractiveTransition : nil;
}

#pragma mark - getter

- (UIView *)dimmingView {
    if(!_dimmingView){
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    }
    return _dimmingView;
}

- (MBPercentDrivenInteractiveTransition *)dismissInteractiveTransition {
    if(!_dismissInteractiveTransition){
        _dismissInteractiveTransition = [MBPercentDrivenInteractiveTransition interactiveTransitionWithType:MBInteractiveTransitionTypeDismiss direction:MBInteractiveTransitionDirectionDown];
        [_dismissInteractiveTransition setCurrentViewController:self.presentingViewController destinationViewController:self.presentedViewController];
    }
    return _dismissInteractiveTransition;
}

- (MBPercentDrivenInteractiveTransition *)presentInteractiveTransition {
    if(!_presentInteractiveTransition){
        _presentInteractiveTransition = [MBPercentDrivenInteractiveTransition interactiveTransitionWithType:MBInteractiveTransitionTypePresent direction:MBInteractiveTransitionDirectionUp];
        [_presentInteractiveTransition setCurrentViewController:self.presentingViewController destinationViewController:self.presentedViewController];
    }
    return _presentInteractiveTransition;
}


@end
