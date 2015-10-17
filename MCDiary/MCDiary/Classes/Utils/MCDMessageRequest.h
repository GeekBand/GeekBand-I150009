//
//  MCDMessageRequest.h
//  MCDiary
//
//  Created by Liang Zisheng on 10/14/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDMessageModel.h"

@class MCDMessageRequest;
@protocol MCDMessageRequestDelegate <NSObject>

- (void)messageRequestSuccess:(MCDMessageRequest *)request messageList:(NSArray *)messageList;
- (void)messageRequestFailed:(MCDMessageRequest *)request error:(NSError *)error;

@end


@interface MCDMessageRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, retain) id<MCDMessageRequestDelegate> delegate;

- (void)sendMessagesListRefreshRequestWithDelegate:(id<MCDMessageRequestDelegate>)delegate;

@end
