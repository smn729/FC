//
//  FCMainModel.h
//  FreedomCloud
//
//  Created by Sam on 14-9-14.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperObject.h"

@interface FCMainModel : FCSuperObject

@property(nonatomic, strong) NSDictionary *diviceInfoDic; // 登录或获取的设备信息

+ (FCMainModel *)shareInstance;

@end
