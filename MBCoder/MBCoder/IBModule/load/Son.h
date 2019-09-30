//
//  Son.h
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Father.h"

@interface Son : Father

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *age;
@property (readonly, nonatomic, copy) NSString *sex;

- (void)run;

@end
