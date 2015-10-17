//
//  MCDWebViewController.h
//  MCDiary
//
//  Created by Liang Zisheng on 10/15/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDWebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end
