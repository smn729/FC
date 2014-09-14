//
//  FCLoginVC.m
//  FreedomCloud
//
//  Created by Sam on 14-9-13.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCLoginVC.h"
#import "FCMainVC.h"

@interface FCLoginVC ()
{
    NSDictionary *loginQuestionDic; // 第一次登录返回的信息
    WRLoadingView *loadingView;
}

@end

@implementation FCLoginVC

#pragma mark - Wrapper

- (FCLoginAnswerModel *)loginAnswerModel
{
    if (nil == _loginAnswerModel)
    {
        _loginAnswerModel = [FCLoginAnswerModel shareRequestWithSuccessBlock:^(FCSuperRequestModel *model) {
            NSLog(@"%@", model.replyBodyDic);
            loginQuestionDic = nil;
            
            // 将摄像头信息放入FCMainModel
            [FCMainModel shareInstance].diviceInfoDic = model.replyBodyDic;
            // 开始发送心跳包
            [[FCMainNetworkModel shareInstance] beginHeartbeat];
            // 转到主页
            [appDelegate showMainView];
            
            [loadingView dismiss];
            [self cleanup];
            
        } failBlock:^(FCSuperRequestModel *model) {
            [loadingView dismiss];
            [self cleanup];
        }];
    }
    
    if (loginQuestionDic)
    {
        NSString *result = loginQuestionDic[@"result"];
        if ([result isEqualToString:@"0"])
        {
//            NSString *method = loginQuestionDic[@"method"];
            NSString *testcode = loginQuestionDic[@"testcode"];
            
            _loginAnswerModel.method = @"0";
            _loginAnswerModel.testcode = testcode;
        }
        else
        {
            NSLog(@"错误 登录1请求失败! %@", loginQuestionDic);
            return nil;
        }
    }
    
    return _loginAnswerModel;
}

- (FCLoginModel *)loginModel
{
    if (nil == _loginModel)
    {
        _loginModel = [FCLoginModel shareRequestWithSuccessBlock:^(FCSuperRequestModel *model) {
//            NSLog(@"%@", model.replyBodyDic);
            loginQuestionDic = model.replyBodyDic;
            
            [self.loginAnswerModel beginRequest];
            
        } failBlock:^(FCSuperRequestModel *model) {
            [loadingView dismiss];
            [self cleanup];
        }];
    }
    
    _loginModel.account_id = self.usernameLabel.text;
    _loginModel.pw = self.passwdLabel.text;
    
    return _loginModel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
}

#pragma mark - Private Method

- (void)cleanup
{
    self.loginModel = nil;
    self.loginAnswerModel = nil;
}

#pragma mark - IBAction

- (IBAction)loginButtonClick:(UIButton *)sender
{
    if ([FCMainNetworkModel shareInstance].protocolTcpSocket.isConnected)
    {
        [self.loginModel beginRequest];
        loadingView = [WRLoadingView showLoadingView];
    }
    else
    {
        [WRLoadingView showMessage:@"无法连接到服务器" hide:2 interactionEnabled:YES];
        NSLog(@"socket未连接");
    }
}
@end
