//
//  AppDelegate.m
//  MBCoder
//
//  Created by Bowen on 2019/9/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "SonicSetup.h"
#import "TPCallTrace.h"
#import "MBMemoryProfiler.h"

extern CFAbsoluteTime StartTime;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SonicSetup setup];
    [[MBMemoryProfiler profiler] setup];
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    ViewController1 *vc1 = ViewController1.new;
    UINavigationController *nav1 = [self addControler:vc1];
    [vc1 setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0]];
    [tabbarVC addChildViewController:nav1];
    
    ViewController2 *vc2 = ViewController2.new;
    UINavigationController *nav2 = [self addControler:vc2];
    [vc2 setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0]];
    [tabbarVC addChildViewController:nav2];
    
    ViewController3 *vc3 = ViewController3.new;
    UINavigationController *nav3 = [self addControler:vc3];
    [vc3 setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0]];
    [tabbarVC addChildViewController:nav3];
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    [self initShortcutItems];
    NSLog(@"%@",NSHomeDirectory());
    double launchTime = (CFAbsoluteTimeGetCurrent() - StartTime);
    NSLog(@"main函数之后启动时间：%lf",launchTime);
    
//    startTrace();
    
    return YES;
}

- (UINavigationController *)addControler:(UIViewController *)vc {
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        
        NSDictionary *userinfo = userActivity.userInfo;
        
        NSString *identifier = [userinfo objectForKey:CSSearchableItemActivityIdentifier];
        NSURL *identifierURL = [NSURL URLWithString:identifier];
        NSURLComponents *compment = [NSURLComponents componentsWithURL:identifierURL resolvingAgainstBaseURL:NO];
        NSArray *queryArray = compment.queryItems;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (NSURLQueryItem *item in queryArray) {
            [dic setObject:item.value forKey:item.name];
        }
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        UIViewController *vc = [UIViewController new];
        vc.title = identifier;
        vc.view.backgroundColor = [UIColor whiteColor];
        [nav pushViewController:vc animated:YES];
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    //这里可以获的shortcutItem对象的唯一标识符
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
    
}

- (void)initShortcutItems {
    
    if ([UIApplication sharedApplication].shortcutItems.count >= 4)
        return;
    
    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
    
    
    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openSearch" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [arrShortcutItem addObject:shoreItem1];
    
    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openCompose" localizedTitle:@"新消息" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
    [arrShortcutItem addObject:shoreItem2];
    
    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
    
    NSLog(@"%lu", [UIApplication sharedApplication].shortcutItems.count);
}



@end

