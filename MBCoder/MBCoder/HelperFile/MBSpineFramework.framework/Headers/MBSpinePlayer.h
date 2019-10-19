//
//  MBSpinePlayer.h
//  MBSpineFramework
//
//  Created by Bowen on 2019/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBSpinePlayerDelegate <NSObject>

- (void)animationDidComplete;

@end

@interface MBSpinePlayer : NSObject

@property(nonatomic, weak) id <MBSpinePlayerDelegate> delegate;

+ (instancetype)player;

/// 设置spine动画承载视图
- (void)setSpineDisplayView:(UIView *)glView;

/// 设置spine动画资源名称和资源包路径
- (void)setSpineName:(NSString *)name bundlePath:(NSString *)bundlePath;

/// 开始
- (void)startAnimation;

/// 停止
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
