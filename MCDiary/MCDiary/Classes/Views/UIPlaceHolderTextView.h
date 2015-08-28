//
//  UIPlaceHolderTextView.h
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

//implements this class in order to make a text view, which has a place holder.
@interface UIPlaceHolderTextView : UITextView

@property(nonatomic, strong)UILabel *placeHolderLabel;
@property(nonatomic, copy)NSString  *placeHolder;
@property(nonatomic, strong)UIColor *placeHolderColor;

@end
