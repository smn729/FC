//
//  FCLoginModel.h
//  FreedomCloud
//
//  Created by Sam on 14-8-30.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperRequestModel.h"

@interface FCLoginModel : FCSuperRequestModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *pw;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *developer;
@property (nonatomic, strong) NSString *developer_code;


@end
