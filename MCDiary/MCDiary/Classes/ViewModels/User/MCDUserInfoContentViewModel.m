//
// Created by zzdjk6 on 15/9/1.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserInfoContentViewModel.h"
#import "MCDUser.h"
#import "MCDUserLocation.h"
#import "NSDate+DateTools.h"
#import "MCDAreaPickerViewModel.h"
#import "MCDUserLocationHelper.h"
#import "MCDCloudUserInfo.h"

@interface MCDUserInfoContentViewModel ()

@property(nonatomic, assign) BOOL basicInfoSaved;
@property(nonatomic, assign) BOOL extraInfoSaved;

@end

@implementation MCDUserInfoContentViewModel
{

}

@synthesize allInfoSavedSignal = _allInfoSavedSignal;
@synthesize infoSaveFailedSignal = _infoSaveFailedSignal;
@synthesize avatarUploadFaieldSignal = _avatarUploadFaieldSignal;
@synthesize avatarUploadSuccessSignal = _avatarUploadSuccessSignal;

#pragma mark - public

- (void)validateAndSave
{
    self.basicInfoSaved = NO;
    self.extraInfoSaved = NO;

    // 邮箱初步验证
    NSString *emailError = [MCDUser errorStringForEmail:self.email];
    if (emailError) {
        _emailErrorTitle = emailError;
        self.emailValid = NO;
        [self infoSaveFailed:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : @"邮箱格式错误"}]];
        return;
    } else {
        self.emailValid = YES;
    }

    @weakify(self);

    // 邮箱保存
    if (self.emailValid && self.email != nil && ![self.email isEqualToString:@""]) {
        AVUser *avUser = [AVUser currentUser];
        avUser.email = self.email;
        [avUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            @strongify(self);
            if (succeeded) {
                self.user.email     = self.email;
                self.basicInfoSaved = YES;
            } else {
                DDLogVerbose(@"%@", error);
                [self infoSaveFailed:error];
            }
        }];
    }

    // 其他字段
    AVQuery *query = [MCDCloudUserInfo query];
    [query whereKey:@"userId" equalTo:self.user.userId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        @strongify(self);
        if (error != nil) {
            DDLogVerbose(@"%@", error);
            return;
        }

        MCDCloudUserInfo *userInfo = (MCDCloudUserInfo *)object;
        userInfo.gender        = @(self.gender);
        userInfo.birthday      = self.birthday;
        userInfo.provinceIndex = @(self.location.provinceIndex);
        userInfo.cityIndex     = @(self.location.cityIndex);
        userInfo.areaIndex     = @(self.location.areaIndex);

        [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                DDLogVerbose(@"%@", error);
                [self infoSaveFailed:error];
                return;
            }

            self.user.gender   = self.gender;
            self.user.birthday = self.birthday;
            self.user.location = self.location;

            self.extraInfoSaved = YES;
        }];
    }];

    // 头像单独处理
}

- (void)uploadAvatar
{
    AVFile *file = [AVFile fileWithName:self.user.userId
                                   data:UIImagePNGRepresentation(self.avatarImage)];

    __weak typeof(file) weakFile = file;
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self avatarUploadFaield:error];
            return;
        }

        AVQuery *query = [MCDCloudUserInfo query];
        [query whereKey:@"userId" equalTo:self.user.userId];
        MCDCloudUserInfo *userInfo = (MCDCloudUserInfo *)[query getFirstObject];
        userInfo.avatarImageFile = weakFile;
        [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self avatarUploadFaield:error];
                return;
            }
            [self avatarUploadSuccess];
        }];
    }];
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始值
        self.user            = [MCDUser currentUser];
        self.pickerViewModel = [[MCDAreaPickerViewModel alloc] init];
        self.emailValid      = YES;

        self.username    = self.user.username;
        self.email       = self.user.email;
        self.gender      = self.user.gender;
        self.location    = self.user.location;
        self.birthday    = self.user.birthday;
        self.avatarImage = self.user.avatarImage;

        // Binding
        [self initBinding];
    }

    return self;
}


#pragma mark - accessor

- (NSString *)emailNormalTitle
{
    return @"邮箱（可选，仅用于找回密码）";
}

#pragma mark - private

- (void)initBinding
{
    RAC(self, birthdayString) = [RACObserve(self, birthday) map:^id(NSDate *date) {
        return [NSString stringWithFormat:
                             @"%ld年 %ld月 %ld日",
                             (long)date.year,
                             (long)date.month,
                             (long)date.day
        ];
    }];

    RAC(self, locationString) = [RACObserve(self.pickerViewModel, initialSelection) map:^id(NSArray *selection) {
        MCDUserLocationHelper *locationHelper = [MCDUserLocationHelper sharedHelper];
        NSString              *string         = [locationHelper getLocationStringByProvinceIndex:[selection[0] unsignedIntegerValue]
                                                                                       cityIndex:[selection[1] unsignedIntegerValue]
                                                                                       areaIndex:[selection[2] unsignedIntegerValue]
        ];
        return string;
    }];

    RAC(self, location) = [RACObserve(self.pickerViewModel, initialSelection) map:^id(NSArray *selection) {

        MCDUserLocation *location = [[MCDUserLocation alloc] init];
        location.provinceIndex = [selection[0] unsignedIntegerValue];
        location.cityIndex     = [selection[1] unsignedIntegerValue];
        location.areaIndex     = [selection[2] unsignedIntegerValue];
        return location;
    }];

    // 仅在全部保存成功的时候发送此信号
    _allInfoSavedSignal = [[RACSignal
        combineLatest:@[
            RACObserve(self, basicInfoSaved),
            RACObserve(self, extraInfoSaved)]
               reduce:^id(NSNumber *basicFlag, NSNumber *extraFlag) {
                   return @([basicFlag boolValue] && [extraFlag boolValue]);
               }]
        filter:^BOOL(NSNumber *flag) {
            return [flag boolValue];
        }];

    _infoSaveFailedSignal = [[self rac_signalForSelector:@selector(infoSaveFailed:)] map:^NSError *(RACTuple *tuple) {
        return tuple.first;
    }];

    _avatarUploadSuccessSignal = [self rac_signalForSelector:@selector(avatarUploadSuccess)];
    _avatarUploadFaieldSignal  = [[self rac_signalForSelector:@selector(avatarUploadFaield:)] map:^NSError *(RACTuple *tuple) {
        return tuple.first;
    }];
}

- (void)infoSaveFailed:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

- (void)avatarUploadFaield:(NSError *)error
{
    DDLogVerbose(@"%@", error);
}

- (void)avatarUploadSuccess
{
    DDLogVerbosePrettyFunction;
}

@end