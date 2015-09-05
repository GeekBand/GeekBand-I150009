//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewController.h"
#import "MCDSignupContentViewModel.h"
#import "RSKImageCropViewController.h"
#import "MCDUserInfoContainerViewController.h"
#import "MMDrawerController.h"

@import MCDiaryKit;

@interface MCDSignupContentViewController ()
    <UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    RSKImageCropViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UIButton         *toLoginButton;
@property(nonatomic, weak) IBOutlet MCDButtonView    *signupButton;
@property(nonatomic, weak) IBOutlet MCDTextFormField *usernameTextFormField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *passwordTextFormField;
@property(nonatomic, weak) IBOutlet MCDTextFormField *emailTextFormField;
@property(nonatomic, weak) IBOutlet MCDAvatarView    *avatarView;

@property(nonatomic, strong) UITextField *activeField;

@end

@implementation MCDSignupContentViewController
{
}

@synthesize viewModel = _viewModel;

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewModel             = [[MCDSignupContentViewModel alloc] init];
    self.viewModel.avatarImage = [MCDAvatarView defaultAvatarImage];

    [self initBinding];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];

    [self.view layoutIfNeeded];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}

#pragma mark - RSKImageCropViewControllerDelegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.viewModel.avatarImage = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.viewModel.avatarImage = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)initBinding
{
    @weakify(self);

    // 用户名
    RAC(self.viewModel, username) = [self.usernameTextFormField.textField rac_textSignal];
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

    // 密码
    RAC(self.viewModel, password) = [self.passwordTextFormField.textField rac_textSignal];
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

    // 邮箱
    RAC(self.viewModel, email) = [[self.emailTextFormField.textField rac_textSignal]
        map:^id(NSString *string) {
            // trim
            return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    ];
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

    // 头像
    RAC(self.avatarView, avatarImage) = RACObserve(self.viewModel, avatarImage);

    // activeField
    [[RACSignal merge:@[
        self.usernameTextFormField.textFieldBeginEditingSignal,
        self.passwordTextFormField.textFieldBeginEditingSignal,
        self.emailTextFormField.textFieldBeginEditingSignal
    ]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.activeField = tuple.first;
    }];

    // 去登录
    [[self.toLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }];

    // 注册
    [self.signupButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activeField resignFirstResponder];
        [self.viewModel validateAndSignup];
        [SVProgressHUD show];
    }];
    [self.viewModel.signUpErrorSignal subscribeNext:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [self.viewModel.signUpSuccessSignal subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        MMDrawerController                 *rootVC     = (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        MCDUserInfoContainerViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MCDUserInfoContainerViewController class])];
        [rootVC setCenterViewController:userInfoVC];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    // 换头像
    [[self.avatarView.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [sheet addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self presentImagePicker:UIImagePickerControllerSourceTypeCamera];
                                                    }]];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [sheet addAction:[UIAlertAction actionWithTitle:@"选择照片"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self presentImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                                                    }]];
        }
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [self presentViewController:sheet animated:YES completion:nil];
    }];
}

- (void)presentImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = sourceType;
    pickerController.delegate   = self;
    [self presentViewController:pickerController
                       animated:YES
                     completion:nil];
}


@end