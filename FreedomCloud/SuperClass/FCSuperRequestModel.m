//
//  FCSuperRequestModel.m
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperRequestModel.h"

@interface FCSuperRequestModel()
{
    UInt32 packetBodyLenth;
}

@property (nonatomic, strong) NSString *testString;

@end

@implementation FCSuperRequestModel

#pragma mark - Wrapper

- (NSMutableDictionary *)replyBodyDic
{
    if (nil == _replyBodyDic)
    {
        _replyBodyDic = [NSMutableDictionary dictionary];
    }
    
    return _replyBodyDic;
}

#pragma mark - Child Method
- (void)setupReplyBodyDic
{
    
}

- (void)parseXMLDataWithKey:(NSString *)key xmlDocument:(DDXMLDocument *)xmlDocument
{
    
}

#pragma mark - Public Method

- (void)requestSuccess
{
    [self parseXMLData:self.responsePacketBody];
    
    NSString *result = self.replyBodyDic[@"result"];
    if (![result isEqualToString:REQUEST_SUCCESS_CODE])
    {
        NSString *errorMessage = [self getErrorMessageWithCode:[result intValue]];
        [WRLoadingView showMessage:errorMessage];
        
        if (self.failBlock)
        {
            self.failBlock(self);
        }
        
        return;
    }
    
    if (self.successBlock)
    {
        self.successBlock(self);
    }
}

- (void)requestFail
{
    NSString *errorString = [self getErrorMessageWithCode:self.errorCode];
    [WRLoadingView showMessage:errorString];
    
    if (self.failBlock)
    {
        self.failBlock(self);
    }
}

+ (NSDictionary *)parsePacketHeader:(NSData *)packetHeader
{
    UInt32 magicNumber = -1;
    UInt16 version = -1;
    UInt16 encryptType = -1;
    UInt32 localPacketBodyLenth = -1;
    UInt16 cmdCode = -1;
    UInt16 reserv = -1;
    UInt32 crc = -1;
    
    [packetHeader getBytes:&magicNumber range:NSMakeRange(0, 4)];
    [packetHeader getBytes:&version range:NSMakeRange(4, 2)];
    [packetHeader getBytes:&encryptType range:NSMakeRange(6, 2)];
    [packetHeader getBytes:&localPacketBodyLenth range:NSMakeRange(8, 4)];
    [packetHeader getBytes:&cmdCode range:NSMakeRange(12, 2)];
    [packetHeader getBytes:&reserv range:NSMakeRange(14, 2)];
    [packetHeader getBytes:&crc range:NSMakeRange(16, 4)];
    
    magicNumber = ntohl(magicNumber);
    version = htons(version);
    encryptType = htons(encryptType);
    localPacketBodyLenth = htonl(localPacketBodyLenth);
    cmdCode = htons(cmdCode);
    reserv = htons(reserv);
    crc = htonl(crc);

    NSDictionary *dic = @{@"magicNumber": @(magicNumber),
                          @"version": @(version),
                          @"encryptType": @(encryptType),
                          @"packetBodyLenth": @(localPacketBodyLenth),
                          @"cmdCode": @(cmdCode),
                          @"reserv": @(reserv),
                          @"crc": @(crc),
                          };
    
    return dic;
}

- (NSString *)getErrorMessageWithCode:(int)code
{
    // 成功
    if (code == 0)
    {
        return NSLocalizedString(@"成功", nil);
    }
    // 协议错误信息
    else if (code == 1)
    {
        return NSLocalizedString(@"用户名/密码错误", nil);
    }
    else if (code == 2)
    {
        return NSLocalizedString(@"没有操作权限", nil);
    }
    else if (code == 3)
    {
        return NSLocalizedString(@"该IP地址被拒绝", nil);
    }
    else if (code == 4)
    {
        return NSLocalizedString(@"你的版本不支持该功能", nil);
    }
    else if (code == 11)
    {
        return NSLocalizedString(@"服务器已经满负荷，拒绝访问", nil);
    }
    else if (code == 12)
    {
        return NSLocalizedString(@"前端设备已经满负荷，拒绝访问", nil);
    }
    else if (code == 21)
    {
        return NSLocalizedString(@"SERVER_INNER_ERROR", nil);
    }
    else if (code == 22)
    {
        return NSLocalizedString(@"XML_REQUEST_ERROR", nil);
    }
    else if (code == 23)
    {
        return NSLocalizedString(@"TEST_CODE_ERROR", nil);
    }
    else if (code == 24)
    {
        return NSLocalizedString(@"TOKEN_DIFFERENT", nil);
    }
    else if (code == 25)
    {
        return NSLocalizedString(@"DB_NOT_ONLINE", nil);
    }
    else if (code == 26)
    {
        return NSLocalizedString(@"DEV_NOT_ONLINE", nil);
    }
    else if (code == 27)
    {
        return NSLocalizedString(@"CLIENT_NOT_ONLINE", nil);
    }
    else if (code == 28)
    {
        return NSLocalizedString(@"RELAY_NOT_ONLINE", nil);
    }
    else if (code == 29)
    {
        return NSLocalizedString(@"DB_NOT_RESPONSE", nil);
    }
    else if (code == 30)
    {
        return NSLocalizedString(@"DB_RESPONSE_ERROR", nil);
    }
    else if (code == 31)
    {
        return NSLocalizedString(@"DEV_RESPONSE_ERROR", nil);
    }
    else if (code == 32)
    {
        return NSLocalizedString(@"CONFIG_FILE_ERROR", nil);
    }
    else if (code == 33)
    {
        return NSLocalizedString(@"用户名或密码错误", nil);
    }
    else if (code == 34)
    {
        return NSLocalizedString(@"REACH_MAX_LOGINNUM", nil);
    }
    else if (code == 35)
    {
        return NSLocalizedString(@"RELAY_SESSIONID_ERROR", nil);
    }
    else if (code == 101)
    {
        return NSLocalizedString(@"失败，硬盘空间不足", nil);
    }
    // 附加错误信息
    else if (code == -1)
    {
        return NSLocalizedString(@"网络错误", nil);
    }
    // 未定义的错误
    else
    {
        return NSLocalizedString(@"未定义错误", nil);
    }
}

#pragma mark - Private Method

#define SERVER_INNER_ERROR       21
#define XML_REQUEST_ERROR        22
#define TEST_CODE_ERROR          23
#define TOKEN_DIFFERENT          24
#define DB_NOT_ONLINE            25
#define DEV_NOT_ONLINE           26
#define CLIENT_NOT_ONLINE        27
#define RELAY_NOT_ONLINE         28
#define DB_NOT_RESPONSE          29
#define DB_RESPONSE_ERROR        30
#define DEV_RESPONSE_ERROR       31
#define CONFIG_FILE_ERROR        32
#define USER_PW_ERROR            33
#define REACH_MAX_LOGINNUM       34
#define RELAY_SESSIONID_ERROR    35

/// 解析收到的xml回应，放入replyBodyDic
- (void)parseXMLData:(NSData *)xmlData
{
    NSString *xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSLog(@"接收XML<-------- : \n%@\n", xmlString);
    
    [self setupReplyBodyDic];
    
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    NSArray *users = [xmlDoc nodesForXPath:@"//reply" error:nil];
    DDXMLElement *replyElement = users[0];
    
    for(NSString *key in self.replyBodyDic.allKeys)
    {
        id value = self.replyBodyDic[key];
        if ([value isKindOfClass:[NSString class]])
        {
            value = [[replyElement elementForName:key] stringValue];
            [SamTools checkNilToString:&value];
            [self.replyBodyDic setObject:value forKey:key];
        }
        else
        {
            [self parseXMLDataWithKey:key xmlDocument:xmlDoc];
        }
    }
    
//    NSLog(@"xml ---> %@", self.replyBodyDic);
}

/// 将dic解析成xml字符串
- (NSString *)convertToXml:(NSDictionary *)dic
{
    DDXMLElement *element = [[DDXMLElement alloc] initWithName:@"request"];
    for(NSString *key in dic.allKeys)
    {
        id value = dic[key];
        if ([value isKindOfClass:[NSString class]])
        {
            DDXMLNode *newNode = [DDXMLNode elementWithName:key];
            [newNode setStringValue:value];
            
            [element addChild:newNode];
        }
        else
        {
            NSLog(@"ERROR convertToXml遇到未知的数据类型");
        }
    }
    
    NSString *prittyXML = [element prettyXMLString];

    NSString *xmlString = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    
    xmlString = [xmlString stringByAppendingString:prittyXML];
    
    return xmlString;
}

#pragma mark - Create Packet

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
    NSAssert(packetBodyLenth, @"property \"packetBodyLenth\" not set!");
    NSAssert(self.cmdCode, @"property \"cmdCode\" not set!");
    
    UInt32 magicNumber = htonl(MAGIC_NUMBER);
    UInt16 version = htons(VERSION_NUMBER);
    UInt16 encryptType = htons(ENCRYPT_TYPE);
    UInt32 localPacketBodyLenth = htonl(packetBodyLenth);
    UInt16 cmdCode = htons(self.cmdCode);
    UInt16 reserv = htons(RESERVE);
    UInt32 crc = htonl(CRC_VERIFY);
    
    NSMutableData *packetHeader = [NSMutableData dataWithCapacity:20];
    
    [packetHeader appendBytes:&magicNumber length:4];
    [packetHeader appendBytes:&version length:2];
    [packetHeader appendBytes:&encryptType length:2];
    [packetHeader appendBytes:&localPacketBodyLenth length:4];
    [packetHeader appendBytes:&cmdCode length:2];
    [packetHeader appendBytes:&reserv length:2];
    [packetHeader appendBytes:&crc length:4];
    
    return packetHeader;
}

- (NSMutableDictionary *)getPacketBodyDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[SamTools dictionaryFromPropertysInObject:self]];
    
    NSString *theToken = dic[@"token"];
    if (theToken)
    {
        self.currentPacketToken = theToken;
    }
    else if(self.currentPacketToken)
    {
        // 特殊的Token
        NSLog(@"特殊的Token %@", self.currentPacketToken);
    }
    else
    {
        NSAssert(self.currentPacketToken, @"self.currentPacketToken Is nil");
    }
    
    // TODO: 对特殊字符做处理: < / &lt; | > / &gt; | & / &amp;
    return dic;
}

- (NSData *)getPacketBody
{
    NSMutableDictionary *dic = [self getPacketBodyDic];
//    NSLog(@"dic: %@", dic);

    NSString *xmlString = [self convertToXml:dic];
    
    NSLog(@"发送XML--------> \n%@\n", xmlString);
    
    NSData *packetBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    packetBodyLenth = packetBody.length;
    
    return packetBody;
}

- (NSData *)getPacket
{
    NSMutableData *packet = [NSMutableData data];
    
    NSData *packetBody = [self getPacketBody];
    NSData *packetHeader = [self getPacketHeader];
    
    [packet appendData:packetHeader];
    [packet appendData:packetBody];
    
    return packet;
}

#pragma mark - Request Call Method

+ (instancetype)shareRequestWithSuccessBlock:(requestSuccessBlock)successBlock failBlock:(requestFailBlock)failBlock
{
    FCSuperRequestModel *model = [[self alloc] init];
    model.successBlock = successBlock;
    model.failBlock = failBlock;
    
    return model;
}

- (void)beginRequest
{
    self.requestPacket = [self getPacket];
    
    if (self.requestPacket)
    {
        [[FCMainNetworkModel shareInstance] addRequestToQueue:self];
    }
    
}

@end
