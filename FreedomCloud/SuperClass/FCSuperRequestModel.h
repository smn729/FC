//
//  FCSuperRequestModel.h
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAGIC_NUMBER            (0x69183752)
#define VERSION_NUMBER          (0x0001)
#define ENCRYPT_TYPE            (0x00)
#define RESERVE                 (0x0000)
#define CRC_VERIFY              (0x00000000)

@interface FCSuperRequestModel : NSObject

// 包头
@property (nonatomic) UInt32 packetBodyLenth; // 包体长度，在子类设置
@property (nonatomic) UInt16 cmdCode; // 请求命令码，在子类设置

/**
 *  获取数据包包头
 *
 *  @return 包头
 */
- (NSData *)getPacketHeader;

@end
