//
//  FCSuperVC.m
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperVC.h"

@interface FCSuperVC ()

@end

@implementation FCSuperVC

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSLog(@"viewDidAppear ---> %s", object_getClassName(self));

    
}

- (void)dealloc
{
    NSLog(@"dealloc ---> %s", object_getClassName(self));
}


@end
