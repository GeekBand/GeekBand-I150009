//
//  DiaryTimeLineViewController.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryTableViewCell.h"
#import "CreateDiaryViewController.h"

@interface DiaryTimeLineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CreateDiaryViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *diariesTableView;

@end
