//
// Created by zzdjk6 on 15/8/18.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDHomeViewModel.h"
#import "MCDUser.h"


@implementation MCDHomeViewModel
{

}

#pragma mark - Accessors

- (BOOL)userLoggedIn
{
    return [MCDUser currentUser] != nil;
}

@end