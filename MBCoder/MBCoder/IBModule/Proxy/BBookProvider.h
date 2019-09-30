//
//  BBookProvider.h
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBookProviderProtocol

- (void)purchaseBookWithTitle:(NSString *)bookTitle;

@end


@interface BBookProvider : NSObject

@end
