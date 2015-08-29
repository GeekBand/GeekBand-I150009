//
//  MCDButtonView.h
//  MCDiary
//
//  Created by zzdjk6 on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDCustomView.h"

IB_DESIGNABLE
@interface MCDButtonView : MCDCustomView

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (copy, nonatomic) IBInspectable NSString *buttonTitle;

@end
