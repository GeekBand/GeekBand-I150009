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

@synthesize oldPasswordValidSignal = _oldPasswordValidSignal;
@synthesize freshPasswordValidSignal = _freshPasswordValidSignal;
@synthesize confirmPasswordValidSignal = _confirmPasswordValidSignal;
@synthesize changePasswordSuccessSignal = _changePasswordSuccessSignal;
@synthesize changePasswordFailedSignal = _changePasswordFailedSignal;
@synthesize sendForgotPasswordEmailSuccessSignal = _sendForgotPasswordEmailSuccessSignal;
@synthesize sendForgotPasswordEmailFailedSignal = _sendForgotPasswordEmailFailedSignal;

#pragma mark - Public

- (void)changePassword
{
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

    // Cloud 修改密码
    if (self.oldPasswordValid && self.freshPasswordValid && self.confirmPasswordValid) {
        self.sendingRequest = YES;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            [AVUser logInWithUsername:[MCDUser currentUser].username
                             password:self.oldPassword
                                error:&error];
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.sendingRequest = NO;
                    [self changePasswordFailed:error];
                });
                return;
            }

            [[AVUser currentUser] updatePassword:self.oldPassword
                                     newPassword:self.confirmPassword
                                           block:^(id object, NSError *cloudError) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   self.sendingRequest = NO;
                                                   if (cloudError != nil) {
                                                       [self changePasswordFailed:cloudError];
                                                       return;
                                                   }

                                                   [self changePasswordSuccess];
                                               });
                                           }];
        });
    }
}

- (void)sendForgetPasswordRequestWithEmail:(NSString *)email
{
    // 检验email
    NSString *errorMsg = [MCDUser errorStringForEmail:email];
    if (errorMsg != nil) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                             code:-1
                                         userInfo:@{
                                             NSLocalizedDescriptionKey : @"Email 不正确"
                                         }];
        [self sendForgotPasswordEmailFailed:error];
        return;
    }

    // 发送重置密码邮件
    self.sendingRequest = YES;
    [AVUser requestPasswordResetForEmailInBackground:email
                                               block:^(BOOL succeeded, NSError *error) {
                                                   self.sendingRequest = NO;
                                                   if (succeeded) {
                                                       [self sendForgotPasswordEmailSuccess];
                                                   } else {
                                                       // TODO: 本地化错误显示
                                                       [self sendForgotPasswordEmailFailed:error];
                                                   }
                                               }];
}

#pragma mark - Life Cycle


#pragma mark - Accessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oldPasswordValidSignal     = RACObserve(self, oldPasswordValid);
        _freshPasswordValidSignal   = RACObserve(self, freshPasswordValid);
        _confirmPasswordValidSignal = RACObserve(self, confirmPasswordValid);
        _changePasswordSuccessSignal = [self rac_signalForSelector:@selector(changePasswordSuccess)];
        _changePasswordFailedSignal = [[self rac_signalForSelector:@selector(changePasswordFailed:)] map:^id(RACTuple *tuple) {
            return tuple.first;
        }];
        _sendForgotPasswordEmailSuccessSignal = [self rac_signalForSelector:@selector(sendForgotPasswordEmailSuccess)];
        _sendForgotPasswordEmailFailedSignal = [[self rac_signalForSelector:@selector(sendForgotPasswordEmailFailed:)] map:^id(RACTuple *tuple) {
            return tuple.first;
        }];

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

#pragma mark - Signal Trigger

- (void)changePasswordSuccess
{
}

- (void)changePasswordFailed:(NSError *)error
{
}

- (void)sendForgotPasswordEmailSuccess
{
}

- (void)sendForgotPasswordEmailFailed:(NSError *)error
{
}

#pragma mark - Private

@end