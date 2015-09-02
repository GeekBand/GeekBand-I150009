//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import <DLRadioButton/DLRadioButton.h>
#import "MCDRadioFormField.h"

@interface MCDRadioFormField ()

@end

@implementation MCDRadioFormField
{

}

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedIndexChangeSignal = _selectedIndexChangeSignal;

#pragma mark - life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];

    @weakify(self);

    // 2-way bind with selectedIndex and radioButtons
    RACChannelTerminal *selectedIndexTerminal        = RACChannelTo(self, selectedIndex);
    RACChannelTerminal *radioButton1SelectedTerminal = RACChannelTo(self.radioButton1, selected);
    RACChannelTerminal *radioButton2SelectedTerminal = RACChannelTo(self.radioButton2, selected);

    // change selectedIndex when radioButton selected
    RACSignal *foreceSelectRadioButton1Signal = [[radioButton1SelectedTerminal filter:^BOOL(NSNumber *number) {
        return [number boolValue];
    }] map:^id(id value) {
        return @(1);
    }];

    RACSignal *forceSelectRadioButton2Signal = [[radioButton2SelectedTerminal filter:^BOOL(NSNumber *number) {
        return [number boolValue];
    }] map:^id(id value) {
        return @(2);
    }];

    [[RACSignal merge:@[foreceSelectRadioButton1Signal, forceSelectRadioButton2Signal]] subscribe:selectedIndexTerminal];

    // select radioButton when selectedIndex change
    RACSignal *radioButton1SelectedOnSignal = [selectedIndexTerminal map:^id(NSNumber *number) {
        return @([number intValue] == 1);
    }];
    [radioButton1SelectedOnSignal subscribe:radioButton1SelectedTerminal];

    RACSignal *radioButton2SelectedOnSignal = [selectedIndexTerminal map:^id(NSNumber *number) {
        return @([number intValue] == 2);
    }];
    [radioButton2SelectedOnSignal subscribe:radioButton2SelectedTerminal];

//    // uncomment below to test
//    [self.selectedIndexChangeSignal subscribeNext:^(NSNumber *number) {
//        NSLog(@"selected index change to: %d",[number intValue]);
//    }];
//
//    self.selectedIndex = 2;
}


#pragma mark - accessor

- (void)setRadioButton1Text:(NSString *)radioButton1Text
{
    _radioButton1Text = radioButton1Text;
    [self.radioButton1 setTitle:_radioButton1Text forState:UIControlStateNormal];
}

- (void)setRadioButton2Text:(NSString *)radioButton2Text
{
    _radioButton2Text = radioButton2Text;
    [self.radioButton2 setTitle:_radioButton2Text forState:UIControlStateNormal];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = _titleText;
}

- (RACSignal *)selectedIndexChangeSignal
{
    if (!_selectedIndexChangeSignal) {
        _selectedIndexChangeSignal = RACObserve(self, selectedIndex);
    }
    return _selectedIndexChangeSignal;
}

#pragma mark - public

#pragma mark - private

@end