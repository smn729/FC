//
//  FCMainVC.m
//  FreedomCloud
//
//  Created by Sam on 14-8-29.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCMainVC.h"
#import "FCTools/DDXML.h"
#import "FCTools/DDXMLElementAdditions.h"

@interface FCMainVC ()

@end

@implementation FCMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"xml"];
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    NSArray *items = [document nodesForXPath:@"//cd" error:nil];
    
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    [self parseXML:xmlData];
}

-(void)parseXML:(NSData *) data
{
    //文档开始（KissXML和GDataXML一样也是基于DOM的解析方式）
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    //利用XPath来定位节点（XPath是XML语言中的定位语法，类似于数据库中的SQL功能）
    NSArray *users = [xmlDoc nodesForXPath:@"//cd" error:nil];
    for (DDXMLElement *user in users)
    {
        NSString *userId = [[user attributeForName:@"country"] stringValue];
        NSLog(@"cd country:%@",userId);
        
        DDXMLElement *nameEle = [user elementForName:@"title"];
        if (nameEle)
        {
            NSLog(@"cd title:%@",[nameEle stringValue]);
        }
        
        DDXMLElement *ageEle = [user elementForName:@"artist"];
        if (ageEle)
        {
            NSLog(@"cd artist:%@",[ageEle stringValue]);
        }
    }
}



@end
