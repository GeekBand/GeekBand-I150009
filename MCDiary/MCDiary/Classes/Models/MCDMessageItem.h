//
//  MCDMessageItem.h
//  MCDiary
//
//  Created by Liang Zisheng on 9/9/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDMessageItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *sendTime;
@property (nonatomic, strong) NSURL *detailContent;

@end
