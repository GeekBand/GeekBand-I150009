//
//  MCDAddPetViewController.h
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCDMyPet;
@class MCDDetailPetViewController;

@protocol  MCDDetailPetViewControllerDelegate<NSObject>

- (void)MCDDetailPetViewController:(MCDDetailPetViewController*)controller didFinishAddingPet:(MCDMyPet *)pet;
- (void)MCDDetailPetViewController:(MCDDetailPetViewController*)controller didFinishEditingPet:(MCDMyPet *)pet;
- (void)MCDDetailPetViewController:(MCDDetailPetViewController*)controller didFinishDeletingPet:(MCDMyPet *)pet;

@end


@interface MCDDetailPetViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthTextField;
@property (weak, nonatomic) IBOutlet UITextField *varietyTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *myPetImageView;

@property (weak, nonatomic) id<MCDDetailPetViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

- (IBAction)doneButton:(id)sender;
- (IBAction)deleteButton:(id)sender;

@property (strong, nonatomic) MCDMyPet *myPetToEdit;

@end
