//
//  EWTextField.m
//  EWallet
//
//  Created by Deepak Chauhan on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLCustomTextField.h"

@implementation SLCustomTextField

- (void)awakeFromNib {
    [super awakeFromNib];
}

//-(void)setTextfieldTextAndPlaceholderColor {
//
//    UIColor *color = [UIColor grayColor];
//
//    self.textColor = color;
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
//}

-(void)drawPlaceholderInRect:(CGRect)rect {
    
    [[UIColor whiteColor] setFill];
    
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2 - 2, rect.size.width, self.font.pointSize+3);
    rect = placeholderRect;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:rect withAttributes:attr];
}

@end
