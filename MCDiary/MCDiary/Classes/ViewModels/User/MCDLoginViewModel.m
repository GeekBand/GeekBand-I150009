//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewModel.h"
#import "MCDUser.h"


@implementation MCDLoginViewModel

#pragma mark - public

- (void)validate
{
    // useranme
    NSString *errorUsername = [MCDUser errorStringForUsername:self.username];
    if(errorUsername){
        _usernameErrorTitle = errorUsername;
        self.usernameValid = NO;
    }else{
        self.usernameValid = YES;
    }

    // password
    NSString *errorPassword = [MCDUser errorStringForPassword:self.password];
    if(errorPassword){
        _passwordErrorTitle = errorPassword;
        self.passwordValid = NO;
    }else{
        self.passwordValid = YES;
    }

    // TODO: Cloud 检测
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isValid       = YES;
        self.usernameValid = YES;
        self.passwordValid = YES;

        RACSignal *usernameValidSignal = RACObserve(self, usernameValid);
        RACSignal *passwordValidSignal = RACObserve(self, passwordValid);
        RACSignal *validSignal         = [RACSignal combineLatest:@[usernameValidSignal, passwordValidSignal]
                                                           reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                                               return @([usernameValid boolValue] && [passwordValid boolValue]);
                                                           }];
        [validSignal subscribeNext:^(NSNumber *valid) {
            self.isValid = [valid boolValue];
        }];
    }

    return self;
}

#pragma mark - accessor

- (NSString *)usernameNormalTitle
{
    return @"用户名";
}

- (NSString *)passwordNormalTitle
{
    return @"密码";
}

#pragma mark - private

@end