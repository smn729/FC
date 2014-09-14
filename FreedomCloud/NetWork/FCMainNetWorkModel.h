//
//  FCMainNetWorkModel.h
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperObject.h"
#import "FCTools/AsyncSocket.h"
@class FCSuperRequestModel;

#define Cloud_Server_IP                 @"115.29.137.199"
#define Cloud_Server_Port               8900
#define Token_Begin                     100
#define Heartbeat_Token                 1
#define Network_Connect_Time_Out        10
#define Network_Write_Time_Out          10
#define Network_Read_Time_Out           10
#define Reconnect_Socket_Interval       3
#define Heartbeat_Interval              10

typedef enum : NSUInteger
{
    Nettype_noNet = -1,
    Nettype_wifi = 0,
    Nettype_net = 1,
    Nettype_wap = 2,
} NetType;

@interface FCMainNetworkModel : FCSuperObject

#pragma mark - Property

/// 当前网络接入类型
@property (nonatomic) NetType currentNetStatus;
/// 协议Socket
@property (nonatomic, strong) AsyncSocket *protocolTcpSocket;
/// 当前设备IP
@property (nonatomic, strong) NSString *localHost;
/// 请求队列
@property (nonatomic, strong) NSMutableArray *requestQueue;

#pragma mark - Method

+ (FCMainNetworkModel *)shareInstance;

///// 连接socket到服务器
//- (BOOL)connectToServer;
/// 连接socket到服务器并保持连接
- (void)connectToServerAndKeepIt;

/// 获取一个新的token,普通请求token从Token_Begin开始，Token_Begin以下作为特殊标识
+ (int32_t)getNewToken;

/// 开始发送心跳包
- (void)beginHeartbeat;

/// 添加请求到队列，并在请求完成后调用对应的请求的对应回掉block
- (void)addRequestToQueue:(FCSuperRequestModel *)request;

@end
