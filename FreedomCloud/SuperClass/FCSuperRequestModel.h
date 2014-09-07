//
//  FCSuperRequestModel.h
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCMainNetworkModel.h"
#import "FCTools/SamTools.h"

#define MAGIC_NUMBER            (0x69183752)
#define VERSION_NUMBER          (0x0001)
#define ENCRYPT_TYPE            (0x00)
#define RESERVE                 (0x0000)
#define CRC_VERIFY              (0x00000000)

#define CLIENT_TYPE             @"1000"
#define DEVELOPER               @"axis"
#define DEVELOPER_CODE          @"1000"

typedef void (^requestSuccessBlock)(FCSuperRequestModel *model);
typedef void (^requestFailBlock)(FCSuperRequestModel *model);

@interface FCSuperRequestModel : NSObject

// 包头
@property (nonatomic) UInt16 cmdCode; // 请求命令码，子类必须实现该属性的get方法，对其进行设置

// 包体

// 回掉
@property (nonatomic, copy) requestSuccessBlock successBlock;
@property (nonatomic, copy) requestFailBlock failBlock;

@property (nonatomic, strong) NSData *requestPacket; // 待发送的请求包
@property (nonatomic, strong) NSData *responsePacketHeader; // 回应包头
@property (nonatomic, strong) NSData *responsePacketBody; // 回应包体
@property (nonatomic, strong) NSString *currentPacketToken; // 当前封装的数据包的token
@property (nonatomic) int errorCode; // 若有失败，则为失败错误码，详见getErrorMessageWithCode方法
@property (nonatomic, strong) NSMutableDictionary *replyBodyDic; // 回应内容字典

/// 获取包头
- (NSData *)getPacketHeader;
/// 获取包体
- (NSData *)getPacketBody;
/// 获取整个数据包
- (NSData *)getPacket;


/// 根据code获取error信息
- (NSString *)getErrorMessageWithCode:(int)code;

/// FCMainNetworkModel调用
- (void)requestSuccess;
- (void)requestFail;

/// 将packetHeader解析成字典
+ (NSDictionary *)parsePacketHeader:(NSData *)packetHeader;

#pragma mark - 子类必须实现的方法
/// cmdCode设置方法
- (UInt16)cmdCode;
/// 设置回应中reply字段中被期待的内容
- (void)setupReplyBodyDic;

#pragma mark - 子类可选实现的方法
/// 获取包体属性构成的字典，子类可以继承该方法，对字典进行修改
- (NSMutableDictionary *)getPacketBodyDic;

#pragma mark - 被调入口
+ (instancetype)shareRequestWithSuccessBlock:(requestSuccessBlock)successBlock failBlock:(requestFailBlock)failBlock;

/// 开始发送请求
- (void)beginRequest;

@end
