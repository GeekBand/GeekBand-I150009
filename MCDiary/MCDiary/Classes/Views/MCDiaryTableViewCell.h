//
//  MCDiaryTableViewCell.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDiaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *MCDiaryImagesScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MCDiaryImagesScrollViewHeightConstraint;

@end
