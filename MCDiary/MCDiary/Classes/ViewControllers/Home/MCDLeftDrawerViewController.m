//
//  MCDLeftDrawerViewController.m
//  MCDiary
//
//  Created by 陈圣晗 on 15/9/18.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDLeftDrawerViewController.h"
#import "MCDUser.h"

@interface MCDLeftDrawerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *greaingLabel;

@end

static const NSUInteger kMyPetIndex    = 0;
static NSUInteger kMessageIndex  = 1;
static NSUInteger kUserInfoIndex = 2;
static NSUInteger kLogoutIndex   = 3;
static NSUInteger kAboutIndex    = 4;

@implementation MCDLeftDrawerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MCDUser *user = [MCDUser currentUser];
    self.greaingLabel.text = [NSString stringWithFormat:@"你好，%@!", user.username];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Redirect
    NSUInteger row = indexPath.row;
    if(row == kMyPetIndex) {
        return;
    }
    if(row == kMessageIndex) {
        return;
    }
    if(row == kUserInfoIndex) {
        return;
    }
    if(row == kLogoutIndex) {
        return;
    }
    if(row == kAboutIndex) {
        return;
    }
}

@end
