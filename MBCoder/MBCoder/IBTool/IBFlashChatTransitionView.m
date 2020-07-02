//
//  IBFlashChatTransitionView.m
//  IBCoder1
//
//  Created by Bowen on 2020/6/30.
//  Copyright © 2020 BowenCoder. All rights reserved.
//

#import "IBFlashChatTransitionView.h"
#import "UIMacros.h"

@implementation IBFlashChatTransitionView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)k16RGBA(0x142a44, 0.6).CGColor, (__bridge id)k16RGBA(0x142a44, 1.0).CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MAX(rect.size.width / 2.0, rect.size.height / 2.0) * sqrt(2);

    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
