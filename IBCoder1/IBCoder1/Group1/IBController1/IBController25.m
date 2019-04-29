//
//  IBController25.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/18.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController25.h"
#import <QuartzCore/QuartzCore.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface IBController25 ()<CAAnimationDelegate>

@property (nonatomic, strong) CALayer *layer;

@end

@implementation IBController25

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(self.view.center.x-50, 100);
    layer.anchorPoint = CGPointZero;
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self createTranslateAnimation];
//    [self createScale1Animation];
//    [self createTransformAnimation];
//    [self createMoveAnimation];
//    [self createPathAnimation];
//    [self createGroupAnimation];
//    [self createSpringAnimation];
//    [self createTransitionAnimation];
    [self createViewAnimation];
}

#pragma mark - UIView封装的动画
- (void)createViewAnimation
{
//    1.
//    [UIView beginAnimations:nil context:nil];
//    self.layer.position = CGPointMake(200, 200);
//    //监听动画(动画执行完毕后，自动执行animateStop的方法)
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animateStop)];
//    [UIView commitAnimations];
    
//    2.
//    [UIView animateWithDuration:1.0 animations:^{
//        self.layer.position = CGPointMake(200, 200);
//    }completion:^(BOOL finished) {
//        //动画执行完毕后执行
//    }];
    
//    3.
//    self.view.backgroundColor = randomColor;
//    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//        ;
//    } completion:^(BOOL finished) {
//        ;
//    }];
    
    [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.position = CGPointMake(self.view.center.x-50, 300);
    } completion:^(BOOL finished) {
    }];

}

- (void)createTransitionAnimation {
    //转场动画
    self.layer.backgroundColor = randomColor.CGColor;
    CATransition *animation = [CATransition animation];
    animation.type = @"moveIn";
    animation.subtype = kCATransitionFromRight;
    
    animation.startProgress = 0.2;
    animation.endProgress = 0.6;
    
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)createSpringAnimation {
    CASpringAnimation *animation = [CASpringAnimation animation];
    animation.keyPath = @"position";
    animation.damping = 5;
    animation.stiffness = 100;
    animation.mass = 1;
    animation.initialVelocity = 0;
    animation.duration = animation.settlingDuration;
    animation.byValue = [NSValue valueWithCGPoint:CGPointMake(0, 200)];
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - 动画组
- (void)createGroupAnimation
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 1.创建缩放动画对象
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @(0.0);
    
    // 2.创建旋转动画对象
    CABasicAnimation *rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation";
    rotate.toValue = @(M_PI);
    
    group.animations = @[scale,rotate];
    group.duration = 2.0;
    
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.layer addAnimation:group forKey:nil];
    
    
}


- (void)createPathAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    
    //设置动画执行路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(100, 100, 100, 100));
    animation.path = path;
    CGPathRelease(path);
    
    //设置动画执行节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //设置动画代理
    animation.delegate = self;
    
    animation.duration = 3.0;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - 动画代理
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
}

- (void)createMoveAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(50, 200)];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(200, 400)];
    NSValue *v4 = [NSValue valueWithCGPoint:CGPointMake(50, 400)];
    NSValue *v5 = [NSValue valueWithCGPoint:CGPointMake(50, 200)];
    
    animation.values = @[v1,v2,v3,v4,v5];
    animation.duration = 3.0;
    
//    animation.keyTimes = @[@(1),@(1.5),@(2)];
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animation forKey:nil];
}

//transform动画
- (void)createTransformAnimation {
    // 1.创建动画对象
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    // 2.设置动画对象
//    animation.keyPath = @"transform";
//    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];

//    animation.keyPath = @"transform.rotation";
//    animation.toValue = @(M_PI);

//    animation.keyPath = @"transform.scale";
//    animation.toValue = @(1.5);
    
    animation.keyPath = @"transform.translation";
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    
    animation.duration = 3.0;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.layer addAnimation:animation forKey:nil];
}


///缩放动画
- (void)createScale1Animation {
    // 1.创建动画对象
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    // 2.设置动画对象
    animation.keyPath = @"bounds";
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    animation.duration = 3.0;
    //延时执行
    animation.beginTime = CACurrentMediaTime() + 2;
    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    //动画完成后是否以动画形式回到初始值
    animation.autoreverses = YES;
    //动画时间偏移
//    animation.timeOffset = 0.5;
    // 3.添加动画
    [self.layer addAnimation:animation forKey:nil];
    
}

///平移动画
- (void)createTranslateAnimation {
    // 1.创建动画对象
    CABasicAnimation *animation = [CABasicAnimation animation];
    // 2.设置动画对象
    //keyPath决定了执行哪个动画，调整哪个layer属性来执行动画
    animation.keyPath = @"position";
//    animation.fromValue =[NSValue valueWithCGPoint:CGPointZero];
    //toValue:变成什么值
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    //byValue:增加多少值
    animation.byValue = [NSValue valueWithCGPoint:CGPointMake(0, 200)];
    animation.duration = 3.0;
    //动画节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置动画结束时，不要删除动画
    animation.removedOnCompletion = NO;
    //保持最新状态
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];

}


- (void)animationPause {
    // 当前时间（暂停时的时间）
    // CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    self.layer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    self.layer.timeOffset = pauseTime;
}
- (void)animationContinue {
    // 动画的暂停时间
    CFTimeInterval pausedTime = self.layer.timeOffset;
    // 动画初始化
    self.layer.speed = 1;
    self.layer.timeOffset = 0;
    self.layer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    self.layer.beginTime = timePause;
}


/*
 动画API不难，难的是设计动画的算法(动画拆分，判断是什么属性)
 任何复杂的动画其实都是由一个个简单的动画组装而成的，只要我们善于分解和组装，我们就能实现出满意的效果
 
 一、动画
 CAAnimation
 这是核心动画的基类，不能直接使用，主要负责动画的时间、速度等，从上面可以看出是准守CAMediaTiming协议的。
 
 CAPropertyAnimation
 属性动画的基础类，继承自CAAnimation，不能直接使用。何谓属性动画呢？即通过修改属性值就可以产生动画效果。
 
 CAAnimationGroup
 动画组，继承自CAAnimation，顾名思义就是一种组合动画，可以通过动画组来进行所有动画行为的统一控制，组中所有动画效果可以并发执行。
 
 CATransition
 转场动画，继承自CAAnimation，主要是通过滤镜来进行动画的效果设置
 
 CABasicAnimation
 基础动画，继承自CAPropertyAnimation，通过属性控制动画的参数，只要初始状态和结束状态
 
 CAKeyframeAnimation
 关键帧动画，继承自CAPropertyAnimation，也是通过属性控制动画参数，但是与基础动画不同的是有多个控制状态，并且可以通过path来实现动画
 
 CASpringAnimation
 弹簧动画，是在iOS 9中引入的，继承自CABasicAnimation，用于制作弹簧动画
 
 0、CAMediaTiming协议属性
    1）beginTime        指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
    2）duration         动画的时长
    3）speed            动画的速度
    4）timeOffset       它对时间进行偏移（offset），从而计算出动画的状态，取值为0-1之间，控制动画显示
    5）autoreverses     动画结束时是否执行逆动画
    6）repeatCount      重复的次数。不停重复设置为 HUGE_VALF
    7）repeatDuration   设置动画的时间。在该时间内动画一直执行，不计次数。
    8）fillMode 决定当前对象在非active时间段的行为。要想fillMode有效，需设置removedOnCompletion = false
       kCAFillModeForwards:当动画结束后，layer会一直保持着动画最后的状态
       kCAFillModeBackwards:设置为该值，将会立即执行动画的第一帧，不论是否设置了beginTime属性。观察发现，设置该值，刚开始视图不
                            见，还不知道应用在哪里
       kCAFillModeBoth:该值是kCAFillModeForwards和kCAFillModeBackwards的组合状态; 动画加入后开始之前，layer便处于动画初始
                        状态，动画结束后layer保持动画最后的状态
       kCAFillModeRemoved:默认值，动画将在设置的beginTime开始执行（如没有设置beginTime属性，则动画立即执行），动画执行完成后会
                          将layer的改变恢复原状
 
 注意：如果只是配置了一个简单的动画，那么你也可以分开使用beginTime和duration以达到相同的效果。
 但是使用speed属性的优点在于这两个事实：
 @1.动画的speed是分等级的。（hierarchical）
    速度为2的动画组有一部分动画的速度为1.5，那么这个动画就是3倍于正常速度。
 @2.CAAnimation不是唯一一个实现CAMediaTiming的类。
    CAMediaTiming是CAAnimation实现的一个协议，但是CALayer（所有Core Animationlayers的基类）也实现了相同的协议，这就意味着你可以
    设置layer的speed为2.0，这样，所有加入到layer的动画运行都要快两倍。同样的，如果一个速度为3的动画加到一个速度为0.5的layer上，这个动
    画最终将会以1.5倍的常速运行。
 
 控制动画时间：http://www.cocoachina.com/programmer/20131218/7569.html
    同时使用speed和timeOffset可以控制动画的当前时间。这几乎不会涉及到什么代码，但是概念却比较难以理解（我希望插图能有所帮助）。为了方便
 ，我将动画的duration设为1.0。因为time offset是绝对值。这样做就意味着当time offset为0.0时，此时就是动画的0%处（动画开始），
 time offset为1.0时，就是动画的100%处（动画结束）。

 1、CAAnimation属性
    1).timingFunction：控制动画运行的节奏
       kCAMediaTimingFunctionLinear (匀速): 在整个动画时间内动画都是以一个相同的速度来改变
       kCAMediaTimingFunctionEaseIn (渐进): 缓慢进入, 加速离开
       kCAMediaTimingFunctionEaseOut(渐出): 快速进入, 减速离开
       kCAMediaTimingFunctionEaseInEaseOut(渐进渐出): 缓慢进入, 中间加速, 减速离开
       kCAMediaTimingFunctionDefault(默认): 效果基本等同于EaseOut(渐出)
 
    2).removedOnCompletion 默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards
 
    3).delegate：动画代理，用来监听动画的执行过程
       - (void)animationDidStart:(CAAnimation *)anim;
       - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
 
 2、CAPropertyAnimation属性
    1).keyPath  指定操作什么属性来展示动画
        transform：           3D变换
        transform.scale：     缩放
        transform.scale.x：   宽度缩放
        transform.rotation.x：围绕x轴旋转
        position：            位置(中心点的改变)
        opacity：             透明度
        bounds：              大小的改变 中心点保持不变
        cornerRadius：        圆角的设置
        backgroundColor：     背景颜色变换
        contents：            可以改变layer展示的图片
        strokeStart：         从起始点开始变化
        strokeEnd：           从结束的位置开始变化
        path：                根据路径来改变
    2).additive 指定该属性动画是否以当前动画效果为基础
    3).cumulative 下一次动画执行是否接着刚才的动画，默认为false
    4).valueFunction 对属性改变的插值计算，系统已经提供了默认的插值计算方式，因此一般无须指定该属性

 3、CABasicAnimation属性
    1）fromValue 所改变属性的起始值(Swift中为Any类型,OC中要包装成NSValue对象)
    2）toValue   所改变属性的结束时的值(类型与fromValue相同)
    3）byValue   所改变属性相同起始值的改变量(类型与fromValue相同)
 
 4、CAKeyframeAnimation属性
    values：关键帧动画值的数组，当path为nil时设置有效，否则优先选择属性path做动画
    path：动画执行的点路径（通过Core Graphics提供的API来绘制路径），设置了path，values将被忽略
    keyTimes：关键帧动画每帧动画开始执行时间点的数组，取值范围为0~1，数组中相邻两个值必须遵循后一个值大于或等于前一个值，并且最后的值不能
             为大于1。设置的时候与calculationMode有关，具体请查看文档。未设置时默认每帧动画执行时间平均（公式：总时间/(总帧数-1)）。例如，
             如果你指定了一个5帧，10秒的动画，那么每帧的时间就是2.5秒钟：10 /(5-1)=2.5
    rotationMode：设置路径旋转，当设置path有不同角度时，会自动旋转layer角度与path相切
    timingFunctions：动画执行效果数组
    calculationMode：关键帧时间计算方法，每帧动画之间如何过渡
 
 5、CASpringAnimation属性
    mass：质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    stiffness：刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    damping：阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    initialVelocity：初始速率，动画视图的初始速度大小，速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    settlingDuration：结算时间 返回弹簧动画到停止时的估算时间
 
 6、CATransition
    type：动画过渡类型
         1)pageCurl 向上翻一页
         2)pageUnCurl 向下翻一页
         3)rippleEffect 滴水效果
         4)suckEffect 收缩效果，如一块布被抽走
         5)cube 立方体效果
         6)oglFlip 上下翻转效果
    subtype：动画过渡方向
    startProgress：动画起点(在整体动画的百分比)
    endProgress：动画终点(在整体动画的百分比)
 

 7、其他
 我们需要知道隐式动画是如何实现的？
    我们把改变属性时CALayer自动应用的动画称作行为，当CALayer的属性被修改时候，它会调用-actionForKey:方法，传递属性的名称。
 剩下的操作都在CALayer的头文件中有详细的说明，实质上是如下几步：
 
    1）图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
    2）如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
    3）如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
    4）最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
    5）所以一轮完整的搜索结束之后，-actionForKey:要么返回空（这种情况下将不会有动画发生），要么是CAAction协议对应的对象，
       最后CALayer拿这个结果去对先前和当前的值做动画。
    于是这就解释了UIKit是如何禁用隐式动画的：每个UIView对它关联的图层都扮演了一个委托，并且提供了-actionForLayer:forKey的实现方法。
 当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。
 
 */



@end
