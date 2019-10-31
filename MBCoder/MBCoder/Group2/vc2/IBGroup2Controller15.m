//
//  IBGroup2Controller15.m
//  MBCoder
//
//  Created by Bowen on 2019/10/31.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller15.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "IBGroup2Controller15Cell.h"

@interface IBGroup2Controller15 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation IBGroup2Controller15

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self.view addSubview:self.tableView];
}

- (void)setupData
{
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *feedDicts = rootDict[@"feed"];
    
    NSMutableArray *entities = @[].mutableCopy;
    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MBFeedEntity *entity = [[MBFeedEntity alloc] initWithDictionary:obj];
        [entities addObject:entity];
    }];
    
    self.data = entities.copy;
}

- (void)configureCell:(IBGroup2Controller15Cell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.entity = self.data[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IBGroup2Controller15Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"IBGroup2Controller15"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"IBGroup2Controller15" cacheByIndexPath:indexPath configuration:^(IBGroup2Controller15Cell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - getter

- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:IBGroup2Controller15Cell.class forCellReuseIdentifier:@"IBGroup2Controller15"];
    }
    return _tableView;
}

/*
 高度缓存
 1.FDIndexPathHeightCache缓存策略
 1）针对横屏\竖屏分别声明了 2 个以 indexPath 为索引的二维数组来存储高度
 2）一般来说 cacheByIndexPath: 方法最为“傻瓜”，可以直接搞定所用问题。
 
 2.FDKeyedHeightCache缓存策略
 1）FDKeyedHeightCache采用字典做缓存，没有复杂的数组构建、存取操作，源码实现上相比于FDIndexPathHeightCache要简单得多。
    当然，在删除、插入、刷新 相关的缓存操作并没有实现，因此需要开发者来自己完成。
 2）cacheByKey: 方法稍显复杂（需要关注数据刷新），但在缓存机制上相比 cacheByIndexPath: 方法更为高效
 3）如果cell高度发生变化（数据源改变），那么需要手动对高度缓存进行处理:invalidateHeightForKey:和invalidateAllHeightCache
 
 3.创建模板cell，计算高度
 默认情况下是使用autoLayout的(fd_enforceFrameLayout属性默认为NO)，如果使用的是frameLayout则设置fd_enforceFrameLayout为YES，
 代码会根据你使用的layout模式来计算templateCell的高度。使用autoLayout的用systemLayoutSizeFittingSize:方法。
 使用frameLayout需要在自定义Cell里重写sizeThatFit:方法。如果两种模式都没有使用，单元格高度设为默认的44。
  
 4.关于UILable的问题：
 当 UILabel 行数大于0时，需要指定 preferredMaxLayoutWidth 后它才知道自己什么时候该折行。这是个“鸡生蛋蛋生鸡”的问题，
 因为 UILabel 需要知道 superview 的宽度才能折行，而 superview 的宽度还依仗着子 view 宽度的累加才能确定。
 框架中的做法是：先计算contentView的宽度，然后对contentView添加宽度约束，然后使用systemLayoutSizeFittingSize：计算获得高度，
 计算完成以后移除contentView的宽度约束。
 
 5、注意点
 1）创建cell，要保证 contentView 内部上下左右所有方向都有约束支撑。
 2）使用代码或 XIB 创建的 cell，使用以下注册方法:
 - (void)registerClass:(nullableClass)cellClassforCellReuseIdentifier:(NSString *)identifier;
 - (void)registerNib:(nullableUINib *)nibforCellReuseIdentifier:(NSString *)identifier;
 3）cell通过-dequeueCellForReuseIdentifier:来创建。
 4）解决初始化的时候约束警告
    cell.bounds = [UIScreen mainScreen].bounds;
 
 */


@end
