//
// Created by zzdjk6 on 15/8/18.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDHomeViewModel.h"


@implementation MCDHomeViewModel
{

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // todo: 判断用户登录状态
        self.userLoggedIn = NO;
    }

    return self;
}


@end