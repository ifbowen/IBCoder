//
//  IBController29.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/23.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController29.h"
#import "FMEncryptQueue.h"
#import <FMDB.h>
#import <FMTokenizers.h>
#import <FMDatabase+FTS3.h>
#import "FMDBMigrationManager.h"
#import "UIView+Ext.h"
#import "IBDatabaseManager.h"

@interface IBController29 ()

@property (nonatomic, strong) FMEncryptQueue *queue;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) FMSimpleTokenizer *tokenize;

@end

@implementation IBController29


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据库加密，全文搜索，版本更新";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDataBase];
    
//    [self createTable];
//    [self createSearchAll];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self operateFMTokenizers];
//    [self updateDB];
    [self updataDB1];
    
}

/**
     SQLite 仅仅支持 ALTER TABLE 语句的一部分功能，我们可以用 ALTER TABLE 语句来更改一个表的名字，也可向表中增加一个字段（列），
 但是我们不能删除一个已经存在的字段，或者更改一个已经存在的字段的名称、数据类型、限定符等等。
 */
- (void)updataDB1 {
    IBDatabaseManager *manager = [IBDatabaseManager managerWithDatabase:self.database];
    IBAlterOperation *operation1 = [[IBAlterOperation alloc] initWithName:@"新增USer表" version:1 sqls:@[@"create table User(id integer primary key autoincrement,sid integer unique, name text, age integer)"]];
    IBAlterOperation *operation2 = [[IBAlterOperation alloc] initWithName:@"USer表新增字段addr" version:2 sqls:@[@"alter table User add addr text"]];
    IBAlterOperation *operation3 = [[IBAlterOperation alloc] initWithName:@"USer表新增字段email" version:3 sqls:@[@"alter table User add email text"]];
    [manager addOperations:@[operation1, operation2, operation3]];
    [manager execute:nil];
    
    NSString *inserSQL = @"insert into User(name, age) values('bowen1',23),('bowen2',21),('bowen3',25)";
    [self.database executeUpdate:inserSQL];


    NSString *sql = @"create table User(id integer primary key autoincrement, nickname text, age text)";
    NSDictionary *info = @{@"sql"      : sql,
                           @"tableName": @"User",
                           @"fields"   : @[@[@{@"oldName":@"name",@"newName":@"nickname"}],@"age"]};
    
    IBRemakeOperation *operation5 = [[IBRemakeOperation alloc] initWithName:@"第一次迁移" version:5 info:info];
    
    [manager addOperations:@[operation5]];
    [manager execute:^(NSProgress *progress) {
        NSLog(@"%@",progress.userInfo);
    }];

}

//第三方
- (void)updateDB {
    
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabase:self.database];
    
    FMDBMigration * migration_1 = [[FMDBMigration alloc] initWithName:@"新增USer表" version:1 sqls:@[@"create table User(name text,age integer)"]];
    FMDBMigration * migration_2= [[FMDBMigration alloc] initWithName:@"USer表新增字段email" version:2 sqls:@[@"alter table User add email text"]];
    
    [manager addMigration:migration_1];
    [manager addMigration:migration_2];
    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
}


#pragma mark - 全文检索
/**
 sqlciphcer版本的sqlite有问题
 */
- (void)operateFMTokenizers {
    
    self.tokenize = [[FMSimpleTokenizer alloc] initWithLocale:NULL];
    [FMDatabase registerTokenizer:self.tokenize withKey:@"test"];
    [self.database installTokenizerModule];

    [self.database executeUpdate:@"CREATE VIRTUAL TABLE simple USING fts3(tokenize=fmdb test)"];
    
    // The FMSimpleTokenizer handles non-ASCII characters well, since it's based on CFStringTokenizer.
    NSString *text = @"I like the band Queensrÿche. They are really great musicians.";
    [self.database executeUpdate:@"INSERT INTO simple VALUES(?)", text];
    
    FMResultSet *results = [self.database executeQuery:@"SELECT * FROM simple WHERE simple MATCH ?", @"Queensrÿche"];
    while (results.next) {
        NSLog(@"%@",results.resultDictionary);
    }
}



/**
    我们的APP部分功能为了满足用户离线使用搜索的场景，使用了内置SQLite数据库的方式，随着内容的日益丰富，数据库记录快速增多，导致搜索速度明显变慢，
 为了提升搜索速度，给我们的数据做了全文检索的支持，在3W+的数据下，搜索速度由原来的数秒提升至几十到几百毫秒（设备不同，搜索效率存在差别）。
 
 FTS3是一个SQLite 虚拟表的模块
 
  一、基本概念
 概述
 全文检索是从文本或数据库中，不限定数据字段，自由地搜索出消息的技术。
 运行全文检索任务的程序，一般称作搜索引擎，它可以将用户随意输入的文字从数据库中找到匹配的内容。
 
 工作原理
    它的工作原理是计算机索引程序通过扫描文章中的每一个词，对每一个词建立一个索引，指明该词在文章中出现的次数和位置，当用户查询时，
 检索程序就根据事先建立的索引进行查找，并将查找的结果反馈给用户的检索方式。
 
 分类
 按字检索
 指对于文章中的每一个字都建立索引，检索时将词分解为字的组合。
 按词检索
 指对文章中的词，即语义单位建立索引，检索时按词检索。
 
 二、分词器
 类型    时候支持中文                   特性                                            注意
 simple    否       连续的合法字符（unicode大于等于128）和数字组词    全都会转换为小写字母
 porter    否    同上，支持生成原语义词（如一个语义的动词、名词、形容词会生成统一的原始词汇）      同上
 icu       是    多语言，需要指明本地化语言，根据语义进行分词                           可以自定义分词规则
 unicode61 是    特殊字符分词，（unicode的空格+字符，如“:”、“-”等）    只能处理ASCII字符，需要SQLite 3.7.13及以上
 
 三、MATCH部分语法
    FTS中MATCH右侧的表达式支持 AND/OR/NEAR/NOT 等运算，注意，需要区分大小写，不可以小写。
 AND  连接两个想要匹配的关键词，所查询到的结果必须同时包含 AND 连接的两个关键词。
 OR   连接两个想要匹配的关键词，不同的是，结果只要包含二者之一即可。
 NOT  也连接两个想要匹配的关键词，它匹配的结果包含前一个关键词、且不包含第二个关键词。
 NEAR 也连接两个想要匹配的关键词，它匹配的结果同时包含两个关键词，但是结果里面的这两个关键词中间默认必须不多余10个根据分词器分出的词。
      另外 NEAR 可以指定最小的间隔数量， NEAR/5 即指定间隔数最大为5。
 */
- (void)createSearchAll {
    
    NSString *createVirtualSQL = @"create virtual table t_guides using fts4(title, content, tokenize=unicode61)";
    [self.database executeUpdate: createVirtualSQL];
    
    NSString *insertSQL = @"insert into t_guides(title, content) VALUES ('医学', '我是一篇指南'),('旅游指南', '北京旅游指导手册内容');";
    [self.database executeUpdate:insertSQL];
    
    NSString *querySQL = @"select * from t_guides where t_guides match '我是*';";
    FMResultSet *results = [self.database executeQuery: querySQL];
    while (results.next) {
        NSLog(@"%@",results.resultDictionary);
    }
}

#pragma mark - 数据库加密
- (void)createTable {
    NSString *createListSQL = @"create table if not exists list(l_id integer primary key autoincrement, l_imgurl varchar(20), l_nickname varchar(20), l_lastmsg text, l_time Datatime);";
    NSString *createMessageSQL = @"create table if not exists messages(m_id integer primary key autoincrement, list_id int, m_content text, m_type int, sendID int, m_time Datetime);";
    NSString *insertListSQL = @"insert into list(l_imgurl, l_nickname, l_lastmsg) values('url1','dain1','buy something1'),('url2','dain2','buy something2'),('url3','dain3','buy something3')";
    NSString *insertMessageSQL = @"insert into messages(list_id, m_content, m_type, sendID) values(1,'hello1', 0, 1001), (2,'hello1', 0, 1001), (1,'hello2', 0, 1), (1,'hello3', 0, 1001)";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeUpdate:createListSQL] && [db executeUpdate:createMessageSQL]) {
            NSLog(@"表初始化成功");
        }
        if ([db executeUpdate:insertListSQL] && [db executeUpdate:insertMessageSQL]) {
            NSLog(@"数据初始化成功");
        }
    }];
}

- (void)createDataBase {
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"IMTable.sqlite"];
    // 1.创建数据库队列
    self.queue = [FMEncryptQueue databaseQueueWithPath:filename];
    
    NSString *filename1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"search.sqlite"];
    self.database = [FMDatabase databaseWithPath:filename1];
    [self.database open];
}


@end
