//
//  FCLoginAnswerModel.m
//  FreedomCloud
//
//  Created by Sam on 14-9-13.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCLoginAnswerModel.h"

@implementation FCLoginAnswerModel

- (NSString *)token
{
    int32_t theToken = [FCMainNetworkModel getNewToken];
    
    return [NSString stringWithFormat:@"%d", theToken];
}

- (NSString *)method
{
    if (nil == _method)
    {
        _method = @"0";
    }
    return _method;
}

- (NSString *)testcode
{
    if (nil == _testcode)
    {
        _testcode = @"";
    }
    
    return _testcode;
}

#pragma mark - Customize

- (UInt16)cmdCode
{
    return 0x0101;
}

- (void)setupReplyBodyDic
{
    [super setupReplyBodyDic];
    
    [self.replyBodyDic setObject:@"" forKey:@"token"];
    [self.replyBodyDic setObject:@"" forKey:@"result"];
    [self.replyBodyDic setObject:[NSArray array] forKey:@"devicelist"];
    [self.replyBodyDic setObject:@"" forKey:@"p2p_ip1"];
    [self.replyBodyDic setObject:@"" forKey:@"p2p_port1"];
    [self.replyBodyDic setObject:@"" forKey:@"p2p_ip2"];
    [self.replyBodyDic setObject:@"" forKey:@"p2p_port2"];
}

- (void)parseXMLDataWithKey:(NSString *)key xmlDocument:(DDXMLDocument *)xmlDocument
{
    [super parseXMLDataWithKey:key xmlDocument:xmlDocument];
    
    if ([key isEqualToString:@"devicelist"])
    {
        NSMutableArray *devicelistArray = [NSMutableArray array];
        
        NSArray *deviceInfoArray = [xmlDocument nodesForXPath:@"//reply/devicelist/deviceinfo" error:nil];
        for (DDXMLElement *aDeviceInfo in deviceInfoArray)
        {
            DDXMLElement *account_device = [aDeviceInfo elementForName:@"account_device"];
            DDXMLElement *devicename = [aDeviceInfo elementForName:@"devicename"];
            DDXMLElement *type_device = [aDeviceInfo elementForName:@"type_device"];
            DDXMLElement *online = [aDeviceInfo elementForName:@"online"];
            DDXMLElement *brand = [aDeviceInfo elementForName:@"brand"];
            DDXMLElement *cameralist = [aDeviceInfo elementForName:@"cameralist"];
            NSArray *cameraInfoArray = [cameralist elementsForName:@"camerainfo"];
            
            NSMutableArray *cameralistArray = [NSMutableArray array];
            for(DDXMLElement *aCamera in cameraInfoArray)
            {
                DDXMLElement *channel = [aCamera elementForName:@"channel"];
                DDXMLElement *name = [aCamera elementForName:@"name"];
                DDXMLElement *encodenum = [aCamera elementForName:@"encodenum"];
                
                NSDictionary *camerainfoDic = @{@"channel": [channel stringValue], @"name": [name stringValue], @"encodenum": [encodenum stringValue]};
                [cameralistArray addObject:camerainfoDic];
            }
            
            NSDictionary *deviceinfoDic = @{@"account_device": [account_device stringValue],
                                  @"devicename": [devicename stringValue],
                                  @"type_device": [type_device stringValue],
                                  @"online": [online stringValue],
                                  @"brand": [brand stringValue],
                                  @"cameralist":cameralistArray};
            
            [devicelistArray addObject:deviceinfoDic];
        }
        
        [self.replyBodyDic setObject:devicelistArray forKey:@"devicelist"];
    }
}

@end
