//
//  IBGroup2Controller3.m
//  IBCoder1
//
//  Created by Bowen on 2019/5/17.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller3.h"
#import "Person.pbobjc.h"

@interface IBGroup2Controller3 ()

@end

@implementation IBGroup2Controller3

/*
 三目运算符
 x ?: y等价于x ? x : y
 ?: c89的语法规则
 一、ATS
 1、App Transport Security (ATS) 是苹果在 iOS9 中为了保障网络安全通讯引进的组件，
 ATS 实际上封装了传输层安全(Transport Layer Security - TLS)。
 a、ATS只允许连接遵守 TLS 1.2 协议的服务器。
 b、ATS只允许连接使用 AES128+ 和 SHA2+ 强加密算法的服务器。
 c、ATS只允许连接遵守完全前向保密 (Perfect Forward Secrecy - PFS) 协议的服务器。
 
 2、不能支持 TLS 怎么办？
 ATS为此提供了相关配置：
 NSAllowArbitraryLoads - 直接禁止 ATS 安全策略， 允许 HTTP 和 非安全的 HTTPS 建立连接。
 NSExceptionAllowsInsecureHTTPLoads - 允许 HTTP 协议访问目标域名。
 NSExceptionMinimumTLSVersion - 指定支持的 TLS 的最低版本号。
 NSExceptionRequiresForwardSecrecy  - 不要求支持完全前向保密。
 NSAllowsArbitraryLoadsForMedia  - 通过AVFoundation操作远程媒体流
 NSAllowsArbitraryLoadsInWebContent - 通过 WKWebView 访问和展示网站内容。
 NSThirdPartyExceptionAllowsInsecureHTTPLoads - 允许 HTTP 协议访问第三方服务器目标域名。
 NSThirdPartyExceptionRequiresForwardSecrecy - 不要求第三方服务器支持完全前向保密。
 NSThirdPartyExceptionMinimumTLSVersion - 指定第三方服务器支持的 TLS 的最低版本号。
 
 二、User Agent
 中文名为用户代理，简称 UA，它是一个特殊字符串头，使得服务器能够识别客户使用的操作系统及版本、
 CPU 类型、浏览器及版本、浏览器渲染引擎、浏览器语言、浏览器插件等。
 例如：Aurora/1.0.01 (iPhone; iOS 12.2; Scale/2.00)
 1、NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",
 [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?:
 [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
 [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?:
 [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
 [[UIDevice currentDevice] model],
 [[UIDevice currentDevice] systemVersion],
 [[UIScreen mainScreen] scale]];
 2、[self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
 
 三、OAuth2基本概念和运作流程
 https://segmentfault.com/a/1190000013467122
 OAuth（开放授权）是一个关于授权的开放标准，允许用户让第三方应用访问该用户在某一网站上存储的私密的资源（如照片，视频，联系人列表），
 而无需将用户名和密码提供给第三方应用。目前的版本是2.0版，本文将对OAuth2.0的一些基本概念和运行流程做一个简要介绍。主要参考RFC-6749。
 运行流程：
 （A）客户端向资源所有者请求授权。授权请求可以直接对资源所有者(如图所示)进行，或者通过授权服务器作为中介进行间接访问（首选方案）。
 （B）资源所有者允许授权，并返回凭证（如code）。
 （C）客户端通过授权服务器进行身份验证，并提供授权凭证（如code），请求访问令牌（access token）。
 （D）授权服务器对客户端进行身份验证，并验证授权凭证，如果有效，则发出访问令牌。
 （E）客户端向资源服务器请求受保护的资源，并通过提供访问令牌来进行身份验证。
 （F）资源服务器验证访问令牌，如果正确则返回受保护资源。
 
 OAuth 2.0定义了四种类型的授权类型：
 授权码模式（authorization code）
 简化模式（implicit）
 密码模式（resource owner password credentials）
 客户端模式（client credentials）
 
 总结，在iOS上使用AFOAuth2Manager实现比较简单
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@", nil ?: @"456");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 创建对象
    Person *person = [Person new];
    person.name = @"bowen";
    person.uid = 20170810;
    person.email = @"bowen@qq.com";
    
    // 序列化为Data
    NSData *data = [person data];
    NSLog(@"NSData= %@", data);
    
    // 反序列化为对象
    Person *person2 = [Person parseFromData:data error:NULL];
    NSLog(@"name:%@ uid:%d email:%@",person2.name,person2.uid,person2.email);
}

@end

/*
 配置protobuf编译器
 方法一
 1、首先将文件下载下来https://github.com/google/protobuf/releases
 2、然后依次执行：
 $ ./configure
 $ make
 $ make check
 $ make install
 
 方法二
 1、首先将文件下载下来https://github.com/protocolbuffers/protobuf
 2、然后依次执行：
 $ ./autogen.sh
 $ ./configure
 $ make
 $ make install
 
 
 3、使用PB编译器编译.proto文件
 $ touch Person.proto
 $ protoc *.proto --objc_out=../ //生成model
 
 例子：
 syntax = "proto3";
 message Person {
    string name = 1;
    int32 uid = 2;
    string email = 3;
    enum PhoneType {
        MOBILE = 0;
        HOME = 1;
        WORK = 2;
 }
 message PhoneNumber {
    string number = 1;
    PhoneType type = 2;
 }
 repeated PhoneNumber phone = 4;
 
 }
 
 4、把Model引入工程，Compile Source把Model的.m文件设置为-fno-objc-arc
 
 */
