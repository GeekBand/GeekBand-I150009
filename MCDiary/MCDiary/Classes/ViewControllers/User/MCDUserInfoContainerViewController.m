//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserInfoContainerViewController.h"
#import "MCDUserInfoContentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface MCDUserInfoContainerViewController ()

@property(nonatomic, strong) MCDUserInfoContentViewController *contentViewController;
@property(nonatomic, assign) CGRect                           contentViewFrame;

@property(nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation MCDUserInfoContainerViewController
{

}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self registerKeyBoardObserver];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self loadContentViewController];
    self.contentViewController.view.frame = self.contentViewFrame;
    [self.contentViewController.view layoutIfNeeded];
}

#pragma mark - accessor

#pragma mark - public

#pragma mark - private

- (void)loadContentViewController
{
    if (self.contentViewController != nil)
        return;

    NSString *contentViewControllerID = NSStringFromClass([MCDUserInfoContentViewController class]);
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:contentViewControllerID];

    self.contentViewFrame                 = self.scrollView.bounds;
    self.contentViewController.view.frame = self.contentViewFrame;

    // UIScrollView 只在 ContentSize 比自己大的时候才滚动
    CGSize contentSize = self.contentViewFrame.size;
    contentSize.height++;
    self.scrollView.contentSize = contentSize;

    [self addChildViewController:self.contentViewController];
    [self.scrollView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
}

@end