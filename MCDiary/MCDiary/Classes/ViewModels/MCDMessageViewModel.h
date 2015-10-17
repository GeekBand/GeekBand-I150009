//
//  MCDMessageViewModel.h
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IZMessageViewModel;
@protocol IZMessageViewModelDelegate <NSObject>

- (void)reloadDataWithViewModel:(IZMessageViewModel *)viewModel;

@optional
- (void)showErrorMessage:(NSString *)msg;
- (void)showWaitingSpinner;
- (void)dismissWaitingSpinner;

@end

@interface IZMessageViewModel : NSObject

@property (nonatomic, strong) NSArray *messageList;
@property (nonatomic, retain) id<IZMessageViewModelDelegate> delegate;

+ (IZMessageViewModel *)viewModel;
- (void)showMeData;
- (void)markAllMessageAsHaveRead;
- (void)markAllMessageAsHaveNotRead;
- (void)archiveMessageList;

@end
