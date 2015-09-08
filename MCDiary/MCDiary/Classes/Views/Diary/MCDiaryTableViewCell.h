//
//  MCDiaryTableViewCell.h
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDiary.h"

#define SIDECAR_ONEIMAGE 100

@protocol MCDiaryTableViewCellDelegate

- (void)presentImages:(NSArray *)images withStartIndex:(NSInteger)startIndex andStartRect:(CGRect)rect;

@end

@interface MCDiaryTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    MCDiary *_diary;
}

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *showImagesCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImagesCollectionViewHeightConstraint;
@property (weak, nonatomic) id<MCDiaryTableViewCellDelegate> delegate;

- (void)setupCellWithDiary:(MCDiary *) diary;

@end
