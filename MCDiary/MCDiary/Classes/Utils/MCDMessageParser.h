//
//  MCDMessageParser.h
//  MCDiary
//
//  Created by Liang Zisheng on 10/14/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDMessageModel.h"

@interface MCDMessageParser : NSObject

- (NSArray *)parseJson:(NSData *)data;

@end
