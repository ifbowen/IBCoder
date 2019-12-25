//
//  UIImage+HSB.h
//  MBCoder
//
//  Created by Bowen on 2019/12/24.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HSB)

- (UIImage *)changeImageWithHueOffset:(CGFloat)hueOffset saturationOffset:(CGFloat)saturationOffset brightnessOffset:(CGFloat)brightnessOffset;

@end

NS_ASSUME_NONNULL_END
