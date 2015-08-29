//
//  MCDAvatarView.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/28.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDAvatarView.h"

@implementation MCDAvatarView

- (void)setAvatarImage:(UIImage *)avatarImage
{
    _avatarImage = avatarImage;
    [self.button setImage:avatarImage forState:UIControlStateNormal];

    self.button.layer.cornerRadius = self.button.bounds.size.width / 2.f;
    self.button.clipsToBounds = YES;
}

@end
