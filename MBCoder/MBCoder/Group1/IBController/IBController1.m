//
//  IBController1.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/23.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController1.h"
#import "UIView+Ext.h"

@interface IBController1 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

/*

 考虑模块拆解
 难点重点
 开发项目考虑已存在代码
 关注性能，主动提出并解决
 解决线上问题能力
 加班提升自己技术
 
 断点续传：分块，分片。
 1、断点续传技术就是利用 HTTP1.1 协议的这个特点在 Header 里添加两个参数来实现的。
    这两个参数分别是客户端请求时发送的 Range 和服务器返回信息时返回的 Content-Range，Range 用于指定第一个字节和最后一个字节的位置
 2、校验
 
 YYCache和SDImageCache
 内存缓存：使用Core Foundation提供的C字典CFMutableDictionaryRef来存储封装的缓存对象，
 并构造了一个双向链表，维护链表并使用LRU淘汰算法来剔除超过限制的缓存对象，使用pthread_mutext互斥锁来保证线程安全，
 包括释放对象使用了一个小技巧使得可以在子线程中释放，而不需要在主线程中执行，直接访问ivar而不使用getter/setter，
 一系列的优化方法使得YYCache的内存缓存效率超过了NSCache及其他第三方库

 磁盘缓存：作者参考了NSURLCache的实现及其他第三方的实现，采用文件系统结合SQLite的实现方式，
 实验发现对于20KB以上的数据，文件系统的读写速度高于SQLite，所以当数据大于20KB时直接将数据保存在文件系统中，
 在数据库中保存元数据，并添加索引，数据小于20KB时直接保存在数据库中，这样，就能够快速统计相关数据来实现淘汰。
 SDWebImage的磁盘缓存使用的只有文件系统。

 
 控制器生命周期
 按照执行顺序排列：
 1. initWithCoder：通过nib文件初始化时触发。
 2. awakeFromNib：nib文件被加载的时候，会发生一个awakeFromNib的消息到nib文件中的每个对象。
 3. loadView：开始加载视图控制器自带的view。
 4. viewDidLoad：视图控制器的view被加载完成。
 5. viewWillAppear：视图控制器的view将要显示在window上。
 6. updateViewConstraints：视图控制器的view开始更新AutoLayout约束。
 7. viewWillLayoutSubviews：视图控制器的view将要更新内容视图的位置。
 8. viewDidLayoutSubviews：视图控制器的view已经更新视图的位置。
 9. viewDidAppear：视图控制器的view已经展示到window上。
 10. viewWillDisappear：视图控制器的view将要从window上消失。
 11. viewDidDisappear：视图控制器的view已经从window上消失。
 */

@implementation IBController1


- (void)setName:(NSString *)name {
    _name = name;
    NSLog(@"set方法在生命周期之前调用");
}

+ (void)initialize {
    NSLog(@"initialize");
}

+ (instancetype)alloc {
    NSLog(@"alloc");
    return [super alloc];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"initWithNibName");
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)loadView {
    [super loadView];
    NSLog(@"loadView");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    /*
     self.view置空，后面在调用view会出现循环调用，因为view是按需加载
     如果为空，会调用loadView加载view，而loadView中调用viewDidLoad；
     */
//    self.view = nil;
    self.view.backgroundColor = [UIColor whiteColor];
}

//将要布局子视图
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

//已经布局子视图
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)dealloc {
    NSLog(@"dealloc");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test0];
//    [self test1];
//    [self test2];
//    [self test3];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier addArcWithCenter:CGPointMake(0, 0) radius:80 startAngle:0 endAngle:M_PI_4 clockwise:YES];
    [bezier addLineToPoint:CGPointMake(0, 0)];
    CAShapeLayer *sectorLayer = [CAShapeLayer layer];
    sectorLayer.frame = CGRectMake(0, 0, 80, 60);
    sectorLayer.path = bezier.CGPath;
    sectorLayer.fillColor = [UIColor redColor].CGColor;
    sectorLayer.masksToBounds = YES;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, 80, 60);
    gl.startPoint = CGPointMake(0.5, 0.85);
    gl.endPoint = CGPointMake(0.5, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:128/255.0 green:39/255.0 blue:254/255.0 alpha:0].CGColor, (__bridge id)[UIColor colorWithRed:128/255.0 green:39/255.0 blue:254/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    gl.mask = sectorLayer;

    
    
    [view.layer addSublayer:gl];
    CGFloat xiaoshu = (double)arc4random()/0x100000000;
    NSLog(@"%lf", xiaoshu/100);

}

/**
 这种方法比较简单，代码量较少，但是操作layer肯定会影响性能，会造成离屏渲染
 */
- (void)test0 {
    self.imgView.layer.cornerRadius = self.imgView.width/2;
    self.imgView.layer.masksToBounds = YES;
}

/**
 Core Graphics 和 UIBezierPath
 性能较高
 */
- (void)test1 {

    //开启上下文
    UIGraphicsBeginImageContextWithOptions(self.imgView.bounds.size, NO, 1.0);
    //设置裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds cornerRadius:self.imgView.width];
    [path addClip];
    //绘制图片
    [self.imgView.image drawInRect:self.imgView.bounds];
    //从上下文中获取图片
    self.imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
}

/**
 CAShapeLayer和UIBezierPath
 这种方法的优点：可以操作任何一个角（左上，右上，左下，右下），并且消耗内存较小，渲染较快。
 缺点：操作了layer，对性能有影响，有离屏渲染
 */
- (void)test2 {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.imgView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.imgView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.imgView.layer.mask = maskLayer;
}

- (void)test3 {
    
    UIImage *image = [UIImage imageNamed:@"icon"];
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect]; // GPU损耗低内存占用大
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imgView.image = newimg;
}

- (void)test4 {
//    第四种方法：使用带圆形的透明图片.
    
}


@end
