//
//  SLUserInfoModel.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLUserInfoModel.h"
#import "Header.h"

@implementation SLUserInfoModel

+(SLUserInfoModel *)profileFromResponse:(NSDictionary*)dictTemp{

    SLUserInfoModel *userInfoTemp = [[SLUserInfoModel alloc] init];
    
    userInfoTemp.userId = [dictTemp objectForKeyNotNull:KuserID expectedClass:[NSString class]];
    userInfoTemp.email = [dictTemp objectForKeyNotNull:KemailID expectedClass:[NSString class]];
    userInfoTemp.firstName = [dictTemp objectForKeyNotNull:Kfirstname expectedClass:[NSString class]];
    userInfoTemp.lastName = [dictTemp objectForKeyNotNull:Klastname expectedClass:[NSString class]];
    userInfoTemp.mobile = [dictTemp objectForKeyNotNull:Kmobile expectedClass:[NSString class]];
    userInfoTemp.dob = [dictTemp objectForKeyNotNull:Kdob expectedClass:[NSString class]];
    userInfoTemp.address = [dictTemp objectForKeyNotNull:Kaddress expectedClass:[NSString class]];
    userInfoTemp.lat = [dictTemp objectForKeyNotNull:Klat expectedClass:[NSString class]];
    userInfoTemp.lng = [dictTemp objectForKeyNotNull:Klon expectedClass:[NSString class]];
    
    userInfoTemp.imgUrl = [dictTemp objectForKeyNotNull:Kimage expectedClass:[NSString class]];
    if ([userInfoTemp.address isEqualToString:@""]) {
        userInfoTemp.address = [dictTemp objectForKeyNotNull:KCountry expectedClass:[NSString class]];
    }
    return userInfoTemp;
}



@end
