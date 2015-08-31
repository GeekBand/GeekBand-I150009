//
//  MCDButtonView.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDButtonView.h"

@implementation MCDButtonView

@synthesize buttonPressSignal = _buttonPressSignal;

#pragma mark - getters & setters

- (RACSignal *)buttonPressSignal
{
    if(!_buttonPressSignal){
        _buttonPressSignal = [self.button rac_signalForControlEvents:UIControlEventTouchUpInside];
    }

    return _buttonPressSignal;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
