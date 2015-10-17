//
//  MCDMessageTableViewCell.h
//  MCDiary
//
//  Created by Liang Zisheng on 9/8/15.
//  Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isReadStatusImageView;

@end
