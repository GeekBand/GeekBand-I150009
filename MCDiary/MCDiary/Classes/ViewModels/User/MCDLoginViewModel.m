//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewModel.h"
#import "MCDUser.h"


@implementation MCDLoginViewModel

@synthesize loginSuccessSignal = _loginSuccessSignal;
@synthesize loginFailSignal = _loginFailSignal;
@synthesize foregetPasswordRequestSuccessSignal = _foregetPasswordRequestSuccessSignal;
@synthesize foregetPasswordRequestFailSignal = _foregetPasswordRequestFailSignal;

#pragma mark - public

- (void)validateAndLogin
{
    // useranme
    NSString *errorUsername = [MCDUser errorStringForUsername:self.username];
    if (errorUsername) {
        _usernameErrorTitle = errorUsername;
        self.usernameValid = NO;
    } else {
        self.usernameValid = YES;
    }

    // password
    NSString *errorPassword = [MCDUser errorStringForPassword:self.password];
    if (errorPassword) {
        _passwordErrorTitle = errorPassword;
        self.passwordValid = NO;
    } else {
        self.passwordValid = YES;
    }

    if(!self.usernameValid || !self.passwordValid)
        return;

    // Cloud 登录
    [AVUser logInWithUsernameInBackground:self.username
                                 password:self.password
                                    block:^(AVUser *user, NSError *error) {
                                        if (user != nil) {
                                            [self loginSuccess:user];
                                        } else {
                                            [self loginFail:error];
                                        }
                                    }];
}

- (void)sendForgetPasswordRequestWithEmail:(NSString *)email
{
    // 检验email
    NSString *errorMsg = [MCDUser errorStringForEmail:email];
    if(errorMsg != nil){
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                             code:-1
                                         userInfo:@{
                                             NSLocalizedDescriptionKey : @"Email 不正确"
                                         }];
        [self forgetPasswordRequestFail:error];
        return;
    }

    // 发送重置密码邮件
    [AVUser requestPasswordResetForEmailInBackground:email
                                               block:^(BOOL succeeded, NSError *error) {
                                                   if (succeeded) {
                                                       [self forgetPasswordRequestSuccess];
                                                   } else {
                                                       // TODO: 本地化错误显示
                                                       [self forgetPasswordRequestFail:error];
                                                   }
                                               }];
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.usernameValid = YES;
        self.passwordValid = YES;

        _loginSuccessSignal = [[self rac_signalForSelector:@selector(loginSuccess:)] map:^MCDUser *(id value) {
            return [MCDUser currentUser];
        }];
        _loginFailSignal    = [[self rac_signalForSelector:@selector(loginFail:)] map:^NSError *(RACTuple *tuple) {
            return tuple.first;
        }];

        _foregetPasswordRequestSuccessSignal = [self rac_signalForSelector:@selector(forgetPasswordRequestSuccess)];
        _foregetPasswordRequestFailSignal = [[self rac_signalForSelector:@selector(forgetPasswordRequestFail:)] map:^NSError *(RACTuple *tuple) {
            return tuple.first;
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

- (void)loginSuccess:(AVUser *)avUser
{
    MCDUser *user = [[MCDUser alloc] initWithAVUser:avUser];
    [MCDUser setCurrentUser:user];
}

- (void)loginFail:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

- (void)forgetPasswordRequestSuccess
{
    DDLogVerbosePrettyFunction;
}

-(void)forgetPasswordRequestFail:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

@end