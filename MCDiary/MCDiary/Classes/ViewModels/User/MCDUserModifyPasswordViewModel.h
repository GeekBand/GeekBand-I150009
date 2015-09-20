//
// Created by zzdjk6 on 15/9/3.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//


#import "MCDBaseViewModel.h"

@class MCDUserModifyPasswordViewModel;

@protocol MCDUserModifyPasswordViewModelDelegate

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel changePasswordSuccess:(BOOL)success;

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel changePasswordFailed:(NSError *)error;

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel sendForgotPasswordEmailSuccess:(BOOL)success;

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel sendForgotPasswordEmailFailed:(NSError *)error;

@end

@interface MCDUserModifyPasswordViewModel : MCDBaseViewModel

@property(nonatomic, weak) id <MCDUserModifyPasswordViewModelDelegate> delegate;

@property(nonatomic, copy) NSString *oldPassword;
@property(nonatomic, copy) NSString *freshPassword;
@property(nonatomic, copy) NSString *confirmPassword;

@property(nonatomic, assign) BOOL oldPasswordValid;
@property(nonatomic, assign) BOOL freshPasswordValid;
@property(nonatomic, assign) BOOL confirmPasswordValid;

@property(nonatomic, strong, readonly) RACSignal *oldPasswordvalidSignal;
@property(nonatomic, strong, readonly) RACSignal *freshPasswordvalidSignal;
@property(nonatomic, strong, readonly) RACSignal *confirmPasswordvalidSignal;

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