//
//  MBPresentationController.h
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 弹出透明视图
@interface MBPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CGRect frame;

@end

NS_ASSUME_NONNULL_END
