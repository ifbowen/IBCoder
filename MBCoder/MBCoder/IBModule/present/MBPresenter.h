//
//  MBPresenter.h
//  MBCoder
//
//  Created by Bowen on 2019/11/14.
//  Copyright © 2019 inke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBPresenterProtocol <NSObject>

- (void)attachPresenter:(id)presenter;

@end

@interface MBPresenter : NSObject

@property (nonatomic, weak) id attachView;

/// 构造函数
/// @param view 负责更新的视图
+ (instancetype)setup:(id<MBPresenterProtocol>)view;

/// 绑定视图
/// @param view 要绑定的视图
- (void)attachView:(id)view;

/// 解除绑定
- (void)detachView;

@end

NS_ASSUME_NONNULL_END
