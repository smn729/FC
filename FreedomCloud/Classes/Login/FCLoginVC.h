//
//  FCLoginVC.h
//  FreedomCloud
//
//  Created by Sam on 14-9-13.
//  Copyright (c) 2014年 Sam. All rights reserved.
//

#import "FCSuperVC.h"
#import "FCLoginModel.h"
#import "FCLoginAnswerModel.h"

@interface FCLoginVC : FCSuperVC

@property (nonatomic, strong) FCLoginModel *loginModel;
@property (nonatomic, strong) FCLoginAnswerModel *loginAnswerModel;

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwdLabel;
- (IBAction)loginButtonClick:(UIButton *)sender;

@end
