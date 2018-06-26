//
//  BClothesProvider.m
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "BClothesProvider.h"

@implementation BClothesProvider

- (void)purchaseClothesWithSize:(BClothesSize )size{
    NSString *sizeStr;
    switch (size) {
        case BClothesSizeLarge:
            sizeStr = @"large size";
            break;
        case BClothesSizeMedium:
            sizeStr = @"medium size";
            break;
        case BClothesSizeSmall:
            sizeStr = @"small size";
            break;
        default:
            break;
    }
    NSLog(@"You've bought some clothes of %@",sizeStr);
}


@end
