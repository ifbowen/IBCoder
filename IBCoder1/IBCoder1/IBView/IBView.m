//
//  IBView.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/2.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBView.h"

@implementation IBView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    UIView *review = [[UIView alloc] initWithFrame:CGRectMake(107, 0, 200, 44)];
    review.backgroundColor = [UIColor grayColor];
    [self addSubview:review];
    review.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)updateConstraints {
    [super updateConstraints];
    NSLog(@"%s",__func__);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%s",__func__);
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSLog(@"%s",__func__);
    return [super sizeThatFits:size];
}


+ (BOOL)requiresConstraintBasedLayout {
    [super requiresConstraintBasedLayout];
    NSLog(@"%s",__func__);
    return YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"%s",__func__);
}

@end
