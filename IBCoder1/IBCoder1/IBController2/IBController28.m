//
//  IBController28.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/23.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController28.h"
#import <FMDB.h>

@interface IBController28 ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation IBController28

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDataBase];
    [self createOneToOneTable];
//    [self createOneToMoreTable];
//    [self createMoreToMoreTable];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self oneToOne];
//    [self oneToMore];
//    [self moreToMore];
//    [self createTrigger];
    [self createView];
}

#pragma mark - 创建视图
/**
 视图（View）是一种虚表，允许用户实现以下几点：
 1）用户或用户组查找结构数据的方式更自然或直观。
 2）限制数据访问，用户只能看到有限的数据，而不是完整的表。
 3）汇总各种表中的数据，用于生成报告。
 
 注意：SQLite 视图是只读的，因此可能无法在视图上执行 DELETE、INSERT 或 UPDATE 语句。但是可以在视图上创建一个触发器，
 当尝试 DELETE、INSERT 或 UPDATE 视图时触发，需要做的动作在触发器内容中定义。
 */
- (void)createView {
    NSString *createViewSQL = @"create view user_view as select * from user";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeStatements:createViewSQL]) {
            NSLog(@"视图创建成功");
        } else {
            NSLog(@"视图创建失败");
        }
        FMResultSet *rs = [db executeQuery:@"select * from user_view"];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
}

#pragma mark - 触发器
/**
 SQLite 触发器（Trigger）是数据库的回调函数，它会在指定的数据库事件发生时自动执行/调用
 1)SQLite的触发器(Trigger)可以指定在特定的数据库表发生 DELETE、INSERT 或 UPDATE 时触发，或在一个或多个指定表的列发生更新时触发。
 2)SQLite只支持 FOR EACH ROW 触发器(Trigger),没有FOR EACH STATEMENT触发器(Trigger)。因此，明确指定FOR EACH ROW是可选的。
 3)WHEN子句和触发器（Trigger）动作可能访问使用表单NEW.column-name和OLD.column-name的引用插入、删除或更新的行元素
 4)如果提供WHEN子句，则只针对WHEN子句为真的指定行执行SQL语句。如果没有提供WHEN子句，则针对所有行执行SQL语句。
 5)BEFORE或AFTER关键字决定何时执行触发器动作，决定是在关联行的插入、修改或删除之前或者之后执行触发器动作。
 5)当触发器相关联的表删除时，自动删除触发器（Trigger）。
 
 优点
 1)强化约束（Enforce restriction）
   触发器能够实现比CHECK 语句更为复杂的约束。
 2)跟踪变化（Auditing changes）
   触发器可以侦测数据库内的操作，从而不允许数据库中未经许可的指定更新和变化。
 3)级联运行（Cascaded operation）。
   触发器可以侦测数据库内的操作，并自动地级联影响整个数据库的各项内容。例如，某个表上的触发器中包含有对另外一个表的数据操作
  （如删除，更新，插入）而该操作又导致该表上触发器被触发。
 缺点：
 1)过多的触发器使得数据逻辑变得复杂
 2)数据操作比较隐含，不易进行调整修改
 3)触发器的功能逐渐在代码逻辑或事务中替代实现，更符合OO思想。

 */
- (void)createTrigger {
    NSString *createTriggerSQL = @"create trigger user_admin after update on user for each row begin update admin set user_id = new.sid where admin.user_id = old.sid; end;";
    NSString *updateUserSQL = @"update user set sid = 9999 where sid = 1001";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeStatements:createTriggerSQL]) {
            NSLog(@"触发器创建成功");
        } else {
            NSLog(@"触发器创建失败");
        }
        if ([db executeUpdate:updateUserSQL]) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"更新失败");
        }
    }];
}

#pragma mark - 表之间的关系
/*
 嵌套查询
 1.带有IN谓词的子查询
   当子查询返回一系列值时，适合带IN的嵌套查询。
 2.带有比较运算符的子查询
   当用户能确切知道内层查询返回的是单个值时，可以用 >、<、=、>=、<=、!=、或<>等比较运算符。
 3.带有ANY（SOME）或ALL谓词的子查询
   子查询返回单值时可以用比较运算符，但返回多值时要用ANY（有的系统用SOME）或ALL谓词修饰符。而使用ANY或ALL谓词时则必须同时使用比较运算符
 4.带有 EXISTS 谓词的子查询
   带有EXISTS 谓词的子查询不返回任何数据，只产生逻辑真值“true”或逻辑假值“false”。
 注意：
 子查询的select查询总使用圆括号括起来
 
 */

- (void)moreToMore {
    NSString *deleteCourseSQL = @"delete from course where cid = 222";
    NSString *queryLinkSQL = @"select * from link;";
    NSString *queryStudentSQL = @"select * from student where sid in (select student_id from link where course_id = 333)";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"PRAGMA foreign_keys=ON"];
        if ([db executeUpdate:deleteCourseSQL]) {
            NSLog(@"课程删除成功");
        } else {
            NSLog(@"课程删除失败");
        }
        FMResultSet *lrs = [db executeQuery:queryLinkSQL];
        while (lrs.next) {
            NSLog(@"Link表：%@",lrs.resultDictionary);
        }
        FMResultSet *srs = [db executeQuery:queryStudentSQL];
        while (srs.next) {
            NSLog(@"学生表：%@",srs.resultDictionary);
        }
    }];
}

/**
 关联表需要联合唯一：
 unique(student_id，course_id)
 student_id和student_id的组合必须是唯一的
 */
- (void)createMoreToMoreTable {
    NSString *createStudentSQL = @"create table if not exists student(id integer primary key autoincrement, sid int unique, name char(16))";
    NSString *createCourseSQL = @"create table if not exists course(id integer primary key autoincrement,cid int unique, name char(16))";
    NSString *createLinkSQL = @"create table if not exists link(id integer primary key autoincrement, student_id int, course_id int, unique(student_id,course_id), foreign key(student_id) references student(sid) on delete cascade on update cascade, foreign key(course_id) references course(cid) on delete cascade on update cascade)";
    
    NSString *insertStudentSQL = @"insert into student(sid,name) values(2012,'XiaoMing'),(2013,'XiaoHong'),(2014,'XiaoLan'),(2015,'XiaoXiao');";
    NSString *insertCourseSQL = @"insert into course(cid,name) values(111,'C++'),(222,'java'),(333,'python'),(444,'swift');";
    NSString *insertLinkSQL = @"insert into link(student_id,course_id) values(2012,111),(2012,333),(2014,222),(2015,333);";
    
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if ([db executeUpdate:createStudentSQL]) {
            NSLog(@"创学生表成功");
        } else {
            NSLog(@"创学生表失败");
        }
        if ([db executeUpdate:createCourseSQL]) {
            NSLog(@"创课程表成功");
        } else {
            NSLog(@"创课程表失败");
        }
        if ([db executeUpdate:createLinkSQL]) {
            NSLog(@"创连接表成功");
        } else {
            NSLog(@"创连接表失败");
        }
        
        if ([db executeUpdate:insertStudentSQL]) {
            NSLog(@"插入学生成功");
        } else {
            NSLog(@"插入学生失败");
        }
        if ([db executeUpdate:insertCourseSQL]) {
            NSLog(@"插入课程成功");
        } else {
            NSLog(@"插入课程失败");
        }
        if ([db executeUpdate:insertLinkSQL]) {
            NSLog(@"插入连接成功");
        } else {
            NSLog(@"插入连接失败");
        }

    }];

}

/*
 1.内连接(inner join或join)：包括相等联接和自然联接
   内连接是等值连接，它使用“=、>、<、<>”等运算符根据每个表共有的列的值匹配两个表中的行
 2.外连接
 1）在左外连接和右外连接时都会以一张表为基表，该表的内容会全部显示，然后加上两张表匹配的内容。如果基表的数据在另一张表没有记录。
    那么在相关联的结果集行中列显示为空值（NULL）。
 2）全连接左表和右表都不做限制，所有的记录都显示，两表不足的地方用null填充。
 3）sqlite不支持右连接和全连接
 4) 左连接（left join 或 left outer join）右连接（right join 或 right outer join）
    全连接（full join 或 full outer join）
 3.交叉连接（Cross join）
   交叉连接也称笛卡尔积,是将两个表中的每一条数据都进行组合。
 4.组合查询(union或union all)
   1)有两种情况需要使用组合查询：
    在一个查询中从不同的表返回结构数据.
    对一个表执行多个查询,按一个查询返回数据.
   2)组合查询一般使用union关键字，或者多条where语句，使用多条where语句的查询,也可以看做是组合查询
   3）使用union关键字的的规则
     @1.union必须由两条或者两条以上select语句组成,语句之间使用union关键字分割
     @2.union中每个查询必须包含相同的列,表达式,或聚集函数,各个列不需要以相同的顺序列出.
     @3.列数据类型必须兼容,类型不必完全相同,但必须是 DBMS可以隐含转换的类型.
     @4.使用union进行组合查询会自动去除重复的行,使用union all关键字,会显示所有匹配的行,不会去除重复.
 5.嵌套查询
 
 */
- (void)oneToMore {
    //内连接
    NSString *queryInner = @"select * from press join book on press.press_sid == book.book_pressid";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       FMResultSet *rs = [db executeQuery:queryInner];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
    
    NSLog(@"=================左连接====================");
    //左连接
    NSString *queryLeft = @"select * from press left join book on press.press_sid == book.book_pressid";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:queryLeft];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
    
    NSLog(@"================交叉查询=====================");
    //交叉查询
    NSString *queryCrossSQL = @"select * from book join press;";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:queryCrossSQL];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
    
    NSLog(@"================组合查询=====================");
    //组合查询
    NSString *queryUnionSQL = @"select * from book where book_id = 5 union select * from book where book_id = 6;";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:queryUnionSQL];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
}
/*
 一、多对一或者一对多（左边表的多条记录对应右边表的唯一一条记录）
 注意
 1.先建被关联的表，保证被关联表的字段必须唯一。
 2.在创建关联表，关联字段一定保证是要有重复的。
 */
- (void)createOneToMoreTable {
    //被关联的表-主表
    NSString *createPressSQL = @"create table if not exists press(press_id integer primary key autoincrement, press_sid int unique, press_name char(20));";
    //关联的表-从表
    NSString *createBookSQL = @"create table if not exists book(book_id integer primary key autoincrement, book_cid int unique, book_name varchar(20), book_price int, book_pressid int,constraint FK_press_book foreign key(book_pressid) references press(sid) on delete cascade on update cascade);";
    
    NSString *insertPressSQL = @"insert into press(press_sid,press_name) values(2012,'新华出版社'),(2013,'海燕出版社'),(2014,'摆渡出版社'),(2015,'大众出版社'),(2016,'人大出版社');";
    
    NSString *insertBookSQL = @"insert into book(book_cid,book_name,book_price,book_pressid) values(101,'Python',100,2012),(102,'Linux',80,2015),(103,'操作系统',70,2012),(104,'数学',50,2014),(105,'英语',103,2015),(106,'网页设计',22,2013);";
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if ([db executeUpdate:createPressSQL]) {
            NSLog(@"创建出版社表成功");
        } else {
            NSLog(@"创建出版社表失败");
        }
        if ([db executeUpdate:createBookSQL]) {
            NSLog(@"创建书表成功");
        } else {
            NSLog(@"创建书表失败");
        }
        if ([db executeUpdate:insertPressSQL]) {
            NSLog(@"插入出版社表成功");
        } else {
            NSLog(@"插入出版社表失败");
        }
        if ([db executeUpdate:insertBookSQL]) {
            NSLog(@"插入书表成功");
        } else {
            NSLog(@"插入书表失败");
        }
    }];
}

/**
 提示：一对一关系是比较少见的关系类型。但在某些情况下，还是会需要使用这种类型。
 情况一：一个表包含了太多的数据列
 情况二：将数据分离到不同的表，划分不同的安全级别。
 情况三：将常用数据列抽取出来组成一个表
 
 优点
 1.便于管理、可提高一定的查询速度
 2.减轻 CPU 的 IO 读写，提高存取效率。
 3.符合数据库设计的三大范式。
 4.符合关系性数据库的特性。
 缺点
 1.增加一定的复杂程度，程序中的读写难度加大。
 
 */
- (void)oneToOne {
    
    NSString *deleteUserSQL = @"delete from user where sid = 1003";
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"PRAGMA foreign_keys=ON"];
        if ([db executeUpdate:deleteUserSQL]) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }];
    
    NSString *queryAdminSQL = @"select * from admin;";
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *rs = [db executeQuery:queryAdminSQL];
        while (rs.next) {
            NSLog(@"%@",rs.resultDictionary);
        }
    }];
}


/**
 一对一：关联的字段唯一
 */
- (void)createOneToOneTable {
    //1.先创建被关联的表
    NSString *createUserSQL = @"create table if not exists user(id integer primary key autoincrement, sid int unique, name char(16));";
    //2.创建关联表
    NSString *createAdminSQL = @"create table if not exists admin(id integer primary key autoincrement, user_id int unique, password varchar(16), foreign key(user_id) references user(sid) on delete cascade on update cascade);";
    //3.批量插入数据
    NSString *insertUserSQL = @"insert into user(sid,name) values(1001,'susan1'),(1002,'susan2'),(1003,'susan3'),(1004,'susan4'),(1005,'susan5'),(1006,'susan6');";
    NSString *insertAdminSQL = @"insert into admin(user_id,password) values(1001,'111'),(1003,'333'),(1006,'666'),(1008,'888');";
    
    //保证线程安全
    [self.queue inDatabase:^(FMDatabase *db) {
        
//        [db beginTransaction];
        
        if ([db executeUpdate:createUserSQL]) {
            NSLog(@"创建用户表成功");
        } else {
            NSLog(@"创建用户表失败");
        }

        if ([db executeUpdate:createAdminSQL]) {
            NSLog(@"创建管理员表成功");
        } else {
            NSLog(@"创建管理员表失败");
        }
        if ([db executeUpdate:insertUserSQL]) {
            NSLog(@"插入用户表成功");
        } else {
            NSLog(@"插入用户表失败");
        }
        if ([db executeUpdate:insertAdminSQL]) {
            NSLog(@"插入管理员表成功");
        } else {
            NSLog(@"插入管理员表失败");
        }
//        [db commit];
    }];
    
}

- (void)createDataBase {
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"relationship.sqlite"];
    // 1.创建数据库队列
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
}

/*
1.事务
    事务（Transaction）是并发控制的基本单位。所谓的事务，它是一个操作序列，这些操作要么都执行，要么都不执行，它是一个不可分割的工作单
 位。例如，银行转账工作：从一个账号扣款并使另一个账号增款，这两个操作要么都执行，要么都不执行。所以，应该把它们看成一个事务。事务是数据
 库维护数据一致性的单位，在每个事务结束时，都能保持数据一致性。
 
 2.级联操作（在iOS中使用级联操作需要先开启"PRAGMA foreign_keys=ON"）
   级联更新(on update cascade):在更新父表中数据的时候，级联更新子表中数据；
   级联删除(on delete cascade):在删除父表数据的时候，级联删除子表中数据；
 
 3.表之间的关系（利用foreign key）
 表1 foreign key 表2
 多对一
 则表1的多条记录对应表2的一条记录，即多对一
 多对多：
 表1的多条记录可以对应表2的一条记录
 表2的多条记录也可以对应表1的一条记录
 一对一：
 表1的一条记录唯一对应表2的一条记录，反之亦然
 
 4.constraint 前缀
 
 PK - Primary Key
 constraint PK_字段 primary key(字段),
 
 IX - Non-Unique Index
 
 AK - Unique Index (AX should have been AK (Alternate Key))
 
 CK - Check Constraint
 constraint CK_字段 check(约束。如：len(字段)>1),
 
 DF - Default Constraint
 constrint DF_字段 default('默认值') for 字段,
 
 FK - Foreign Key
 constraint FK_主表_从表 foreign(外键字段) references 主表(主表主键字段)

 UK - Unique Key Constraint
 constraint UK_字段 unique key(字段),
 
 5.PRAGMA：可以用在SQLite环境内控制各种环境变量和状态标志
    


 

 */

@end
