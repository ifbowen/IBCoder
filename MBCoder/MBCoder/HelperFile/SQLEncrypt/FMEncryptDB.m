//
//  FMEncryptDB.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/25.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "FMEncryptDB.h"
#import <sqlite3.h>
#import <objc/runtime.h>
@interface FMEncryptDB ()

@property (nonatomic) void *database;

@end

@implementation FMEncryptDB

static NSString *encryptKey_;

+ (void)initialize
{
    [super initialize];
    //初始化数据库加密key，在使用之前可以通过 setEncryptKey 修改
    encryptKey_ = @"FDLSAFJEIOQJR34JRI4JIGR93209T489FR";
}

#pragma mark - Override Methods
- (BOOL)open {
    if (_database) {
        return YES;
    }
    
    int err = sqlite3_open([self sqlitePath], (sqlite3**)&_database);
    //给父类私有属性赋值
    Ivar _db = class_getInstanceVariable([self class], "_db");
    object_setIvar(self, _db, (__bridge id _Nullable)(_database));
    
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        //数据库open后设置加密key
        [self setKey:encryptKey_];
    }
    
    if (self.maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:self.maxBusyRetryTimeInterval];
    }
    
    return YES;
}

- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName {
#if SQLITE_VERSION_NUMBER >= 3005000
    if (_database) {
        return YES;
    }
    
    int err = sqlite3_open_v2([self sqlitePath], (sqlite3**)&_database, flags, [vfsName UTF8String]);
    //给父类私有属性赋值
    Ivar _db = class_getInstanceVariable([self class], "_db");
    object_setIvar(self, _db, (__bridge id _Nullable)(_database));
    
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        //数据库open后设置加密key
        [self setKey:encryptKey_];
    }
    
    if (self.maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:self.maxBusyRetryTimeInterval];
    }
    
    return YES;
#else
    NSLog(@"openWithFlags requires SQLite 3.5");
    return NO;
#endif
}

- (const char*)sqlitePath {

    if(!self.databasePath) {
        return ":memory:";
    }

    if([self.databasePath length] == 0) {
        return ""; // this creates a temporary database (it's an sqlite thing).
    }

    return [self.databasePath fileSystemRepresentation];

}

#pragma mark - 配置方法
+ (void)setEncryptKey:(NSString *)encryptKey
{
    encryptKey_ = encryptKey;
}

@end
