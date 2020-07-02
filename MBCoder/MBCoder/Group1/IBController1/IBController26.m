//
//  IBController26.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/18.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController26.h"
#import "UIView+Ext.h"
#import "IBCALayer.h"
#import "IBCAShapeLayer.h"
#import "IBCATextLayer.h"
#import "IBCATransformLayer.h"
#import "IBCAGradientLayer.h"
#import "IBCAReplicatorLayer.h"
#import "IBCATiledLayer.h"
#import "IBCAEmitterLayer.h"
#import "UIMacros.h"

@interface IBController26 ()

@property (nonatomic, strong) UIView *containerView;

@end
//https://www.kancloud.cn/manual/ios/97792
@implementation IBController26

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, 300)];
    self.containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.containerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
//    [self test8];
    [self test9];
}

- (void)test9
{
    UIImage *image = [UIImage imageNamed:@"flashchat_search_oval"];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = k16RGB(0x142a44);
    [self.view addSubview:view];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat x = self.view.width/2 - width/2;
    CGFloat y = self.view.height/2 - height/2;
    CGRect rect = CGRectMake(x, y, width, height);
    CGRect rect1 = CGRectMake(x+1, y+1, width-2, height-2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:rect1];
    [path appendPath:path1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = view.bounds;
    view.layer.mask = shapeLayer;

    UIImageView *view0 = [[UIImageView alloc] initWithFrame:rect];
    view0.image = image;
    [self.view addSubview:view0];
    
}

- (void)test8_1
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    CGFloat height = view.frame.size.height;
    CGFloat width = view.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, height)]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = view.bounds;
    [view.layer addSublayer:shapeLayer];
    
//    view.layer.mask = shapeLayer;
}

- (void)test8 {
    IBCAEmitterLayer *emitter = [IBCAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
}

- (void)test7 {
    
    IBCATiledLayer *tileLayer = [IBCATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 320, self.view.width - 20, 300)];
    scroll.backgroundColor = [UIColor lightGrayColor];
    [scroll.layer addSublayer:tileLayer];
    scroll.contentSize = tileLayer.frame.size;
    [self.view addSubview:scroll];
    
    [tileLayer setNeedsDisplay];
    
}

- (void)test6 {
    IBCAReplicatorLayer *layer = [IBCAReplicatorLayer layer];
    layer.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:layer];

}

- (void)test5 {
    IBCAGradientLayer *layer = [IBCAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, self.view.width - 100, 300);
    [self.containerView.layer addSublayer:layer];
}

- (void)test4 {
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = pt;
    
    //set up the transform for cube 1 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);

    IBCATransformLayer *transform = [[IBCATransformLayer alloc] init];
    transform.frame = CGRectMake(0, 0, self.view.width - 100, 300);
    CALayer *cube1 = [transform cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube1];
}

- (void)test3 {
    IBCATextLayer *layer = [[IBCATextLayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.view.width - 100, 300);
    [self.containerView.layer addSublayer:layer];

}

- (void)test2 {
    IBCAShapeLayer *layer = [[IBCAShapeLayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.view.width - 200, 100);
    [self.containerView.layer addSublayer:layer];

}

- (void)test1 {

    IBCALayer *layer = [[IBCALayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.view.width - 200, 100);
    [self.containerView.layer addSublayer:layer];
}

@end
