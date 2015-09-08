//
//  IZMessageTableViewController.m
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "IZMessageTableViewController.h"
#import "IZMessageViewModel.h"

@interface IZMessageTableViewController ()

@property (strong, nonatomic) IZMessageViewModel *viewModel;

- (IBAction)showMessageOption:(UIBarButtonItem *)sender;

@end

@implementation IZMessageTableViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[IZMessageViewModel alloc] init];
    [self bindViewModel];
}

- (void)bindViewModel {
    ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.viewModel.messagesList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IZMessageTableViewCell" forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBAction
- (IBAction)showMessageOption:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction *markAllAsReadAction = [UIAlertAction actionWithTitle:@"标记全部消息为已读"
                                                                  style: UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    
                                                                }];
    UIAlertAction *markAllAsUnreadAction = [UIAlertAction actionWithTitle:@"标记全部消息为未读"
                                                                    style:  UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      
                                                                  }];
    
    [alert addAction:markAllAsReadAction];
    [alert addAction:markAllAsUnreadAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
