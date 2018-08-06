//
//  AppDelegate.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifdef DEBUG
#import <FLEX.h>
#endif

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    [self addFLEX];
#endif
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - privte

+ (UINavigationController *)navigationController
{
    return (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
}

#ifdef DEBUG

- (void)addFLEX
{
    static UIWindow *flexWindow;
    flexWindow = [[UIWindow alloc] init];
    flexWindow.backgroundColor = [UIColor clearColor];
    flexWindow.rootViewController = [[UIViewController alloc] init];
    flexWindow.windowLevel = UIWindowLevelStatusBar + 50;
    CGFloat windowY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    flexWindow.frame = CGRectMake(0.5 * ([UIScreen mainScreen].bounds.size.width - 30), windowY, 30, 13);
    [flexWindow makeKeyAndVisible];
    
    UIButton *flexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [flexBtn setTitle:@"FLEX" forState:UIControlStateNormal];
    [flexBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [flexBtn addTarget:self action:@selector(showFlexSettingView) forControlEvents:UIControlEventTouchUpInside];
    flexBtn.frame = flexWindow.bounds;
    [flexWindow addSubview:flexBtn];
}

-(void)showFlexSettingView
{
    [[FLEXManager sharedManager] showExplorer];
}

#endif

@end
