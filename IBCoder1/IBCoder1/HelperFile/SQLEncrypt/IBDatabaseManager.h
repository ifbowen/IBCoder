//
//  IBDatabaseManager.h
//  IBCoder1
//
//  Created by Bowen on 2018/5/27.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <FMDB.h>

/**
 数据库版本管理
 */
@interface IBDatabaseManager : NSObject

+ (instancetype)managerWithDatabase:(FMDatabase *)database;
+ (instancetype)managerWithDatabasePath:(NSString *)path;

- (void)addOperations:(NSArray *)operations;
- (BOOL)execute:(void (^)(NSProgress *progress))progressBlock;

@property (nonatomic, readonly) NSInteger currentVersion;

@end

@protocol IBOperation <NSObject>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger version;

- (BOOL)executeOperation:(FMDatabase *)database;

@end

//仅支持添加字段
@interface IBAlterOperation : NSObject <IBOperation>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger version;

- (instancetype)initWithName:(NSString *)name version:(NSInteger)version sqls:(NSArray *)sqls;//自定义方法

@end

//支持修改字段名称、类型和删除字段
@interface IBRemakeOperation : NSObject <IBOperation>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger version;

/*
 info格式：
 @{@"sql"      : sql,
   @"tableName": @"User",
   @"fields"   : @[@[@{@"oldName":@"name",@"newName":@"nickname"}],@"age"]
 };
 oldName: 原始字段
 newName: 新字段
 */
- (instancetype)initWithName:(NSString *)name version:(NSInteger)version info:(NSDictionary *)info;//自定义方法

@end


