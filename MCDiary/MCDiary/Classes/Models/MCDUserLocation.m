//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserLocation.h"

@interface MCDUserLocation ()

@end

@implementation MCDUserLocation
{

}

#pragma mark - life cycle

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.provinceIndex forKey:@"provinceIndex"];
    [coder encodeInteger:self.cityIndex forKey:@"cityIndex"];
    [coder encodeInteger:self.areaIndex forKey:@"areaIndex"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if(self){
        self.provinceIndex = (NSUInteger)[coder decodeIntegerForKey:@"provinceIndex"];
        self.cityIndex = (NSUInteger)[coder decodeIntegerForKey:@"cityIndex"];
        self.areaIndex = (NSUInteger)[coder decodeIntegerForKey:@"areaIndex"];
    }
    return self;
}

#pragma mark - accessor

#pragma mark - public

#pragma mark - private

@end