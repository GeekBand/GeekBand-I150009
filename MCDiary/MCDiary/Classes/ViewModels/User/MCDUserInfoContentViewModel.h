//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseViewModel.h"
#import "MCDUser.h"

@class MCDUser;
@class MCDAreaPickerViewModel;

@interface MCDUserInfoContentViewModel : MCDBaseViewModel

@property(nonatomic, strong) MCDUser *user;

@property(nonatomic, strong) MCDAreaPickerViewModel *pickerViewModel;

@property(nonatomic, strong) UIImage         *avatarImage;
@property(nonatomic, copy) NSString          *username;
@property(nonatomic, copy) NSString          *email;
@property(nonatomic, assign) MCDUserGender   gender;
@property(nonatomic, copy) NSDate            *birthday;
@property(nonatomic, strong) MCDUserLocation *location;

@property(nonatomic, copy) NSString *locationString;
@property(nonatomic, copy) NSString *birthdayString;

@property(nonatomic, assign) BOOL       emailValid;
@property(nonatomic, readonly) NSString *emailErrorTitle;
@property(nonatomic, readonly) NSString *emailNormalTitle;

- (void)validateAndSave;

@end