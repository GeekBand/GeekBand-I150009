//
//  MCDPresentImagesViewController.m
//  MCDiary
//
//  Created by Turtleeeeeeeeee on 15/9/8.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDPresentImagesViewController.h"

@implementation MCDPresentImagesViewController

#pragma mark - View controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _presentImagesScrollView.delegate = self;
    //加载所有图片视图
    _presentingImageViews = [NSMutableArray array];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _presentImagesScrollView.contentSize = CGSizeMake(screenBounds.size.width * _presentingImages.count, screenBounds.size.height);
    for (int i = 0; i < _presentingImages.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_presentingImages[i]];
        //frame即图片缩放到宽度跟屏幕一个宽度的大小位置。
        CGRect frame = imageView.frame;
        CGFloat ratioOfWidth = frame.size.width / screenBounds.size.width;
        frame.size.width /= ratioOfWidth;
        frame.size.height /= ratioOfWidth;
        frame.origin.x = i * screenBounds.size.width;
        if (frame.size.height >= screenBounds.size.height) {
            frame.origin.y = 0;
        }else{
            frame.origin.y = (screenBounds.size.height - frame.size.height) / 2;
        }
        imageView.frame = frame;
        [_presentingImageViews addObject:imageView];
        [_presentImagesScrollView addSubview:imageView];
    }
    _imagesPageControl.numberOfPages = _presentingImages.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImageView *imageView = _presentingImageViews[_startIndex];
    CGRect frame = imageView.frame;
    _presentImagesScrollView.contentOffset = CGPointMake(frame.origin.x, 0);
    _imagesPageControl.currentPage = _startIndex;
    _rectForAnimation.origin.x += frame.origin.x;
    imageView.frame = _rectForAnimation;
    _rectForAnimation.origin.x -= frame.origin.x;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = frame;
    } completion:nil];
}

#pragma mark - UI Responder methods

- (IBAction)tapGestureTrigger:(id)sender {
    //缩小动画
    UIImageView *imageView = _presentingImageViews[_imagesPageControl.currentPage];
    CGRect frame = imageView.frame;
    CGRect rectOfCellInWindow = [_bindingCollectionView convertRect:[_bindingCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_imagesPageControl.currentPage inSection:0]].frame toView:nil];
    _rectForAnimation = rectOfCellInWindow;
    _rectForAnimation.origin.x += frame.origin.x;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = _rectForAnimation;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - UIScrollView Delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _imagesPageControl.currentPage = scrollView.contentOffset.x / screenBounds.size.width;
}

@end
