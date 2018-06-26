//
//  IBController27.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/23.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController27.h"
#import "IBGrahpicsView.h"
#import "UIView+Ext.h"

@interface IBController27 ()

@property (nonatomic, strong) IBGrahpicsView *gView;

@end

@implementation IBController27

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test1];
    NSLog(@"%@",self);
//    [self test2];
//    [self test3];
}

- (void)test1 {
    
    IBGrahpicsView *view = [[IBGrahpicsView alloc] initWithFrame:CGRectMake(0, TopBarHeight, self.view.width, 500)];
    view.backgroundColor = [UIColor orangeColor];
    self.gView = view;
    [self.view addSubview:view];
    
}

- (void)test3 {
    // 1. 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    // 2. 获取位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3. 把屏幕上的图层渲染到图形上下文
    [self.view.layer renderInContext:ctx];
    
    // 4. 从位图上下文获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 6. 存储图片
    self.gView.layer.contents = (id)image.CGImage;
    self.gView.layer.contentsScale = [UIScreen mainScreen].scale;

}

//绘制图片
- (void)test2 {
    // 创建图片
    UIImage *logoImage = [UIImage imageNamed:@"AppIcon"];
    CGSize size = logoImage.size;
    // 1. 开启位图上下文
    // 注意: 位图上下文跟view无关联，所以不需要在drawRect中获取上下文
    // size: 位图上下文的尺寸（绘制出新图片的尺寸）
    // opaque: 是否透明，YES：不透明  NO：透明，通常设置成透明的上下文
    // scale: 缩放上下文，取值0表示不缩放，通常不需要缩放上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    // 2. 描述绘画内容
    
    // 绘制原生图片
//    [logoImage drawAtPoint:CGPointZero];
    [logoImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 绘制文字
    NSString *logo = @"iShowMap";
    // 创建字典属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:5];
    [logo drawAtPoint:CGPointMake(10, 0) withAttributes:dict];
    
    // 绘制图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.gView.layer.contents = (id)image.CGImage;
    self.gView.layer.contentsScale = [UIScreen mainScreen].scale;

}


@end

/*
 iOS提供了两套绘图框架，分别是UIBezierPath和Core Graphics。UIBezierPath属于UIKit。UIBezierPath是对Core Graphics框架的进一步封装。
 OpenGL和Core Graphics都是绘图专用的API类族，调用图形处理器（GPU）进行图形的绘制和渲染。在架构上是平级的，相比UIkit更接近底层。
 
 一、Quartz
 在介绍 Core Graphics 之前，我们先把 Quartz 的概念理顺清楚。嫌啰嗦可以直接拉到下面看结论
 
 1、简单来说：
 Quartz由Quartz Compositor和Quartz 2D两部分组成
 Core Graphics是基于Quartz框架的2D绘图引擎，同Quartz 2D是等价的。
 CoreAnimation：提供强大的2D和3D动画效果
 CoreImage：给图片提供各种滤镜处理，比如高斯模糊、锐化等
 OpenGL-ES：主要用于游戏绘制，但它是一套编程规范，具体由设备制造商实现
 
 
 2、疑问：那么Quartz同OpenGL是什么关系呢？他的底层是否通过OpenGL调用GPU？
 CoreGraphics是基于Quartz框架的绘图引擎，同Quartz 2D是等价的。
 Quartz Extreme是针对Quartz底层的GPU加速。
 Quartz仅使用OpenGL的命令集，直接连接AGP（图形加速接口）
 Quartz在CPU上执行绘图命令，在GPU上最终合成成图形
 QuartzGL是Quartz 2D API的GPU加速。启用QuartzGL后，所有Quartz绘图命令都将转换为OpenGL命令并在GPU上执行。这个模式默认是关闭的
 Quartz在进行3D图形渲染时是基于OpenGL的，通过OpenGL连接AGP
 
 二、Core Graphics
    Core Graphics是基于Quartz框架的高保真输出2D图形的渲染引擎。可处理基于路径的绘图、抗锯齿渲染、渐变、图像、颜色管理、
 PDF文档等。Core Graphics提供了一套2D绘图功能的C语言API，使用C结构体和C的函数模拟了一套面向对象的编程机制。Core Graphics
 中没有OC的对象和方法。无论图片、PDF还是视图的图层，都是由CoreGraphics框架完成绘制的。UIImage、UIBezierPath和NSString都
 提供了至少一种用于在drawRect:中绘图的方法，实现原理是将Core Graphics代码封装在其中，降低绘图难度。
 
 1、Context
 CoreGraphics中最重要的对象是graphics context，既图形上下文。context是CGContextRef的对象，负责存储绘画状态和绘制内存所处的内存空间。
 
 图形上下文是一个CGContextRef类型的数据，图形上下文相当于画板，用于封装绘图信息(画了什么)和绘图状态(线条大小、颜色等)，它决定绘制的输出目标
 (绘制到什么地方去)，目标可以是PDF文件、bitmap或者显示器的窗口。
 
 相同的一套绘图序列，指定不同的图形上下文，就可将相同的图像绘制到不同的目标上，目标可以是PDF文件、bitmap或者显示器的窗口。
 
 QuartZ 2D提供了 5 种类型的图形上下文：Bitmap Graphics Context、PDF Graphics Context、Window Graphics Context、
 Layer Context、Post Graphics Context。
 
 在UIView中，系统会默认创建一个Layer Graphics Context，它对应UIView的layer属性，该图形上下文可以在drawRect:方法中获取，
 开发者只能获取，不能自己重新创建，在该图层上下文中绘制的图形，最终会通过CALayer显示出来。因此，View之所以能显示东西，完全是因为它内部的layer。
 
 2、图形上下文的图形状态堆栈
    图形上下文中包含一个保存过的图形状态堆栈。在QuartZ 2D创建图形上下文时，该堆栈是空的。
    CGContextSaveGState()函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，
 但不影响存储在堆栈中的拷贝。
    CGContextRestoreGState()函数，修改完成后使用此函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和
 弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。

3、Core Graphics的Ref后缀类型
   带有Ref后缀的类型是CoreGraphics中用来模拟面向对象机制的C结构。CoreGraphics对象是在堆上分配内存，因此创建CoreGraphics对象时，
 会返回一个指向对象内存地址的指针。
   使用这种分配方式的C结构都有一个用来表示结构指针的类型定义（type definition）。例如，CGColor结构，不会被直接使用的类型，有一个表示
 Color * 的类型定义—CGColorRef，用来被使用的类型。使用这种类型定义是为了区分指针变量，方便开发者判断指针变量是指向C结构还是可以接收消
 息的Objective-C对象。
   CGRect和CGPoint这种比较简单直接在栈上分配的结构体，不需要使用结构指针，因此类型名称后不带Ref后缀。
   带有Ref后缀的类型的对象可能是强引用指针，成为指向对象的拥有者。ARC是无法识别Core对象的所有权，必须在使用后手动释放。规则是，如果使用名
 称中带有create或者copy的函数创建了一个CoreGraphics对象，就必须调用Release函数并传入该对象的指针。
 
 3、作用
 绘制图形 : 线条、三角形、矩形、圆、圆弧弧等
 绘制文字
 绘制生成图片(图像)
 读取生成PDF
 截图
 绘制渐变
 自定义UI控件
 
 4、总结
    UIBezierPath的优势是方便，能用最少的代码得要想要的图形，并且不需要管理图形上下文、缓冲区等容易出问题的地方，只需要关注图形本身就行了。
 最主要的缺点是支持的效果有限，当需要实现一些复杂图形、复杂渐变效果的时候就无能为力了。所以如果只是一个简单的图形没有特别的要求，
 可以用UIBezierPath实现。
    Core Graphics的功能就比UIBezierPath强大很多，使用起来也更复杂，而且需要自己管理图形上下文，需要投入更多的开发工作量。
 在效率和可做更多工作这两个方面上Core Graphics全面压制UIBezierPath，所以如果是复杂的图形、多个图形叠加、多种颜色渐变等
 需求可以使用Core Graphics实现。
 
 
 三、UIView和CALayer的区别
 对于继承
 UIView —> UIResponder —> NSObject
 CALayer —> NSObject
 
 对于响应用户事件
 UIView继承自UIResponder，UIResponder是用来响应事件的，所以UIView可以响应事件
 CALayer直接继承于NSObject，所以CALayer不能响应事件
 
 对于所属框架
 UIView是在/System/Library/Frameworks/UIKit.framework中定义，UIKit主要是用来构建用户界面，并且是可以响应事件的
 CALayer是在/System/Library/Frameworks/QuartzCore.framework定义，2D图像绘制都是通过QuartzCore.framework实现的
 
 对于基本属性
 UIView：position、size、transform
 CALayer：position、size、transform、animations
 
 四、UIView的显示原理
    因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说
 是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就
 是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中
 UIView又会调用自己的drawRect:方法。
    我们可以把UIView的显示比作“在电脑上使用播放器播放U盘上得电影”，播放器相当于UIView，视频解码器相当于CALayer，U盘
 相当于CGContextRef，电影相当于绘制的图形信息。不同的图形上下文可以想象成不同接口的U盘。
 
 注意：当我们需要绘图到根层上时，一般在drawRect:方法中绘制，不建议在drawLayer:inContext:方法中绘图
 
 总结
UIView相比CALayer最大区别是UIView可以响应用户事件，而CALayer不可以。
 UIView侧重于对显示内容的管理，CALayer侧重于对内容的绘制。
 对于UIView所管理的内容，显示任何图形都会受到CALayer的影响。UIView依赖于CALayer提供的内容，
 CALayer依赖于UIView提供的容器来显示绘制的内容。UIView与CALayer都有树状层级结构，
 CALayer内部有SubLayers，UIView内部也有SubViews。

 
 五、iOS系统使用OpenGL编程流程
 
 1、设置CAEAGLLayer
 CAEAGLLayer是iOS中用于呈现OpenGL ES的渲染内容的
 
 2、设置EAGLContext
 OpenGL ES 渲染上下文。这个context管理所有使用OpenGL ES 进行描绘的状态，命令以及资源信息。
 
 3、创建Renderbuffer
 缓冲区用于存储绘图数据，Render Buffer有三种类型，分别是color、depth、stencil buffer
 
 4、创建Framebuffer object
 Framebuffer object是buffer的管理者，color、depth、stencil可以添加到一个Framebuffer object上
 
 5、销毁Renderbuffer和Framebuffer
 当UIView变化后，layer的宽高也随之变化，导致原来的renderbuffer 不再相符，需要销毁既有 renderbuffer 和 framebuffer
 
 */
