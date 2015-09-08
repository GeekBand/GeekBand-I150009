//
//  MCPresentImagesViewController.m
//  MCDiary
//
//  Created by Turtleeeeeeeeee on 15/9/8.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCPresentImagesViewController.h"

@implementation MCPresentImagesViewController

#pragma mark - View controller life cycle
- (void)viewDidLoad {
    
}

- (void)viewWillAppear:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_presentingImages[_startIndex]];
    //frame即图片缩放到宽度跟屏幕一个宽度的大小位置。
    CGRect frame = imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat ratioOfWidth = frame.size.width / screenBounds.size.width;
    frame.size.width /= ratioOfWidth;
    frame.size.height /= ratioOfWidth;
    frame.origin.x = 0;
    if (frame.size.height >= screenBounds.size.height) {
        frame.origin.y = 0;
    }else{
        frame.origin.y = (screenBounds.size.height - frame.size.height) / 2;
    }
    imageView.frame = _rectForAnimation;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = frame;
    } completion:nil];
}

@end
