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
 我测试不存在(xib适配iphoneX)
 
 1.设置导航条为不透明，这样，就默认从导航条下方开始计算了。
 2.把项目里所有的XIB全部换成Storyboard。
 3.在代码里做判断，然后设置
 
 另一种
 1.多添加一个距离SuperView的约束
 2.设置这个约束为>=距离
 3.设置距离Safe Area的约束优先级比距离SuperView约束优先级低。（比如750）
 
 
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
    [self test1];
//    [self test2];
//    [self test3];
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
