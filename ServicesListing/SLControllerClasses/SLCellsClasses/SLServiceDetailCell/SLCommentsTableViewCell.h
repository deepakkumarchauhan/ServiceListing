//
//  SLCommentsTableViewCell.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCommentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewCommentPerson;
@property (strong, nonatomic) IBOutlet UILabel *labelNameCommentPerson;
@property (strong, nonatomic) IBOutlet UILabel *labelPhoneNumberCommentPerson;
@property (strong, nonatomic) IBOutlet UILabel *labelDescriptionCommentPerson;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeCommentPerson;

@property (strong, nonatomic) IBOutlet UIButton *btnMore;


@end
