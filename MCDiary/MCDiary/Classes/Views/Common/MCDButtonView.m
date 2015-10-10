//
//  MCDButtonView.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDButtonView.h"

@implementation MCDButtonView

#pragma mark - getters & setters

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
