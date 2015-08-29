//
//  MCDAvatarView.h
//  MCDiary
//
//  Created by zzdjk6 on 15/8/28.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDCustomView.h"

IB_DESIGNABLE
@interface MCDAvatarView : MCDCustomView

@property(nonatomic, weak) IBOutlet UIButton *button;

@property(nonatomic, weak) IBInspectable UIImage* avatarImage;

@end
