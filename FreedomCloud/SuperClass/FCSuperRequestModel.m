//
//  FCSuperRequestModel.m
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperRequestModel.h"

@interface FCSuperRequestModel()

@property (nonatomic, strong) NSString *testString;

@end

@implementation FCSuperRequestModel


// header如下：
// 4字节: 魔数，值是0x69183752用以标识header的开始，
// 2字节: 协议版本号，目前版本号是0x0001
// 2字节: 加密类型，0表示不加密（服务器也会返回未加密的响应）, 1-DES加密
// 4字节: 加密报文长度
// 2字节: 命令码
// 2字节: 保留
// 4字节: CRC校验，仅对头部前16个字节进行CRC校验
- (NSData *)getPacketHeader
{
    NSAssert(self.packetBodyLenth, @"property \"packetBodyLenth\" not set!");
    NSAssert(self.cmdCode, @"property \"cmdCode\" not set!");
    
    UInt32 magicNumber = htonl(MAGIC_NUMBER);
    UInt16 version = htons(VERSION_NUMBER);
    UInt16 encryptType = htons(ENCRYPT_TYPE);
    UInt32 packetBodyLenth = htonl(self.packetBodyLenth);
    UInt16 cmdCode = htons(self.cmdCode);
    UInt16 reserv = htons(RESERVE);
    UInt32 crc = htonl(CRC_VERIFY);
    
    NSMutableData *packetHeader = [NSMutableData dataWithCapacity:20];
    
    [packetHeader appendBytes:&magicNumber length:4];
    [packetHeader appendBytes:&version length:2];
    [packetHeader appendBytes:&encryptType length:2];
    [packetHeader appendBytes:&packetBodyLenth length:4];
    [packetHeader appendBytes:&cmdCode length:2];
    [packetHeader appendBytes:&reserv length:2];
    [packetHeader appendBytes:&crc length:4];
    
    return packetHeader;
}

@end
