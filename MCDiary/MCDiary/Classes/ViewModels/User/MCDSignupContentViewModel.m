//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewModel.h"
#import "MCDUser.h"
#import "MCDCloudUserInfo.h"

@interface MCDSignupContentViewModel ()

@end

@implementation MCDSignupContentViewModel
{

}

@synthesize signUpErrorSignal = _signUpErrorSignal;
@synthesize signUpSuccessSignal = _signUpSuccessSignal;

#pragma mark - public

- (void)validateAndSignup
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

    // email
    NSString *errorEmail = [MCDUser errorStringForEmail:self.email];
    if (errorEmail) {
        _emailErrorTitle = errorEmail;
        self.emailValid = NO;
    } else {
        self.emailValid = YES;
    }

    // Cloud 检测
    if (!(self.emailValid && self.usernameValid && self.passwordValid)) {
        return;
    }

    AVUser *avUser = [AVUser user];
    avUser.username  = self.username;
    avUser.password  = self.password;
    if (self.email != nil && ![self.email isEqualToString:@""])
        avUser.email = self.email;

    @weakify(self);
    // 因为avUser的Block要引用自身,因此需要弱引用
    __weak typeof(avUser) weakAVUser = avUser;
    [avUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            [self signUpSucess:weakAVUser];
        } else {
            // TODO: 本地化错误显示
            [self signUpError:error];
        }
    }];
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usernameValid = YES;
        _passwordValid = YES;
        _emailValid    = YES;

        _signUpSuccessSignal = [self rac_signalForSelector:@selector(signUpSucess:)];
        _signUpErrorSignal   = [[self rac_signalForSelector:@selector(signUpError:)] map:^NSError *(RACTuple *tuple) {
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

- (NSString *)emailNormalTitle
{
    return @"邮箱（可选，仅用于找回密码）";
}

#pragma mark - private

- (void)signUpSucess:(AVUser *)avUser
{
    // 设置仅用户可写的ACL
    AVACL *acl = [AVACL ACL];
    [acl setPublicReadAccess:YES]; //此处设置的是所有人的可读权限
    [acl setWriteAccess:YES forUser:avUser]; //而这里设置了文件创建者的写权限

    // 设置用户的ACL
    avUser.ACL = acl;
    [avUser saveInBackground];

    // 上传头像
    AVFile *avatarFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png",avUser.objectId]
                                         data:UIImagePNGRepresentation(self.avatarImage)];

    __weak typeof(avatarFile) weakFile = avatarFile;
    [avatarFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            MCDCloudUserInfo *cloudUserInfo = [MCDCloudUserInfo object];
            cloudUserInfo.userId = avUser.objectId;
            cloudUserInfo.avatarImageFile = weakFile;
            cloudUserInfo.ACL = acl;
            [cloudUserInfo save];
        }
    }];

    MCDUser *user = [[MCDUser alloc] initWithAVUser:avUser];
    [MCDUser setCurrentUser:user];
}

- (void)signUpError:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

@end