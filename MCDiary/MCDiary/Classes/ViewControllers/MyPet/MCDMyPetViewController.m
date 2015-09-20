//
//  MCDMyMengChongCollectionViewController.m
//  MCDiary
//
//  Created by zero on 15/8/27.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "MCDMyPetViewController.h"
#import "MCDMyPetDataModel.h"
#import "MCDCustomCell.h"
#import "MCDMyPet.h"
#import "MCDDrawerControllerHelper.h"

@interface MCDMyPetViewController ()

@end

@implementation MCDMyPetViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {

    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _myPetDataModel = [[MCDMyPetDataModel alloc] init];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MCDDetailPetViewController class]]) {
            MCDDetailPetViewController *controller = (MCDDetailPetViewController *)segue.destinationViewController;
        controller.delegate = self;
        if ([segue.identifier isEqualToString:@"AddPet"]) {
            controller.navigationItem.rightBarButtonItem = nil;
        }else
        if ([segue.identifier isEqualToString:@"EditPet"]){
            controller.title = @"编辑宠物";
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
            controller.myPetToEdit = self.myPetDataModel.petList[indexPath.row];
        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.myPetDataModel.petList count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MCDCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    MCDMyPet *pet = self.myPetDataModel.petList[indexPath.row];
    // Configure the cell
    
    cell.myPetImage.image = pet.image;
    cell.myPetNickName.text = [NSString stringWithFormat:@"%@",pet.nickName];
    
    return cell;
}


#pragma mark MCDAddPetViewControllerDelegate

- (void)MCDDetailPetViewController:(MCDDetailPetViewController *)controller didFinishAddingPet:(MCDMyPet *)pet{
    
    [self.myPetDataModel.petList addObject:pet];
    [self.myPetDataModel savePetList];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)MCDDetailPetViewController:(MCDDetailPetViewController *)controller didFinishEditingPet:(MCDMyPet *)pet{
    NSInteger indext = [self.myPetDataModel.petList indexOfObject:pet];
    NSLog(@"%ld",indext);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indext inSection:0];
    
    MCDCustomCell *cell = (MCDCustomCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.myPetImage.image = pet.image;
    cell.myPetNickName.text = [NSString stringWithFormat:@"%@",pet.nickName];
    
    [self.myPetDataModel savePetList];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)MCDDetailPetViewController:(MCDDetailPetViewController *)controller didFinishDeletingPet:(MCDMyPet *)pet{
    NSInteger indext = [self.myPetDataModel.petList indexOfObject:pet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indext inSection:0];
    [self.myPetDataModel.petList removeObjectAtIndex:indexPath.row];
    [self.myPetDataModel savePetList];
    
    NSArray *deleteItems = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:deleteItems];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction

- (IBAction)showMenu:(UIButton *)sender {
    [MCDDrawerControllerHelper openDrawer];
}

@end
