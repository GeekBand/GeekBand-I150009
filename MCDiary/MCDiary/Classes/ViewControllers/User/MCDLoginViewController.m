//
// Created by zzdjk6 on 15/8/27.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDLoginViewController.h"
#import "MCDTextFormField.h"
#import "MCDLoginViewModel.h"
#import "MCDButtonView.h"

@interface MCDLoginViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property(weak, nonatomic) IBOutlet UIImageView        *logoImageView;

@property(weak, nonatomic) IBOutlet MCDTextFormField *usernameField;
@property(weak, nonatomic) IBOutlet MCDTextFormField *passwordField;
@property(weak, nonatomic) IBOutlet MCDButtonView    *loginButton;

@end

@implementation MCDLoginViewController

@synthesize viewModel = _viewModel;

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[MCDLoginViewModel alloc] init];

    [self registerKeyBoardObserver];
    [self registerButtonObserver];
}

- (void)registerButtonObserver
{
    @weakify(self);

    [[self.loginButton.button rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel validate];
            [self updateFormField];
            if (self.viewModel.isValid) {
                // TODO: login
                return;
            }
        }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private

- (void)registerKeyBoardObserver
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification
                                                           object:nil]
        subscribeNext:^(NSNotification *notification) {
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
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 @strongify(self);
                                 self.bottomLayoutConstraint.constant = 0;
                                 self.logoImageView.alpha             = 1.0f;
                                 [self.view layoutIfNeeded];
                             }];
        }];

    self.usernameField.textField.delegate = self;
    self.passwordField.textField.delegate = self;

    RAC(self.viewModel, username) = [self.usernameField.textField rac_textSignal];
    RAC(self.viewModel, password) = [self.passwordField.textField rac_textSignal];
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