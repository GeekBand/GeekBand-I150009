//
//  MCShowImageViewController.m
//  MCDiary
//
//  Created by Turtleeeeeeeeee on 15/9/6.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCShowImageViewController.h"

@implementation MCShowImageViewController

#pragma mark - View controller life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_imageToShow];
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
    imageView.frame = frame;
    _imagesScrollView.backgroundColor = [UIColor blackColor];
    [_imagesScrollView addSubview:imageView];
}

#pragma mark - UIResponder methods

- (IBAction)backwardButtonDidTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonDidTouch:(id)sender {
    [_delegate deleteImage:_imageToShow];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
