//
//  IBGrahpicsView1.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/12.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBGrahpicsView.h"

@implementation IBGrahpicsView

- (void)drawRect:(CGRect)rect {
    [self test1];
    [self test2];
    [self test3];
//    [self test4];
    [self test5];
    [self test6];
    [self test7];
}

- (void)test7 {
    UIImage *img = [UIImage imageNamed:@"AppIcon"];
    CGImageRef image = img.CGImage;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect touchRect = CGRectMake(50, 300, img.size.width, img.size.height);
    
//    CGContextDrawImage(context, touchRect, image);//默认是倒置的
    [img drawInRect:touchRect];
    CGContextRestoreGState(context);
}


/**
 绘制文字
 */
- (void)test6 {
    NSString *text = @"天将降大任于斯人也。。。";
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName: [UIColor redColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:15]
                           };
    [text drawAtPoint:CGPointMake(50, 250) withAttributes:attr];
}

- (void)test5 {
    //放射性渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *gradientColors = [NSArray arrayWithObjects:
                               (id)[UIColor whiteColor].CGColor,
                               (id)[UIColor blackColor].CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)gradientColors,
                                                        gradientLocations);
    CGPoint startCenter = CGPointMake(100, 180);
    CGFloat radius = 50;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient,
                                startCenter, 0,
                                startCenter, radius,
                                0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //线性渐变
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    NSArray* gradientColors1 = [NSArray arrayWithObjects:
                               (id)[UIColor whiteColor].CGColor,
                               (id)[UIColor purpleColor].CGColor, nil];
    CGFloat gradientLocations1[] = {0, 1};
    
    CGGradientRef gradient1 = CGGradientCreateWithColors(colorSpace1,
                                                        (__bridge CFArrayRef)gradientColors1,
                                                        gradientLocations1);
    
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context1);
    CGContextMoveToPoint(context1, 250, 300);
    CGContextAddLineToPoint(context1, 350, 300);
    CGContextSetLineWidth(context1, 5);
    CGContextStrokePath(context1);
    
    CGContextDrawLinearGradient(context1, gradient1, CGPointMake(250, 40), CGPointMake(350, 40),kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context1);
    
    CGGradientRelease(gradient1);
    CGColorSpaceRelease(colorSpace1);

}

//上下文的矩阵操作
- (void)test4 {
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 50, 100)];
    
    // 矩阵操作
    // 移动
    CGContextTranslateCTM(context, 100, 100);
    // 缩放
    CGContextScaleCTM(context, 1, 2);
    // 旋转
    CGContextRotateCTM(context, M_PI_4);
    
    // 把路径添加到上下文
    CGContextAddPath(context, path.CGPath);
    // 设置颜色
    [[UIColor blueColor] set];
    // 渲染上下文
    CGContextStrokePath(context);
}

/**
 CGPath转换：UIKit框架转CoreGraphics直接 .CGPath 就能转换
 优点： 用UIBezierPath 画多根不连接的线，可以管理各个线的状态
 缺点： UIBezierPath 不能画曲线
 
    使用贝瑟尔路径绘图只能在drawRect里进行，因为底层要用到上下文，图形上下文只能在drawRect里获取，不能在其他方法里面绘图，
 比如：不能在awakeFromNib里绘图！
 1、创建贝瑟尔路径
 2、描述绘画内容
 a. 创建图形起始点(moveToPoint)
 b. 添加图形的终点(addLineToPoint)
 3、设置路径状态
 4、绘制路径
 */
- (void)test3 {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 110)];
    [path addLineToPoint:CGPointMake(200, 110)];
    [[UIColor blueColor] set];
    [path setLineWidth:5];
    [path stroke];
}

/*
 方法二：使用上下文直接绘图
 注意：不用创建路径，也不需要把绘图内容添加到图形上下文，因为图形上下文封装了这些步骤。
 
 1、获取当前控件的图形上下文
 2、描述绘画内容
 a. 创建图形起始点
 b. 添加图形的终点
 3、设置图形上下文的状态（线宽、颜色等）
 4、渲染图形上下文
 */
- (void)test2 {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 50, 80);
    CGContextAddLineToPoint(context, 200, 80);
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokePath(context);
}


/*
 方法一：最原始的绘图方式
 
 1、获取当前控件的图形上下文
 2、描述绘画内容
 a. 创建图形路径
 b. 创建图形起始点
 c. 添加图形的终点
 3、把绘画内容添加到图形上下文
 4、设置图形上下文的状态（线宽、颜色等）
 5、渲染图形上下文
 */
- (void)test1 {
//    1. 获取当前控件的图形上下文
//    CG:表示这个类在CoreGraphics框架里  Ref:引用
    CGContextRef context = UIGraphicsGetCurrentContext();
//    2. 描述绘画内容
//    a. 创建图形路径
    CGMutablePathRef path = CGPathCreateMutable();
//    b. 创建图形起始点
    CGPathMoveToPoint(path, NULL, 50, 50);
//    c. 添加图形的终点
    CGPathAddLineToPoint(path, NULL, 200, 50);
//    3. 把绘画内容添加到图形上下文
    CGContextAddPath(context, path);
//    4. 设置图形上下文的状态（线宽、颜色等）
    CGContextSetLineWidth(context, 5);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
//    5. 渲染图形上下文
    CGContextStrokePath(context);

}


@end
