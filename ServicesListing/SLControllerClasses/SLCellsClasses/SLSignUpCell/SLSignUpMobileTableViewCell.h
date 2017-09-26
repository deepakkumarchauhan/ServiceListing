//
//  SLSignUpMobileTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCustomTextFieldBlackPlaceholder.h"

@interface SLSignUpMobileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *mobileCodeTextField;
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryPickerButton;

@end
