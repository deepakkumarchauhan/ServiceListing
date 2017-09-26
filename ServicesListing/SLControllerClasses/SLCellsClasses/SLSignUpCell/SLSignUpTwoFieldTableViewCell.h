//
//  SLSignUpTwoFieldTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCustomTextFieldBlackPlaceholder.h"

@interface SLSignUpTwoFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *signUpLeftTextField;
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *signUpRightTextField;

@end
