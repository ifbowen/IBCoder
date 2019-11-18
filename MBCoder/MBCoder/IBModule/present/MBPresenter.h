//
//  MBPresenter.h
//  MBCoder
//
//  Created by Bowen on 2019/11/14.
//  Copyright © 2019 inke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 视图应该遵循的协议
@protocol MBPresenterViewProtocol <NSObject>

- (void)attachPresenter:(id)presenter;

@end

/// 控制器应该遵循的协议
@protocol MBPresenterControllerProtocol <NSObject>

@end

@interface MBPresenter : NSObject

/// 子类重写，实现某一个具体协议
@property (nonatomic, weak) id controller;
/// 子类重写，实现某一个具体协议
@property (nonatomic, weak) id attachView;

/// 构造函数
/// @param controller 控制器
+ (instancetype)setup:(id<MBPresenterControllerProtocol>)controller;

/// 绑定视图
/// @param view 要绑定的视图
- (void)attachView:(id<MBPresenterViewProtocol>)view;

/// 解除绑定
- (void)detachView;

@end

NS_ASSUME_NONNULL_END
