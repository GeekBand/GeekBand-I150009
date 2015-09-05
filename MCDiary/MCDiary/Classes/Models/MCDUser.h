//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseModel.h"

@class MCDUserLocation;

typedef NS_ENUM (NSUInteger, MCDUserGender)
{
    MCDUserGenderFemale = 1,
    MCDUserGenderMale   = 2,
};

@interface MCDUser : MCDBaseModel <NSCoding>

@property(nonatomic, copy) NSString          *username;
@property(nonatomic, copy) NSString          *password;
@property(nonatomic, copy) NSString          *email;
@property(nonatomic, assign) MCDUserGender   gender;
@property(nonatomic, copy) NSDate            *birthday;
@property(nonatomic, strong) MCDUserLocation *location;
@property(nonatomic, strong) UIImage         *avatarImage;

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, strong) AVUser *avUser;

@property(nonatomic, strong, readonly) RACSignal *allInfoUpdatedSignal;
@property(nonatomic, strong, readonly) RACSignal *infoUpdateFailSignal;
@property(nonatomic, strong, readonly) RACSignal *logoutSignal;

+ (MCDUser *)currentUser;

+ (void)setCurrentUser:(MCDUser *)user;

+ (NSString *)errorStringForUsername:(NSString *)username;

+ (NSString *)errorStringForPassword:(NSString *)password;

+ (NSString *)errorStringForEmail:(NSString *)email;

+ (MCDUser *)loadCachedUser;

- (instancetype)initWithAVUser:(AVUser *)avUser;

- (void)save;

- (void)cacheUser;

- (void)updateUserFromCloud;

- (void)logout;


@end