//
//  SLSortTableViewCell.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLSortTableViewCell.h"

@implementation SLSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.checkButton.layer.cornerRadius = self.checkButton.frame.size.width / 2;
    self.checkButton.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
