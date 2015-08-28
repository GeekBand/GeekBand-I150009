//
//  UIPlaceHolderTextView.m
//  MCDiary
//
//  Created by Turtle on 15/8/27.
//  Copyright © 2015年 zzdjk6. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

- (void)dealloc {
    //remove observer from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _placeHolder = @"这一刻想说什么。。。";
    _placeHolderColor = [UIColor lightGrayColor];
    [self initializePlaceHolderLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return nil;
}

- (void)initializePlaceHolderLabel {
    if([_placeHolder length] > 0 )
    {
        if ( _placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = _placeHolderColor;
            _placeHolderLabel.hidden = YES;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = _placeHolder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [_placeHolder length] > 0 )
    {
        _placeHolderLabel.hidden = NO;
    }
}

- (void)setText:(NSString * _Nullable)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)textChanged:(NSNotification *)notification {
    _placeHolderLabel.hidden = YES;
}

- (void)textDidEndEditing:(NSNotification *)notification {
    if (self.text.length == 0) {    
        _placeHolderLabel.hidden = NO;
    }
}

@end
