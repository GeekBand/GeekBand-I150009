//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDAreaPickerViewModel.h"
#import "MCDUser.h"
#import "MCDUserLocation.h"
#import "MCDUserLocationHelper.h"

@interface MCDAreaPickerViewModel ()


@end

@implementation MCDAreaPickerViewModel
{
}

#pragma mark - public

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [MCDUser currentUser];
        _provinceList     = [[MCDUserLocationHelper sharedHelper] provinceList];
        _provinceIndex    = self.user.location.provinceIndex;
        _cityIndex        = self.user.location.cityIndex;
        _areaIndex        = self.user.location.areaIndex;
        _initialSelection = @[@(_provinceIndex), @(_cityIndex), @(_areaIndex)];
    }

    return
        self;
}

#pragma mark - accessor

#pragma mark - private

- (NSArray *)getCityList
{
    return _provinceList[self.provinceIndex][@"cities"];
}

- (NSArray *)getAreaList
{
    NSArray *cityList = [self getCityList];
    return cityList[self.cityIndex][@"areas"];
}

#pragma mark - Delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.provinceList.count;
        case 1:
            return [self getCityList].count;
        case 2:
            if ([self getAreaList].count == 0)
                return 1;
            return [self getAreaList].count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSUInteger urow = (NSUInteger)row;
    switch (component) {
        case 0:
            return self.provinceList[urow][@"state"];
        case 1:
            return [self getCityList][urow][@"city"];
        case 2:
            if ([self getAreaList].count == 0)
                return @"";
            return [self getAreaList][urow];
        default:
            return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger urow = (NSUInteger)row;
    switch (component) {
        case 0:
            self.provinceIndex = urow;
            self.cityIndex     = 0;
            self.areaIndex     = 0;
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            self.cityIndex = urow;
            self.areaIndex = 0;
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            break;
        case 2:
            self.areaIndex = urow;
            break;
        default:
            break;
    }

    self.initialSelection = @[
        @(self.provinceIndex),
        @(self.cityIndex),
        @(self.areaIndex),
    ];
}

@end