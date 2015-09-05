//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDBaseViewModel.h"


@interface MCDLoginViewModel : MCDBaseViewModel

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, assign) BOOL usernameValid;
@property(nonatomic, assign) BOOL passwordValid;

@property(nonatomic, copy, readonly) NSString *usernameErrorTitle;
@property(nonatomic, copy, readonly) NSString *passwordErrorTitle;

@property(nonatomic, copy, readonly) NSString *usernameNormalTitle;
@property(nonatomic, copy, readonly) NSString *passwordNormalTitle;


@property(nonatomic, strong, readonly) RACSignal *loginSuccessSignal;
@property(nonatomic, strong, readonly) RACSignal *loginFailSignal;

@property(nonatomic, strong, readonly) RACSignal *foregetPasswordRequestSuccessSignal;
@property(nonatomic, strong, readonly) RACSignal *foregetPasswordRequestFailSignal;

- (void)validateAndLogin;

- (void)sendForgetPasswordRequestWithEmail:(NSString *)email;
@end