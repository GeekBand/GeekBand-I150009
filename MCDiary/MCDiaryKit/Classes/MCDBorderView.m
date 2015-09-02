//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDBorderView.h"
#import "UIColor+MCDiary.h"

@interface MCDBorderView ()

@end

@implementation MCDBorderView
{

}

#pragma mark - public

#pragma mark - life cycle

#pragma mark - accessor

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self.layer setBorderColor:_borderColor.CGColor];
}

- (void)setBorderWidth:(NSInteger)borderWidth
{
    _borderWidth = borderWidth;
    [self.layer setBorderWidth:_borderWidth];
}

#pragma mark - private

@end