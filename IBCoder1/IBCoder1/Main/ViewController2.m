//
//  ViewController2.m
//  IBCoder1
//
//  Created by Bowen on 2019/4/29.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "ViewController2.h"
#import "UIView+Ext.h"
#import "IBController1.h"
#import "IBController4.h"

@interface ViewController2 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *tableArray;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)initialize {
    self.tableArray = @[@"单例，进制转换，原码、反码、补码", @"内存空间分布和结构体内存"];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"IBGroup2Controller%ld",indexPath.row+1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *controller = [NSString stringWithFormat:@"IBGroup2Controller%ld",indexPath.row+1];
    Class class = NSClassFromString(controller);
    
    UIViewController *vc = [[class alloc] init];
    vc.title = self.tableArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}



@end