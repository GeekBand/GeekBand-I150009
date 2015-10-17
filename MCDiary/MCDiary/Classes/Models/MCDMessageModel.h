//
//  MCDMessageModel.h
//  MCDiary
//
//  Created by Liang Zisheng on 9/9/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDMessageModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *messageTitle;
@property (nonatomic, strong) NSString *publishDate;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL isReadStatus;

@end
