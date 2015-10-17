//
//  MCDMessageRequest.m
//  MCDiary
//
//  Created by Liang Zisheng on 10/14/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageRequest.h"
#import "MCDMessageParser.h"


@implementation MCDMessageRequest

- (void)sendMessagesListRefreshRequestWithDelegate:(id<MCDMessageRequestDelegate>)delegate {

    [self.urlConnection cancel];
    self.delegate = delegate;
    
    NSString *urlString = @"https://raw.githubusercontent.com/GeekBand/GeekBand-I150009/master/Website/Announcement.json";
    NSString *encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:60];
    
    request.HTTPMethod = @"Get";
        
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
  
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
 
    self.receivedData = [NSMutableData data];
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *dataString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Recieved Data String: %@", dataString);
    
    MCDMessageParser *parser = [[MCDMessageParser alloc] init];
    NSArray *messageList = [parser parseJson:self.receivedData];
    //parse the dataString
    if ([self.delegate respondsToSelector:@selector(messageRequestSuccess:messageList:)]) {
        [self.delegate messageRequestSuccess:self messageList:messageList];
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    
    NSLog(@"Error: %@", error);
    if ([self.delegate respondsToSelector:@selector(messageRequestFailed:error: )]) {
        [self.delegate messageRequestFailed:self error:error];
    }
}


@end
