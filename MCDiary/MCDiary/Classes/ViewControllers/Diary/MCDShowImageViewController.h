//
//  MCDShowImageViewController.h
//  MCDiary
//
//  Created by Turtleeeeeeeeee on 15/9/6.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

//该类用以在创建日记的图片点击后放大

#import <UIKit/UIKit.h>

@protocol MCDShowImageViewControllerDelegate

- (void)deleteImage:(UIImage *)image;

@end

@interface MCDShowImageViewController : UIViewController

@property (strong, nonatomic)UIImage *imageToShow;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic)id<MCDShowImageViewControllerDelegate> delegate;

@end
