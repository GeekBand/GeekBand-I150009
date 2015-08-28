//
//  DiaryTableViewCell.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *diaryImagesScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryImagesScrollViewHeightConstraint;

@end
