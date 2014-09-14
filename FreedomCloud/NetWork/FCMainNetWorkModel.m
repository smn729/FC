//
//  FCMainNetWorkModel.m
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCMainNetworkModel.h"
#import "FCTools/Reachability.h"
#import "FCSuperRequestModel.h"
#import "FCHeartbeatModel.h"


static int32_t token = Token_Begin;
static FCMainNetworkModel *mainNetworkModel = nil;

@interface FCMainNetworkModel()
{
    NSTimer *heartbeatTimer; // heartbeat Timer
    BOOL shouldKeepSocket; // 是否需要保持soket
}
@property (nonatomic, strong) FCHeartbeatModel *heartbeatModel;

@end

@implementation FCMainNetworkModel

#pragma mark - Wrapper

- (FCHeartbeatModel *)heartbeatModel
{
    if (nil == _heartbeatModel)
    {
        _heartbeatModel = [FCHeartbeatModel shareRequestWithSuccessBlock:^(FCSuperRequestModel *model) {
            
        } failBlock:^(FCSuperRequestModel *model) {
            
        }];
    }
    
    _heartbeatModel.currentPacketToken = [NSString stringWithFormat:@"%d", Heartbeat_Token];
    return _heartbeatModel;
}

- (NSMutableArray *)requestQueue
{
    if (nil == _requestQueue)
    {
        _requestQueue = [NSMutableArray array];
    }
    
    return _requestQueue;
}

- (AsyncSocket *)protocolTcpSocket
{
    if (nil == _protocolTcpSocket)
    {
        _protocolTcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    return _protocolTcpSocket;
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 设置网络变更监听
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
        // they *WILL NOT* be called on THE MAIN THREAD
        reach.reachableBlock = ^(Reachability *reach)
        {
            NSLog(@"Reachability: NET Change To %@", [reach currentReachabilityString]);
            NetworkStatus netState = [reach currentReachabilityStatus];
            
            switch (netState)
            {
                case NotReachable:
                {
                    self.currentNetStatus = Nettype_noNet;
                }
                    break;
                case ReachableViaWiFi:
                {
                    self.currentNetStatus = Nettype_wifi;
                }
                    break;
                case ReachableViaWWAN:
                {
                    self.currentNetStatus = Nettype_wap;
                }
                    break;
                    
                default:
                {
                    NSLog(@"Reachability: Error--currentNetstatus: Should Never See This Line!!! ");
                }
                    break;
            }
            
        };
        
        reach.unreachableBlock = ^(Reachability *reach)
        {
            NSLog(@"Reachability: NET UNREACHABLE");
            self.currentNetStatus = Nettype_noNet;
        };
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [reach startNotifier];

    }
    return self;
}


#pragma mark - Pulic Method

+ (FCMainNetworkModel *)shareInstance
{
    if (mainNetworkModel == nil)
    {
        @synchronized(self)
        {
            mainNetworkModel = [[FCMainNetworkModel alloc] init];
        }
    }
    
    return mainNetworkModel;
}

+ (int32_t)getNewToken
{
    token ++;
    if (token >= INT32_MAX)
    {
        token = Token_Begin;
    }
    return token;
}

- (void)beginHeartbeat
{
    if (nil == heartbeatTimer)
    {
        heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:Heartbeat_Interval target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
    }
}

- (void)connectToServerAndKeepIt
{
    [self connectToServer];
    shouldKeepSocket = YES;
}

- (BOOL)connectToServer
{
    NSLog(@"正在连接Socket...");
    NSError *error = nil;
    if([self.protocolTcpSocket connectToHost:Cloud_Server_IP onPort:Cloud_Server_Port withTimeout:Network_Connect_Time_Out error:&error])
    {
        return YES;
    }
    else
    {
        NSLog(@"ERROR connectToServer %@", error.localizedDescription);
        return NO;
    }
    
}

- (void)addRequestToQueue:(FCSuperRequestModel *)request
{
    [self.requestQueue addObject:request];
    // 负值代表数据包包头，正值代表包体
    int token = -[request.currentPacketToken intValue];
    [self.protocolTcpSocket writeData:request.requestPacket withTimeout:Network_Write_Time_Out tag:token];
}

#pragma mark - Private Method

/// 获取当前队列中的请求
- (FCSuperRequestModel *)getRequestModelWithTag:(int)tag
{
    for(FCSuperRequestModel *aModel in self.requestQueue)
    {
        if ([aModel.currentPacketToken intValue] == tag)
        {
            return aModel;
        }
    }
    
    return nil;
}

- (void)sendHeartbeat
{
    NSLog(@"发送心跳包");
    [self.heartbeatModel beginRequest];
}

#pragma mark - AsyncSocketDelegate

/**
 * In the event of an error, the socket is closed.
 * You may call "unreadData" during this call-back to get the last bit of data off the socket.
 * When connecting, this delegate method may be called
 * before"onSocket:didAcceptNewSocket:" or "onSocket:didConnectToHost:".
 **/
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Socket: willDisconnectWithError %@", err.localizedDescription);
    
    for(FCSuperRequestModel *model in self.requestQueue)
    {
        [self.requestQueue removeObject:model];
        model.errorCode = -1;
        [model requestFail];
    }
}

/**
 * Called when a socket disconnects with or without error.  If you want to release a socket after it disconnects,
 * do so here. It is not safe to do that during "onSocket:willDisconnectWithError:".
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Socket: onSocketDidDisconnect");
    
    // 对所有没有处理完成的请求发送失败消息
    [self.requestQueue removeAllObjects];
    
    if (shouldKeepSocket)
    {
        [self performSelector:@selector(connectToServer) withObject:nil afterDelay:Reconnect_Socket_Interval];
    }
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Socket: didConnectToHost %@:%hu", host, port);
    self.localHost = sock.localHost;

}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"Socket: didReadData %d, Tag %ld", data.length, tag);
    long fTag = fabs(tag);
    // 特殊处理
    if (fTag < Token_Begin)
    {
        NSLog(@"didReadData 特殊处理 %ld", fTag);
    }
    // 包头
    else if (tag < 0)
    {
        NSDictionary *headerDic = [FCSuperRequestModel parsePacketHeader:data];
        int localPacketBodyLenth = [headerDic[@"packetBodyLenth"] intValue];
        
        FCSuperRequestModel *model = [self getRequestModelWithTag:abs(tag)];
        if (!model)
        {
            NSLog(@"ERROR 没有找到对应的modle!!!");
            return;
        }
        model.responsePacketHeader = data;
        [sock readDataToLength:localPacketBodyLenth withTimeout:Network_Read_Time_Out tag:abs(tag)];
    }
    // 包体
    else if(tag > 0)
    {
        FCSuperRequestModel *model = [self getRequestModelWithTag:tag];
        model.responsePacketBody = data;
        
        [self.requestQueue removeObject:model];
        
        [model requestSuccess];
    }
    else
    {
        NSLog(@"ERROR 丢弃读取的错误数据!!!");
    }
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
//    NSLog(@"Socket: didReadPartialDataOfLength %ld Tag %ld", partialLength, tag);
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Socket: didWriteDataWithTag Tag %ld", tag);
    // 特殊处理
    long fTag = fabs(tag);
    if (fTag < Token_Begin)
    {
        switch (fTag)
        {
            // 心跳数据包
            case Heartbeat_Token:
            {
                // Do nothing
            }
                break;
                
            default:
            {
                
            }
                break;
        }
    }
    else
    {
        [sock readDataToLength:20 withTimeout:Network_Read_Time_Out tag:tag];
    }
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
//    NSLog(@"Socket: didWritePartialDataOfLength %ld Tag %ld", partialLength, tag);
}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length
{
    NSLog(@"Socket: shouldTimeoutReadWithTag Tag %ld", tag);
    
    FCSuperRequestModel *model = [self getRequestModelWithTag:tag];
    [self.requestQueue removeObject:model];
    model.errorCode = -1;
    [model requestFail];
    
    return 0;
}

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length
{
    NSLog(@"Socket: shouldTimeoutWriteWithTag Tag %ld", tag);
    
    FCSuperRequestModel *model = [self getRequestModelWithTag:tag];
    [self.requestQueue removeObject:model];
    model.errorCode = -1;
    [model requestFail];
    
    return 0;
}

@end
