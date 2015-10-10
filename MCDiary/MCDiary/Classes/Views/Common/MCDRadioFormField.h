//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDCustomView.h"

@class DLRadioButton;
@class RACSignal;

IB_DESIGNABLE
@interface MCDRadioFormField : MCDCustomView

@property(nonatomic, strong) IBInspectable NSString *radioButton1Text;
@property(nonatomic, strong) IBInspectable NSString *radioButton2Text;
@property(nonatomic, assign) IBInspectable NSUInteger selectedIndex;
@property(nonatomic, copy) IBInspectable NSString *titleText;

@property(nonatomic, weak) IBOutlet DLRadioButton *radioButton1;
@property(nonatomic, weak) IBOutlet DLRadioButton *radioButton2;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;


@property(nonatomic, strong, readonly) RACSignal *selectedIndexChangeSignal;

@end