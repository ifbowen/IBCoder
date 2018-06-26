//
//  FMEncryptDB.h
//  IBCoder1
//
//  Created by Bowen on 2018/5/25.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "FMDatabase.h"

@interface FMEncryptDB : FMDatabase

/** 如果需要自定义encryptkey，可以调用这个方法修改（在使用之前）*/
+ (void)setEncryptKey:(NSString *)encryptKey;

@end
