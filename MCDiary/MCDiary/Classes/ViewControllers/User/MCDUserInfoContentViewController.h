//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseViewController.h"

@class MCDUserInfoContentViewModel;

@interface MCDUserInfoContentViewController : MCDBaseViewController

@property(nonatomic, strong) MCDUserInfoContentViewModel *viewModel;
@property(nonatomic, strong) UITextField *activeField;

@end