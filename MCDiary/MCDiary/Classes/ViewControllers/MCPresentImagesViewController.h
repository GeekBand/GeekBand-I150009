//
//  MCPresentImagesViewController.h
//  MCDiary
//
//  Created by Turtleeeeeeeeee on 15/9/8.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

//该类用以时间轴上的图片点击后放大展示

#import <UIKit/UIKit.h>

@interface MCPresentImagesViewController : UIViewController<UIScrollViewDelegate>{
    NSMutableArray          *_presentingImageViews;
}

@property (weak, nonatomic) IBOutlet UIScrollView   *presentImagesScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl  *imagesPageControl;
@property (strong, nonatomic) NSArray               *presentingImages;
@property (assign, nonatomic) NSInteger              startIndex;
@property (assign, nonatomic) CGRect                 rectForAnimation;
//@property (strong, nonatomic) NSArray *fullImagesAddresses;  //大图地址

@end
