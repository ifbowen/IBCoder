//
//  IBCATiledLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCATiledLayer.h"
#import <UIKit/UIKit.h>

/*
 CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。
 */

@interface IBCATiledLayer ()<CALayerDelegate>

@end

@implementation IBCATiledLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    
    self.delegate = self;
    self.contentsScale = [UIScreen mainScreen].scale;
    
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
//    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
//    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
//    //load tile image
//    NSString *imageName = [NSString stringWithFormat: @"Snowman_%02i_%02i", x, y];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
//    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    
    NSString *imageName = @"AppIcon";
    UIImage *tileImage = [UIImage imageNamed:imageName];
    
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

@end
