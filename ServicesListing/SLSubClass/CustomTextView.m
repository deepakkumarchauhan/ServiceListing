//
//  BZTextView.m
//  BizFocus
//
//  Created by KrishnaKant kaira on 02/09/13.
//  Copyright (c) 2013 Mobiloitte. All rights reserved.
//

#import "CustomTextView.h"
//#import "AllConstants.h"

@interface CustomTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

@implementation CustomTextView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder)
        [self setPlaceholder:@""];
    
    if (!self.placeholderFont) {
        self.placeholderFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16];
    }
    [self setPlaceholderColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor blackColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)textChanged:(NSNotification *)notification {
    
    if([[self placeholder] length] == 0)
        return;
    if([[self text] length] == 0)
        [[self viewWithTag:999] setAlpha:1];
    else
        [[self viewWithTag:999] setAlpha:0];
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    
    if( [[self placeholder] length] > 0 ) {
        
        if (_placeHolderLabel == nil ) {
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,8,self.bounds.size.width - 14,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        [[self viewWithTag:999] setAlpha:1];
    
    [self customizeTextView];
    
    [super drawRect:rect];
}


- (void)customizeTextView {
    
    [[self layer] setCornerRadius : 5.0f];
    [[self layer] setMasksToBounds: YES];
    
    self.layer.masksToBounds    = YES;
    self.layer.borderColor      = [[UIColor clearColor]CGColor];
    self.layer.borderWidth      = 1;
    self.backgroundColor        = [UIColor clearColor];
   // self.textAlignment          = NSTextAlignmentLeft;
    self.textColor              = [UIColor blackColor];
    [self setFont:self.placeholderFont];
    [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self  setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
}

@end
