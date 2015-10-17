//
//  MCDMessageTableViewController.m
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDMessageTableViewController.h"
#import "MCDMessageViewModel.h"
#import "MCDDrawerControllerHelper.h"
#import "MCDMessageTableViewCell.h"
#import "MCDMessageModel.h"
#import "Masonry.h"
#import "NSDate+DateTools.h"
#import "MCDWebViewController.h"

@interface IZMessageTableViewController () <IZMessageViewModelDelegate>

@property (strong, nonatomic) IZMessageViewModel *viewModel;
@property (strong, nonatomic) NSArray *messageList;

- (IBAction)showMessageOption:(UIBarButtonItem *)sender;

@end

@implementation IZMessageTableViewController

#pragma mark - Lifecycle Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [IZMessageViewModel viewModel];
    self.viewModel.delegate = self;
    [self.viewModel showMeData];
    [self bindViewModel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.viewModel archiveMessageList];
}

- (void)bindViewModel {
    
    self.messageList = self.viewModel.messageList;
}

#pragma mark - Custom Delegate Methods
- (void)reloadDataWithViewModel:(IZMessageViewModel *)viewModel {
    
    [self bindViewModel];
    [self.tableView reloadData];
}

- (void)showErrorMessage:(NSString *)msg {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showWaitingSpinner {
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];

    self.spinner.hidesWhenStopped = YES;
    [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view).centerOffset(CGPointMake(0, -100));
    }];

    [self.spinner startAnimating];
}

- (void)dismissWaitingSpinner {
    
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [self.messageList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCDMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IZMessageTableViewCell" forIndexPath:indexPath];
    MCDMessageModel *message = self.messageList[[indexPath row]];
    cell.messageLabel.text = message.messageTitle;
    cell.timeLabel.text = [[NSDate dateWithString:message.publishDate formatString:@"YYYY-MM-dd HH:mm"] timeAgoSinceNow];
    cell.isReadStatusImageView.image = [UIImage imageNamed:message.isReadStatus ? @"completed" : @"unCompleted"];
    
    return cell;
}


#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCDMessageTableViewCell *cell = (MCDMessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isReadStatusImageView.image = [UIImage imageNamed:@"completed"];
    
    MCDMessageModel *message =  self.viewModel.messageList[indexPath.row];
    message.isReadStatus = YES;
    
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
                                                                    [self.viewModel markAllMessageAsHaveRead];
                                                                }];
    UIAlertAction *markAllAsUnreadAction = [UIAlertAction actionWithTitle:@"标记全部消息为未读"
                                                                    style:  UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                    [self.viewModel markAllMessageAsHaveNotRead];
                                                                  }];
    
    [alert addAction:markAllAsReadAction];
    [alert addAction:markAllAsUnreadAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)showMenu:(UIBarButtonItem *)sender {
    
    [MCDDrawerControllerHelper openDrawer];
}

#pragma mark - Navgation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        MCDWebViewController *webVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MCDMessageModel *message = self.messageList[indexPath.row];
        
        NSURL *url = message.url;
        webVC.url = url;
    }
}

@end
