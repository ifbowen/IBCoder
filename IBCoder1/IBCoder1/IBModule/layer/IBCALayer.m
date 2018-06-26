//
//  IBCALayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/6.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCALayer.h"
#import <UIKit/UIKit.h>

@interface IBCALayer () <CALayerDelegate>

@end

@implementation IBCALayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"AppIcon"];
        self.contents = (__bridge id _Nullable)image.CGImage;
        self.contentsGravity = kCAGravityCenter;
        self.contentsScale = image.scale;
        self.delegate = self;
//        [self maskLayer];
        
        
        
    }
    return self;
}

- (void)maskLayer {
    UIImage *image = [UIImage imageNamed:@"AppIcon"];
    CALayer *mask = [[CALayer alloc] init];
    mask.frame = self.bounds;
    mask.contents = (__bridge id _Nullable)image.CGImage;
    self.mask = mask;

    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, self.bounds);
}



@end


/*
 一、寄宿图（图层中包含的图）
第一种content实现（只有寄宿图消耗一定的内存空间）
 1、contents
    类型为id，意味着可以是任何类型的对象（比如图片）
 2、contentsGravity
    类似于contentmode，决定内容在图层边界中怎么对齐
 3、contentsScale
    定义了寄宿图的像素尺寸和视图大小比例，默认值为1.0，类似于UIView的contentScaleFactor，但并不总会对寄宿图产生影响（比如你拉伸图片）
    CGImage没有拉伸的概念，当我们使用UIImage读取高质量的Retain图片，然后转为CGImage，拉伸这个因素就丢失了，这时可以使
    用contentsScale修复
 4、maskToBounds
    裁剪超出边界的内容
 5、contentsRect
    允许我们在图层边框中显示寄宿图的一个子域，单位坐标0~1之间。最长使用为图片拼合
 6、contentsCenter
    定义了固定边框和可拉伸区域
 
 第二种 自定义（需要使用图层上下文，图层上下文消耗内存更大：图层宽*图层高*4个字节，每次绘制都需要抹去这块内存重新绘制）
 1、在UIView的drawRect方法中使用CoreGraphics绘制
 2、成为CALayer的代理，实现相关协议，在需要重新绘制的时候使用display调用协议displayLayer等方法实现
 注意：UIView自动把图层代理设置给了自己，并提供了相关协议
 
 二、图层几何
 UIView三个重要布局属性：frame，bounds，center
 CALayer三个重要布局属性：frame，bounds，position
 1、frame代表了图层内部坐标(也就是在父视图上占据的空间)，bounds是内部坐标，position和center是相对于父图层的anchorPoint所在位置
    为了区分清楚图层用position，视图用center。
 2、视图的frame，bounds，center属性仅仅是存取方法，当改变视图的frame，实际上是改变位于视图下方的图层的frame
 3、当对对图层做变换（旋转）的时候，frame实际上代表了覆盖图层旋转之后的整个轴对齐的矩形区域，也就是frame和bounds不一样了
 4、anchorPoint位于图层中心（0.5，0.5），图层以这个点为中心位置，是一个相对坐标范围是0~1之间，当小于0或者大于1的时候，使他放置在图
    层范围之外，当想要旋转图层某一点时，可以使用这个属性。当你设置为（0，0）的时候，它位于图层frame的左上角，于是图层的内容将会向左下
    角移动，但是图层position不变，视图的center不变，frame改变
    图层的变换都是基于anchorPoint
 5、frame，position，anchorPoint之间的关系
 公式：
 frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
 frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
 1）position，anchorPoint互不影响
 2）当你设置图层的frame属性的时候，position点的位置（也就是position坐标）根据锚点（anchorPoint）的值来确定，而当你设置图
    层的position属性的时候，bounds的位置（也就是frame的orgin坐标）会根据锚点(anchorPoint)来确定。
 3）现实开发中，我需要修改anchorPoint，但又不想要移动layer也就是不想修改frame.origin，先修改anchorPoint后再重新设置一遍frame
    就可以达到目的
 4）position是layer中的anchorPoint在superLayer中的位置坐标
 
 6、点击事件
 在touchbegin方法中拿到点
 1、使用-containsPoint:方法判断在范围内就是点击奔本图层
 2、使用-hitTest方法，使用hitTest方法时严格依赖于图层树中图层的顺序，当使用zPosition属性时会影响结果
 
 7、自动布局
    当图层的bounds发生改变时，需要调用setNeedsLayout方法，在- (void)layoutSublayersOfLayer:(CALayer *)layer
    方法中自己重新布局，做不到像UIView的autoresizingMask和constraints属性做到自适应
 
 三、视觉效果
 1、cornerRadius圆角
    只影响背景色，不影响背景图（背景图需要设置maskToBounds）
 2、图层边框(borderColor,borderWidth)
 3、阴影(shadowOpacity,shadowOffset,shadowRadius,shadowPath)
    shadowOpacity：默认显示一个黑色模糊的阴影在图层之上
    shadowOffset：控制阴影的方向和距离
    shadowRadius：控制阴影的模糊度
    shadowPath：控制阴影的形状
 4、图层蒙版(Mask)
    mask图层不关心颜色，真正重要的是图层的轮廓
    图层蒙版真正厉害之处在于蒙版图不限于静态图，任何有图层的构成都可以作为mask属性，意味着蒙版可以通过代码甚至动画生成
 
 四、拉伸过滤(minificationFilter,magnificationFilter)
    处理同一张图片需要显示不同大小，它作用于原图像素上，并根据需要生成新的像素显示在屏幕上
    minificationFilter缩小图片，magnificationFilter放大图片
    对于比较小的图或者是差异特别明显，极少斜线的大图，最近过滤算法(kCAFilterNearest)会保留这种差异明显的特质以呈现更好的结果。
    对于大多数的图尤其是有很多斜线或是曲线轮廓的图片来说，最近过滤算法会导致更差的结果。使用kCAFilterLinear
    换句话说，线性过滤保留了形状，最近过滤则保留了像素的差异
 
 五、组透明
    1、UIView有一个叫做alpha的属性来确定视图的透明度。CALayer有一个等同的属性叫做opacity
 
    2、iOS常见的做法是把一个空间的alpha值设置为0.5（50%）以使其看上去呈现为不可用状态。对于独立的视图来说还不错，但是当一个控件有子视
 图的时候，图层会混合叠加，显得不自然。处理方法：设置CALayer的一个叫做shouldRasterize属性来实现组透明的效果，如果它被设置为YES，在
 应用透明度之前，图层及其子图层都会被整合成一个整体的图片
    3、为了启用shouldRasterize属性，我们设置了图层的rasterizationScale属性。默认情况下，所有图层拉伸都是1.0， 所以如果你
 使用了shouldRasterize属性，你就要确保你设置了rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题。
    4、shouldRasterize一定避免作用在内容不断变动的视图上
 六、变换
    1、仿射变换：CGAffineTransform
    2、3D变换：CATransform3D
 
 */
