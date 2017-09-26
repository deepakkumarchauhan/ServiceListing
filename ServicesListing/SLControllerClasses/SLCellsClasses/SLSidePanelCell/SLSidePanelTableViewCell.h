//
//  SLSidePanelTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 19/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSidePanelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sideImageView;
@property (weak, nonatomic) IBOutlet UILabel *sideTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSeperatorLabel;

@property (strong, nonatomic) IBOutlet UIView *mainViewCell;


@end
