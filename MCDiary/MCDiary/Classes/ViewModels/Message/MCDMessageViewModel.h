//
//  MCDMessageViewModel.h
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IZMessageViewModel : NSObject

@property (nonatomic, strong) NSArray *messagesList;

+ (IZMessageViewModel *)viewModel;

@end
