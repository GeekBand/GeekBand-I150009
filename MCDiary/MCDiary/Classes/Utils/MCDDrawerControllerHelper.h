//
// Created by Shenghan Chen on 15/9/20.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


@interface MCDDrawerControllerHelper : NSObject
+ (void)setCenterViewController:(UIViewController *)viewController completion:(void (^)(BOOL finished))completion;

+ (void)openDrawer;
@end