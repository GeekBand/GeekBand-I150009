//
//  DiaryTimeLineViewController.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "DiaryTimeLineViewController.h"

@interface DiaryTimeLineViewController ()

@end

@implementation DiaryTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _diariesTableView.rowHeight = UITableViewAutomaticDimension;
    _diariesTableView.estimatedRowHeight = 120;
    _diariesTableView.dataSource = self;
    _diariesTableView.delegate = self;
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
    return 5;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DiaryCellIdentifier";
    DiaryTableViewCell *cell = (DiaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DiaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

#pragma mark - CreateDiaryViewControllerDelegate methods
- (void)setupDiary:(Diary *)diary{
    
}

- (void)removeDiary:(Diary *)diary{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
