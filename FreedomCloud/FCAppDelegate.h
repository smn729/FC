//
//  FCAppDelegate.h
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// 设置root视图
- (void)setRootVCTo:(UIViewController *)vc;
/// 转到主视图
- (void)showMainView;

@end
extern FCAppDelegate *appDelegate;