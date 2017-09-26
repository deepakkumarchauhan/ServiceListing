//
//  SLSignUpTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCustomTextFieldBlackPlaceholder.h"

@interface SLSignUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *signUpTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImageView;

@property (weak, nonatomic) IBOutlet UIButton *availableButton;
@property (weak, nonatomic) IBOutlet UILabel *transportLabel;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *notAvailableButton;
@end
