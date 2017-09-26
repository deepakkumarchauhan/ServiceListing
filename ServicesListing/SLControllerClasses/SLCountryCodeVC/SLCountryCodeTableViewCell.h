//
//  SLCountryCodeTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 07/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCountryCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@end
