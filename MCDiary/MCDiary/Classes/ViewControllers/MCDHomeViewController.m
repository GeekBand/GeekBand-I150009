//
//  ViewController.m
//  MCDiary
//
//  Created by zzdjk6 on 15/8/18.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDHomeViewController.h"
#import "MCDHomeViewModel.h"

@interface MCDHomeViewController ()

@end

@implementation MCDHomeViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [[MCDHomeViewModel alloc] init];
}

@end
