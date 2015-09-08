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
    NSMutableArray              *_dataSourceArray;
    NSMutableArray              *_ordinaryEventsIndexPathsArray;
}

@end

@implementation MCDiaryTimeLineViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _diariesTableView.rowHeight = UITableViewAutomaticDimension;
    _diariesTableView.estimatedRowHeight = 100;
    _diariesTableView.dataSource = self;
    _diariesTableView.delegate = self;
    _diariesTableView.backgroundColor = [UIColor whiteColor];
    _diariesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _fullDiariesArray = [NSMutableArray array];
    _filteredDiariesArray = [NSMutableArray array];
    _dataSourceArray = _fullDiariesArray;
    _ordinaryEventsIndexPathsArray = [NSMutableArray array];
    [_eventsSegmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Memory Handler

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UI Responder methods

- (void)segmentedControlValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        _dataSourceArray = _fullDiariesArray;
        [_diariesTableView insertRowsAtIndexPaths:_ordinaryEventsIndexPathsArray withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        _dataSourceArray = _filteredDiariesArray;
        [_diariesTableView deleteRowsAtIndexPaths:_ordinaryEventsIndexPathsArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [_diariesTableView reloadData];
}

#pragma mark - Two top layout guide buttons' responding selectors

- (IBAction)menuButtonTouchUpInside:(id)sender {
    
}

- (IBAction)createButtonTouchUpInside:(id)sender {
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MCDiaryCellIdentifier";
    MCDiary *diary = _dataSourceArray[indexPath.row];
    MCDiaryTableViewCell *cell = (MCDiaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    for (UIView *view in [cell.contentView subviews]) {
//        if (view.tag == 999) {
//            [view removeFromSuperview];
//        }
//    }
    [cell setupCellWithDiary:_dataSourceArray[indexPath.row]];
    CGRect rect = cell.contentView.frame;
    rect.size.width -= 64;
    if (diary.images.count == 0) {
        cell.showImagesCollectionViewHeightConstraint.constant = 0;
        cell.showImagesCollectionView.hidden = YES;
    }else if(diary.images.count == 1) {
        cell.showImagesCollectionViewHeightConstraint.constant = 120;
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 120);
        cell.showImagesCollectionView.frame = rect;
        cell.showImagesCollectionView.contentSize = CGSizeMake(cell.showImagesCollectionView.contentSize.width, 120);
        cell.showImagesCollectionView.hidden = NO;
    }else if(diary.images.count <= 3){
//        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 60);
        cell.showImagesCollectionViewHeightConstraint.constant = 60;
//        cell.showImagesCollectionView.frame = rect;
        cell.showImagesCollectionView.contentSize = CGSizeMake(cell.showImagesCollectionView.contentSize.width, 60);
        cell.showImagesCollectionView.hidden = NO;
    }else if(diary.images.count <= 6){
//        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 120);
        cell.showImagesCollectionViewHeightConstraint.constant = 120;
//        cell.showImagesCollectionView.frame = rect;
        cell.showImagesCollectionView.contentSize = CGSizeMake(cell.showImagesCollectionView.contentSize.width, 120);
        cell.showImagesCollectionView.hidden = NO;
    }else{
//        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 180);
        cell.showImagesCollectionViewHeightConstraint.constant = 180;
//        cell.showImagesCollectionView.frame = rect;
        cell.showImagesCollectionView.contentSize = CGSizeMake(cell.showImagesCollectionView.contentSize.width, 180);
        cell.showImagesCollectionView.hidden = NO;
    }
    cell.showImagesCollectionView.scrollEnabled = NO;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    _createDiaryViewController.diary = _dataSourceArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消日记的选中状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - MCCreateDiaryViewControllerDelegate methods

- (void)setupMCDiary:(MCDiary *) diary {
    if (diary.isBigEvent) {
        [_fullDiariesArray addObject:diary];
        [_filteredDiariesArray addObject:diary];
    }else{
        [_fullDiariesArray addObject:diary];
        [_ordinaryEventsIndexPathsArray addObject:[NSIndexPath indexPathForRow:_fullDiariesArray.count - 1 inSection:0]];
    }
    [_diariesTableView reloadData];
}

- (void)removeMCDiary:(MCDiary *) diary {
    if (diary.isBigEvent) {
        [_fullDiariesArray removeObject:diary];
        [_filteredDiariesArray removeObject:diary];
    }else{
        NSInteger index = [_fullDiariesArray indexOfObjectIdenticalTo:diary];
        if (index == NSNotFound) {
            NSLog(@"Not found");
        }else{
            for (NSIndexPath *indexPath in _ordinaryEventsIndexPathsArray) {
                if (indexPath.row == index && indexPath.section == 0) {
                    [_ordinaryEventsIndexPathsArray removeObject:indexPath];
                    break;
                }
            }
        }
        [_fullDiariesArray removeObject:diary];
    }
    [_diariesTableView reloadData];
}

- (void)reloadTimeLineView {
    [_diariesTableView reloadData];
}

#pragma mark - MCDiaryTableViewCellDelegate methods

- (void)presentImages:(NSArray *)images withStartIndex:(NSInteger)startIndex andStartRect:(CGRect)rect {
    MCPresentImagesViewController *presentImagesViewController = [[UIStoryboard storyboardWithName:@"Diary" bundle:nil] instantiateViewControllerWithIdentifier:@"MCPresentImagesViewController"];
    presentImagesViewController.presentingImages = images;
    presentImagesViewController.startIndex = startIndex;
    presentImagesViewController.rectForAnimation = rect;
    [self.view addSubview:presentImagesViewController.view];
    [self addChildViewController:presentImagesViewController];
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
