//
//  SLNotificationTableViewCell.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 20/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLNotificationTableViewCell.h"

@implementation SLNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    self.notificationImageView.layer.cornerRadius = self.notificationImageView.frame.size.width / 2;
    self.notificationImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
