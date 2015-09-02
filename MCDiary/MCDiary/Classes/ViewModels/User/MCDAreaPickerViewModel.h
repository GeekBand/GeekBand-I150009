//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "ActionSheetCustomPickerDelegate.h"

@class MCDUser;

@interface MCDAreaPickerViewModel : NSObject <ActionSheetCustomPickerDelegate>

@property(nonatomic, strong) MCDUser *user;

@property(nonatomic, strong, readonly) NSArray *provinceList;
@property(nonatomic, assign) NSUInteger        provinceIndex;
@property(nonatomic, assign) NSUInteger        cityIndex;
@property(nonatomic, assign) NSUInteger        areaIndex;

@property(nonatomic, strong) NSArray *initialSelection;
@end