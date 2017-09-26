//
//  SLProfileTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 19/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleDescTextField;
@property (weak, nonatomic) IBOutlet UIButton *dobButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;

@end
