//
//  AppDelegate.m
//  WeiXinTested
//
//  Created by mobiusif on 15/8/24.
//  Copyright (c) 2015年 wky. All rights reserved.
//
/*说明：微信支付的简要流程  //   wky19824010@163.com
 1.首先查看官方的流程图，下载官方的demo，仔细研究。
 2.添加库WeChatSDK_1.5
 3.编译添加库文件。
 4.添加URL Schemes
 4.查看appdelegate
 5.查看界面的按钮事件。
 6.注意官方文档的说明和sdk有些不一样，导致md5签名的时候逻辑有些变动。
 */



#import "AppDelegate.h"
#import "Common.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];//微信注册回调
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];//微信注册回调
}

- (void)onResp:(BaseResp*)resp{         //微信支付结果
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                NSString *strTemp = [NSString stringWithFormat:@"支付成功"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:strTemp delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
                break;
            default :
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                NSString *strTempB = [NSString stringWithFormat:@"支付失败的代码 ＝ %d",response.errCode];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:strTempB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                break;
        }
        
    }
}
@end
