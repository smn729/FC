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
    int32_t theToken = [FCMainNetworkModel getNewToken];
    
    return [NSString stringWithFormat:@"%d", theToken];
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
        _account_id = @"";
    }
    
    return _account_id;
}

- (NSString *)pw
{
    if (nil == _pw)
    {
        _pw = @"";
    }
    return _pw;
}

- (NSString *)ip
{
    if (nil == _ip)
    {
        _ip = [SamTools getLocalHost]; // 该方法只能调用一次，第二次调用会获得空
    }
    
    NSString *host = [FCMainNetworkModel shareInstance].localHost;
    if (host.length > 0)
    {
        _ip = host;
    }

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
    [super setupReplyBodyDic];
    
    [self.replyBodyDic setObject:@"" forKey:@"token"];
    [self.replyBodyDic setObject:@"" forKey:@"result"];
    [self.replyBodyDic setObject:@"" forKey:@"method"];
    [self.replyBodyDic setObject:@"" forKey:@"testcode"];
}

@end
