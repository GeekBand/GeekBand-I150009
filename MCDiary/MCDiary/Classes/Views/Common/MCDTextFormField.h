//
//  MCDTextFormField.h
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDCustomView.h"

@class RACSignal;

typedef NS_ENUM(NSUInteger, MCDTextFormFieldState)
{
    MCDTextFormFieldStateNormal,
    MCDTextFormFieldStateError
};

IB_DESIGNABLE
@interface MCDTextFormField : MCDCustomView

@property(nonatomic, weak) IBOutlet UILabel     *titleLabel;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet UIButton    *assessoryButton;

@property(nonatomic, copy) IBInspectable NSString *titleText;
@property(nonatomic, copy) IBInspectable NSString *hintText;
@property(nonatomic, assign) IBInspectable BOOL   isPassword;
@property(nonatomic, assign) IBInspectable BOOL   needAssessoryButton;

@property(nonatomic, assign) MCDTextFormFieldState state;

@property(nonatomic, strong, readonly) RACSignal *textFieldBeginEditingSignal;
@property(nonatomic, strong, readonly) RACSignal *textFieldShouldReturnSignal;

@end
