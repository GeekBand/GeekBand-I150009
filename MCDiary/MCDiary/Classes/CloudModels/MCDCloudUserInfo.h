//
// Created by zzdjk6 on 15/9/5.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDUser.h"

@interface MCDCloudUserInfo : AVObject <AVSubclassing>

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSNumber *gender;
@property(nonatomic, strong) NSDate   *birthday;
@property(nonatomic, strong) AVFile   *avatarImageFile;
@property(nonatomic, strong) NSNumber *provinceIndex;
@property(nonatomic, strong) NSNumber *cityIndex;
@property(nonatomic, strong) NSNumber *areaIndex;

@end