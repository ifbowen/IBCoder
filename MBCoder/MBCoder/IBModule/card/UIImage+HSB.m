//
//  UIImage+HSB.m
//  MBCoder
//
//  Created by Bowen on 2019/12/24.
//  Copyright © 2019 inke. All rights reserved.
//

#import "UIImage+HSB.h"

@implementation UIImage (HSB)

// Category方法
// 3个入参均为偏移量，传0-360之间的正整数，默认传0。
- (UIImage *)changeImageWithHueOffset:(CGFloat)hueOffset saturationOffset:(CGFloat)saturationOffset brightnessOffset:(CGFloat)brightnessOffset {
    CGImageRef image = self.CGImage;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    CGContextRef context = CGBitmapContextCreate(data,width,height,bitsPerComponent,bytesPerRow,space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    for (size_t i = 0; i < height; i++) {
        for (size_t j = 0; j < width; j++) {
            size_t pixelIndex = i * width * 4 + j * 4;
            unsigned char red = data[pixelIndex];
            unsigned char green = data[pixelIndex + 1];
            unsigned char blue = data[pixelIndex + 2];
            unsigned char a = data[pixelIndex + 3];
            if (a == 0) { // 不处理透明通道
                continue;
            }
            // 修改颜色
            // RGB转HSV
            UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:a];
            CGFloat hue;
            CGFloat saturation;
            CGFloat brightness;
            CGFloat alpha;
            BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            if (success) {
                // 修改HSV
                CGFloat (^block)(CGFloat, CGFloat) = ^(CGFloat value, CGFloat offset) {
                    if (offset) {
                        value = value * 360 + offset;
                        if (value > 360) {
                            value = value - 360;
                        }
                        value = value / 360;
                    }
                    return value;
                };
                hue = block(hue, hueOffset);
                saturation = block(saturation, saturationOffset);
                brightness = block(brightness, brightnessOffset);
                
                // HSV转RGB
                color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
                CGFloat red;
                CGFloat green;
                CGFloat blue;
                BOOL success = [color getRed:&red green:&green blue:&blue alpha:&alpha];
                if (success) {
                    data[pixelIndex] = red;
                    data[pixelIndex + 1] = green;
                    data[pixelIndex + 2] = blue;
                    continue;
                }
            }
            data[pixelIndex] = red;
            data[pixelIndex + 1] = green;
            data[pixelIndex + 2] = blue;
        }
    }
    image = CGBitmapContextCreateImage(context);
    return [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

-(void)doCIColorMatrixFilter
{
    // Make the input image recipe
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"facedetectionpic.jpg"].CGImage]; // 1

    // Make the filter
    CIFilter *colorMatrixFilter = [CIFilter filterWithName:@"CIColorMatrix"]; // 2
    [colorMatrixFilter setDefaults]; // 3
    [colorMatrixFilter setValue:inputImage forKey:kCIInputImageKey]; // 4
    [colorMatrixFilter setValue:[CIVector vectorWithX:1 Y:1 Z:1 W:0] forKey:@"inputRVector"]; // 5
    [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputGVector"]; // 6
    [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:1 W:0] forKey:@"inputBVector"]; // 7
    [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"]; // 8

    // Get the output image recipe
    CIImage *outputImage = [colorMatrixFilter outputImage];  // 9

    // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]]; // 10
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
}


@end
