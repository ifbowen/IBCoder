//
//  NSObject+debugDescription.h
//  ModelLog
//
//  Created by BowenCoder on 2017/8/3.
//  Copyright © 2017年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Log)

- (NSDictionary *)ib_description;

@end

@interface NSDictionary (Log)

- (NSString *)ib_description;

@end

@interface NSArray (Log)

- (NSString *)ib_description;

@end


