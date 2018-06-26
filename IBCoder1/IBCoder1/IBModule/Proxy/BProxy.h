//
//  BProxy.h
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBookProvider.h"
#import "BClothesProvider.h"

@interface BProxy : NSProxy<BBookProviderProtocol, BClothesProviderProtocol>

+ (instancetype)proxy;

@end
