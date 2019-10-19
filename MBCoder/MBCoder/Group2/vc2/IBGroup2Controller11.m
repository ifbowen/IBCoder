//
//  IBGroup2Controller11.m
//  MBCoder
//
//  Created by Bowen on 2019/10/10.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller11.h"
#import <SVGA.h>
#import <Lottie/Lottie.h>
#import <MBSpineFramework/MBSpineFramework.h>

@interface IBGroup2Controller11 ()<MBSpinePlayerDelegate>

@property(nonatomic, strong) MBSpinePlayer *player;
@property (nonatomic, strong) UIView *spineView;

@end

@implementation IBGroup2Controller11

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
//    [self startLottie];
//    [self startSVGA];
    
    [self startSpine];
}

- (void)startSVGA
{
    SVGAPlayer *svgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*0.287)];
    svgaPlayer.loops = 0;
    svgaPlayer.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:svgaPlayer];
    
    SVGAParser *svgaParser = [[SVGAParser alloc] init];
    [svgaParser parseWithNamed:@"home_colourline" inBundle:nil
               completionBlock:^(SVGAVideoEntity * videoItem){
                   if (videoItem != nil) {
                       svgaPlayer.videoItem = videoItem;
                       [svgaPlayer startAnimation];
                   }
               } failureBlock:^(NSError *error) {
                   NSLog(@"bowen %@", error);
               }];
}

- (void)startLottie
{
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"LottieLogo"];
    animationView.loopAnimation = YES;
    animationView.contentMode = UIViewContentModeScaleAspectFill;
    [animationView playWithCompletion:nil];
    [self.view addSubview:animationView];
}

- (void)startSpine
{
    self.spineView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.spineView];
    self.player = [MBSpinePlayer player];
    self.player.delegate = self;

    [self runSpine];
}

- (void)runSpine
{
    [self.player setSpineDisplayView:self.spineView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"common" ofType:nil];
    [self.player setSpineName:@"spineboy" bundlePath:path];
    [self.player startAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.player stopAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)animationDidComplete {
    
    [self.player stopAnimation];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self runSpine];
    });
}

- (void)dealloc
{
    [self.player stopAnimation];
    NSLog(@"%s", __func__);
}


@end

/*
 gif,svga,lottie,spine动画
 
 Lottie渲染时需要提供一系列的图片，渲染不同帧的时候会使用组合不同的图片。
 Spine Runtime使用一个小图片合成的大图片，渲染时会取不同的部分来渲染。
 
 SVGA
 动画原理：
 逐帧渲染，每一帧均为关键帧，只需渲染每个元素无需插值计算
 播放前一次性上传纹理到GPU，并在动画过程中复用纹理
 
 设计成本
 不支持复杂的矢量形状图层
 AE自带的渐变、生成、描边、擦除等
 对图片动画更加友好
 
 开发成本
 文件资源较小
 三端通用
 每个动画播放都会重新解压，需要重新设计一套缓存策略（尤其在列表中使用）
 zlib打包，不方便解压和追踪包内容
 占用内存高
 
 Lottie
 动画原理：
 逐层渲染，完全按照设计工具的设计思路还原
 播放解析多个图层配置并添加相应动画，并在动画过程中复用图层
 当需要解析高阶插值，性能相对差一些
 
 设计成本
 基本满足所有种类的矢量动画和图片动画
 
 开发成本
 三端通用
 缓存策略可以满足业务需求，不需要二次开发
 文件资源相对较大
 图片需要重命名 & 偶先播不出来动效
 
 优点：
 开发成本低，设计师导出json后，开发同学只需引用文件即可。
 支持服务端URL创建，服务端可以配置json文件，随时替换动画。
 性能提升，替换原使用帧图完成的动画，节省客户端空间和内存。
 跨平台，iOS、Android使用一套方案，效果统一。
 支持转场动画
 
 缺点：
 对某些AE属性不支持。
 对平台有限制，iOS 8.0 以上，Android API 14 以上。
 交互动画不可行，主要是播放类型动画。
 
 spine
 动画原理：
 通过控制骨骼的动作与贴图的方式还原动画，使用差值算法计算中间帧
 动画之间可以进行混合（如一个角色可以开枪射击，同时也可以走、跑、跳或者游泳）
 
 设计成本
 学习成本相对较大
 
 开发成本
 三端通用
 文件资源较小，复用率高
 动画性能较好，可组合动画
 研发成本相对比较大
 
 */
