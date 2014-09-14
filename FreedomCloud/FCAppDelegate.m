//
//  FCAppDelegate.m
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCAppDelegate.h"
#import "FCMainVC.h"
#import "FCLoginVC.h"
#import "FCMainNetworkModel.h"
#import "FCLiveVideoVC.h"
#import "FCPlaybackVC.h"
#import "FCDeviceManagerVC.h"
#import "FCAboutVC.h"

FCAppDelegate *appDelegate = nil;

@implementation FCAppDelegate

#pragma mark - Public Method

- (void)setRootVCTo:(UIViewController *)vc
{
    NSAssert(vc, @"rootVC不能为nil");
    self.window.rootViewController = vc;
}

- (void)showMainView
{
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    FCLiveVideoVC *liveVC = [[FCLiveVideoVC alloc] init];
    FCPlaybackVC *playbackVC = [[FCPlaybackVC alloc] init];
    FCDeviceManagerVC *deviceManagerVC = [[FCDeviceManagerVC alloc] init];
    FCAboutVC *aboutVC = [[FCAboutVC alloc] init];
    
    UINavigationController *liveN = [[UINavigationController alloc] initWithRootViewController:liveVC];
    UINavigationController *playbackN = [[UINavigationController alloc] initWithRootViewController:playbackVC];
    UINavigationController *deviceManagerN = [[UINavigationController alloc] initWithRootViewController:deviceManagerVC];
    UINavigationController *aboutN = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    
    tabController.viewControllers = @[liveN, playbackN, deviceManagerN, aboutN];
    
    [self setRootVCTo:tabController];
}

#pragma mark - Private Method


#pragma mark - Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[FCMainNetworkModel shareInstance] connectToServerAndKeepIt];
    
    FCLoginVC *loginVC = [[FCLoginVC alloc] init];
    [self setRootVCTo:loginVC];
    
//    FCMainVC *mainVC = [[FCMainVC alloc] init];
//    [self setRootVCTo:mainVC];
    
    appDelegate = self;
    
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

@end
