//
//  MCDLeftDrawerViewController.m
//  MCDiary
//
//  Created by 陈圣晗 on 15/9/18.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDLeftDrawerViewController.h"
#import "MCDUser.h"
#import "MCDDrawerControllerHelper.h"

@interface MCDLeftDrawerViewController ()

@property(weak, nonatomic) IBOutlet UILabel *greatingLabel;

@end

static const NSUInteger kMyPetIndex    = 0;
static const NSUInteger kDiaryIndex    = 1;
static const NSUInteger kMessageIndex  = 2;
static const NSUInteger kUserInfoIndex = 3;
static const NSUInteger kLogoutIndex   = 4;
static const NSUInteger kAboutIndex    = 5;

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
    self.greatingLabel.text = [NSString stringWithFormat:@"你好，%@!", user.username];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = (NSUInteger)indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (row == kMyPetIndex) {
        UIStoryboard     *storyboard     = [UIStoryboard storyboardWithName:@"MyPet" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [MCDDrawerControllerHelper setCenterViewController:viewController completion:nil];
        return;
    }
    if (row == kDiaryIndex) {
        UIStoryboard     *storyboard     = [UIStoryboard storyboardWithName:@"Diary" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [MCDDrawerControllerHelper setCenterViewController:viewController completion:nil];
        return;
    }
    if (row == kMessageIndex) {
        UIStoryboard     *storyboard     = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [MCDDrawerControllerHelper setCenterViewController:viewController completion:nil];
        return;
    }
    if (row == kUserInfoIndex) {
        UIStoryboard     *storyboard     = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MCDUserInfoContainerViewController"];
        [MCDDrawerControllerHelper setCenterViewController:viewController completion:nil];
        return;
    }
    if (row == kLogoutIndex) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认注销?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"注销"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [[MCDUser currentUser] logout];
                                                              UIStoryboard     *storyboard     = [UIStoryboard storyboardWithName:@"User" bundle:nil];
                                                              UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MCDLoginViewController"];
                                                              [MCDDrawerControllerHelper setCenterViewController:viewController completion:nil];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"还不用"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        return;
    }
    if (row == kAboutIndex) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"欢迎使用萌宠日记.x"
                                                        message:[NSString stringWithFormat:@"当前版本: %@", [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]]
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

@end
