//
// Created by zzdjk6 on 15/8/29.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDSignupContentViewController.h"
#import "MCDSignupContentViewModel.h"
#import "RSKImageCropViewController.h"
@import MCDiaryKit;

@interface MCDSignupContentViewController ()
    <UITextFieldDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    RSKImageCropViewControllerDelegate>

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

    self.viewModel             = [[MCDSignupContentViewModel alloc] init];
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
        [self.activeField resignFirstResponder];
        [self.viewModel validate];
    }];
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    self.viewModel.avatarImage = image;
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