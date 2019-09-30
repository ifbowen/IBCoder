//
//  ASCameraButton.m
//  Assassin
//
//  Created by Bowen on 2018/9/29.
//  Copyright © 2018年 inke. All rights reserved.
//

#import "ASCameraButton.h"
#import "UIView+Ext.h"


@interface ASCameraButton () <UIGestureRecognizerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) CAShapeLayer *drawLayer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat strokeEndValue;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat currentRecordTime;

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat deltaRadius;
@property (nonatomic, assign) CGFloat currentRadius;

@property (nonatomic, assign) CGFloat startRadius;
@property (nonatomic, assign) CGFloat endRadius;

@end

@implementation ASCameraButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self addGesture];
        [self setupUI];
    }
    return self;
}

- (void)initData {
    self.timeDuration = 15.0;
    self.strokeEndValue = 0.0;
    self.lineWidth = 6.0;
    self.centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.startRadius = self.width/2 - self.lineWidth;
    self.endRadius = self.width/2 + self.lineWidth * 2;
    self.currentRadius = self.startRadius;
    self.deltaRadius = (self.endRadius - self.startRadius) / 12;
}

- (void)addGesture {
    // 点按手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent)];
    [self addGestureRecognizer:click];
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPress.minimumPressDuration = 0.25;
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)setupUI {
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = self.bounds;
    self.circleLayer.path = [self bezierPath:self.startRadius].CGPath;
    self.circleLayer.lineWidth = self.lineWidth;
    self.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.circleLayer];
}

- (UIBezierPath *)bezierPath:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:radius startAngle:- M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
    return path;
}


- (void)resetState{
    [self.drawLayer removeFromSuperlayer];
    self.drawLayer = nil;
    self.strokeEndValue = 0.0;
    self.currentRadius = self.startRadius;
    self.currentRecordTime = 0;
    self.circleLayer.path = [self bezierPath:self.startRadius].CGPath;
}

- (void)clickEvent {
    self.startHandle();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.endHandle();
    });
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self startAnimation];
            break;
        case UIGestureRecognizerStateEnded:
            [self endAnimation];
        default:
            break;
    }
}

- (void)startAnimation {
    
    self.startHandle();
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginDraw)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)beginDraw {
    
    self.currentRadius += self.deltaRadius;
    if (self.currentRadius <= self.endRadius ) {
        self.circleLayer.path = [self bezierPath:self.currentRadius].CGPath;
    } else {
        self.strokeEndValue += (1.0 / (self.timeDuration*60));
        self.drawLayer.strokeEnd = self.strokeEndValue;
        if (self.strokeEndValue > 1) {
            [self endAnimation];
            return;
        }
        self.currentRecordTime += 1.f/60;
    }
}

- (void)endAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self resetState];
    
    self.endHandle();
}

- (CAShapeLayer *)drawLayer {
    if(!_drawLayer){
        _drawLayer = [[CAShapeLayer alloc] init];
        _drawLayer.frame = self.bounds;
        _drawLayer.path = [self bezierPath:self.endRadius].CGPath;
        _drawLayer.lineWidth = self.lineWidth;
        _drawLayer.strokeEnd = 0;
        _drawLayer.strokeColor = [UIColor redColor].CGColor;
        _drawLayer.fillColor = [UIColor clearColor].CGColor;
        _drawLayer.lineCap = kCALineCapRound;
        _drawLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_drawLayer];
    }
    return _drawLayer;
}

@end






