//
// Created by zzdjk6 on 15/9/5.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDUser.h"

@interface MCDCloudUserInfo : AVObject <AVSubclassing>

@property(nonatomic, copy) NSString *userId;

@property(nonatomic, assign) MCDUserGender gender;
@property(nonatomic, copy) NSDate          *birthday;
@property(nonatomic, strong) AVFile        *avatarImageFile;

// 位置
@property(nonatomic, assign) NSNumber      *provinceIndex;
@property(nonatomic, assign) NSNumber      *cityIndex;
@property(nonatomic, assign) NSNumber      *areaIndex;

@end