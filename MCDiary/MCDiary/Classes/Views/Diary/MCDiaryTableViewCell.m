//
//  MCDiaryTableViewCell.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDiaryTableViewCell.h"

@implementation MCDiaryTableViewCell

- (void)setupCellWithDiary:(MCDiary *)diary {
    if (diary.isBigEvent) {
        _tagImageView.image = [UIImage imageNamed:@""];
    }else{
        _tagImageView.image = [UIImage imageNamed:@""];
    }
    _timeLabel.text = [self dateStringFromADate:diary.createTime];
    _titleLabel.text = diary.title;
    _contentLabel.text = diary.content;
    if (diary.images == nil || diary.images.count == 0) {
        _MCDiaryImagesScrollView.hidden = YES;
        _MCDiaryImagesScrollViewHeightConstraint.constant = 0;
    }else{
        _MCDiaryImagesScrollView.hidden = NO;
        _MCDiaryImagesScrollViewHeightConstraint.constant = 50;
    }
}

- (NSString *)dateStringFromADate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.ddHH:mm";
    return [formatter stringFromDate:date];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
