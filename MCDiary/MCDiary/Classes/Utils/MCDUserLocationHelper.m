//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserLocationHelper.h"

@interface MCDUserLocationHelper ()

@end

@implementation MCDUserLocationHelper
{

}

#pragma mark - public

+ (MCDUserLocationHelper *)sharedHelper
{
    static MCDUserLocationHelper *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (NSString *)getLocationStringByProvinceIndex:(NSUInteger)provinceIndex
                                     cityIndex:(NSUInteger)cityIndex
                                     areaIndex:(NSUInteger)areaIndex
{
    NSArray *cityList = _provinceList[provinceIndex][@"cities"];
    NSArray *areaList = cityList[cityIndex][@"areas"];

    NSString *province = _provinceList[provinceIndex][@"state"];
    NSString *city     = cityList[cityIndex][@"city"];

    NSString *area = @"";
    if (areaList.count > 0)
        area = areaList[areaIndex];

    return [NSString stringWithFormat:
                         @"%@ %@ %@",
                         province,
                         city,
                         area
    ];
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _provinceList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"]];
    }

    return
        self;
}

#pragma mark - private

@end