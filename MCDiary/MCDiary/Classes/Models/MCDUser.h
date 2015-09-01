//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseModel.h"

@class MCDUserLocation;

typedef NS_ENUM(NSUInteger, MCDUserGender)
{
    MCDUserGenderFemale = 1,
    MCDUserGenderMale   = 2,
};

@interface MCDUser : MCDBaseModel

@property(nonatomic, copy) NSString          *username;
@property(nonatomic, copy) NSString          *password;
@property(nonatomic, copy) NSString          *email;
@property(nonatomic, assign) MCDUserGender   gender;
@property(nonatomic, copy) NSDate            *birthday;
@property(nonatomic, strong) MCDUserLocation *location;
@property(nonatomic, strong) UIImage         *avatarImage;

+ (MCDUser *)currentUser;

+ (NSString *)errorStringForUsername:(NSString *)username;

+ (NSString *)errorStringForPassword:(NSString *)password;

+ (NSString *)errorStringForEmail:(NSString *)email;

- (void)save;

@end