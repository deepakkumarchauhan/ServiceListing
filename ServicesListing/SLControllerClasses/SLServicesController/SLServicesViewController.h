//
//  SLServicesViewController.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/19/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"


@interface SLServicesViewController : UIViewController

@property(nonatomic,assign)BOOL fromSidePanel;

@property(nonatomic,strong) NSString *categoryId;
@property(nonatomic,strong) NSString *categoryName;
@end
