//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewModel.h"
#import "RegExCategories.h"


@implementation MCDLoginViewModel

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


- (NSString *)usernameNormalTitle
{
    return @"用户名";
}

- (NSString *)passwordNormalTitle
{
    return @"密码";
}

- (void)validate
{
    [self validateUsername];
    [self validatePassword];
}

-(void)validateUsername
{
    self.usernameValid = NO;
    if (self.username.length < 3) {
        _usernameErrorTitle = @"用户名（不能短于3位）";
        return;
    }
    if (self.username.length > 15) {
        _usernameErrorTitle = @"用户名（不能长于15位）";
        return;
    }

    if(![self.username isMatch:RX(@"^\\w+$")]){
        _usernameErrorTitle = @"用户名（只包含字母、数字和下划线）";
        return;
    }
    self.usernameValid = YES;
}

-(void)validatePassword
{
    self.passwordValid = NO;
    if (self.password.length < 6) {
        _passwordErrorTitle = @"密码（不能短于6位）";
        return;
    }
    if (self.password.length > 12) {
        _passwordErrorTitle = @"用户名（不能长于12位）";
        return;
    }

    if(![self.password isMatch:RX(@"^\\w+$")]){
        _passwordErrorTitle = @"密码（只包含字母、数字和下划线）";
        return;
    }
    self.passwordValid = YES;
}

@end