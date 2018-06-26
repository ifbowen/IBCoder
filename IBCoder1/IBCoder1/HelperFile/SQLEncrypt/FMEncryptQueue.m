//
//  FMEncryptDatabaseQueue.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/25.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "FMEncryptQueue.h"
#import "FMEncryptDB.h"

@implementation FMEncryptQueue

+ (Class)databaseClass
{
    return [FMEncryptDB class];
}

@end
