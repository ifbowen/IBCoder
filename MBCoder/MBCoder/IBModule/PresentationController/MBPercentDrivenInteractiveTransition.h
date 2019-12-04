//
//  MBPercentDrivenInteractiveTransition.h
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBInteractiveTransitionDirection) {//手势的方向
    MBInteractiveTransitionDirectionLeft = 0,
    MBInteractiveTransitionDirectionRight,
    MBInteractiveTransitionDirectionUp,
    MBInteractiveTransitionDirectionDown
};

typedef NS_ENUM(NSUInteger, MBInteractiveTransitionType) {//手势控制哪种转场
    MBInteractiveTransitionTypePresent = 0,
    MBInteractiveTransitionTypeDismiss,
    MBInteractiveTransitionTypePush,
    MBInteractiveTransitionTypePop,
};


@interface MBPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录手势是否开始*/
@property (nonatomic, assign) BOOL interation;

+ (instancetype)interactiveTransitionWithType:(MBInteractiveTransitionType)type direction:(MBInteractiveTransitionDirection)direction;

- (void)setCurrentViewController:(UIViewController *)currentViewController destinationViewController:(UIViewController *)destinationViewController;

@end

NS_ASSUME_NONNULL_END
