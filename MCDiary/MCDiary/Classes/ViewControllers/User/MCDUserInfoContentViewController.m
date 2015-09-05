//
// Created by zzdjk6 on 15/8/31.
// Copyright (c) 2015 zzdjk6. All rights reserved.
//

#import "MCDUserInfoContentViewController.h"
#import "NSDate+DateTools.h"
#import "ActionSheetPicker.h"
#import "UIColor+MCDiary.h"
#import "MCDUserInfoContentViewModel.h"
#import "MCDAreaPickerViewModel.h"
#import "RSKImageCropViewController.h"
#import "MCDUser.h"
#import "MCDUserModifyPasswordViewController.h"

@import MCDiaryKit;

@interface MCDUserInfoContentViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

@property(nonatomic, weak) IBOutlet MCDAvatarView      *avatarView;
@property(nonatomic, weak) IBOutlet MCDTextFormField   *usernameField;
@property(nonatomic, weak) IBOutlet MCDTextFormField   *emailField;
@property(nonatomic, weak) IBOutlet MCDRadioFormField  *genderField;
@property(nonatomic, weak) IBOutlet MCDButtonFormField *birthdayField;
@property(nonatomic, weak) IBOutlet MCDButtonFormField *locationField;

@property(nonatomic, weak) IBOutlet MCDButtonView *changePasswordButton;
@property(nonatomic, weak) IBOutlet MCDButtonView *saveInfoButton;

@end

@implementation MCDUserInfoContentViewController
{

}

@synthesize viewModel = _viewModel;

#pragma mark - public

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[MCDUserInfoContentViewModel alloc] init];

    [self initBindings];
}


#pragma mark - accessor

#pragma mark - private

- (void)initBindings
{
    @weakify(self);

    // 用户名，初始值，不可以更改
    self.usernameField.textField.text                   = self.viewModel.username;
    self.usernameField.textField.userInteractionEnabled = NO;

    // 邮箱，初始值+输入绑定+错误提示
    self.emailField.textField.text = self.viewModel.email;
    RAC(self.viewModel, email) = [[self.emailField.textField rac_textSignal] map:^id(NSString *string) {
        // trim
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }];
    [RACObserve(self.viewModel, emailValid) subscribeNext:^(NSNumber *number) {
        if ([number boolValue]) {
            self.emailField.titleText = self.viewModel.emailNormalTitle;
            self.emailField.state     = MCDTextFormFieldStateNormal;
        } else {
            self.emailField.titleText = self.viewModel.emailErrorTitle;
            self.emailField.state     = MCDTextFormFieldStateError;
        }
    }];
    [self.emailField.textFieldBeginEditingSignal subscribeNext:^(id x) {
        @strongify(self);
        self.activeField = self.emailField.textField;
    }];

    // 性别，初始值+输入绑定
    self.genderField.selectedIndex = self.viewModel.gender;
    RAC(self.viewModel, gender) = self.genderField.selectedIndexChangeSignal;

    // 生日，展示绑定
    RAC(self.birthdayField, buttonText) = RACObserve(self.viewModel, birthdayString);
    [self.birthdayField.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择生日"
                                                                          datePickerMode:UIDatePickerModeDate
                                                                            selectedDate:self.viewModel.birthday
                                                                               doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                                                                   self.viewModel.birthday = selectedDate;
                                                                               }
                                                                             cancelBlock:^(ActionSheetDatePicker *picker) {

                                                                             }
                                                                                  origin:self.view];
        [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        [datePicker setMaximumDate:[[NSDate date] dateBySubtractingDays:1]];
        [datePicker setMinimumDate:[[NSDate date] dateBySubtractingYears:100]];

        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
        doneButton.title     = @"完成";
        doneButton.tintColor = [UIColor MCDGreen];
        [datePicker setDoneButton:doneButton];

        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
        cancelButton.title     = @"取消";
        cancelButton.tintColor = [UIColor MCDGreen];
        [datePicker setCancelButton:cancelButton];

        [datePicker showActionSheetPicker];
    }];

    // 所在地，展示绑定
    RAC(self.locationField, buttonText) = RACObserve(self.viewModel, locationString);
    [self.locationField.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        MCDAreaPickerViewModel  *pickerViewModel = self.viewModel.pickerViewModel;
        ActionSheetCustomPicker *customPicker    = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择所在地"
                                                                                         delegate:pickerViewModel
                                                                                 showCancelButton:NO
                                                                                           origin:self.view
                                                                                initialSelections:pickerViewModel.initialSelection
        ];
        [customPicker showActionSheetPicker];
    }];

    // 头像，展示绑定
    RAC(self.avatarView, avatarImage) = RACObserve(self.viewModel, avatarImage);
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

    // 保存信息
    [self.saveInfoButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activeField resignFirstResponder];
        [SVProgressHUD show];
        [self.viewModel validateAndSave];
    }];
    [self.viewModel.allInfoSavedSignal subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功"
                                                        message:@"您的信息已保存"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [[self.viewModel.infoSaveFailedSignal throttle:1]
        subscribeNext:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];

    //修改密码
    [self.changePasswordButton.buttonPressSignal subscribeNext:^(id x) {
        @strongify(self);
        MCDUserModifyPasswordViewController *vc = [self.storyboard
            instantiateViewControllerWithIdentifier:NSStringFromClass([MCDUserModifyPasswordViewController class])];
        [self presentViewController:vc animated:YES completion:nil];
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

@end