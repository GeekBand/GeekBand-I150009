//
//  MCDMyPetDetails.m
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDMyPet.h"

@implementation MCDMyPet

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.image = [aDecoder decodeObjectForKey:@"Image"];
        self.nickName = [aDecoder decodeObjectForKey:@"NickName"];
        self.birthday = [aDecoder decodeObjectForKey:@"Birthday"];
        self.variety = [aDecoder decodeObjectForKey:@"Variety"];
        self.height = [aDecoder decodeObjectForKey:@"Height"];
        self.weight = [aDecoder decodeObjectForKey:@"Weight"];
        
        self.gender = [aDecoder decodeIntegerForKey:@"Gender"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.image forKey:@"Image"];
    [aCoder encodeObject:self.nickName forKey:@"NickName"];
    [aCoder encodeObject:self.birthday forKey:@"Birthday"];
    [aCoder encodeObject:self.variety forKey:@"Variety"];
    [aCoder encodeObject:self.height forKey:@"Height"];
    [aCoder encodeObject:self.weight forKey:@"Weight"];
    
    [aCoder encodeInteger:self.gender forKey:@"Gender"];
}

@end
