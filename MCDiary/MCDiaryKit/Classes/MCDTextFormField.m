//
//  MCDTextFormField.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <HexColors/HexColors.h>
#import "MCDTextFormField.h"

@interface MCDTextFormField () <UITextFieldDelegate>

@end

@implementation MCDTextFormField

@synthesize textFieldBeginEditingSignal = _textFieldBeginEditingSignal;
@synthesize textFieldShouldReturnSignal = _textFieldShouldReturnSignal;

#pragma mark - life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.delegate = self;

    _textFieldBeginEditingSignal = [self rac_signalForSelector:@selector(textFieldShouldBeginEditing:)];
    _textFieldShouldReturnSignal = [self rac_signalForSelector:@selector(textFieldShouldReturn:)];
}

#pragma mark - getter & setter

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setHintText:(NSString *)hintText
{
    _hintText = hintText;
    self.textField.placeholder = hintText;
}

- (void)setIsPassword:(BOOL)isPassword
{
    _isPassword = isPassword;
    self.textField.secureTextEntry = isPassword;
}

- (void)setNeedAssessoryButton:(BOOL)needAssessoryButton
{
    _needAssessoryButton = needAssessoryButton;
    self.assessoryButton.hidden = !needAssessoryButton;
}

- (void)setState:(MCDTextFormFieldState)state
{
    switch (state) {
        case MCDTextFormFieldStateError:
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#D0021B" alpha:0.5f];
            break;
        default:
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#1D1D26" alpha:0.5f];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
