//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDBaseViewController.h"

@class MCDSignupContentViewModel;

@interface MCDSignupContentViewController : MCDBaseViewController

@property(nonatomic, strong) MCDSignupContentViewModel *viewModel;

@property(nonatomic, strong, readonly) UITextField *activeField;

@end