//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDAreaPickerViewModel.h"

@interface MCDAreaPickerViewModel ()


@end

@implementation MCDAreaPickerViewModel
{
}

#pragma mark - life cycle

#pragma mark - accessor

#pragma mark - public

- (NSArray *)getCityList
{
    return _provinceList[self.provinceIndex][@"cities"];
}

- (NSArray *)getAreaList
{
    NSArray *cityList = [self getCityList];
    return cityList[self.cityIndex][@"areas"];
}

#pragma mark - private

#pragma mark - Delegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _provinceList  = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"]];
        _provinceIndex = 0;
        _cityIndex     = 0;
        _areaIndex     = 0;
    }

    return
        self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch(component){
        case 0:
            return self.provinceList.count;
        case 1:
            return [self getCityList].count;
        case 2:
            return [self getAreaList].count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSUInteger urow = (NSUInteger)row;
    switch(component){
        case 0:
            return self.provinceList[urow][@"state"];
        case 1:
            return [self getCityList][urow][@"city"];
        case 2:
            return [self getAreaList][urow];
        default:
            return @"NULL";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger urow = (NSUInteger)row;
    switch(component){
        case 0:
            self.provinceIndex = urow;
            self.cityIndex = 0;
            self.areaIndex = 0;
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
        default:break;
    }
}

@end