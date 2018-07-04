//
//  ViewController.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/23.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Ext.h"
#import "IBController1.h"
#import "IBController4.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *tableArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //为了测试block中不用strong，weakself被释放情况
    if ([Student shareInstance].arr.count > 0) {
        [Student shareInstance].arr[0]();
    }
}

- (void)fitVersion {
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
}

- (void)initialize {
    self.tableArray = @[@"生命周期/圆形绘制",@"autoreleasepool/assign",@"线程",@"block",@"copy",@"layout方法",@"主线程更新UI原因",@"tableview滑动不加载图片1",@"tableview滑动不加载图片2",@"tableview滑动不加载图片3",@"响应者链",@"RunLoop",@"Runtime",@"load、initialize和排序注意",@"多继承、NSProxy",@"KVO",@"时间戳",@"组件化",@"消息机制",@"加载高清大图处理",@"离屏渲染",@"排序查找算法",@"mian函数之前做了什么",@"https、TCP、socket",@"CoreAnimation",@"Layer",@"CoreGraphics",@"数据库-表之间的关系和查询方式",@"数据库-其他",@"CoreSpotlight",@"UIScrollView",@"关联属性，关联对象",@"新闻详情页",@"GCDObjC",@"模型打印",@"NSLogger",@"RAC"];
}

- (void)setupUI {
//    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, TopBarHeight + 10, self.view.width, 40)];
//    lbl.text = @"Better late than never";
//    lbl.textColor = [UIColor redColor];
//    lbl.font = [UIFont boldSystemFontOfSize:18];
//    lbl.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:lbl];
    
    self.tableView = ({
        UITableView *tb = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.dataSource = self;
        tb.delegate = self;
        [self.view addSubview:tb];
        tb;
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.tableArray[indexPath.row];
    cell.textLabel.layer.masksToBounds = YES;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"IBController%ld",indexPath.row+1];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *controller = [NSString stringWithFormat:@"IBController%ld",indexPath.row+1];
    Class class = NSClassFromString(controller);
    if ([controller isEqualToString:@"IBController1"]) {
        IBController1 *vc = [[class alloc] initWithNibName:@"IBController1" bundle:[NSBundle mainBundle]];
        vc.title = self.tableArray[indexPath.row];
        vc.name = @"bowen";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [[class alloc] init];
        vc.title = self.tableArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
