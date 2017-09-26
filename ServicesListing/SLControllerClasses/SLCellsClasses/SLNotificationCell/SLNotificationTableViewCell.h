//
//  SLNotificationTableViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 20/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificatinTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDateLabel;

@property (strong, nonatomic) IBOutlet UIView *mainViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;



@end
