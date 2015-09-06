//
//  MCDiaryTimeLineViewController.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDiaryTableViewCell.h"
#import "MCCreateDiaryViewController.h"

@interface MCDiaryTimeLineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MCCreateDiaryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *diariesTableView;
@property (strong, nonatomic) NSMutableArray *fullDiariesArray;
@property (strong, nonatomic) NSMutableArray *filteredDiariesArray;

@end
