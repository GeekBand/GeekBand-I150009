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

@import MCDiaryKit;

@interface MCDUserInfoContentViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

@property(nonatomic, weak) IBOutlet MCDAvatarView      *avatarView;
@property(nonatomic, weak) IBOutlet MCDTextFormField   *usernameField;
@property(nonatomic, weak) IBOutlet MCDTextFormField   *emailField;
@property(nonatomic, weak) IBOutlet MCDRadioFormField  *genderField;
@property(nonatomic, weak) IBOutlet MCDButtonFormField *birthdayField;
@property(nonatomic, weak) IBOutlet MCDButtonFormField *locationField;

@end

@implementation MCDUserInfoContentViewController
{

}

@synthesize viewModel = _viewModel;

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[MCDUserInfoContentViewModel alloc] init];
    self.viewModel.avatarImage = [MCDAvatarView defaultAvatarImage];

    [self initBind];
    [self initButtonControls];
    [self initPickers];
}


#pragma mark - accessor

#pragma mark - public

#pragma mark - private

- (void)initBind
{
    RAC(self.avatarView, avatarImage) = RACObserve(self.viewModel, avatarImage);
}

- (void)initButtonControls
{
    @weakify(self);
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

- (void)initPickers
{
    // 可以优化:缓存选择器控件

    [self.birthdayField.buttonPressSignal subscribeNext:^(id x) {
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择生日"
                                                                          datePickerMode:UIDatePickerModeDate
                                                                            selectedDate:[[NSDate date] dateBySubtractingYears:20]
                                                                               doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {

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

    [self.locationField.buttonPressSignal subscribeNext:^(id x) {
        ActionSheetCustomPicker *customPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择所在地"
                                                                                      delegate:[[MCDAreaPickerViewModel alloc] init]
                                                                              showCancelButton:NO
                                                                                        origin:self.view];
        [customPicker showActionSheetPicker];
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