//
//  MCDMyPetDataModel.h
//  MCDiary
//
//  Created by zero on 15/8/30.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDMyPetDataModel : NSObject

@property(nonatomic, strong)NSMutableArray *petList;

- (void)savePetList;

@end
