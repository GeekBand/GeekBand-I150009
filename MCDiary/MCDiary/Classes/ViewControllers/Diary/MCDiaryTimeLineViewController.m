//
//  MCDiaryTimeLineViewController.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDiaryTimeLineViewController.h"

@interface MCDiaryTimeLineViewController (){
    MCCreateDiaryViewController *_createDiaryViewController;
}

@end

@implementation MCDiaryTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _diariesTableView.rowHeight = UITableViewAutomaticDimension;
    _diariesTableView.estimatedRowHeight = 100;
    _diariesTableView.dataSource = self;
    _diariesTableView.delegate = self;
    _diariesTableView.backgroundColor = [UIColor whiteColor];
    _diariesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _diaries = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Two top layout guide buttons' responding selectors

- (IBAction)menuButtonTouchUpInside:(id)sender {
    
}

- (IBAction)createButtonTouchUpInside:(id)sender {
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _diaries.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MCDiaryCellIdentifier";
    MCDiaryTableViewCell *cell = (MCDiaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MCDiaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setupCellWithDiary:_diaries[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    _createDiaryViewController.diary = _diaries[indexPath.row];
}

#pragma mark - MCCreateDiaryViewControllerDelegate methods

- (void)setupMCDiary:(MCDiary *) diary {
    [_diaries addObject:diary];
    [_diariesTableView reloadData];
}

- (void)removeMCDiary:(MCDiary *) diary {
    [_diaries removeObject:diary];
    [_diariesTableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _createDiaryViewController = (MCCreateDiaryViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"AddMCDiarySegue"]) {
        _createDiaryViewController.diary = nil;
        //hide delete button
        _createDiaryViewController.shouldHideDeleteButton = YES;
    }
    
    if ([segue.identifier isEqualToString:@"EditMCDiarySegue"]) {
        //show delete button
        _createDiaryViewController.shouldHideDeleteButton = NO;
    }
    _createDiaryViewController.delegate = self;
}

@end
