//
//  MCDMessageViewModel.m
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageViewModel.h"
#import "MCDMessageRequest.h"
#import "MCDMessageModel.h"



@interface IZMessageViewModel() <MCDMessageRequestDelegate>

@property (nonatomic, strong) MCDMessageRequest *request;

@end

@implementation IZMessageViewModel

#pragma mark - Getter && Setter Methods

#pragma mark - Init Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

+ (IZMessageViewModel *)viewModel {
    return [[IZMessageViewModel alloc] init];
}

#pragma mark - custom Methods
- (void)showMeData {
    // 检查是否存在 xx.plist 文件，如果存在读入
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"message.plist"];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger isReadableFileAtPath:filePath]) {
        //self.messageList = [NSArray arrayWithContentsOfFile:filePath];
        self.messageList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!self.messageList) {
            NSLog(@"Unarchiver is failed");
        }
    }
    // 提交网络请求
    // 启动小菊花
    if ([self.delegate respondsToSelector:@selector(showWaitingSpinner)]) {
        [self.delegate showWaitingSpinner];
    } else {
        NSLog(@"delegate is not respondsTofuction showWaitingSpinner");
    }
    self.request = [[MCDMessageRequest alloc] init];
    [self.request sendMessagesListRefreshRequestWithDelegate:self];
        
}

- (void)markAllMessageAsHaveRead {
    
    for (MCDMessageModel *message in self.messageList) {
        message.isReadStatus = YES;
    }
    [self.delegate reloadDataWithViewModel:self];
}

- (void)markAllMessageAsHaveNotRead {
    
    for (MCDMessageModel *message in self.messageList) {
        message.isReadStatus = NO;
    }
    [self.delegate reloadDataWithViewModel:self];
}

- (void)archiveMessageList {
    // 写入 plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"message.plist"];
    //BOOL isSuccess = [self.messageList writeToFile:filePath atomically:YES];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:self.messageList toFile:filePath];
    NSLog(@"Archieving messagesData into %@ is %@", filePath, isSuccess ? @"Success" : @"Failed");
}

#pragma mark - MCDMessageRequestDelegate
- (void)messageRequestSuccess:(MCDMessageRequest *)request
                  messageList:(NSArray *)messageList {
    
    self.messageList = [NSArray arrayWithArray:messageList];
    
    [self archiveMessageList];
    // 刷新 tableview
    if ([self.delegate respondsToSelector:@selector(reloadDataWithViewModel:)]) {
        [self.delegate reloadDataWithViewModel:self];
    } else {
        NSLog(@"--> IZMessageViewModel's delegate is not working\n");
    }
    
    // 让小菊花停转
    [self.delegate dismissWaitingSpinner];

}

- (void)messageRequestFailed:(MCDMessageRequest *)request
                       error:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(showErrorMessage:)]) {
        [self.delegate showErrorMessage:[error description]];
    } else {
        NSLog(@"--> IZMessageViewModel's delegate is not working\nBtw, %@", error);
    }
    
    // 让小菊花停转
    [self.delegate dismissWaitingSpinner];

}



@end
