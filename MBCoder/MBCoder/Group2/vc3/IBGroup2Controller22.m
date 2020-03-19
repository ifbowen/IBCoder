//
//  IBGroup2Controller22.m
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller22.h"
#import "MBPresentationController.h"

@interface MBPresentationViewController : UIViewController

@end

@implementation MBPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

@interface IBGroup2Controller22 ()

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) MBPresentationController *presentation;


@end

@implementation IBGroup2Controller22

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MBPresentationViewController *vc =[[MBPresentationViewController alloc] init];
    MBPresentationController *presentation = [[MBPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentation.frame = CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300);
    vc.transitioningDelegate = presentation;
    self.vc = vc;
    self.presentation = presentation;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"present" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.orangeColor];
    button.frame = CGRectMake(0, 100, self.view.frame.size.width, 44);
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)present
{
    [self presentViewController:self.vc animated:YES completion:nil];
}


@end

/*
 
 Mac环境变量配置(https://hao5743.github.io/2017/06/28/2017-06-28/)
 mac一般使用bash作为默认shell，如果安装了oh my sh，则默认使用zshshell。

 Mac系统环境变量的加载顺序：
 /etc/profile
 /etc/paths
 ~/.bash_profile
 ~/.bash_login
 ~/.profile
 ~/.bashrc

 /etc/profile和/etc/paths是系统级别的，系统启动后就会加载。后面几个是当前用户级的环境变量。
 如果~/.bash_profile存在，后面几个文件就会忽略不读，不存在时，才会以此类推读取后面的文件。
 ~/.bashrc没有上述规则，他始终加载，他是在bash shell打开的时候载入的。
 设置Path的语法
 # 中间使用冒号分隔
 export PATH=$PATH:<PATH 1>:<PATH 2>:<PATH 3>:------:<PATH N>
 全局设置
 下面的几个文件设置是全局的，修改时需要root权限

 /etc/paths （全局建议修改这个文件 ）
 编辑 paths，将环境变量添加到 paths文件中 ，一行一个路径.
 /etc/paths 文件：

 /usr/local/bin
 /usr/bin
 /bin
 /usr/sbin
 /sbin
 /etc/profile （建议不修改这个文件 ）
 全局（公有）配置，不管是哪个用户，登录时都会读取该文件。

 /etc/bashrc （一般在这个文件中添加系统级环境变量）
 全局（公有）配置，bash shell执行时，不管是何种方式，都会读取此文件。

 单个用户设置
 ~/.bash_profile （添加用户级环境变量）
 （注：Linux 里面是 .bashrc 而 Mac 是 .bash_profile）
 若bash shell是以login方式执行时，才会读取此文件，该文件仅仅执行一次，默认情况下，他设置一些环境变量。
 设置命令别名
 alias ll=’ls -la’
 设置环境变量：

 export PATH=/opt/local/bin:/opt/local/sbin:$PATH
 比如设置ANDROID_HOME到PATH：

 export ANDROID_HOME=/Users/shaoc/Library/Android/sdk

 export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
 ~/.bashrc 同上
 一般重启shell设置就会生效，如果想立刻生效，则可执行下面的语句：

 $ source 相应的文件
 zsh中配置环境变量
 在安装了oh my zsh后， .bash_profile 文件中的环境变量就无法起到作用，因为终端默认启动的是zsh，而不是bash shell，所以无法加载。

 解决方法：
 在~/.zshrc配置文件中，增加对.bash_profile的引用：

 source ~/.bash_profile
  
 */
