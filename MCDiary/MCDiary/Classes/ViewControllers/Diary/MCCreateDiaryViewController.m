//
//  MCCreateDiaryViewController.m
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "MCCreateDiaryViewController.h"

@interface MCCreateDiaryViewController () {
    UITextField     *_titleTextField;
    UISwitch        *_bigEventSwitch;
    NSMutableArray  *_imagesArray;
    UIButton        *_addPhotoButton;
}

@end

@implementation MCCreateDiaryViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsTableView.dataSource = self;
    if (_diary) {
        _imagesArray = _diary.images;
        _contentTextView.text = _diary.content;
    }
    [_deleteButton setHidden:_shouldHideDeleteButton];
    if (_shouldHideDeleteButton) {
        _titleLabel.text = @"添加日记";
    }else{
        _titleLabel.text = @"编辑日记";
    }
    [self initializeImagesScrollView];
}

- (void)initializeImagesScrollView {
    //上图       图片：宽 80, 高 60  间距为5
    _imagesScrollView.contentSize = CGSizeMake(85 * 9 + 5, _imagesScrollView.frame.size.height);
    if (_imagesArray) {
        if (85 * (_imagesArray.count + 1) + 5 > _imagesScrollView.frame.size.width) {
            _imagesScrollView.scrollEnabled = YES;
        }else{
            _imagesScrollView.scrollEnabled = NO;
        }
        for(int i = 0; i < _imagesArray.count; ++i){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 * i + 5, 8, 80, 60)];
            imageView.image = (UIImage *)_imagesArray[i];
            [_imagesScrollView addSubview:imageView];
        }
    }else{
        _imagesScrollView.scrollEnabled = NO;
    }
    
    _addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(_imagesArray.count * 85 + 5, 8, 80, 60)];
    [_addPhotoButton setTitle:@"add" forState:UIControlStateNormal];
    [_addPhotoButton setBackgroundColor:[UIColor grayColor]];
    [_addPhotoButton addTarget:self action:@selector(addImageButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_imagesScrollView addSubview:_addPhotoButton];
}

- (void)refreshScrollView {
    if (85 * (_imagesArray.count + 1) + 5 > _imagesScrollView.frame.size.width) {
        _imagesScrollView.scrollEnabled = YES;
    }else{
        _imagesScrollView.scrollEnabled = NO;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 * (_imagesArray.count - 1) + 5, 8, 80, 60)];
    imageView.image = (UIImage *)_imagesArray[_imagesArray.count - 1];
    [_imagesScrollView addSubview:imageView];
    
    _addPhotoButton.frame = CGRectMake(_imagesArray.count * 85 + 5, 8, 80, 60);
}

#pragma mark - Memory Handler

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Responder methods

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
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
    }
    else{
        _diary = [[MCDiary alloc] initAMCDiaryWithTitle:_titleTextField.text createTime:[NSDate date] content:_contentTextView.text images:_imagesArray isBigEvent:_bigEventSwitch.on];
        [_delegate setupMCDiary:_diary];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImageButtonTouchUpInside:(UIButton *) button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
        }else{
            UIAlertController *cameraDenyAlertController = [UIAlertController alertControllerWithTitle:@"相机不可用" message:@"相机并不可用哦亲！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [cameraDenyAlertController addAction:okAction];
            [self presentViewController:cameraDenyAlertController animated:YES completion:nil];
        }
    }];
    UIAlertAction *photoStoreAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
- (void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    for (NSString *key in [info allKeys]) {
        if ([key isEqualToString:UIImagePickerControllerOriginalImage] || [key isEqualToString:UIImagePickerControllerEditedImage]) {
            UIImage *image = (UIImage *)[info objectForKey:key];
            if (_imagesArray == nil) {
                _imagesArray = [NSMutableArray array];
            }
            if (image) {
                [_imagesArray addObject:image];
                [self refreshScrollView];
            }
        }
    }
}

@end
