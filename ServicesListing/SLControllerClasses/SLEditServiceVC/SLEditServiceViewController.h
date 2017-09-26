//
//  SLEditServiceViewController.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLServiceDetailModal.h"

@protocol editServiceProtocol <NSObject>
-(void)editAdd;
@end

@interface SLEditServiceViewController : UIViewController

@property(nonatomic,weak) SLServiceDetailModal *serviceModel;
@property(nonatomic,strong) id<editServiceProtocol> delegate;

@end
