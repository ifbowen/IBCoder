//
//  IBDatabaseManager.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/27.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBDatabaseManager.h"

@interface IBDatabaseManager ()

@property (nonatomic, readonly) FMDatabase *database;
@property (nonatomic, assign)   BOOL existVersionTable;
@property (nonatomic, strong)   NSMutableArray *operations;

@end

@implementation IBDatabaseManager

+ (instancetype)managerWithDatabasePath:(NSString *)path
{
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    return [[self alloc] initWithDatabase:database];
}

+ (instancetype)managerWithDatabase:(FMDatabase *)database
{
    return [[self alloc] initWithDatabase:database];
}

- (instancetype)initWithDatabase:(FMDatabase *)database
{
    if (!database) NSLog(@"error initialize manager (database is nil)");
    if ([super init]) {
        _database = database;
        if (![_database goodConnection]) {
            [database open];
        }
        _existVersionTable = [self createVersionTable];
        _currentVersion = [self maxVersion];
        if (!_existVersionTable) {
            NSLog(@"error initialize manager (create version table failed)");
        }
    }
    return self;
}

- (void)dealloc {
    [self.database close];
}

- (void)addOperations:(NSArray *)operations {
    NSParameterAssert(operations);
    [self.operations removeAllObjects];
    for (id<IBOperation> operation in operations) {
        if (operation.version > self.currentVersion) {
            [self.operations addObject:operation];
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"version" ascending:YES];
    [self.operations sortUsingDescriptors:@[sort]];
}

- (BOOL)execute:(void (^)(NSProgress *progress))progressBlock{
    BOOL success = YES;
    if (self.operations.count == 0) {
        return success;
    }
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:self.operations.count];
    for (id<IBOperation> operation in self.operations) {
        [self.database beginTransaction];

        success = [operation executeOperation:self.database];
        if (!success) {
            [self.database rollback];
            break;
        }
        success = [self.database executeUpdate:@"insert into DBVersion(version, name) values (?,?)", @(operation.version), operation.name];
        if (!success) {
            [self.database rollback];
            break;
        }
        
        progress.completedUnitCount++;
        if (progressBlock) {
            [progress setUserInfoObject:operation forKey:@"operation"];
            progressBlock(progress);
            if (progress.cancelled) {
                success = NO;
                [self.database rollback];
                break;
            }
        }
        [self.database commit];
    }
    
    return success;
}

- (BOOL)createVersionTable {
    if (self.existVersionTable) return YES;
    NSString *createVersionSQL = @"create table if not exists DBVersion(id integer primary key autoincrement, version integer unique, name text)";
    return [self.database executeUpdate:createVersionSQL];
}

- (BOOL)existVersionTable {
    if (!_existVersionTable) {
        _existVersionTable = NO;
        FMResultSet *resultSet = [self.database executeQuery:@"select name from sqlite_master where type='table' AND name=?", @"DBVersion"];
        if ([resultSet next]) {
            [resultSet close];
            _existVersionTable = YES;
        }
    }
    return _existVersionTable;
}

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [ NSMutableArray array];
    }
    return _operations;
}

- (NSInteger)maxVersion
{
    if (!self.existVersionTable) return 0;

    uint64_t version = 0;
    FMResultSet *resultSet = [self.database executeQuery:@"select max(version) from DBVersion"];
    if ([resultSet next]) {
        version = [resultSet unsignedLongLongIntForColumnIndex:0];
    }
    [resultSet close];
    return version;;
}

@end


@interface IBAlterOperation ()

@property (nonatomic, copy) NSArray *sqls;

@end

@implementation IBAlterOperation

- (instancetype)initWithName:(NSString *)name version:(NSInteger)version sqls:(NSArray *)sqls{
    if (self=[super init]) {
        _name    = name;
        _version = version;
        _sqls     = sqls;
    }
    return self;
}

- (BOOL)executeOperation:(FMDatabase *)database
{
    BOOL success = NO;
    for(NSString *sql in _sqls) {
        success = [database executeUpdate:sql];
        if (!success) {
            break;
        }
    }
    return success;
}

@end

@interface IBRemakeOperation ()

@property (nonatomic, copy) NSDictionary *info;
@property (nonatomic, strong) NSMutableArray *fields;

@end

@implementation IBRemakeOperation

- (instancetype)initWithName:(NSString *)name version:(NSInteger)version info:(NSDictionary *)info{
    if (self=[super init]) {
        _name    = name;
        _version = version;
        _info   = info;
        _fields = [NSMutableArray array];
        [self judgeInfo];
    }
    return self;
}

- (BOOL)executeOperation:(FMDatabase *)database {
    
    BOOL success = NO;
    
    //1.把原来表改为临时表
    NSString *renameSQL = [NSString stringWithFormat:@"alter table %@ rename to temp",self.info[@"tableName"]];
    success = [database executeUpdate:renameSQL];
    if (!success) {
        return success;
    }
    
    //2.使用原来表名重新建表
    success = [database executeUpdate:self.info[@"sql"]];
    if (!success) {
        return success;
    }

    //3.迁移数据
    NSMutableString *oldFields = @"".mutableCopy;
    NSMutableString *newFields = @"".mutableCopy;
    [self fetchNewFields:newFields oldField:oldFields];
    NSString *moveDataSQL = [NSString stringWithFormat: @"insert into %@(%@) select %@ from temp",self.info[@"tableName"],newFields,oldFields];
    success = [database executeUpdate:moveDataSQL];
    if (!success) {
        return success;
    }

    //4.删除临时表
    NSString *dropTableSQL = @"drop table temp";
    success = [database executeUpdate:dropTableSQL];
    if (!success) {
        return success;
    }

    return success;
}

- (void)judgeInfo {
 
    if (!self.info[@"sql"]) {
        NSLog(@"error invalid parameter (sql is nil)");
    }
    if (!self.info[@"tableName"]) {
        NSLog(@"error invalid parameter (tableName is nil)");
    }
    if (!self.info[@"fields"]) {
        NSLog(@"error invalid parameter (Fields is nil)");
    }
}

- (void)fetchNewFields:(NSMutableString *)newFields oldField:(NSMutableString *)oldFields {
    
    NSArray *fields = self.info[@"fields"];
    for (int i = 0; i < fields.count; i++) {
        id obj = fields[i];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [oldFields appendString:obj];
            [newFields appendString:obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in obj) {
                [oldFields appendString:dict[@"oldName"]];
                [newFields appendString:dict[@"newName"]];
            }
        }
        if (i != fields.count - 1) {
            [oldFields appendString:@","];
            [newFields appendString:@","];
        }
    }
}


@end


