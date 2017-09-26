//
//  SLEditServiceTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCustomTextFieldBlackPlaceholder.h"

@interface SLEditServiceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *editServiceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *editServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *availableButton;
@property (weak, nonatomic) IBOutlet UIButton *notAvailableButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportationLabel;

@end
