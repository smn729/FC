//
//  FCLoginModel.m
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCLoginModel.h"

@implementation FCLoginModel

- (NSString *)token
{
    UInt32 theToken = [FCMainNetworkModel getNewToken];

    return [NSString stringWithFormat:@"%u", (unsigned int)theToken];
}

- (NSString *)account
{
    if (nil == _account)
    {
        _account = @"";
    }
    
    return _account;
}

- (NSString *)account_id
{
    if (nil == _account_id)
    {
        // FIXME: 测试用
        _account_id = @"swu@joincc.com.au";
    }
    
    return _account_id;
}

- (NSString *)pw
{
    if (nil == _pw)
    {
        _pw = @"temp";
    }
    return _pw;
}

- (NSString *)ip
{
    _ip = [FCMainNetworkModel shareInstance].localHost;
    return _ip;
}

- (NSString *)type
{
    if (nil == _type)
    {
        _type = CLIENT_TYPE;
    }
    
    return _type;
}

- (NSString *)developer
{
    if (nil == _developer)
    {
        // FIXME: 测试
        _developer = DEVELOPER;
    }
    
    return _developer;
}

- (NSString *)developer_code
{
    if (nil == _developer_code)
    {
        _developer_code = DEVELOPER_CODE;
    }
    
    return _developer_code;
}

#pragma mark - Customize

- (NSMutableDictionary *)getPacketBodyDic
{
    NSMutableDictionary *dic = [super getPacketBodyDic];
    if (self.account.length <= 0)
    {
        [dic removeObjectForKey:@"account"];
    }
    if (self.account_id.length <= 0)
    {
        [dic removeObjectForKey:@"account_id"];
    }
    
    return dic;
}

- (UInt16)cmdCode
{
    return 0x0100;
}

- (void)setupReplyBodyDic
{
    [self.replyBodyDic setObject:@"" forKey:@"token"];
    [self.replyBodyDic setObject:@"" forKey:@"result"];
    [self.replyBodyDic setObject:@"" forKey:@"method"];
    [self.replyBodyDic setObject:@"" forKey:@"testcode"];
}

@end
