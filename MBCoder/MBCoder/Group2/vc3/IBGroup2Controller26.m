//
//  IBGroup2Controller26.m
//  MBCoder
//
//  Created by Bowen on 2020/3/19.
//  Copyright © 2020 inke. All rights reserved.
//

#import "IBGroup2Controller26.h"
#import <WebRTC/WebRTC.h>

@interface IBGroup2Controller26 ()

@end

@implementation IBGroup2Controller26

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

/*
 
 iOS下音视频通信的实现-基于WebRTC
 1、安装 depot_tools

 git 命令获取 depot_tools：
 $ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
 
 配置坏境变量
 $ echo "export PATH=$PWD/depot_tools:$PATH" > $HOME/.bash_profile
 $ source $HOME/.bash_profile
 
 检测配置是否成功
 $ echo $PATH
 
 2、安装 ninja

 ninja 是 WebRTC 的编译工具，我们需要对其进行编译，步骤如下：
 $ git clone git://github.com/martine/ninja.git
 $ cd ninja/
 $ ./bootstrap.py
 
 复制到系统目录（也可配置坏境变量）
 $ sudo cp ninja /usr/local/bin/
 $ sudo chmod a+rx /usr/local/bin/ninja
 
 3、下载源代码
 
 设置要编译的平台到环境变量中：
 $ export GYP_DEFINES="OS=ios"
 
 下载所需要的工程
 $ fetch --nohooks webrtc_ios
 
 与远端 repo 进行代码同步
 $ gclient sync -r 52b6562a10b495cf771d8388ee51990d56074059 --force
 在https://webrtc.github.io/webrtc-org/release-notes/ 选择最新提交版本
 
 4、编译WebRTC.framework
 $ cd /src/tools_webrtc/ios/
 $ ./build_ios_libs.sh
 
 
 5、错误记录
 
 错误：buildtools/mac/gn文件不存在
 解决方案：gn下载网站，去网站上下载一个，放到需要的目录下，之后会在报错信息中告诉你，当前gn与需要的gn版本不一致，然后错误信息中会给出需要的版本的下载路径

 错误：下载https://commondatastorage.googleapis.com/chromium-browser-clang/Mac/clang-363790-d874c057-3.tgz失败
 解决方案:这个问题也是因为GFW导致的，需要打开tools/clang/scripts/update.py，配置urlopen翻墙，也就是挂代理
 
 import urllib2
 proxies=urllib2.ProxyHandler({'https':'127.0.0.1:1087'})
 opener=urllib2.build_opener(proxies)
 urllib2.install_opener(opener)
 
 如果还是不行的话可能是网络不好，多试几遍
 
 错误：找不到.cipd_bin/vpython文件 解决方案: 在终端执行update_depot_tools命令，如果执行该命令报错
 curl: (35) error:1400410B:SSL routines:CONNECT_CR_SRVR_HELLO:wrong version number
 这是因为网络不好的原因，网络好的话，秒级时间就OK
 我是执行gclient生成的，看人品。
 
 
 参考文档：
 http://www.cocoachina.com/articles/18837
 http://www.enkichen.com/2017/05/12/webrtc-ios-build/
 https://depthlove.github.io/2019/05/02/webrtc-development-2-source-code-download-and-build/
 https://skylerlee.github.io/codelet/2017/03/08/build-v8/
 https://whisperloli.github.io/2019/07/04/compile_chromedriver
 
*/

@end
