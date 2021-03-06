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
#import "MCDDrawerControllerHelper.h"

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
            [MCDDrawerControllerHelper openDrawer];
        }
    ];

    // 注销用户
    [[MCDUser currentUser].logoutSignal subscribeNext:^(id x) {
        MMDrawerController *rootVC = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        rootVC.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MCDLoginViewController class])];
    }];
    [[self.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认注销?"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"注销"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [[MCDUser currentUser] logout];
                                                              }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"还不用"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }
    ];

}

@end