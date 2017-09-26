//
//  SLHomeCollectionViewCell.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 21/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceDesc;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
