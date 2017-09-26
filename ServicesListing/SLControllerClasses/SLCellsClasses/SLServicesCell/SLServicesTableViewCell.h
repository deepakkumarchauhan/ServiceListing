//
//  SLServicesTableViewCell.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/19/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLServicesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewService;
@property (strong, nonatomic) IBOutlet UILabel *labelServiceName;
@property (strong, nonatomic) IBOutlet UILabel *labelServiceDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnDistance;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
