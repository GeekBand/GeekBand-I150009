//
//  MCDMyPetDetails.h
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDMyPet : NSObject<NSCoding>

@property(nonatomic, copy)UIImage *image;

@property(nonatomic, copy)NSString *nickName;
@property(nonatomic, copy)NSString *birthday;
@property(nonatomic, copy)NSString *variety;

@property(nonatomic, assign)NSInteger gender;

@property(nonatomic, copy)NSString *height;
@property(nonatomic, copy)NSString *weight;


@end
