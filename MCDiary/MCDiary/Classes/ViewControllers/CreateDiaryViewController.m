//
//  CreateDiaryViewController.m
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "CreateDiaryViewController.h"

@interface CreateDiaryViewController () {
    UITextField     *_titleTextField;
    UISwitch        *_bigEventSwitch;
    NSMutableArray  *_imagesArray;
}

@end

@implementation CreateDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsTableView.dataSource = self;
    if (_diary) {
        _imagesArray = _diary.images;
        _contentTextView.text = _diary.content;
    }
}

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
    if (_delegate) {
        [_delegate removeDiary:_diary];
    }
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
    
    if ((_imagesArray == nil || _imagesArray.count == 0) || _contentTextView.text.length == 0) {
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
        _diary = [[Diary alloc] initADiaryWithTitle:_titleTextField.text createTime:[NSDate date] content:_contentTextView.text images:_imagesArray isBigEvent:_bigEventSwitch.on];
    }
    
    if (_delegate) {
        [_delegate setupDiary:_diary];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DiaryOptionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
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

@end
