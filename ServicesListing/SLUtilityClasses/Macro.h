//
//  Macro.h
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#endif /* Macro_h */

//Color Macros
#define LBLUE_COLOR  [UIColor colorWithRed:71.0/255.0f green:88.0/255.0f blue:149.0/255.0f alpha:1.0f]
#define LNAV_COLOR [UIColor colorWithRed:57.0/255.0 green:71.0/255.0 blue:135.0/255.0 alpha:1.0f]

#define windowHeight [UIScreen mainScreen].bounds.size.height
#define windowWidth [UIScreen mainScreen].bounds.size.width
#define NSUSERDEFAULT        [NSUserDefaults standardUserDefaults]
#define APPDELEGATE             (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define TRIM_SPACE(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]


#define KNOTIFICATION_GRID_LIST_VIEW @"NOTIFICATION_GRID_LIST_VIEW"
#define KNOTIFICATION_SEARCH_VIEW_EDITED @"NOTIFICATION_SEARCH_VIEW_EDITED"
#define KNOTIFICATION_SEARCH_VIEW_CANCELLED @"NOTIFICATION_SEARCH_VIEW_CANCELLED"

#define KNOTIFICATION_ALL_SEARCH_VIEW_EDITED @"NOTIFICATION_ALL_SEARCH_VIEW_EDITED"
#define KNOTIFICATION_LANGUAGE_CHANGED @"NOTIFICATION_LANGUAGE_CHANGED"
#define KNOTIFICATION_UPDATE_FAVORITE_LIST @"NOTIFICATION_UPDATE_FAVORITE_LIST"
#define KNOTIFICATION_UPDATE_PROFILE @"NOTIFICATION_UPDATE_PROFILE"

#define KCALL_ALL_SEARCH_API         @"CALL_ALL_SEARCH_API"

#define KGET_CATEGORY_ID             @"GET_CATEGORY_ID"

#define KNOTIFICATION_RELOAD_TABLE   @"NOTIFICATION_RELOAD_TABLE"
#define KNOTIFICATION_SORT           @"NOTIFICATION_SORT"
#define KNOTIFICATION_FILTER         @"NOTIFICATION_FILTER"

#define KDefaultView @"DefaultView"

#define GOOGLE_GEOLOCATION_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/"

#define GOOGLE_API_KEY   @"AIzaSyBwveE3mtcdUWozHPtET70gbXP17YLX9uI"

#define ACCEPTABLE_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

#define PARAM_PRIDICTION    @"predictions"


#define KresponseMessage        @"responseMessage"
#define KresponseCode           @"responseCode"
#define KSuccessCode            200
#define KSuccess                @"Success!"
#define KError                  @"Error!"
#define Kar                     @"ar"
#define Ken                     @"en"

#define KDefaultUserID          @"DefaultUserID"
#define KDefaultUserVerification  @"DefaultUserVerification"

#define KDefaultlanguageType    @"languageType"
#define KDefaultLocation        @"DefaultLocation"
#define KDefaultLanguage        @"DefaultLanguage"
#define KDefaultDeviceToken     @"DefaultDeviceToken"
#define KDefaultlatitude        @"Defaultlatitude"
#define KDefaultlongitude       @"Defaultlongitude"
#define KDefaultUserName        @"DefaultUserName"
#define KDefaultUserProfile     @"DefaultUserProfile"


#define KDefaultAvailable       @"DefaultAvailable"
#define KDefaultDistance        @"DefaultDistance"
#define KDefaultFilterState        @"DefaultFilterState"
#define KDefaultSort            @"DefaultSort"
#define KmobileNo               @"mobileNo"
#define Kotp                    @"otp"
#define Ktype                   @"type"

#define Kdescription            @"description"
#define Ksubject                @"subject"

#define Klocation               @"location"
#define KlocationArr            @"locationarabic"


#define KdeviceToken            @"deviceToken"

#define KdeviceID               @"deviceID"


#define KdeviceType             @"deviceType"
#define Kios                    @"iOS"
#define Kuid                    @"uid"
#define Klatitude               @"latitude"
#define Klongitude              @"longitude"
#define KlanguageType           @"languageType"
#define KcountryCode            @"countryCode"
#define KfirstName              @"firstName"
#define KlastName               @"lastName"
#define KCountry                @"country"

#define KemailID                @"emailID"
#define Kfirstname              @"firstname"
#define Klastname               @"lastname"
#define Kmobile                 @"mobile"
#define Kdob                    @"dob"
#define Kaddress                @"address"
#define Klat                    @"lat"
#define Klon                    @"lon"
#define Kemail                  @"email"
#define Kusername               @"username"
#define Kcreated                @"created"



#define Knoti_id                @"noti_id"
#define Ktitle                  @"title"
#define KnotificationList       @"notificationList"
#define Kmy_fav_advertisement_list  @"my_fav_advertisement_list"
#define Kmyadvertisement_list       @"myadvertisement_list"
#define Kmyservices_list        @"myservices_list"

#define Kservices_list          @"services_list"

#define KuserID                 @"userID"
#define KrequirementName        @"requirementName"
#define Kcategory               @"category"
#define KserviceType            @"serviceType"
#define Kservice_Type           @"service_type"
#define Ksorttype               @"sorttype"

#define KownserviceSearch       @"ownserviceSearch"

#define Ktransportation         @"transportation"
#define Kprice                  @"price"
#define Kimage                  @"image"
#define KlanguageType           @"languageType"
#define Kservice_name           @"service_name"
#define Kservice_category_id    @"service_category_id"
#define Kicon_image             @"icon_image"
#define Kservice_category_list  @"service_category_list"
#define KprofileDetail          @"profileDetail"
#define Kcategory_id            @"category_id"

#define Kfav_status            @"fav_status"
#define Kis_current_user_post  @"is_current_user_post"


#define KCid                   @"cid"

#define Knid                    @"nid"
#define Kbody                   @"body"
#define Klikecount              @"likecount"
#define Kcommentcount           @"commentcount"
#define KchangeMobileStatus     @"changeMobileStatus"
#define KpageNumber             @"pageNumber"
#define KpageSize               @"pageSize"
#define Klike_status            @"like_status"
#define KpostDate               @"postDate"

#define KtotalLikes             @"totalLikes"
#define Kservice_category       @"service_category"


#define KAES_ENCRYPT_KEY        @"1234567887654321"

//Pageination
#define kpagination             @"pagination"

#define Kcategory_name          @"category_name"
#define Ktransport              @"transport"
#define Kservice_type           @"service_type"
#define Ktotalviews             @"totalviews"
#define Kview                   @"view"

#define Kdistance               @"distance"
#define Kuser_image             @"user_image"
#define Kuser_firstName         @"user_firstName"
#define Kuser_lastName          @"user_lastName"
#define Kuser_mobileNo          @"user_mobileNo"
#define Kuser_email             @"user_email"
#define Kuser_transport         @"user_transport"
#define Kcomments               @"comments"

#define Kcomm_firstName         @"comm_firstName"
#define Kcomm_lastName          @"comm_lastName"
#define Kcomm_commentedOn       @"comm_commentedOn"
#define Kcomm_mobile            @"comm_mobile"
#define Kcomment                @"comment"
#define Kcomm_image             @"comm_image"


#define Kcomm_email             @"comm_email"
#define Kcomm_uid               @"comm_uid"

#define Kid                     @"id"

#define KcategoryType           @"categoryType"

#define KcommentId             @"comm_id"



//#define Kcomment                @"comment"



//

////////// Validation Messages////////
//
//static NSString *validateEmail          = @"Please enter a valid email id.";
//static NSString *fillPassword           = @"Please enter password.";
//static NSString *validatePasswordLength = @"Password must be in between 8 to 16 characters.";
//static NSString *fillEmail              = @"Please enter email id.";
//static NSString *validateEmailorMobile              = @"Please enter valid email id/Mobile number.";
//static NSString *fillEmailorMobile              = @"Please enter email id/Mobile number.";
//
//
//static NSString *fillFirstName               = @"Please enter first name.";
//static NSString *fillLastName               = @"Please enter last name.";
//
//
//static NSString *fillMobile             = @"Please enter mobile number.";
//static NSString *validateMobileNumber   = @"Please enter a valid mobile number.";
//static NSString *agreeToTerms           = @"Please agree to terms and conditions.";
//static NSString *fillOldPassword        = @"Please enter old password.";
//
//static NSString *fillNewPassword        = @"Please enter new password.";
//static NSString *validateNewPassLength  = @"New password must be atleast 8 characters.";
//static NSString *fillConfirmPassword    = @"Please enter confirm password.";
//static NSString *validateConfirmPassLength = @"Confirm password must be in between 8 to 16 characters.";
//static NSString *validateConfirmAndNewPass = @"New password and Confirm password does not match.";
//
//static NSString *validatePasswordAndConfirmPass = @"Password and Confirm password does not match.";
//
//static NSString *fillOtpNumber             = @"Please enter otp number.";
//static NSString *validateOtpNumber         = @"Please enter valid otp number.";
//static NSString *fillDateOfBirth             = @"Please select date of birth.";
//static NSString *fillAddress             = @"Please enter address.";
//
//
//static NSString *noCamera              = @"Device has no camera.";






