//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUser.h"
#import "MCDUserLocation.h"
#import "MCDAvatarView.h"
#import "NSDate+DateTools.h"
#import "RegExCategories.h"
#import "MCDCloudUserInfo.h"

static MCDUser *_instance = nil;

@interface MCDUser ()

@property(nonatomic, assign) BOOL basicInfoUpdated;
@property(nonatomic, assign) BOOL extraInfoUpdated;

@end

@implementation MCDUser
{

}

@synthesize allInfoUpdatedSignal = _allInfoUpdatedSignal;
@synthesize infoUpdateFailSignal = _infoUpdateFailSignal;

#pragma mark - public

+ (MCDUser *)currentUser
{
    @synchronized (self) {
        if (_instance == nil) {
            // 从缓存中取
            _instance = [self loadCachedUser];
        }
    }

    return _instance;
}

+ (void)setCurrentUser:(MCDUser *)user
{
    _instance = user;
}

+ (MCDUser *)loadCachedUser
{
    NSURL *cacheURL = [MCDUser cacheURL];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:cacheURL.path];
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

- (void)cacheUser
{
    NSURL *cacheURL = [MCDUser cacheURL];
    [NSKeyedArchiver archiveRootObject:self toFile:cacheURL.path];
}

- (void)updateUserFromCloud
{
    if (self.userId == nil || [self.userId isEqualToString:@""])
        return;
    self.basicInfoUpdated = NO;
    self.extraInfoUpdated = NO;

    // 基本信息
    AVQuery *query = [AVUser query];
    [query getObjectInBackgroundWithId:self.userId
                                 block:^(AVObject *object, NSError *cloudError) {
                                     if (cloudError != nil) {
                                         DDLogVerbose(@"%@", cloudError);
                                         [self infoUpdateFailed:cloudError];
                                         return;
                                     }

                                     AVUser *avUser = (AVUser *)object;
                                     self.avUser   = avUser;
                                     self.username = avUser.username;

                                     if (avUser.email != nil)
                                         self.email = avUser.email;

                                     self.basicInfoUpdated = YES;
                                 }];

    // 额外信息
    query = [MCDCloudUserInfo query];
    [query whereKey:@"userId" equalTo:self.userId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *cloudError) {
        if (cloudError != nil) {
            DDLogVerbose(@"%@", cloudError);
            [self infoUpdateFailed:cloudError];
            return;
        }

        MCDCloudUserInfo *cloudUserInfo = (MCDCloudUserInfo *)object;
        if (cloudUserInfo.gender != nil)
            self.gender = (MCDUserGender)[cloudUserInfo.gender unsignedIntegerValue];

        if (cloudUserInfo.birthday != nil)
            self.birthday = cloudUserInfo.birthday;

        if (cloudUserInfo.avatarImageFile != nil)
            self.avatarImage = [UIImage imageWithData:[cloudUserInfo.avatarImageFile getData]];

        if (cloudUserInfo.provinceIndex != nil)
            self.location.provinceIndex = [cloudUserInfo.provinceIndex unsignedIntegerValue];

        if (cloudUserInfo.cityIndex != nil)
            self.location.cityIndex = [cloudUserInfo.cityIndex unsignedIntegerValue];

        if (cloudUserInfo.areaIndex != nil)
            self.location.areaIndex = [cloudUserInfo.areaIndex unsignedIntegerValue];

        self.extraInfoUpdated = YES;
    }];
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

        _allInfoUpdatedSignal = [[RACSignal
            combineLatest:@[
                RACObserve(self, basicInfoUpdated),
                RACObserve(self, extraInfoUpdated)]
                   reduce:^id(NSNumber *basicFlag, NSNumber *extraFlag) {
                       return @([basicFlag boolValue] && [extraFlag boolValue]);
                   }]
            filter:^BOOL(NSNumber *numFlag) {
                return [numFlag boolValue];
            }];
        _infoUpdateFailSignal = [[self rac_signalForSelector:@selector(infoUpdateFailed:)] map:^NSError *(RACTuple *tuple) {
            return tuple.first;
        }];
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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeInteger:self.gender forKey:@"gender"];
    [coder encodeObject:self.birthday forKey:@"birthday"];
    [coder encodeObject:self.location forKey:@"location"];
    [coder encodeObject:UIImagePNGRepresentation(self.avatarImage) forKey:@"avatarImage"];
    [coder encodeObject:self.userId forKey:@"userId"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.username    = [coder decodeObjectForKey:@"username"];
        self.email       = [coder decodeObjectForKey:@"email"];
        self.gender      = (MCDUserGender)[coder decodeIntegerForKey:@"gender"];
        self.birthday    = [coder decodeObjectForKey:@"birthday"];
        self.location    = [coder decodeObjectForKey:@"location"];
        self.avatarImage = [UIImage imageWithData:[coder decodeObjectForKey:@"avatarImage"]];
        self.userId      = [coder decodeObjectForKey:@"userId"];
    }
    return self;
}


#pragma mark - accessor

#pragma mark - private

+ (NSURL *)cacheURL
{
    NSURL *docUrl  = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:nil];
    NSURL *fileUrl = [docUrl URLByAppendingPathComponent:@"UserCache.plist"];
    return fileUrl;
}

- (void)infoUpdateFailed:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

@end