//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserInfoContentViewModel.h"
#import "MCDUser.h"
#import "MCDUserLocation.h"
#import "NSDate+DateTools.h"
#import "MCDAreaPickerViewModel.h"
#import "MCDUserLocationHelper.h"

@interface MCDUserInfoContentViewModel ()

@end

@implementation MCDUserInfoContentViewModel
{

}

#pragma mark - public

- (void)validateAndSave
{
    // 验证+保存邮箱
    NSString *emailError = [MCDUser errorStringForEmail:self.email];
    if (emailError) {
        _emailErrorTitle = emailError;
        self.emailValid = NO;
    } else {
        self.emailValid = YES;
        self.user.email = self.email;
    }

    // 其他字段
    self.user.gender      = self.gender;
    self.user.birthday    = self.birthday;
    self.user.location    = self.location;
    self.user.avatarImage = self.avatarImage;

    [self.user save];
}


#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始值
        self.user = [MCDUser currentUser];
        self.pickerViewModel = [[MCDAreaPickerViewModel alloc] init];
        self.emailValid = YES;

        self.username    = self.user.username;
        self.email       = self.user.email;
        self.gender      = self.user.gender;
        self.location    = self.user.location;
        self.birthday    = self.user.birthday;
        self.avatarImage = self.user.avatarImage;

        // Binding
        RAC(self, birthdayString) = [RACObserve(self, birthday) map:^id(NSDate *date) {
            return [NSString stringWithFormat:
                                 @"%u年 %u月 %u日",
                                 date.year,
                                 date.month,
                                 date.day
            ];
        }];

        RAC(self, locationString) = [RACObserve(self.pickerViewModel, initialSelection) map:^id(NSArray *selection) {
            MCDUserLocationHelper *locationHelper = [MCDUserLocationHelper sharedHelper];
            NSString              *string         = [locationHelper getLocationStringByProvinceIndex:[selection[0] unsignedIntegerValue]
                                                                                           cityIndex:[selection[1] unsignedIntegerValue]
                                                                                           areaIndex:[selection[2] unsignedIntegerValue]
            ];
            return string;
        }];

        RAC(self, location) = [RACObserve(self.pickerViewModel, initialSelection) map:^id(NSArray *selection) {

            MCDUserLocation *location = [[MCDUserLocation alloc] init];
            location.provinceIndex = [selection[0] unsignedIntegerValue];
            location.cityIndex     = [selection[1] unsignedIntegerValue];
            location.areaIndex     = [selection[2] unsignedIntegerValue];
            return location;
        }];
    }

    return self;
}


#pragma mark - accessor

- (NSString *)emailNormalTitle
{
    return @"邮箱（可选，仅用于找回密码）";
}

#pragma mark - private

@end