//
//  MCDMyPetDataModel.m
//  MCDiary
//
//  Created by zero on 15/8/30.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDMyPetDataModel.h"

@implementation MCDMyPetDataModel


- (id)init{
    self = [super init];
    if (self) {
        [self loadPetList];
    }
    return self;
}

- (NSString*)dataFilePath{
    NSString *fullPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
    if ([paths count] > 0) {
        NSString *documentsDirectory = [paths firstObject];
        fullPath = [documentsDirectory stringByAppendingPathComponent:@"MyPetList.plist"];
    }
    return fullPath;
}

- (void)savePetList{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.petList forKey:@"MyPetList"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadPetList{
    NSString *path = [self dataFilePath];
    NSLog(@"读取文件的路径是：%@",[self dataFilePath]);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.petList = [unarchiver decodeObjectForKey:@"MyPetList"];
        [unarchiver finishDecoding];
    }else{
        self.petList = [[NSMutableArray alloc] init];
    }
}

@end
