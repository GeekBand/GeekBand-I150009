//
//  MCDMessageViewModel.m
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageViewModel.h"

@implementation IZMessageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _messagesList = @[@{@"title":@"喵", @"timeStamp":@"13", @"url":@"xxx"},
                          @{@"title":@"汪", @"timeStamp":@"14", @"url":@"xxx"}];
    }
    return self;
}

+ (IZMessageViewModel *)viewModel {
    return [[IZMessageViewModel alloc] init];
}

@end
