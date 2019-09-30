//
//  IBController36.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/13.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController36.h"
#import "NSLogger.h"

@interface IBController36 ()

@end

@implementation IBController36

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *open = [UIButton buttonWithType:UIButtonTypeSystem];
    open.titleLabel.font = [UIFont systemFontOfSize:20];
    open.frame = CGRectMake(self.view.center.x - 50, 100, 100, 40);
    [open setTitle:@"open" forState:UIControlStateNormal];
    [open addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:open];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.titleLabel.font = [UIFont systemFontOfSize:20];
    save.frame = CGRectMake(self.view.center.x - 50, 150, 100, 40);
    [save setTitle:@"save" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    UIButton *option = [UIButton buttonWithType:UIButtonTypeSystem];
    option.titleLabel.font = [UIFont systemFontOfSize:20];
    option.frame = CGRectMake(self.view.center.x - 50, 200, 100, 40);
    [option setTitle:@"option" forState:UIControlStateNormal];
    [option addTarget:self action:@selector(option) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:option];
    
}



- (void)option {
    //日志策略

    LoggerSetOptions(NULL,                        // configure the default logger
                     kLoggerOption_BufferLogsUntilConnection |
                     kLoggerOption_UseSSL |
                     kLoggerOption_LogToConsole    |
                     kLoggerOption_BrowseBonjour |
                     kLoggerOption_BrowseOnlyLocalDomain);

}

- (void)save {
    //保存日志
    NSString *bufferPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"log.rawnsloggerdata"];
    LoggerSetBufferFile(NULL, (__bridge CFStringRef)bufferPath);
}


- (void)open {
    
    //联机日志
    LoggerSetViewerHost(NULL, (__bridge CFStringRef)@"192.168.10.59", 4444);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}

static int i = 0;

- (void)test {
    i++;
    
//    UIImage *image = [UIImage imageNamed:@"AppIcon"];
//    NSData *data = UIImagePNGRepresentation(image);
    
    NSLog(@"Some message to NSLogger %d",i);
    
    NSLogger(@"123");
    LoggerError(0,@"456");
    
//    fprintf(stdout, "Some message to stdout\n");
//    fflush(stdout);
    
//    LogMessage(@"NetWork", 4, @"网络请求");
    
//    LogData(@"data", 4, UIImagePNGRepresentation(image));
    
//    LogImageData(@"image", 4, image.size.width, image.size.width, data);
    
//    LoggerFile(4,@"日志打印log");

}

@end
