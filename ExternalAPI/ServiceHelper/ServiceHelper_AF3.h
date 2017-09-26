//
//  ServiceHelper_AF3.h
//  SaruPayPOS
//
//  Created by Mirza Zuhaib Beg on 9/21/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Header.h"


// staging
//#define SERVICE_BASE_URL @"http://172.16.0.9/PROJECTS/ServiceListingApp/trunk/api"

#define SERVICE_BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/ServiceListingApp/trunk/api"




static NSString * apiGetUserId                    = @"getuserId";
static NSString * apiSignUp                       = @"signUp";
static NSString * apiLogIn                        = @"login";
static NSString * apiAddAdvertisement             = @"add_advertisement";
static NSString * apiservice_category_list        = @"service_category_list";
static NSString * apiResendOTP                    = @"resendOTP";
static NSString * apiVerifyOTP                    = @"verifyOTP";
static NSString * apiStaticPage                   = @"staticPages";
static NSString * apiContact_us                   = @"contact_us";
static NSString * apiGetprofile                   = @"getprofile";
static NSString * apiUpdateProfile                = @"updateProfile";
static NSString * apiLogout                       = @"logout";
static NSString * apiNotification_list            = @"notification_list";
static NSString * apiFavourite_advertisement_list = @"favourite_advertisement_list";
static NSString * apiMake_favourite_advertisement = @"make_favourite_advertisement";
static NSString * apiMy_advertisement             = @"my_advertisement";
static NSString * apiLike_advertisement           = @"like_advertisement";
static NSString * apiUnlike_advertisement         = @"unlike_advertisement";
static NSString * apiupdateProfilebyOTP           = @"updateProfilebyOTP";
static NSString * apiadvertisement_detail         = @"advertisement_detail";
static NSString * apipost_comment                 = @"post_comment";
static NSString * apidelete_advertisement         = @"delete_advertisement";
static NSString * apiedit_advertisement           = @"edit_advertisement";
static NSString * apirepost_advertisement         = @"repost_advertisement";
static NSString * apidelete_notification          = @"delete_notification";
static NSString * apireport                       = @"report";
static NSString * apimy_services                  = @"my_services";
static NSString * apimake_unfavourite_advertisement = @"make_unfavourite_advertisement";
static NSString * apisearch_serviceList           = @"search_serviceList";
static NSString * apihome_services_list           = @"home_services_list";
static NSString * apiDeleteComment                = @"delete_comment";
static NSString * apiUpdateLocation               = @"updatelocation";
static NSString * apiUpdateDeviceToken            = @"updatetoken";

static NSString * apiNotificationCount            = @"get_unreadcount";
static NSString * apiClearNotification            = @"clear_notification";


typedef void (^ServiceCompletionBlock)(BOOL suceeded, NSString *error,id response);

@interface ServiceHelper_AF3 : NSObject

@property (strong,nonatomic) ServiceCompletionBlock completionBlock;

@property (strong,nonatomic) AFHTTPSessionManager *manager;

+(id)instance;

-(void)makeGETWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeDeleteWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;

@end
