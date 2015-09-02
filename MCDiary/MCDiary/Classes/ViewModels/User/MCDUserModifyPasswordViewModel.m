//
// Created by zzdjk6 on 15/9/3.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserModifyPasswordViewModel.h"
#import "MCDUser.h"

@interface MCDUserModifyPasswordViewModel ()

@end

@implementation MCDUserModifyPasswordViewModel
{
}

@synthesize oldPasswordvalidSignal = _oldPasswordvalidSignal;
@synthesize freshPasswordvalidSignal = _freshPasswordvalidSignal;
@synthesize confirmPasswordvalidSignal = _confirmPasswordvalidSignal;
@synthesize successSignal = _successSignal;

#pragma mark - public

- (void)changePassword
{
    // TODO: Cloud 验证旧密码
    _oldPasswordTitleError = [MCDUser errorStringForPassword:self.oldPassword];
    self.oldPasswordValid = (_oldPasswordTitleError == nil);

    // 新密码
    _freshPasswordTitleError = [MCDUser errorStringForPassword:self.freshPassword];
    self.freshPasswordValid = (_freshPasswordTitleError == nil);

    // 确认新密码
    do {
        if (![self.confirmPassword isEqualToString:self.freshPassword]) {
            _confirmPasswordTitleError = @"确认新密码（两次输入的密码不一致）";
            self.confirmPasswordValid = NO;
            break;
        }

        _confirmPasswordTitleError = [MCDUser errorStringForPassword:self.confirmPassword];
        self.confirmPasswordValid = (_confirmPasswordTitleError == nil);
    } while (0);

    // TODO: 真的修改密码
    if (self.oldPasswordValid && self.freshPasswordValid && self.confirmPasswordValid)
        self.success = YES;
}

#pragma mark - life cycle


#pragma mark - accessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oldPasswordvalidSignal     = RACObserve(self, oldPasswordValid);
        _freshPasswordvalidSignal   = RACObserve(self, freshPasswordValid);
        _confirmPasswordvalidSignal = RACObserve(self, confirmPasswordValid);
        _successSignal              = RACObserve(self, success);

        _success              = YES;
        _oldPasswordValid     = YES;
        _freshPasswordValid   = YES;
        _confirmPasswordValid = YES;
    }

    return
        self;
}

- (NSString *)oldPasswordTitleNormal
{
    return @"原密码";
}

- (NSString *)freshPasswordTitleNormal
{
    return @"新密码";
}

- (NSString *)confirmPasswordTitleNormal
{
    return @"确认新密码";
}

#pragma mark - private

@end