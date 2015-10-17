//
//  MCDMessageModel.m
//  MCDiary
//
//  Created by Liang Zisheng on 9/9/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageModel.h"

@implementation MCDMessageModel

- (NSString *)description {
    return [NSString stringWithFormat:@"{messageTitle:%@, publishDate:%@, url:%@, isReadStatus:%@}", self.messageTitle, self.publishDate, self.url, self.isReadStatus ? @"Yes" : @"No"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.messageTitle forKey:@"message"];
    [aCoder encodeObject:self.publishDate forKey:@"create_at"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeBool:self.isReadStatus forKey:@"isReadStatus"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.messageTitle = [aDecoder decodeObjectForKey:@"message"];
        self.publishDate = [aDecoder decodeObjectForKey:@"create_at"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.isReadStatus = [aDecoder decodeBoolForKey:@"isReadStatus"];
    }
    return self;
}

@end
