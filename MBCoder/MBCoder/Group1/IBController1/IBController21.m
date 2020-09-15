//
//  IBController21.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/17.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController21.h"

@interface IBController21 ()

@end

@implementation IBController21

/*
 1、UILabel 绘制中文使用clipsToBounds避免出现离屏渲染
 2、UILabel为什么约束左上就可以
    因为UIView的intrinsicContentSize属性，如果你不约束，我就自己计算使用
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 Core Animation
 
 1) Color Blended Layers(图层混合)
    颜色标识：红色->混合图层  绿色->没有使用混合
    很多情况下，界面都是会出现多个UI控件叠加的情况，如果有透明或者半透明的控件，那么GPU会去计算这些这些layer最终的显示的颜色，也就是我们
 肉眼所看到的效果。例如一个上层Veiw颜色是绿色RGB(0,255,0)，下层又放了一个View颜色是红色RGB(0,0,255)，透明度是50%，那么最终显示到我们
 眼前的颜色是蓝色RGB(0,127.5,127.5)。这个计算过程会消耗一定的GPU资源损耗性能。如果我们把上层的绿色View改为不透明，那么GPU就不用耗费资源
 计算，直接显示绿色。混合颜色计算公式：
    R(C)=alpha*R(B)+(1-alpha)*R(A)    R(x)、G(x)、B(x)分别指颜色x的RGB分量
 
    如果出现图层混合了，打开Color Blended Layers选项，那块区域会显示红色，所以我们调试的目的就是将红色区域消减的越少越好。那么如何减少
 红色区域的出现呢？只要设置控件不透明即可。
 （1）设置opaque 属性为true。(默认为true)
 （2）给View设置一个不透明的颜色，没有特殊需要设置白色即可。
 
 例子
 label.backgroundColor = [UIColor whiteColor];
 label.layer.masksToBounds = YES;
    到这里你可能奇怪，设置label的背景色第一行不就够了么，为什么还有第二行？这是因为如果label的内容是中文，label实际渲染区域要大于label
 的size，最外层多了一个sublayer，如果不设置第二行label的边缘外层灰出现图层混合的红色，因此需要在label内容是中文的情况下加第二句。单独使
 用label.layer.masksToBounds = YES是不会发生离屏渲染，下文会讲离屏渲染。
 注意点：UIImageView控件比较特殊，不仅需要自身这个容器是不透明的，并且imageView包含的内容图片也必须是不透明的，如果你自己的图片出现了图层混合红色，
       先检查是不是自己的代码有问题，如果确认代码没问题，就是图片自身的问题，可以联系你们的UI眉眉～
 
 2) Color Hits Green and Misses Red（光栅化）
    颜色标识： 红色->光栅化  绿色->未光栅化
    这个选项主要是检测我们是是否正确使用layer的shouldRasterize属性，shouldRasterize = YES开启光栅化。
 光栅化是将一个layer预先渲染成位图(bitmap)，再加入到缓存中，成功被缓存的layer会标注为绿色,没有成功缓存的会标注为红色，
 正确使用光栅化可以得到一定程度的性能提升。
 适用情况：一般在图像内容不变的情况下才使用光栅化，例如设置阴影耗费资源比较多的静态内容，如果使用光栅化对性能的提升有一定帮助。
 非适用情况：如果内容会经常变动,这个时候不要开启,否则会造成性能的浪费。
 例如我们在使用tableViewCell中，一般不要用光栅化，因为tableViewCell的绘制非常频繁，内容在不断的变化，如果使用了光栅化，会造成大量的离屏渲染降低性能。
 如果你在一个界面中使用了光栅化，刚进去这个页面的所有使用了光栅化的控件layer都会是红色，因为还没有缓存成功，如果上下滑动你会发现，layer变
 成了绿色。但是如果你滑动幅度较大会发现，新出现的控件会是红色然后变成绿色，因为刚开始这些控件的layer还没有缓存。
 注意点：
 （1）系统给光栅化缓存分配了一个固定的大小，因此不能过度使用，如果超出了缓存也会造成离屏渲染。
 （2）缓存的时间为100ms，因此如果在100ms内没有使用缓存的对象，则会从缓存中清除。
 
 光栅化概念：将图转化为一个个栅格组成的图象。
 光栅化特点：每个元素对应帧缓冲区中的一像素。
 
 3）Color Copied Images（图片颜色格式）
    颜色标识：蓝色->需要复制
    如果GPU不支持当前图片的颜色格式，那么就会将图片交给CPU预先进行格式转化，并且这张图片标记为蓝色。那么GPU支持什么格式呢？
 苹果的GPU只解析32bit的颜色格式，如果使用Color Copied Images去调试发现是蓝色，这个时候你也可以去找你们的UI眉眉了～
 
 知识扩展：
    32bit指的是图片颜色深度，用“位”来表示，用来表示显示颜色数量，例如一个图片支持256种颜色，那么就需要256个不同的值来表示不同的颜色，
 也就是从0到255，二进制表示就是从00000000到11111111，一共需要8位二进制数，所以颜色深度是8。
 通常32bit色彩中使用三个8bit分别表示R红G绿B蓝,还有一个8bit常用来表示透明度（Alpha）。
 
 
 4）Color Immediately（颜色刷新频率）
    当执行颜色刷新的时候移除10ms的延迟，因为可能在特定情况下你不需要这些延迟，所以使用此选项加快颜色刷新的频率。不过一般这个调试选项我们是
 用不到的。
 
 5）Color Misaligned Images(图片大小)
    颜色标识：洋红色->图片没有像素对齐， 黄色->图片缩放
    目标像素与源像素不对齐的图像， 或者图片大小和UIImageView大小不一致。

 6）Color Offscreen-Rendered Yellow（离屏渲染）
    颜色标识：黄色->发生离屏渲染
    离屏渲染Off-Screen Rendering 指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。还有另外一种屏幕渲染方式-当前屏幕渲染
 On-Screen Rendering ，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。 离屏渲染会先在屏幕外创建新缓冲区，离屏渲染结束后，再从
 离屏切到当前屏幕，把离屏的渲染结果显示到当前屏幕上，这个上下文切换的过程是非常消耗性能的，实际开发中尽可能避免离屏渲染。
 触发离屏渲染Offscreen rendering的行为：
 （1）drawRect:方法
 （2）layer.shadow
 （3）layer.allowsGroupOpacity or layer.allowsEdgeAntialiasing
 （4）layer.shouldRasterize
 （5）layer.mask
 （6）layer.masksToBounds && layer.cornerRadius
 这里有需要注意的是第三条layer.shouldRasterize ，其实就是我们本文讲的第三个选项光栅化，光栅化会触发离屏渲染，因此光栅化慎用。
 第六条设置圆角会触发离屏渲染，如果在某个页面大量使用了圆角，会非常消耗性能造成FPS急剧下降，设置圆角触发离屏渲染要同时满足下面两个条件:
 layer.masksToBounds = YES;
 layer.cornerRadius = 5;
 为了尽可能避免触发离屏渲染，我们可以换其他手段来实现必要的功能：
 （1）阴影绘制shadow:使用ShadowPath来替代shadowOffset等属性的设置
     imageViewLayer.shadowPath = CGPathCreateWithRect(imageRect, NULL);
 （2）利用GraphicsContex生成一张带圆角的图片或者view，这里不写具体实现过程，需要的可以度娘Copy，很多现成的代码。
 
 离屏渲染一定会引起性能问题吗？
    很少会，比如drawRect这个方法，只会在时图进行重新绘制的时候才会调用。也就是说，假如你的View并不会频繁重绘，那么即使实现了drawRect，
 也没什么关系。对了，目前iOS设备的硬件越来越好也是一个原因，想要要性能差也挺难的。
 
 7）Color Compositing Fast-Path Blue (快速路径)
    颜色标记->蓝色
    标记由硬件绘制的路径，显示蓝色，越多越好。 可以直接对OpenGL绘制的图像高亮。
 
 8）Flash Updated Regions (重绘区域)
    颜色标识->黄色
    对重绘区域高亮为黄色，会使用CoreGraphics绘制，越小越好。
 
 9）Color Layer Formats（颜色格式）
    颜色标识：UILabel显示灰色背景
 
 
 界面顿卡的原因(主要两个方面)
 CPU限制
 1、对象的创建，释放，属性调整。这里尤其要提一下属性调整，CALayer的属性调整的时候是会创建隐式动画的，是比较损耗性能的。
 2、视图和文本的布局计算，AutoLayout的布局计算都是在主线程上的，所以占用CPU时间也很多 。
 3、文本渲染，诸如UILabel和UITextview都是在主线程渲染的
 4、图片的解码，这里要提到的是，通常UIImage只有在交给GPU之前的一瞬间，CPU才会对其解码。
 GPU限制
 1、视图的混合。比如一个界面十几层的视图叠加到一起，GPU不得不计算每个像素点药显示的像素
 2、离屏渲染。视图的Mask，圆角，阴影。
 3、半透明，GPU不得不进行数学计算，如果是不透明的，CPU只需要取上层的就可以了
 4、浮点数像素

 
 */


@end
