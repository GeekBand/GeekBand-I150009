//
//  MCDTextFormField.h
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDCustomView.h"

typedef NS_ENUM(NSUInteger, MCDTextFormFieldState)
{
    MCDTextFormFieldStateNormal,
    MCDTextFormFieldStateError
};

IB_DESIGNABLE
@interface MCDTextFormField : MCDCustomView

@property(weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(weak, nonatomic) IBOutlet UIButton    *assessoryButton;

@property(copy, nonatomic) IBInspectable NSString *titleText;
@property(copy, nonatomic) IBInspectable NSString *hintText;
@property(assign, nonatomic) IBInspectable BOOL   isPassword;
@property(assign, nonatomic) IBInspectable BOOL   needAssessoryButton;

@property(assign, nonatomic) MCDTextFormFieldState state;

@end
