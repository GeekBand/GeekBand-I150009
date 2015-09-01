//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContainerViewController.h"
#import "MCDSignupContentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface MCDSignupContainerViewController ()

@property(nonatomic, strong) MCDSignupContentViewController *contentViewController;
@property(nonatomic, assign) CGRect                         contentViewFrame;

@property(nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation MCDSignupContainerViewController

#pragma mark - life cycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self loadContentViewController];
    self.contentViewController.view.frame = self.contentViewFrame;
    [self.contentViewController.view layoutIfNeeded];

}

#pragma mark - private

- (void)loadContentViewController
{
    if (self.contentViewController != nil)
        return;

    NSString *contentViewControllerID = NSStringFromClass([MCDSignupContentViewController class]);
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