//
//  SLNotificationModal.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/27/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface SLNotificationModal : NSObject

+(NSMutableArray *)notificationArrayFromResponse:(NSArray*)arrTemp;

@property (nonatomic,strong)NSString *strNotificationTitle;
@property (nonatomic,strong)NSString *strNotificationDescription;
@property (nonatomic,strong)NSString *strNotificationDate;
@property (nonatomic,strong)NSString *strNotificationId;
@property (nonatomic,strong)NSString *strUsername;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *strNotificationType;
@property (nonatomic,strong)NSString *strNotificationAddID;


@end
