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

@property(nonatomic, strong, readonly) RACSignal *oldPasswordValidSignal;
@property(nonatomic, strong, readonly) RACSignal *freshPasswordValidSignal;
@property(nonatomic, strong, readonly) RACSignal *confirmPasswordValidSignal;
@property(nonatomic, strong, readonly) RACSignal *changePasswordSuccessSignal;
@property(nonatomic, strong, readonly) RACSignal *changePasswordFailedSignal;
@property(nonatomic, strong, readonly) RACSignal *sendForgotPasswordEmailSuccessSignal;
@property(nonatomic, strong, readonly) RACSignal *sendForgotPasswordEmailFailedSignal;

@property(nonatomic, copy, readonly) NSString *oldPasswordTitleError;
@property(nonatomic, copy, readonly) NSString *freshPasswordTitleError;
@property(nonatomic, copy, readonly) NSString *confirmPasswordTitleError;

@property(nonatomic, copy, readonly) NSString *oldPasswordTitleNormal;
@property(nonatomic, copy, readonly) NSString *freshPasswordTitleNormal;
@property(nonatomic, copy, readonly) NSString *confirmPasswordTitleNormal;

@property(nonatomic, assign) BOOL sendingRequest;

- (void)changePassword;

- (void)sendForgetPasswordRequestWithEmail:(NSString *)email;
@end