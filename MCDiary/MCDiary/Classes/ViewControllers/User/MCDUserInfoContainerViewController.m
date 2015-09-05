//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserInfoContainerViewController.h"
#import "MCDUserInfoContentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MMDrawerController.h"
#import "MCDUser.h"
#import "MCDLoginViewController.h"

@interface MCDUserInfoContainerViewController ()

@property(nonatomic, strong) MCDUserInfoContentViewController *contentViewController;
@property(nonatomic, assign) CGRect                           contentViewFrame;

@property(nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UIButton                     *openMenuButton;
@property(nonatomic, weak) IBOutlet UIButton                     *logoutButton;

@end

@implementation MCDUserInfoContainerViewController
{

}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initBindings];
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

- (void)initBindings
{
    // 打开菜单
    [[self.openMenuButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            MMDrawerController *rootVC = (MMDrawerController *)
                [UIApplication sharedApplication].delegate.window.rootViewController;
            rootVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
            [rootVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
    ];

    // 注销用户
    [[MCDUser currentUser].logoutSignal subscribeNext:^(id x) {
        MMDrawerController *rootVC = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        rootVC.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MCDLoginViewController class])];
    }];
    [[self.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            [[MCDUser currentUser] logout];
        }
    ];

}

@end