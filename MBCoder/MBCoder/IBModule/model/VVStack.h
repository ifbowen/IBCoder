//
//  VVStack.h
//  MBCoder
//
//  Created by Bowen on 2019/10/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVStack : NSObject

- (void)push:(double)num;

- (double)pop;

- (double)top;

@end

NS_ASSUME_NONNULL_END
