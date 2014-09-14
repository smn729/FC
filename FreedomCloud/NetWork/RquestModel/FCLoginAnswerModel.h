//
//  FCLoginAnswerModel.h
//  FreedomCloud
//
//  Created by Sam on 14-9-13.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperRequestModel.h"

@interface FCLoginAnswerModel : FCSuperRequestModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *testcode;

@end
