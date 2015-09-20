//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserModifyPasswordViewController.h"
#import "MCDiaryKit.h"
#import "MCDUserModifyPasswordViewModel.h"
#import "MCDUser.h"

@interface MCDUserModifyPasswordViewController () <MCDUserModifyPasswordViewModelDelegate>

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
    self.viewModel          = [[MCDUserModifyPasswordViewModel alloc] init];
    self.viewModel.delegate = self;

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

    [RACObserve(self.viewModel, sendingRequest) subscribeNext:^(NSNumber *flagNumber) {
        if ([flagNumber boolValue]) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

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
            @strongify(self);
            [self popupForgetPasswordAlert];
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

- (void)popupForgetPasswordAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"忘记密码"
                                                                   message:@"请输入邮箱"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"找回密码"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              UITextField *field = alert.textFields[0];
                                                              [self.viewModel sendForgetPasswordRequestWithEmail:field.text];
                                                          }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [alert dismissViewControllerAnimated:YES
                                                                                        completion:nil];
                                                          }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [MCDUser currentUser].email;
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MCDUserModifyPasswordViewModelDelegate

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel
                 changePasswordSuccess:(BOOL)success
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码修改成功"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel
                  changePasswordFailed:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@">_< 出错了"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel
        sendForgotPasswordEmailSuccess:(BOOL)success
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码邮件已发出"
                                                        message:@"请到邮箱查收邮件并重置密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)MCDUserModifyPasswordViewModel:(MCDUserModifyPasswordViewModel *)viewModel
         sendForgotPasswordEmailFailed:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@">_< 出错了"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end