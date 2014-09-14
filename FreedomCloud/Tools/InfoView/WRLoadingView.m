//
//  WRLoadingView.m
//  RingSetup
//
//  Created by Sam on 14-8-19.
//  Copyright (c) 2014年 http://www.9sky.com/. All rights reserved.
//

#import "WRLoadingView.h"
#import "FCTools/SamTools.h"

@implementation WRLoadingView

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}


#pragma mark - Private Method

- (void)setup
{
    [SamTools makeGrayBordAndRoundCorner:self.contentView];
    [self.indicatorView startAnimating];
    self.indicatorView.hidesWhenStopped = YES;
}

#pragma mark - Public Method

+ (WRLoadingView *)showLoadingView
{
    UIView *superView = [[[UIApplication sharedApplication] windows] firstObject];
    return [WRLoadingView showLoadingViewInSuperView:superView];
}

+ (WRLoadingView *)showLoadingViewInSuperView:(UIView *)superView
{
    WRLoadingView *loadingView = [[[NSBundle mainBundle] loadNibNamed:@"WRLoadingView" owner:self options:nil] lastObject];
    loadingView.userInteractionEnabled = YES;
    loadingView.frame = superView.bounds;
    
//    loadingView.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
//    [UIView animateWithDuration:0.2 animations:^{
        [superView addSubview:loadingView];
//        loadingView.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    } completion:^(BOOL finished) {
//        if (finished)
//		{
//            [UIView animateWithDuration:0.1 animations:^{
//                loadingView.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
//            } completion:^(BOOL finished) {
//                if (finished)
//                {
//                    [UIView animateWithDuration:0.05 animations:^{
//                        loadingView.contentView.transform = CGAffineTransformIdentity;
//                    }];
//                }
//            }];
//        }
//    }];
    
    return loadingView;
}

- (void)dismiss
{
//    [UIView animateWithDuration:0.05 animations:^{
//        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//    } completion:^(BOOL finished) {
//        if (finished)
//		{
            [self removeFromSuperview];
//        }
//    }];
}

- (void)showMessage:(NSString *)message hide:(NSTimeInterval)time
{
    [self.indicatorView stopAnimating];
    self.infoLabel.text = message;
    
    CGSize messageSize = [message sizeWithFont:self.infoLabel.font constrainedToSize:CGSizeMake(self.infoLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:self.infoLabel.lineBreakMode];
    CGRect infoLabelFrame = self.infoLabel.frame;
    infoLabelFrame.size.height = MIN(self.contentView.bounds.size.height, messageSize.height + 15);
    infoLabelFrame.origin.y = (self.contentView.bounds.size.height - infoLabelFrame.size.height) / 2.0f;
    
    self.infoLabel.frame = infoLabelFrame;
    
    __weak WRLoadingView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismiss];
    });
}

+ (void)showMessage:(NSString *)message hide:(NSTimeInterval)time interactionEnabled:(BOOL)enabled
{
    WRLoadingView *loadingView = [WRLoadingView showLoadingView];
    loadingView.userInteractionEnabled = enabled;
    [loadingView showMessage:message hide:time];
}

+ (void)showMessage:(NSString *)message
{
    [WRLoadingView showMessage:message hide:2.5f interactionEnabled:NO];
}



@end
