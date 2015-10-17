//
//  MCDMessageParser.m
//  MCDiary
//
//  Created by Liang Zisheng on 10/14/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageParser.h"

@implementation MCDMessageParser


- (NSArray *)parseJson:(NSData *)data {
    
    NSError *error = nil;
    id jsonList = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    if (error) {
        NSLog(@"This parser is not work since: %@", error);
    } else {
        if ([jsonList isKindOfClass:[NSArray class]]) {
            NSMutableArray *messageList = [NSMutableArray array];
            for (id item in jsonList) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    MCDMessageModel *message = [[MCDMessageModel alloc] init];
                    message.messageTitle = [item valueForKey:@"content"];
                    message.publishDate = [item valueForKey:@"created_at"];
                    message.url = [NSURL URLWithString:[item valueForKey:@"url"]];
                    message.isReadStatus = NO;
                    
                    [messageList addObject:message];
                }
            }
            return messageList;
        }
    }
    
    return nil;
}

@end
