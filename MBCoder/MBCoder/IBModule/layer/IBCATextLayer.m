//
//  IBCATextLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/7.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCATextLayer.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/**
 CATextLayer比UILabel有更好的性能表现，渲染很快。但是不支持自动布局
 
 1、可以自定义UIView并重写layerClass方法，返回CATextLayer更换底层Layer实现自动布局
 2、CATextLayer和UILabel行距和间距不同
 */
@implementation IBCATextLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    
    self.backgroundColor = [UIColor orangeColor].CGColor;
    self.contentsScale = [UIScreen mainScreen].scale;
    self.alignmentMode = kCAAlignmentJustified;
    self.wrapped = YES;
    NSString *text = @"“三位一体”高考招生改革，即把考生的会考成绩、高校对考生的测试成绩以及高考成绩，按一定比例折算成综合分，最后按照综合分择优录取考生。";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:20]
                           };
    [string setAttributes:attr range:NSMakeRange(0, string.length)];
    
    attr = @{
             NSForegroundColorAttributeName: [UIColor redColor],
             NSFontAttributeName: [UIFont systemFontOfSize:20],
             NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
             };
    [string setAttributes:attr range:NSMakeRange(0, 6)];
    
    self.string = string;
    
}

@end
