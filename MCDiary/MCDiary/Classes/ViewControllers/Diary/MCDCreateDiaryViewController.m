//
//  MCDCreateDiaryViewController.m
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCDCreateDiaryViewController.h"

@interface MCDCreateDiaryViewController () {
    UITextField     *_titleTextField;
    UISwitch        *_bigEventSwitch;
    NSMutableArray  *_imagesArray;
    UIButton        *_addPhotoButton;
    __weak MCDShowImageViewController *_showImageViewController;
    CGRect           _keyboardFrame;
}

@end

@implementation MCDCreateDiaryViewController

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsTableView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_imagesCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(IMAGE_CELL_SIDECAR, IMAGE_CELL_SIDECAR);
    flowLayout.minimumInteritemSpacing = 5;
    _imagesCollectionView.dataSource = self;
    _imagesCollectionView.delegate = self;
    [_deleteButton setHidden:_shouldHideDeleteButton];
    if (_shouldHideDeleteButton) {
        _titleLabel.text = @"添加日记";
    }else{
        _titleLabel.text = @"编辑日记";
    }
    _contentTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_diary) {
        _imagesArray = _diary.images;
        _contentTextView.text = _diary.content;
    }
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _showImageViewController = (MCDShowImageViewController *)segue.destinationViewController;
    _showImageViewController.delegate = self;
}

#pragma mark - Keyboard Handler

- (void)keyboardWillAppear:(NSNotification *)notification {
    _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([_contentTextView isFirstResponder]) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _collectionHeightLayoutConstraint.constant += 15;
            CGRect frame = self.view.frame;
            frame.origin.y -= _keyboardFrame.size.height;
            self.view.frame = frame;
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([_contentTextView isFirstResponder]) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _collectionHeightLayoutConstraint.constant -= 15;
            CGRect frame = self.view.frame;
            frame.origin.y += _keyboardFrame.size.height;
            self.view.frame = frame;
        } completion:nil];
    }
}

#pragma mark - Memory Handler

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Responder methods

- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([_titleTextField respondsToSelector:@selector(resignFirstResponder)]) {
        [_titleTextField resignFirstResponder];
    }
    if ([_contentTextView respondsToSelector:@selector(resignFirstResponder)]) {
        [_contentTextView resignFirstResponder];
    }
}

- (IBAction)swipeGestureHandler:(id)sender {
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        if ([_titleTextField respondsToSelector:@selector(resignFirstResponder)]) {
            [_titleTextField resignFirstResponder];
        }
        if ([_contentTextView respondsToSelector:@selector(resignFirstResponder)]) {
            [_contentTextView resignFirstResponder];
        }
    }
}

- (IBAction)cancelButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonTouchUpInside:(id)sender {
    [_delegate removeMCDiary:_diary];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    if (_titleTextField.text == nil || _titleTextField.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题不明去向" message:@"日记标题不能为空哦亲！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ((_imagesArray == nil || _imagesArray.count == 0) && _contentTextView.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"内容失踪了" message:@"日记怎么能缺少内容呢亲！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_diary) {
        [_diary setupDataWithTitle:_titleTextField.text createTime:[NSDate date] content:_contentTextView.text images:_imagesArray isBigEvent:_bigEventSwitch.on];
        [_delegate reloadTimeLineView];
    }
    else{
        _diary = [[MCDiary alloc] initAMCDiaryWithTitle:_titleTextField.text createTime:[NSDate date] content:_contentTextView.text images:_imagesArray isBigEvent:_bigEventSwitch.on];
        [_delegate setupMCDiary:_diary];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImageButtonTouchUpInside:(UIButton *) button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
        }else{
            UIAlertController *cameraDenyAlertController = [UIAlertController alertControllerWithTitle:@"相机不可用" message:@"相机并不可用哦亲！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [cameraDenyAlertController addAction:okAction];
            [self presentViewController:cameraDenyAlertController animated:YES completion:nil];
        }
    }];
    UIAlertAction *photoStoreAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerController.allowsEditing = YES;
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
        }else{
            UIAlertController *cameraDenyAlertController = [UIAlertController alertControllerWithTitle:@"相册不可用" message:@"相册并不可用哦亲！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [cameraDenyAlertController addAction:okAction];
            [self presentViewController:cameraDenyAlertController animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:takePhotoAction];
    [alertController addAction:photoStoreAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MCDiaryOptionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 30, TIPS_LABEL_HEIGHT)];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.text = @"标题";
        [cell.contentView addSubview:titleLabel];
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, tableView.frame.size.width - 20, 30)];
        _titleTextField.textColor = [UIColor blackColor];
        _titleTextField.font = [UIFont systemFontOfSize:17.0];
        if (_diary) {
            _titleTextField.text = _diary.title;
        }
        [cell.contentView addSubview:_titleTextField];
    }else{
        UILabel *bigEventLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (cell.contentView.frame.size.height - TIPS_LABEL_HEIGHT) / 2 + OFFSET, tableView.frame.size.width - 10, TIPS_LABEL_HEIGHT)];
        bigEventLabel.textColor = [UIColor lightGrayColor];
        bigEventLabel.font = [UIFont systemFontOfSize:12.0];
        bigEventLabel.text = @"大事";
        
        [cell.contentView addSubview:bigEventLabel];
        
        _bigEventSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 50, (cell.contentView.frame.size.height - 30) / 2 + OFFSET, 45, 30)];
        if (_diary) {
            _bigEventSwitch.on = _diary.isBigEvent;
        }else{
            _bigEventSwitch.on = NO;
        }
        //handle switch UI
        [cell.contentView addSubview:_bigEventSwitch];
    }
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary *)info
{
    for (NSString *key in [info allKeys]) {
        if ([key isEqualToString:UIImagePickerControllerEditedImage] || [key isEqualToString:UIImagePickerControllerOriginalImage]) {
            UIImage *image = (UIImage *)[info objectForKey:key];
            if (_imagesArray == nil) {
                _imagesArray = [NSMutableArray array];
            }
            if (image) {
                [_imagesArray addObject:image];
                [_imagesCollectionView reloadData];
                [picker dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_imagesArray.count + 1) >= 9 ? 9 : _imagesArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (nonnull UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *imageCellIdentifier = @"CreateImageCellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    if (indexPath.item == _imagesArray.count && _imagesArray.count != 9) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IMAGE_CELL_SIDECAR, IMAGE_CELL_SIDECAR)];
        [addButton setTitle:@"add" forState:UIControlStateNormal];
        [addButton setBackgroundColor:[UIColor lightGrayColor]];
        [addButton addTarget:self action:@selector(addImageButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addButton];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_CELL_SIDECAR, IMAGE_CELL_SIDECAR)];
        imageView.image = _imagesArray[indexPath.item];
        [cell.contentView addSubview:imageView];
        for (id view in [cell.contentView subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
    if (collectionView.contentSize.height > 75) {
        _collectionHeightLayoutConstraint.constant = collectionView.contentSize.height;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _showImageViewController.imageToShow = _imagesArray[indexPath.item];
}

#pragma mark - MCDShowImageViewControllerDelegate methods

- (void)deleteImage:(UIImage *)image {
    [_imagesArray removeObject:image];
    [_imagesCollectionView reloadData];
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = self.view.frame;
//    NSLog(@"%@", NSStringFromCGRect(frame));
    if (frame.origin.y == 0) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _collectionHeightLayoutConstraint.constant += 15;
            CGRect frame = self.view.frame;
            frame.origin.y -= _keyboardFrame.size.height;
            self.view.frame = frame;
        } completion:nil];
    }
}

@end
