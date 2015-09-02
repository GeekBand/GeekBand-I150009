//
//  MCDButtonView.h
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDCustomView.h"

@class RACSignal;

IB_DESIGNABLE
@interface MCDButtonView : MCDCustomView

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (copy, nonatomic) IBInspectable NSString *buttonTitle;

@property(nonatomic, assign, readonly) RACSignal *buttonPressSignal;

@end
