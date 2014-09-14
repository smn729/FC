//
//  FCMainModel.m
//  FreedomCloud
//
//  Created by Sam on 14-9-14.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCMainModel.h"

static FCMainModel *mainModel = nil;

@implementation FCMainModel

#pragma mark - Wrapper

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Public Method

+ (FCMainModel *)shareInstance
{
    @synchronized(self)
    {
        if (nil == mainModel)
        {
            mainModel = [[FCMainModel alloc] init];
        }
        
        return mainModel;
    }
}

#pragma mark - Private Method

@end
