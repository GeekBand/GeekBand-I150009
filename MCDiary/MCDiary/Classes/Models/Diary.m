//
//  Diary.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "Diary.h"

@implementation Diary

- (id)initADiaryWithTitle:(NSString *) title
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
