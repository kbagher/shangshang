//
//  AppDelegate.m
//  ShangShang
//
//  Created by 史东杰 on 14-6-23.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

//@synthesize downloadCache = _downloadCache;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"iPhone simulator not support push!");
#elif TARGET_OS_IPHONE
    //消息推送支持的类型
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
#else
    NSLog(@"unknown target!");
#endif

    DBManager *dbManager=[[DBManager alloc] init];
    [dbManager createDictTable];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ServerConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    [dbManager InsertOrUpdateDictData:@"ServerIP" andValue:[dict objectForKey:@"ServerIP"]];
    /*
    UIColor *barColor=[UIColor colorWithRed:22.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
    UIColor *textColor=[UIColor whiteColor];
    CGFloat titleSize=12.0;
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"FontNAme" size:titleSize], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:barColor];
    */
    /*
    //初始化ASIDownloadCache缓存对象
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.downloadCache = cache;
    [cache release];
    
    //路径
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //设置缓存存放路径
    
    [self.downloadCache setStoragePath:[documentDirectorystringByAppendingPathComponent:@"resource"]];
    
    //设置缓存策略
    
    [self.downloadCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
    */
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//注册push服务
- (void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]; //去掉"<>"
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格
    NSLog(@"deviceToken: %@", token);
    [SSUser getInstance].deviceToken=token;
    //debug
    /*
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"devicetoken"
                                                    message:token
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"更新状态",nil];
    [alert show];
    [alert release];
    */
}

//注册push服务失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration for APNS. Error: %@", error);
    
    //debug
    /*
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"devicetoken"
                                                    message:@"error"
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"更新状态",nil];
    [alert show];
    [alert release];
     */
}

//接收到push消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"收到推送消息 ： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"推送通知"
                                                    message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"更新状态",nil];
    [alert show];
    [alert release];
}
/*
- (void)dealloc
{
    [_downloadCache release];
    [super dealloc];
}
*/
@end
