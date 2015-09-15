//
//  MCDiary.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDiary.h"

static NSString *titleKey      =    @"MCDiaryTitle";
static NSString *createTimeKey =    @"MCDiaryCreateTime";
static NSString *contentKey    =    @"MCDiaryContent";
static NSString *imagesKey     =    @"MCDiaryImages";
static NSString *isBigEventKey =    @"MCDiaryIsBigEvent";

@implementation MCDiary

#pragma mark - Encoding 

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:titleKey];
    [aCoder encodeObject:_createTime forKey:createTimeKey];
    [aCoder encodeObject:_content forKey:contentKey];
    [aCoder encodeObject:_images forKey:imagesKey];
    [aCoder encodeBool:_isBigEvent forKey:isBigEventKey];
}

#pragma mark - Initialize methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:titleKey];
        _createTime = [aDecoder decodeObjectForKey:createTimeKey];
        _content = [aDecoder decodeObjectForKey:contentKey];
        _images = [aDecoder decodeObjectForKey:imagesKey];
        _isBigEvent = [aDecoder decodeObjectForKey:isBigEventKey];
    }
    return self;
}

- (id)initAMCDiaryWithTitle:(NSString *) title
               createTime:(NSDate *) createTime
                  content:(NSString *) content
                   images:(NSMutableArray *) images
               isBigEvent:(BOOL) isBigEvent
{
    self = [super init];
    if (self) {
        _title = title;
        _createTime = createTime;
        _content = content;
        _images = images;
        _isBigEvent = isBigEvent;
    }
    return self;
}

#pragma mark - Actually a setter

- (void)setupDataWithTitle:(NSString *)title
                createTime:(NSDate *) createTime
                   content:(NSString *) content
                    images:(NSMutableArray *) images
                isBigEvent:(BOOL) isBigEvent
{
    _title = title;
    _createTime = createTime;
    _content = content;
    _images = images;
    _isBigEvent = isBigEvent;
}

@end
