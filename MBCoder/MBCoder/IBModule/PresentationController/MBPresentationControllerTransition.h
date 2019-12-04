//
//  MBPresentationControllerTransition.h
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBPresentationControllerTransitionType) {
    MBPresentationControllerTransitionPresent = 0,
    MBPresentationControllerTransitionDismiss
};

@interface MBPresentationControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(MBPresentationControllerTransitionType)type frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
