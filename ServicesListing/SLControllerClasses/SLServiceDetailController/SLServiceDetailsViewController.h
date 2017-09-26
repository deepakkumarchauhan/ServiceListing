//
//  SLServiceDetailsViewController.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class SLServiceModal;

@protocol serviceDetailProtocol <NSObject>
-(void)deletePost;
@end

@interface SLServiceDetailsViewController : UIViewController

@property(nonatomic,strong) SLServiceModal *serviceModel;

@property(nonatomic,weak) id<serviceDetailProtocol> delegate;

@property(nonatomic,assign) BOOL isFromFavorite;

@property (nonatomic, strong) NSString * notificationIdString;

@property (assign, nonatomic) BOOL isFromPushNotification;

-(void)pushNotificationGetValue:(NSDictionary *)dict;

@end
