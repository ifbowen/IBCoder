//
//  IBCAReplicatorLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCAReplicatorLayer.h"
#import <UIKit/UIKit.h>

/**
 CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。
 主要应用2个方面：重复效果,反射效果(倒影)
 */
@implementation IBCAReplicatorLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}


/**
 重复效果
 */
- (void)setupLayer {
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 20, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -20, 0);
    self.instanceTransform = transform;
    
    self.instanceCount = 10;
    self.instanceDelay = 1;
    self.instanceBlueOffset = -0.1;
    self.instanceGreenOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(80.0f, 80.0f, 80.0f, 80.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self addSublayer:layer];
    
}

@end

/*
 
 CATransform3D中的属性和方法
 //初始化一个transform3D对象，不做任何变换
 const CATransform3D CATransform3DIdentity;
 //判断一个transform3D对象是否是初始化的对象
 bool CATransform3DIsIdentity (CATransform3D t);
 //比较两个transform3D对象是否相同
 bool CATransform3DEqualToTransform (CATransform3D a, CATransform3D b);
 //将两个 transform3D对象变换属性进行叠加，返回一个新的transform3D对象
 CATransform3D CATransform3DConcat (CATransform3D a, CATransform3D b);
 
 1、平移变换
 //返回一个平移变换的transform3D对象 tx，ty，tz对应x，y，z轴的平移
 CATransform3D CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz);
 //在某个transform3D变换的基础上进行平移变换，t是上一个transform3D，其他参数同上
 CATransform3D CATransform3DTranslate (CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz);
 
 2、缩放变换
 //x，y，z分别对应x轴，y轴，z轴的缩放比例
 CATransform3D CATransform3DMakeScale (CGFloat sx, CGFloat sy, CGFloat sz);
 //在一个transform3D变换的基础上进行缩放变换，其他参数同上
 CATransform3D CATransform3DScale (CATransform3D t, CGFloat sx, CGFloat sy, CGFloat sz);
 
 3、旋转变换
 //angle参数是旋转的角度，为弧度制 0-2π
 //x，y，z决定了旋转围绕的中轴，取值为-1——1之间，例如（1，0，0）,则是绕x轴旋转（0.5，0.5，0），则是绕x轴与y轴中
 //间45度为轴旋转,依次进行计算
 CATransform3D CATransform3DMakeRotation (CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
 //在一个transform3D的基础上进行旋转变换，其他参数如上
 CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
 
 4、旋转翻转变换
 //将一个旋转的效果进行翻转
 CATransform3D CATransform3DInvert (CATransform3D t);
 
 5、CATransform3D与CGAffineTransform的转换
 CGAffineTransform是UIKit框架中一个用于变换的矩阵，其作用与CATransform类似，只是其可以直接作用于View，而不用作用于layer，
 这两个矩阵也可以进行转换，方法如下：
 
 //将一个CGAffinrTransform转化为CATransform3D
 CATransform3D CATransform3DMakeAffineTransform (CGAffineTransform m);
 //判断一个CATransform3D是否可以转换为CAAffineTransform
 bool CATransform3DIsAffine (CATransform3D t);
 //将CATransform3D转换为CGAffineTransform
 CGAffineTransform CATransform3DGetAffineTransform (CATransform3D t);
 
 */
