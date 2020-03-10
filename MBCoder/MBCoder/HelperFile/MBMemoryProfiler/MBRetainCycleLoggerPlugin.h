//
//  MBRetainCycleLoggerPlugin.h
//  MBCoder
//
//  Created by BowenCoder on 2020/3/9.
//  Copyright © 2020 inke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBMemoryProfiler/FBMemoryProfiler.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBRetainCycleLoggerPlugin : NSObject <FBMemoryProfilerPluggable>

@end

NS_ASSUME_NONNULL_END
