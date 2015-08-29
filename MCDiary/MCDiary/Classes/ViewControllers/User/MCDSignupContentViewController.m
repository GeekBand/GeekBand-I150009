//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewController.h"
#import "MCDTextFormField.h"
#import "MCDSignupContentViewModel.h"
#import "MCDButtonView.h"
#import "MCDAvatarView.h"

@interface MCDSignupContentViewController () <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UIButton         *toLoginButton;
@property(nonatomic, weak) IBOutlet MCDButtonView    *signupButton;
@property(nonatomic, weak) IBOutlet MCDTextFormField *usernameTextFormField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *passwordTextFormField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *emailTextFormField;
@property(nonatomic, weak) IBOutlet MCDAvatarView    *avatarView;

@end

@implementation MCDSignupContentViewController
{

}

@synthesize viewModel = _viewModel;

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init UI
    self.usernameTextFormField.textField.delegate = self;
    self.passwordTextFormField.textField.delegate = self;
    self.emailTextFormField.textField.delegate    = self;

    self.viewModel = [[MCDSignupContentViewModel alloc] init];
    self.viewModel.avatarImage = [MCDAvatarView defaultAvatarImage];

    @weakify(self);

    // V to VM binding
    RAC(self.viewModel, username)     = [self.usernameTextFormField.textField rac_textSignal];
    RAC(self.viewModel, password)     = [self.passwordTextFormField.textField rac_textSignal];
    RAC(self.viewModel, email)        = [[self.emailTextFormField.textField rac_textSignal]
        map:^id(NSString *string) {
            // trim
            return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    ];
    RAC(self.avatarView, avatarImage) = RACObserve(self.viewModel, avatarImage);

    // VM to V binding
    [RACObserve(self.viewModel, usernameValid) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if ([number boolValue]) {
            self.usernameTextFormField.state     = MCDTextFormFieldStateNormal;
            self.usernameTextFormField.titleText = self.viewModel.usernameNormalTitle;
        } else {
            self.usernameTextFormField.state     = MCDTextFormFieldStateError;
            self.usernameTextFormField.titleText = self.viewModel.usernameErrorTitle;
        }
    }];

    [RACObserve(self.viewModel, passwordValid) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if ([number boolValue]) {
            self.passwordTextFormField.state     = MCDTextFormFieldStateNormal;
            self.passwordTextFormField.titleText = self.viewModel.passwordNormalTitle;
        } else {
            self.passwordTextFormField.state     = MCDTextFormFieldStateError;
            self.passwordTextFormField.titleText = self.viewModel.passwordErrorTitle;
        }
    }];

    [RACObserve(self.viewModel, emailValid) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if ([number boolValue]) {
            self.emailTextFormField.state     = MCDTextFormFieldStateNormal;
            self.emailTextFormField.titleText = self.viewModel.emailNormalTitle;
        } else {
            self.emailTextFormField.state     = MCDTextFormFieldStateError;
            self.emailTextFormField.titleText = self.viewModel.emailErrorTitle;
        }
    }];

    // buttons
    [[self.toLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [[self.signupButton.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel validate];
    }];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];

    [self.view layoutIfNeeded];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end