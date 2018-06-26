//
//  IBCAEmitterLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCAEmitterLayer.h"
#import <UIKit/UIKit.h>

/**
 CAEmitterLayer是一个高性能的粒子引擎
 */
@implementation IBCAEmitterLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    
    // 1.创建发射器
//    CAEmitterLayer *emitter = [[CAEmitterLayer alloc]init];
    
    // 2.设置发射器的位置
    self.emitterPosition = CGPointMake(150, 280);
    //控制着在视觉上粒子图片是如何混合的
    self.renderMode = kCAEmitterLayerAdditive;
    // 3.开启三维效果--可以关闭三维效果看看(是否将3D例子系统平面化到一个图层)
    self.preservesDepth = YES;
    
    // 4.创建粒子, 并且设置粒子相关的属性
    // 4.1.创建粒子Cell
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    
    // 4.2.设置粒子速度
    cell.velocity = 150;
    //速度范围波动50到250
    cell.velocityRange = 100;
    
    // 4.3.设置粒子的大小
    //一般我们的粒子大小就是图片大小， 我们一般做个缩放
    cell.scale = 0.7;
    
    //粒子大小范围: 0.4 - 1 倍大
    cell.scaleRange = 0.3;
    
    // 4.4.设置粒子方向
    //这个是设置经度，就是竖直方向 --具体看我们下面图片讲解
    //这个角度是逆时针的，所以我们的方向要么是 (2/3 π)， 要么是 (-π)
    cell.emissionLongitude = -M_PI_2;
    //emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
    cell.emissionRange = M_PI_2 / 4;
    
    // 4.5.设置粒子的存活时间
    cell.lifetime = 6;
    cell.lifetimeRange = 1.5;
    // 4.6.设置粒子旋转
    cell.spin = M_PI_2;
    cell.spinRange = M_PI_2 / 2;
    // 4.6.设置粒子每秒弹出的个数
    cell.birthRate = 20;
    // 4.7.设置粒子展示的图片 --这个必须要设置为CGImage
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"AppIcon"].CGImage);
    //color属性指定了一个可以混合图片内容颜色的混合色
    cell.color = [UIColor orangeColor].CGColor;
    //指定值在时间线上的变化,例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐消失的效果
    cell.alphaSpeed = -0.4;
    // 5.将粒子设置到发射器中--这个是要放个数组进去
    self.emitterCells = @[cell];
}

@end
