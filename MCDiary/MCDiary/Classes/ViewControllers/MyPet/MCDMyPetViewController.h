//
//  MCDMyMengChongCollectionViewController.h
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDDetailPetViewController.h"
@class MCDMyPetDataModel;

@interface MCDMyPetViewController : UICollectionViewController<MCDDetailPetViewControllerDelegate,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) MCDMyPetDataModel *myPetDataModel;

@end
