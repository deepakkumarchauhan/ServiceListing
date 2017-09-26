//
//  SLTextFieldAndButtonTableViewCell.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface SLTextFieldAndButtonTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelLeftttl;
@property (strong, nonatomic) IBOutlet UITextField *textFieldRight;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;


@end
