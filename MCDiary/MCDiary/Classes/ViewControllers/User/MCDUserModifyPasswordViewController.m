//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserModifyPasswordViewController.h"
#import "MCDiaryKit.h"
#import "MCDUserModifyPasswordViewModel.h"

@interface MCDUserModifyPasswordViewController ()

@property(nonatomic, weak) IBOutlet MCDTextFormField *oldPasswordField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *freshPasswordField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *confirmPasswordField;
@property(nonatomic, weak) IBOutlet MCDButtonView    *confirmChangePasswordButton;
@property(nonatomic, weak) IBOutlet UIButton         *forgetPasswordButton;
@property(nonatomic, weak) IBOutlet UIButton         *backgroundButton;

@property(nonatomic, weak) UITextField *activeField;

@end

@implementation MCDUserModifyPasswordViewController
{

}

@synthesize viewModel = _viewModel;

#pragma mark - public

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[MCDUserModifyPasswordViewModel alloc] init];

    [self initBinding];
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

#pragma mark - accessor

#pragma mark - private

- (void)initBinding
{
    @weakify(self);

    // 原密码
    [self.viewModel.oldPasswordvalidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.oldPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.oldPasswordField.titleText = flag ?
            self.viewModel.oldPasswordTitleNormal :
            self.viewModel.oldPasswordTitleError;
    }];

    // 新密码
    [self.viewModel.freshPasswordvalidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.freshPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.freshPasswordField.titleText = flag ?
            self.viewModel.freshPasswordTitleNormal :
            self.viewModel.freshPasswordTitleError;
    }];

    // 确认新密码
    [self.viewModel.confirmPasswordvalidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.confirmPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.confirmPasswordField.titleText = flag ?
            self.viewModel.confirmPasswordTitleNormal :
            self.viewModel.confirmPasswordTitleError;
    }];

    // 忘记密码按钮
    [[self.forgetPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
//            @strongify(self);
            DDLogVerbosePrettyFunction;
        }
    ];

    // 更改密码按钮
    [self.confirmChangePasswordButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activeField resignFirstResponder];
        self.viewModel.oldPassword     = self.oldPasswordField.textField.text;
        self.viewModel.freshPassword   = self.freshPasswordField.textField.text;
        self.viewModel.confirmPassword = self.confirmPasswordField.textField.text;
        [self.viewModel changePassword];
    }];

    // 修改成功
    [self.viewModel.successSignal subscribeNext:^(id x) {
        @strongify(self);
        DDLogVerbosePrettyFunction;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    // activeField
    [[RACSignal merge:@[
        self.oldPasswordField.textFieldBeginEditingSignal,
        self.freshPasswordField.textFieldBeginEditingSignal,
        self.confirmPasswordField.textFieldBeginEditingSignal
    ]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.activeField = tuple.first;
    }];

    // 点击空白消失
    [[self.backgroundButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end