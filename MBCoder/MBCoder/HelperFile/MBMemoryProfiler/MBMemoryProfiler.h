//
//  MBMemoryProfiler.h
//  MBCoder
//
//  Created by BowenCoder on 2020/3/9.
//  Copyright © 2020 inke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBMemoryProfiler : NSObject

+ (instancetype)profiler;

- (void)setup;

@end

NS_ASSUME_NONNULL_END
