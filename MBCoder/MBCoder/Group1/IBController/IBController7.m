//
//  IBController7.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/2.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController7.h"
#import "Masonry.h"
#import "UIView+Ext.h"

@interface IBController7 ()


@property (nonatomic, strong) UIButton *btn;

@end

@implementation IBController7

/*
 像UIKit这样大的框架上确保线程安全是一个重大的任务，会带来巨大的成本。UIKit不是线程安全的，假如在两个线程中设置了同一张背景图片，很有可能就会由于背景图片被释放两次，使得程序崩溃。或者某一个线程中遍历找寻某个subView，然而在另一个线程中删除了该subView，那么就会造成错乱。apple有对大部分的绘图方法和诸如UIColor等类改写成线程安全可用，可还是建议将UI操作保证在主线程中。
 
 事实上在子线程中如果要对其他UI 进行更新，必须等到该子线程运行结束，而对响应用户点击的Button的UI更新则是及时的，不管他是在主线程还是在子线程中做的更新，意义都不大了，因为子线程中对所有其他ui更新都要等到该子线程生命周期结束才进行。
 
  在子线程中是不能进行UI 更新的，我们看到的UI更新其实是子线程代码执行完毕了，又自动进入到了主线程，执行了子线程中的UI更新的函数栈，这中间的时间非常的短，就让大家误以为分线程可以更新UI。如果子线程一直在运行，则子线程中的UI更新的函数栈 主线程无法获知，即无法更新。只有极少数的UI能直接进行UI更新，因为开辟线程时会获取当前环境，如点击某个按钮，这个按钮响应的方法是开辟一个子线程，在子线程中对该按钮进行UI 更新是能及时的，如上面的换背景图，但这没有任何意义。
 
 */

///UIKit不是线程安全的
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 44)];
    [self.btn setTitle:@"AAA" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(refreshUI) forControlEvents:UIControlEventTouchUpInside];
    self.btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [NSThread detachNewThreadSelector:@selector(test1) toTarget:self withObject:nil];
}

- (void)refreshUI {
    [self performSelector:@selector(test1) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
}

- (void)test1 {
    NSLog(@"%@",[NSThread currentThread]);
    [self.btn setTitle:@"BBB" forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor orangeColor];
    [NSThread sleepForTimeInterval:4];
}


@end
