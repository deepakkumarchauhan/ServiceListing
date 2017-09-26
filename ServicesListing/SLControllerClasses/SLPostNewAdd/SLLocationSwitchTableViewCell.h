//
//  SLLocationSwitchTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 19/06/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLocationSwitchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *changeLocationLabel;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@end
