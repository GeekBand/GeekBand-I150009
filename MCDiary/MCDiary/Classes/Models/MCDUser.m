//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUser.h"
#import "MCDUserLocation.h"
#import "MCDAvatarView.h"
#import "NSDate+DateTools.h"
#import "RegExCategories.h"

static MCDUser *_instance = nil;

@interface MCDUser ()

@end

@implementation MCDUser
{

}

#pragma mark - public

+ (MCDUser *)currentUser
{
    @synchronized (self) {
        if (_instance == nil) {
            // TODO: load from plist and cloud
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

+ (void)setCurrentUser:(MCDUser *)user
{
    _instance = user;
}

+ (nullable NSString *)errorStringForUsername:(NSString *)username
{
    if (username.length < 3) {
        return @"用户名（不能短于3位）";
    }
    if (username.length > 15) {
        return @"用户名（不能长于15位）";
    }

    if (![username isMatch:RX(@"^\\w+$")]) {
        return @"用户名（只包含字母、数字和下划线）";
    }

    return nil;
}

+ (nullable NSString *)errorStringForPassword:(NSString *)password
{
    if (password.length < 6) {
        return @"密码（不能短于6位）";
    }
    if (password.length > 12) {
        return @"用户名（不能长于12位）";
    }

    if (![password isMatch:RX(@"^\\w+$")]) {
        return @"密码（只包含字母、数字和下划线）";
    }

    return nil;
}

+ (nullable NSString *)errorStringForEmail:(NSString *)email
{
    // 允许没有邮箱
    if ([email isEqualToString:@""]) {
        return nil;
    }

    if (![email isMatch:RX(@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")]) {
        return @"邮箱（格式不正确）";
    }

    return nil;
}

- (void)save
{
    DDLogVerbosePrettyFunction;
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.username    = @"User";
        self.location    = [MCDUserLocation new];
        self.avatarImage = [MCDAvatarView defaultAvatarImage];
        self.gender      = MCDUserGenderFemale;
        self.birthday    = [NSDate dateWithYear:1991 month:1 day:1];
    }

    return self;
}

- (instancetype)initWithAVUser:(AVUser *)avUser
{
    self = [self init];
    if (self) {
        self.userId   = avUser.objectId;
        self.username = avUser.username;
        self.email    = avUser.email;
        self.avUser   = avUser;
    }
    return self;
}


#pragma mark - accessor

#pragma mark - private

@end