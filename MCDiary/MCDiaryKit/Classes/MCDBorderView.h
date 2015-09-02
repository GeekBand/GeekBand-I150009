//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDCustomView.h"

IB_DESIGNABLE
@interface MCDBorderView : MCDCustomView

@property(nonatomic, assign) IBInspectable NSInteger borderWidth;
@property(nonatomic, strong) IBInspectable UIColor    *borderColor;

@end