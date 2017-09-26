//
//  SLNotificationModal.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/27/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLNotificationModal.h"

@implementation SLNotificationModal

+(NSMutableArray *)notificationArrayFromResponse:(NSArray*)arrTemp {
    
    NSMutableArray *arrNotification = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictTemp in arrTemp) {
        
        SLNotificationModal *notiInfoTemp = [[SLNotificationModal alloc] init];
        
        notiInfoTemp.strNotificationId = [dictTemp objectForKeyNotNull:Knoti_id expectedClass:[NSString class]];
        notiInfoTemp.strNotificationTitle = [dictTemp objectForKeyNotNull:Ktitle expectedClass:[NSString class]];
        notiInfoTemp.strUsername = [dictTemp objectForKeyNotNull:Kusername expectedClass:[NSString class]];
        notiInfoTemp.strNotificationDate = [dictTemp objectForKeyNotNull:Kcreated expectedClass:[NSString class]];
        notiInfoTemp.image = [dictTemp objectForKeyNotNull:Kimage expectedClass:[NSString class]];
        notiInfoTemp.strNotificationType = [dictTemp objectForKeyNotNull:Ktype expectedClass:[NSString class]];
        notiInfoTemp.strNotificationAddID = [dictTemp objectForKeyNotNull:Knid expectedClass:[NSString class]];
        [arrNotification addObject:notiInfoTemp];
    }
    return arrNotification;
}

@end
