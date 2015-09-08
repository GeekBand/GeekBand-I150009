//
//  MCDiaryTableViewCell.m
//  MCDiary
//
//  Created by Turtle on 15/8/26.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDiaryTableViewCell.h"

@implementation MCDiaryTableViewCell

#pragma mark - initialize methods

- (void)setupCellWithDiary:(MCDiary *)diary {
    _diary = diary;
    if (diary.isBigEvent) {
//        _tagImageView.image = [UIImage imageNamed:@""];
        _tagImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:126/255.0 blue:74/255.0 alpha:1.0];
    }else{
//        _tagImageView.image = [UIImage imageNamed:@""];
        _tagImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:199/255.0 blue:140/255.0 alpha:1.0];
    }
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake( 40, 0, 1, 500)];
    [grayLineView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    grayLineView.tag = 999;
    [self.contentView insertSubview:grayLineView belowSubview:_tagImageView];
    _timeLabel.text = [self dateStringFromADate:diary.createTime];
    _titleLabel.text = diary.title;
    _contentLabel.text = diary.content;
    [_showImagesCollectionView reloadData];
}

- (NSString *)dateStringFromADate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.ddHH:mm";
    return [formatter stringFromDate:date];
}

#pragma mark - UIView life cycle

- (void)awakeFromNib {
    // Initialization code
    _showImagesCollectionView.delegate = self;
    _showImagesCollectionView.dataSource = self;
}

#pragma mark - UIResponder methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _diary.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *showImageCellIdentifier = @"ShowImageCellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showImageCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIDECAR_ONEIMAGE, SIDECAR_ONEIMAGE)];
    imageView.image = _diary.images[indexPath.item];
    [cell.contentView addSubview:imageView];
    CGRect newFrame = [self convertRect:cell.frame toView:nil];
    NSLog(@"%@", NSStringFromCGRect(newFrame));
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_diary.images.count == 0) {
        return CGSizeZero;
    }else if(_diary.images.count == 1){
        return CGSizeMake(SIDECAR_ONEIMAGE, SIDECAR_ONEIMAGE);
    }else{
        return CGSizeMake(50, 50);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (_diary.images.count == 0) {
        return UIEdgeInsetsZero;
    }else if (_diary.images.count == 1){
        return UIEdgeInsetsMake(10, 10, 10, 50);
    }else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_showImagesCollectionView cellForItemAtIndexPath:indexPath];
    CGRect startRect = [self convertRect:cell.frame toView:nil];
    [_delegate presentImages:[_diary.images copy] withStartIndex:indexPath.item andStartRect: startRect];
}

@end
