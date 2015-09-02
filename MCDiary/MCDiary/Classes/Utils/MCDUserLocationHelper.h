//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


@interface MCDUserLocationHelper : NSObject

@property(nonatomic, strong, readonly) NSArray *provinceList;

+ (MCDUserLocationHelper *)sharedHelper;

- (NSString *)getLocationStringByProvinceIndex:(NSUInteger)provinceIndex
                                     cityIndex:(NSUInteger)cityIndex
                                     areaIndex:(NSUInteger)areaIndex;

@end