//
//  MCCreateDiaryViewController.h
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPlaceHolderTextView.h"
#import "MCDiary.h"
#import "MCShowImageViewController.h"

#define TIPS_LABEL_HEIGHT 15
#define OFFSET 8
#define IMAGE_CELL_SIDECAR 60

@protocol MCCreateDiaryViewControllerDelegate

- (void)setupMCDiary:(MCDiary *) diary;
- (void)removeMCDiary:(MCDiary *) diary;
- (void)reloadTimeLineView;

@end

@interface MCCreateDiaryViewController : UIViewController<UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, MCShowImageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet MCPlaceHolderTextView *contentTextView;
@property (strong, nonatomic) MCDiary *diary;
@property (weak, nonatomic) id<MCCreateDiaryViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL shouldHideDeleteButton;

@end
