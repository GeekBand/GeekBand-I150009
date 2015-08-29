//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewModel.h"
#import "RegExCategories.h"

@interface MCDSignupContentViewModel ()

@end

@implementation MCDSignupContentViewModel
{

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

#pragma mark - public

- (void)validate
{
    [self validateUsername];
    [self validatePassword];
    [self validateEmail];
}

#pragma mark - private

-(void)validateUsername
{
    if (self.username.length < 3) {
        _usernameErrorTitle = @"用户名（不能短于3位）";
        self.usernameValid = NO;
        return;
    }
    if (self.username.length > 15) {
        _usernameErrorTitle = @"用户名（不能长于15位）";
        self.usernameValid = NO;
        return;
    }

    if(![self.username isMatch:RX(@"^\\w+$")]){
        _usernameErrorTitle = @"用户名（只包含字母、数字和下划线）";
        self.usernameValid = NO;
        return;
    }
    self.usernameValid = YES;
}

-(void)validatePassword
{
    if (self.password.length < 6) {
        _passwordErrorTitle = @"密码（不能短于6位）";
        self.passwordValid = NO;
        return;
    }
    if (self.password.length > 12) {
        _passwordErrorTitle = @"用户名（不能长于12位）";
        self.passwordValid = NO;
        return;
    }

    if(![self.password isMatch:RX(@"^\\w+$")]){
        _passwordErrorTitle = @"密码（只包含字母、数字和下划线）";
        self.passwordValid = NO;
        return;
    }
    self.passwordValid = YES;
}

- (void)validateEmail
{
    // no email is ok
    if([self.email isEqualToString:@""]){
        self.emailValid = YES;
        return;
    }

    if(![self.email isMatch:RX(@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")]){
        _emailErrorTitle =  @"邮箱（格式不正确）";
        self.emailValid = NO;
        return;
    }

    self.emailValid = YES;
}

@end