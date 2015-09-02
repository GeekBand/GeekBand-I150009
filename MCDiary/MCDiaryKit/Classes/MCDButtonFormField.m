//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDButtonFormField.h"

@interface MCDButtonFormField ()

@end

@implementation MCDButtonFormField
{

}

@synthesize buttonPressSignal = _buttonPressSignal;

#pragma mark - life cycle


#pragma mark - accessor

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setButtonText:(NSString *)buttonText
{
    _buttonText = buttonText;
    [self.button setTitle:_buttonText forState:UIControlStateNormal];
}

- (RACSignal *)buttonPressSignal
{
    if(!_buttonPressSignal){
        _buttonPressSignal = [self.button rac_signalForControlEvents:UIControlEventTouchUpInside];
    }

    return _buttonPressSignal;
}

#pragma mark - public

#pragma mark - private

@end