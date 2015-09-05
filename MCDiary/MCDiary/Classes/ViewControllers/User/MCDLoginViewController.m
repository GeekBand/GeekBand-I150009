//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewController.h"
#import "MCDSignupContainerViewController.h"
#import "MCDLoginViewModel.h"
#import "MMDrawerController.h"
#import "MCDUserInfoContainerViewController.h"

@import MCDiaryKit;

@interface MCDLoginViewController ()

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property(nonatomic, weak) IBOutlet UIImageView        *logoImageView;

@property(nonatomic, weak) IBOutlet MCDTextFormField *usernameField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *passwordField;
@property(nonatomic, weak) IBOutlet MCDButtonView    *loginButton;
@property(nonatomic, weak) IBOutlet UIButton         *toSignupButton;

@property(nonatomic, weak) UITextField *activeField;

@end

@implementation MCDLoginViewController

@synthesize viewModel = _viewModel;

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[MCDLoginViewModel alloc] init];

    [self initBinding];
}

#pragma mark - private

- (void)initBinding
{
    @weakify(self);

    // 用户名字段
    RAC(self.viewModel, username) = [self.usernameField.textField rac_textSignal];
    [RACObserve(self.viewModel, usernameValid) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if (![number boolValue]) {
            self.usernameField.state     = MCDTextFormFieldStateError;
            self.usernameField.titleText = self.viewModel.usernameErrorTitle;
        } else {
            self.usernameField.state     = MCDTextFormFieldStateNormal;
            self.usernameField.titleText = self.viewModel.usernameNormalTitle;
        }
    }];

    // 密码字段
    RAC(self.viewModel, password) = [self.passwordField.textField rac_textSignal];
    [RACObserve(self.viewModel, passwordValid) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if (![number boolValue]) {
            self.passwordField.state     = MCDTextFormFieldStateError;
            self.passwordField.titleText = self.viewModel.passwordErrorTitle;
        } else {
            self.passwordField.state     = MCDTextFormFieldStateNormal;
            self.passwordField.titleText = self.viewModel.passwordNormalTitle;
        }
    }];

    // 忘记密码
    [self initForgetPasswordLogic];

    // activeField
    [[[RACSignal merge:@[
        self.usernameField.textFieldBeginEditingSignal,
        self.passwordField.textFieldBeginEditingSignal
    ]] map:^id(RACTuple *tuple) {
        return tuple.first;
    }] subscribeNext:^(UITextField *textField) {
        @strongify(self);
        self.activeField = textField;
    }];

    // 登录按钮
    [self.loginButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activeField resignFirstResponder];
        [SVProgressHUD show];
        [self.viewModel validateAndLogin];
    }];
    [self.viewModel.loginSuccessSignal subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        MMDrawerController                 *rootVC     = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        MCDUserInfoContainerViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MCDUserInfoContainerViewController class])];
        [rootVC setCenterViewController:userInfoVC];
    }];
    [[[self.viewModel loginFailSignal]
        throttle:1] // 1秒内只接受一次登录失败的信号
        subscribeNext:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];

    // 去注册
    [[self.toSignupButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            NSString                         *vcID = NSStringFromClass([MCDSignupContainerViewController class]);
            MCDSignupContainerViewController *vc   = [self.storyboard instantiateViewControllerWithIdentifier:vcID];
            [self presentViewController:vc animated:YES completion:nil];
        }
    ];

    // 监听键盘
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification
                                                           object:nil]
        subscribeNext:^(NSNotification *notification) {
            @strongify(self);
            NSDictionary *info  = [notification userInfo];
            CGSize       kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

            [UIView animateWithDuration:0.3f
                             animations:^{
                                 @strongify(self);
                                 self.bottomLayoutConstraint.constant = kbSize.height;
                                 self.logoImageView.alpha             = 0.0f;
                                 [self.view layoutIfNeeded];
                             }];
        }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification
                                                           object:nil]
        subscribeNext:^(id x) {
            @strongify(self);
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 @strongify(self);
                                 self.bottomLayoutConstraint.constant = 0;
                                 self.logoImageView.alpha             = 1.0f;
                                 [self.view layoutIfNeeded];
                             }];
        }];
}

#pragma mark - 忘记密码

- (void)initForgetPasswordLogic
{
    // 忘记密码 按钮
    [[self.passwordField.assessoryButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            [self popupForgetPasswordAlert];
        }
    ];

    // 忘记密码邮件发送信号订阅
    [self.viewModel.foregetPasswordRequestFailSignal subscribeNext:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出错啦"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    [self.viewModel.foregetPasswordRequestSuccessSignal subscribeNext:^(id x) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码邮件已发出"
                                                            message:@"请到邮箱查收邮件并重置密码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
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

    // 由于block不由self持有,这里的block不需要self的若引用
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = self.usernameField.textField.text;
    }];

    [SVProgressHUD show];
    [self presentViewController:alert animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

@end