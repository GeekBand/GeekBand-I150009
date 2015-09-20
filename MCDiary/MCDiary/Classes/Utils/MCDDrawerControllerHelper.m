//
// Created by Shenghan Chen on 15/9/20.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDDrawerControllerHelper.h"
#import "MMDrawerController.h"

@interface MCDDrawerControllerHelper ()

@end

@implementation MCDDrawerControllerHelper
{

}

#pragma mark - Public

+ (void)setCenterViewController:(UIViewController *)viewController
                     completion:(void(^)(BOOL finished))completion
{
    MMDrawerController *drawerController = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [drawerController setCenterViewController:viewController
                           withCloseAnimation:YES
                                   completion:completion];
}

+ (void)openDrawer
{
    MMDrawerController *drawerController = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Life Cycle

#pragma mark - Accessor

#pragma mark - Bindings

#pragma mark - Private

@end