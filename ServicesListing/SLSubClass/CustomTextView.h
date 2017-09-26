//
//  CustomTextView.h
//  Qismet
//
//  Created by KrishnaKant kaira on 11/18/14.
//  Copyright (c) 2014 Qismet. All rights reserved.
//

#import "Header.h"

@interface CustomTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIFont *placeholderFont;
- (void)setPlaceholder:(NSString *)string;

@end
