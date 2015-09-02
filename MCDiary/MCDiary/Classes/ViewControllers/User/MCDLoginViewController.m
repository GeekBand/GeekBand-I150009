//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewController.h"
#import "MCDSignupContainerViewController.h"
#import "MCDLoginViewModel.h"

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

    // 同步绑定用户名和密码
    RAC(self.viewModel, username) = [self.usernameField.textField rac_textSignal];
    RAC(self.viewModel, password) = [self.passwordField.textField rac_textSignal];

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

    // 按钮事件
    [self.loginButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activeField resignFirstResponder];
        [self.viewModel validate];
        [self updateFormField];
        if (self.viewModel.isValid) {
            // TODO: login
            return;
        }
    }];

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

- (void)updateFormField
{
    if (!self.viewModel.usernameValid) {
        self.usernameField.state     = MCDTextFormFieldStateError;
        self.usernameField.titleText = self.viewModel.usernameErrorTitle;
    } else {
        self.usernameField.state     = MCDTextFormFieldStateNormal;
        self.usernameField.titleText = self.viewModel.usernameNormalTitle;
    }

    if (!self.viewModel.passwordValid) {
        self.passwordField.state     = MCDTextFormFieldStateError;
        self.passwordField.titleText = self.viewModel.passwordErrorTitle;
    } else {
        self.passwordField.state     = MCDTextFormFieldStateNormal;
        self.passwordField.titleText = self.viewModel.passwordNormalTitle;
    }
}

@end