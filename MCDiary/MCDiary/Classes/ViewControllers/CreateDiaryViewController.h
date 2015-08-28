//
//  CreateDiaryViewController.h
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "Diary.h"

#define TIPS_LABEL_HEIGHT 15
#define OFFSET 8

@protocol CreateDiaryViewControllerDelegate

- (void)setupDiary:(Diary *) diary;
- (void)removeDiary:(Diary *) diary;

@end

@interface CreateDiaryViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (strong, nonatomic) Diary *diary;
@property (weak, nonatomic) id<CreateDiaryViewControllerDelegate> delegate;

@end
