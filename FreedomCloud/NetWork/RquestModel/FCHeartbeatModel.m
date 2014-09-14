//
//  FCHeartbeatModel.m
//  FreedomCloud
//
//  Created by Sam on 14-9-14.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCHeartbeatModel.h"

@implementation FCHeartbeatModel

- (NSString *)interval
{
    if (nil == _interval)
    {
        _interval = [NSString stringWithFormat:@"%d", Heartbeat_Interval];
    }
    
    return _interval;
}

#pragma mark - Customize

- (UInt16)cmdCode
{
    return 0x0002;
}

@end
