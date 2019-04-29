//
//  IBController14.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController14.h"
#import "Son.h"

@interface IBController14 ()

@end

@implementation IBController14

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Son *son = [[Son alloc] init];
    [son run];
    [son sleep];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    test();
}

void test() {
    NSArray *names = @[@"夏侯惇", @"貂蝉", @"诸葛亮", @"张三", @"李四", @"流火绯瞳", @"流火", @"李白", @"张飞", @"韩信", @"范冰冰", @"赵丽颖"];
    NSArray *ages = @[@"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58", @"2018-01-30 19:49:58"];
    NSArray *heights = @[@"170", @"163", @"180", @"165", @"163", @"176", @"174", @"183", @"186", @"178", @"167", @"160"];
    
    NSMutableArray *peoples = [NSMutableArray arrayWithCapacity:names.count];
    for (int i = 0; i<names.count; i++) {
        
        Son *son = [[Son alloc]init];
        [son setValue:@"nan" forKey:@"sex"];
        son.name = names[i];
        son.age = ages[i];
        son.height = heights[i];
        [peoples addObject:son];
    }
    //双重排列的的属性类型必须一样
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    
    [peoples sortUsingDescriptors:@[sort,sort1]];
    
    // 输出排序结果
    for (Son *temp in peoples) {
        NSLog(@"age: %@, height: %@, sex: %@, name: %@", temp.age, temp.height, temp.sex, temp.name);
    }

}

@end
