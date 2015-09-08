//
//  ViewController.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/18.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDHomeViewController.h"
#import "MCDHomeViewModel.h"
#import "MMDrawerController.h"
#import "UIColor+MCDiary.h"

@interface MCDHomeViewController ()

@end

@implementation MCDHomeViewController

@synthesize viewModel = _viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewModel = [[MCDHomeViewModel alloc] init];
    
    UIStoryboard     *sb = [UIStoryboard storyboardWithName:@"MyPet" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
//     根据用户登录状态判断跳转位置
//    if (!self.viewModel.userLoggedIn) {
//        // 去登录
//        UIStoryboard     *sb = [UIStoryboard storyboardWithName:@"User" bundle:nil];
//        UIViewController *vc = [sb instantiateInitialViewController];
//
//        UIViewController *leftDrawer = [self.storyboard instantiateViewControllerWithIdentifier:@"MCDLeftDrawerViewController"];
//        leftDrawer.view.backgroundColor = [UIColor MCDGreen];
//
//        MMDrawerController *drawerController = [[MMDrawerController alloc]
//            initWithCenterViewController:vc
//                leftDrawerViewController:leftDrawer
//               rightDrawerViewController:nil];
//
//        [UIApplication sharedApplication].delegate.window.rootViewController = drawerController;
//    }
}

@end
