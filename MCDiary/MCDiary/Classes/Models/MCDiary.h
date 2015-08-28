//
//  MCDiary.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDiary : NSObject

@property (copy, nonatomic)NSString         *title;
@property (strong, nonatomic)NSDate         *createTime;
@property (copy, nonatomic)NSString         *content;
@property (strong, nonatomic)NSMutableArray *images;
@property (assign, nonatomic)BOOL            isBigEvent;

- (id)initAMCDiaryWithTitle:(NSString *) title
               createTime:(NSDate *) createTime
                  content:(NSString *) content
                   images:(NSMutableArray *) images
               isBigEvent:(BOOL) isBigEvent;

- (void)setupDataWithTitle:(NSString *)title
                createTime:(NSDate *) createTime
                   content:(NSString *) content
                    images:(NSMutableArray *) images
                isBigEvent:(BOOL) isBigEvent;

@end
