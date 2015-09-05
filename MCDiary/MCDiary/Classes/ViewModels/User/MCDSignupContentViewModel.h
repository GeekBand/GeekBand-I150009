//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDBaseViewModel.h"

@interface MCDSignupContentViewModel : MCDBaseViewModel

@property(nonatomic, strong) UIImage *avatarImage;

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *email;

@property(nonatomic, assign) BOOL usernameValid;
@property(nonatomic, assign) BOOL passwordValid;
@property(nonatomic, assign) BOOL emailValid;

@property(nonatomic, readonly) NSString *usernameErrorTitle;
@property(nonatomic, readonly) NSString *passwordErrorTitle;
@property(nonatomic, readonly) NSString *emailErrorTitle;

@property(nonatomic, readonly) NSString *usernameNormalTitle;
@property(nonatomic, readonly) NSString *passwordNormalTitle;
@property(nonatomic, readonly) NSString *emailNormalTitle;

@property(nonatomic, strong, readonly) RACSignal *signUpErrorSignal;
@property(nonatomic, strong, readonly) RACSignal *signUpSuccessSignal;

- (void)validateAndSignup;

@end