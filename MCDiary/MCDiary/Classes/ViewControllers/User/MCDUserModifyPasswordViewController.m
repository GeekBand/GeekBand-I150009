//
// Created by zzdjk6 on 15/9/2.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserModifyPasswordViewController.h"
#import "MCDUserModifyPasswordViewModel.h"
#import "MCDUser.h"
#import "MCDTextFormField.h"
#import "MCDButtonView.h"

@interface MCDUserModifyPasswordViewController ()

@property(nonatomic, weak) IBOutlet MCDTextFormField *oldPasswordField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *freshPasswordField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *confirmPasswordField;
@property(nonatomic, weak) IBOutlet MCDButtonView    *confirmChangePasswordButton;
@property(nonatomic, weak) IBOutlet UIButton         *forgetPasswordButton;
@property(nonatomic, weak) IBOutlet UIButton         *backgroundButton;

@end

@implementation MCDUserModifyPasswordViewController
{

}

@synthesize viewModel = _viewModel;

#pragma mark - Public

#pragma mark - Life Cycle

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

#pragma mark - Accessor

#pragma mark - Bindings

- (void)initHUDBinding
{
    [RACObserve(self.viewModel, sendingRequest) subscribeNext:^(NSNumber *flagNumber) {
        if ([flagNumber boolValue]) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)initTextFieldsBinding
{
    @weakify(self);

    // 原密码
    [self.viewModel.oldPasswordValidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.oldPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.oldPasswordField.titleText = flag ?
            self.viewModel.oldPasswordTitleNormal :
            self.viewModel.oldPasswordTitleError;
    }];

    // 新密码
    [self.viewModel.freshPasswordValidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.freshPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.freshPasswordField.titleText = flag ?
            self.viewModel.freshPasswordTitleNormal :
            self.viewModel.freshPasswordTitleError;
    }];

    // 确认新密码
    [self.viewModel.confirmPasswordValidSignal subscribeNext:^(NSNumber *number) {
        @strongify(self);
        BOOL flag = [number boolValue];
        self.confirmPasswordField.state     = flag ? MCDTextFormFieldStateNormal : MCDTextFormFieldStateError;
        self.confirmPasswordField.titleText = flag ?
            self.viewModel.confirmPasswordTitleNormal :
            self.viewModel.confirmPasswordTitleError;
    }];
}

- (void)initForgotPasswordBinding
{
    @weakify(self);

    // 忘记密码按钮
    [[self.forgetPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            [self.view endEditing:YES];

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
    ];

    // 发送成功
    [self.viewModel.sendForgotPasswordEmailSuccessSignal subscribeNext:^(id x) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码邮件已发出"
                                                            message:@"请到邮箱查收邮件并重置密码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    // 发送失败
    [self.viewModel.sendForgotPasswordEmailFailedSignal subscribeNext:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@">_< 出错了"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)initChangePasswordBinding
{
    @weakify(self);

    // 更改密码按钮
    [[self.confirmChangePasswordButton.button rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            [self.view endEditing:YES];
            self.viewModel.oldPassword     = self.oldPasswordField.textField.text;
            self.viewModel.freshPassword   = self.freshPasswordField.textField.text;
            self.viewModel.confirmPassword = self.confirmPasswordField.textField.text;
            [self.viewModel changePassword];
        }];

    // 修改成功
    [self.viewModel.changePasswordSuccessSignal subscribeNext:^(id x) {
        @strongify(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码修改成功"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];

        [self presentViewController:alertController animated:YES completion:nil];
    }];

    // 修改失败
    [self.viewModel.changePasswordFailedSignal subscribeNext:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@">_< 出错了"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)initBackgroundTapBinding
{
    @weakify(self);
    // 点击空白消失
    [[self.backgroundButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Private

- (void)initBinding
{
    @weakify(self);

    [self initHUDBinding];
    [self initTextFieldsBinding];
    [self initForgotPasswordBinding];
    [self initChangePasswordBinding];
    [self initBackgroundTapBinding];
}

@end