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

#pragma mark - public

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
                    [self.delegate MCDUserModifyPasswordViewModel:self changePasswordFailed:error];
                });
                return;
            }

            [[AVUser currentUser] updatePassword:self.oldPassword
                                     newPassword:self.confirmPassword
                                           block:^(id object, NSError *cloudError) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   self.sendingRequest = NO;
                                                   if (cloudError != nil) {
                                                       [self.delegate MCDUserModifyPasswordViewModel:self changePasswordFailed:cloudError];
                                                       return;
                                                   }

                                                   [self.delegate MCDUserModifyPasswordViewModel:self changePasswordSuccess:YES];
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
        [self.delegate MCDUserModifyPasswordViewModel:self sendForgotPasswordEmailFailed:error];
        return;
    }

    // 发送重置密码邮件
    self.sendingRequest = YES;
    [AVUser requestPasswordResetForEmailInBackground:email
                                               block:^(BOOL succeeded, NSError *error) {
                                                   self.sendingRequest = NO;
                                                   if (succeeded) {
                                                       [self.delegate MCDUserModifyPasswordViewModel:self sendForgotPasswordEmailSuccess:YES];
                                                   } else {
                                                       // TODO: 本地化错误显示
                                                       [self.delegate MCDUserModifyPasswordViewModel:self sendForgotPasswordEmailFailed:error];
                                                   }
                                               }];
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