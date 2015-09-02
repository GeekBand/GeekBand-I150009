//
// Created by zzdjk6 on 15/9/3.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseViewModel.h"

@interface MCDUserModifyPasswordViewModel : MCDBaseViewModel

@property(nonatomic, copy) NSString *oldPassword;
@property(nonatomic, copy) NSString *freshPassword;
@property(nonatomic, copy) NSString *confirmPassword;

@property(nonatomic, assign) BOOL oldPasswordValid;
@property(nonatomic, assign) BOOL freshPasswordValid;
@property(nonatomic, assign) BOOL confirmPasswordValid;
@property(nonatomic, assign) BOOL success;

@property(nonatomic, strong, readonly) RACSignal *successSignal;
@property(nonatomic, strong, readonly) RACSignal *oldPasswordvalidSignal;
@property(nonatomic, strong, readonly) RACSignal *freshPasswordvalidSignal;
@property(nonatomic, strong, readonly) RACSignal *confirmPasswordvalidSignal;

@property(nonatomic, copy, readonly) NSString *oldPasswordTitleError;
@property(nonatomic, copy, readonly) NSString *freshPasswordTitleError;
@property(nonatomic, copy, readonly) NSString *confirmPasswordTitleError;

@property(nonatomic, copy, readonly) NSString *oldPasswordTitleNormal;
@property(nonatomic, copy, readonly) NSString *freshPasswordTitleNormal;
@property(nonatomic, copy, readonly) NSString *confirmPasswordTitleNormal;

- (void)changePassword;

@end