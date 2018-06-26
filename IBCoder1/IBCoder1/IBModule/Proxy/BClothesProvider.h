//
//  BClothesProvider.h
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, BClothesSize){
    BClothesSizeSmall = 0,
    BClothesSizeMedium,
    BClothesSizeLarge
};

@protocol BClothesProviderProtocol

- (void)purchaseClothesWithSize:(BClothesSize )size;

@end

@interface BClothesProvider : NSObject

@end
