//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDCustomView.h"

@class RACSignal;

IB_DESIGNABLE
@interface MCDButtonFormField : MCDCustomView

@property(weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property(weak, nonatomic) IBOutlet UIButton    *button;

@property(copy, nonatomic) IBInspectable NSString *titleText;
@property(copy, nonatomic) IBInspectable NSString *buttonText;

@property(strong, nonatomic, readonly) RACSignal *buttonPressSignal;

@end