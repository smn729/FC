//
//  WRLoadingView.h
//  RingSetup
//
//  Created by Sam on 14-8-19.
//  Copyright (c) 2014年 http://www.9sky.com/. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRLoadingView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

+ (WRLoadingView *)showLoadingView;
+ (WRLoadingView *)showLoadingViewInSuperView:(UIView *)superView;

+ (void)showMessage:(NSString *)message; // 默认2.5s后隐藏
+ (void)showMessage:(NSString *)message hide:(NSTimeInterval)time interactionEnabled:(BOOL)enabled;
- (void)showMessage:(NSString *)message hide:(NSTimeInterval)time;
- (void)dismiss;

@end
