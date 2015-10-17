//
//  MCDWebViewController.m
//  MCDiary
//
//  Created by Liang Zisheng on 10/15/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDWebViewController.h"
#import "Masonry.h"

@interface MCDWebViewController () <UIWebViewDelegate>

@end

@implementation MCDWebViewController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self showWaitingSpinner];
    [self.webView loadRequest:request];
    //[self dismissWaitingSpinner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods
- (void)showWaitingSpinner {
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:self.spinner];
        self.spinner.hidesWhenStopped = YES;
        [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view).centerOffset(CGPointMake(0, -100));
        }];
    }
    
    [self.spinner startAnimating];
}

- (void)dismissWaitingSpinner {
    
    [self.spinner stopAnimating];
    //[self.spinner removeFromSuperview];

}

#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showWaitingSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self dismissWaitingSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self dismissWaitingSpinner];
    NSLog(@"%@", error);
}


@end
