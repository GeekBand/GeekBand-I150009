//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDBaseViewModel.h"


@interface MCDLoginViewModel : MCDBaseViewModel

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, assign) BOOL isValid;
@property(nonatomic, assign) BOOL usernameValid;
@property(nonatomic, assign) BOOL passwordValid;

@property(nonatomic, readonly) NSString *usernameErrorTitle;
@property(nonatomic, readonly) NSString *passwordErrorTitle;

@property(nonatomic, readonly) NSString *usernameNormalTitle;
@property(nonatomic, readonly) NSString *passwordNormalTitle;

- (void)validate;
@end