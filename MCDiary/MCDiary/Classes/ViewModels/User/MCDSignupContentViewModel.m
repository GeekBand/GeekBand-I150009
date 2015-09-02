//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewModel.h"
#import "RegExCategories.h"
#import "MCDUser.h"

@interface MCDSignupContentViewModel ()

@end

@implementation MCDSignupContentViewModel
{

}

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

    // email
    NSString *errorEmail = [MCDUser errorStringForEmail:self.email];
    if(errorEmail){
        _emailErrorTitle = errorEmail;
        self.emailValid = NO;
    }else{
        self.emailValid = YES;
    }

    // TODO: Cloud 检测
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usernameValid = YES;
        _passwordValid = YES;
        _emailValid = YES;
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

- (NSString *)emailNormalTitle
{
    return @"邮箱（可选，仅用于找回密码）";
}

#pragma mark - private

@end