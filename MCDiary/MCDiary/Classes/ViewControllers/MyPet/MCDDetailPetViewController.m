//
//  MCDAddPetViewController.m
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDDetailPetViewController.h"
#import "MCDMyPet.h"

@interface MCDDetailPetViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@end

@implementation MCDDetailPetViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.myPetToEdit != nil) {
        self.myPetImageView.image = self.myPetToEdit.image;
        self.nickNameTextField.text = self.myPetToEdit.nickName;
        self.birthTextField.text = self.myPetToEdit.birthday;
        self.varietyTextField.text = self.myPetToEdit.variety;
        self.heightTextField.text = self.myPetToEdit.height;
        self.weightTextField.text = self.myPetToEdit.weight;
        self.genderSegmentedControl.selectedSegmentIndex = self.myPetToEdit.gender;
        
        self.genderSegmentedControl.enabled = NO;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecoginize:)];
    [self.tableView addGestureRecognizer:gestureRecognizer];

}

- (void)gestureRecoginize:(UIGestureRecognizer *)gestureRecongnizer{
    CGPoint point = [gestureRecongnizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath.row == 0) {
        [self callCamera];
    }else{
        [self hideKeyboard];
    }
}
/**
 *  调用相机
 */
- (void)callCamera{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册选取", @"拍摄新照片", nil];
    [actionSheet showInView:self.view];
}

/**
 *  隐藏键盘输入框
 */
- (void)hideKeyboard{
    [self.nickNameTextField resignFirstResponder];
    [self.birthTextField    resignFirstResponder];
    [self.varietyTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"从相册选取"]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if ([buttonTitle isEqualToString:@"拍摄新照片"]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if ([buttonTitle isEqualToString:@"取消"]){
        return;
    }
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.myPetImageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add new pet data
/**
 *  读取文本框信息，添加或者编辑宠物对象
 *
 */
- (IBAction)doneButton:(id)sender {

    if (self.myPetToEdit == nil) {
        MCDMyPet *pet = [[MCDMyPet alloc] init];
        pet.nickName = self.nickNameTextField.text;
        pet.birthday = self.birthTextField.text;
        pet.variety = self.varietyTextField.text;
        pet.height = self.heightTextField.text;
        pet.weight = self.weightTextField.text;
        pet.image = self.myPetImageView.image;
        pet.gender = self.genderSegmentedControl.selectedSegmentIndex;
        
        [self meetRequireInformation:pet];
    }
    else{
        self.myPetToEdit.nickName = self.nickNameTextField.text;
        self.myPetToEdit.birthday = self.birthTextField.text;
        self.myPetToEdit.variety = self.varietyTextField.text;
        self.myPetToEdit.height = self.heightTextField.text;
        self.myPetToEdit.weight = self.weightTextField.text;
        self.myPetToEdit.image = self.myPetImageView.image;
        
        [self meetRequireInformation:self.myPetToEdit];
    }

}
/**
 *  删除宠物信息
 *
 */
- (IBAction)deleteButton:(id)sender {
    [self.delegate MCDDetailPetViewController:self didFinishDeletingPet:self.myPetToEdit];
}
/**
 *  判断是否满足登记新宠物所需要的信息要求，选择对应操作
 *
 */
- (void)meetRequireInformation:(MCDMyPet*)pet{
    if ([pet.nickName length] > 0 && [pet.birthday length] > 0 && [pet.variety length] > 0 && pet.image){
        if (self.myPetToEdit == nil) {
            [self.delegate MCDDetailPetViewController:self didFinishAddingPet:pet];
        }else{
            [self.delegate MCDDetailPetViewController:self didFinishEditingPet:pet];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入昵称、生日、种类并选择萌照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


@end
