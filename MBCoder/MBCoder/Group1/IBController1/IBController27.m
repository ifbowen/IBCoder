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
 
 iOS 图像渲染过程解析
 
 一、图形渲染过程
 
 1.视图渲染
 
 UIKit是开发中最常用的框架，可以通过设置UIKit组件的布局以及相关属性来绘制界面，显示和动画都通过Core Anmation.
 
 CoreAnimation 是一个复合引擎
 提供强大的2D和3D动画效果
 它可以快速组合屏幕上不同的可视内容，这些内容被分解成独立的图层(CALayer)，存储在一个图层树的体系中
 
 Core Graphics 是基于Quartz框架的2D绘图引擎，同Quartz 2D是等价的。
 主要用于运行时绘制图像。开发者可以使用此框架来处理基于路径的绘图，转换，颜色管理，离屏渲染，图案，渐变和阴影，图像数据管理，
 图像创建和图像遮罩以及 PDF 文档创建，显示和分析。
 
 UIBezierPath是对Core Graphics框架的进一步封装。
 
 Core Image 是用来处理运行前创建的图像的。拥有一系列现成的图像过滤器，能对已存在的图像进行高效的处理。
 大部分情况下，Core Image 会在 GPU 中完成工作，但如果 GPU 忙，会使用 CPU 进行处理。

 Metal 类似于 OpenGL ES，也是一套第三方标准，具体实现由苹果实现。大多数开发者都没有直接使用过 Metal，但其实所有开发者都在间接地使用 Metal。
 Core Animation、Core Image、SceneKit、SpriteKit 等等渲染框架都是构建于 Metal 之上的。
 
 OpenGL-ES：主要用于游戏绘制，但它是一套编程规范，具体由设备制造商实现
 
 2.显示逻辑
 CoreAnimation提交会话，包括自己和子树（view hierarchy）的layout状态等；
 RenderServer解析提交的子树状态，生成绘制指令；
 GPU执行绘制指令；
 显示渲染后的数据；
 
 3.提交流程(Commit Transaction)
 在 Core Animation 流水线中，app 调用 Render Server 前的最后一步 Commit Transaction 其实可以细分为 4 个步骤：
 Layout, Display, Prepare, Commit
 
 Layout 阶段主要进行视图构建，包括：LayoutSubviews 方法的重载，addSubview: 方法填充子视图等。
 
 Display 阶段主要进行视图绘制，这里仅仅是设置要成像的图元数据。
 重载视图的 drawRect: 方法可以自定义 UIView 的显示，其原理是在 drawRect: 方法内部绘制寄宿图，该过程使用 CPU和内存。
 
 Prepare 阶段属于附加步骤，一般处理图像的解码和转换等操作。

 Commit 阶段主要将图层进行打包(序列化)，并将它们发送至 Render Server。该过程会递归执行，因为图层和视图都是以树形结构存在。
 
 4.动画渲染原理
 一般使用 UIView Animation 实现，iOS 将其处理过程分为如下三部阶段：
 Step 1：调用 animationWithDuration:animations: 方法
 Step 2：在 Animation Block 中进行 Layout，Display，Prepare，Commit 等步骤。
 Step 3：Render Server 根据 Animation 逐帧进行渲染。

 二、UIView与CALayer的关系
 UIKit 中的每一个 UI 视图控件其实内部都有一个关联的 CALayer
 由于这种一一对应的关系，视图层级拥有 视图树 的树形结构，对应 CALayer 层级也拥有 图层树 的树形结构。
 其中，视图的职责是 创建并管理 图层，以确保当子视图在层级关系中 添加或被移除 时，其关联的图层在图层树中也有相同的操作，即保证视图树和图层树在结构上的一致性。
 
 1、那么为什么 iOS 要基于 UIView 和 CALayer 提供两个平行的层级关系呢？
 其原因在于要做 职责分离，这样也能避免很多重复代码。在 iOS 和 Mac OS X 两个平台上，事件和用户交互有很多地方的不同，
 基于多点触控的用户界面和基于鼠标键盘的交互有着本质的区别，
 这就是为什么 iOS 有 UIKit 和 UIView，
 对应 Mac OS X 有 AppKit 和 NSView 的原因。
 它们在功能上很相似，但是在实现上有着显著的区别。

 实际上，这里并不是两个层级关系，而是四个。每一个都扮演着不同的角色。除了 视图树 和 图层树，还有 呈现树 和 渲染树。

 2、CALayer
 那么为什么 CALayer 可以呈现可视化内容呢？因为 CALayer 基本等同于一个 纹理。纹理是 GPU 进行图像渲染的重要依据。
 CALayer 包含一个 contents 属性指向一块缓存区，称为 backing store，可以存放位图（Bitmap）。iOS 中将该缓存区保存的图片称为 寄宿图。
 在实际开发中，绘制界面也有两种方式：一种是 手动绘制；另一种是 使用图片。

 1、Contents Image 是指通过 CALayer 的 contents 属性来配置图片。然而，contents 属性的类型为 id。
 在这种情况下，可以给 contents 属性赋予任何值，app 仍可以编译通过。但是在实践中，如果 content 的值不是 CGImage ，得到的图层将是空白的。
 为什么要将 contents 的属性类型定义为 id 而非 CGImage。这是因为在 Mac OS 系统中，该属性对 CGImage 和 NSImage 类型的值都起作用，
 而在 iOS 系统中，该属性只对 CGImage 起作用。
 本质上，contents 属性指向的一块缓存区域，称为 backing store，可以存放 bitmap 数据。
 
 2、Custom Drawing 是指使用 Core Graphics 直接绘制寄宿图。实际开发中，一般通过继承 UIView 并实现 -drawRect: 方法来自定义绘制。
 底层是 CALayer 完成了重绘工作并保存了产生的图片。
 
 1）CALayer 有一个可选的 delegate 属性，实现了 CALayerDelegate 协议。UIView 作为 CALayer 的代理实现了 CALayerDelegae 协议。
 2）当需要重绘时，即调用 -drawRect:，CALayer 请求其代理给予一个寄宿图来显示。
 3）CALayer 首先会尝试调用 -displayLayer: 方法，此时代理可以直接设置 contents 属性。
 4）如果代理没有实现 -displayLayer: 方法，CALayer 则会尝试调用 -drawLayer:inContext: 方法。
 在调用该方法前，CALayer 会创建一个空的寄宿图（尺寸由 bounds 和 contentScale 决定）和一个 Core Graphics 的绘制上下文，
 为绘制寄宿图做准备，作为 ctx 参数传入。
 5）最后，由 Core Graphics 绘制生成的寄宿图会存入 backing store。


 三.渲染服务(Render Server)
 1）渲染服务进程首先将打包上来的图层进行解压(反序列化)，得到图层树。

 2）然后依据图层树中图层的顺序、RGBA值、图层的frame等，对被遮挡的图层进行过滤。

 3）Core Animation进行过滤以后将图层树转化为渲染树。
 渲染树就是指图层树对应每个图层的信息，比如顶点坐标、顶点颜色这些信息，抽离出来，形成的树结构，就叫渲染树了
 然后将渲染树信息递归提交给OpenGL ES /Metal。

 4）OpenGL ES /Metal会编译、链接可编程的顶点着色器和片元着色器程序(如果有对顶点着色器和片元着色器进行自定义)，
 并结合固定的渲染管线，生成绘制命令，并提交到命令缓冲区CommandBuffer `，供GPU读取调用。

 四. 图形渲染管线(Graphics Rendering Pipeline)
 
 Graphics Rendering Pipeline，图形渲染管线，实际上指的是一堆原始图形数据途经一个输送管道，期间经过各种变化处理最终出现在屏幕的过程。
 通常情况下，渲染管线可以描述成 vertices(顶点) 到 pixels(像素) 的过程。
 
 图形渲染管线的主要工作可以被划分为两个部分：
 把 3D 坐标转换为2D 坐标
 把 2D 坐标转变为实际的有颜色的像素
 
 GPU 图形渲染管线的具体实现可分为六个阶段，如下图所示。
 顶点着色器（Vertex Shader）
 形状装配（Shape Assembly），又称 图元装配
 几何着色器（Geometry Shader）
 光栅化（Rasterization）
 片段着色器（Fragment Shader）
 测试与混合（Tests and Blending）
 
 五.屏幕显示
 iOS 设备会始终使用双缓存，并开启垂直同步。
 由于垂直同步的机制，如果在一个 VSync 时间内，CPU或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，
 而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因。
 双缓冲工作原理:GPU 会预先渲染一帧放入一个缓冲区中，用于视频控制器的读取。当下一帧渲染完毕后，GPU 会直接把视频控制器的指针指向第二个缓冲器。
 
 屏幕图像显示的原理，需要先从 CRT 显示器原理说起
 CRT 的电子枪从上到下逐行扫描，扫描完成后显示器就呈现一帧画面。
 然后电子枪回到初始位置进行下一次扫描。为了同步显示器的显示过程，显示器会用硬件时钟产生一系列的定时信号。
 当电子枪换行进行扫描时，显示器会发出一个水平同步信号（horizonal synchronization），简称 HSync；
 而当一帧画面绘制完成后，电子枪回复到原位，
 准备画下一帧前，显示器会发出一个垂直同步信号（vertical synchronization），简称 VSync。
 显示器通常以固定频率进行刷新，这个刷新率就是VSync 信号产生的频率。虽然现在的显示器基本都是液晶显示屏了，但其原理基本一致。
 
 */
