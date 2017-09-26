//
//  SLUserInfoModel.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLUserInfoModel : NSObject



@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)UIImage *imageProfile;
@property (nonatomic,strong)NSString *imgUrl;

@property (nonatomic,strong)NSString *userId;

// Otp Screen
@property (nonatomic,strong)NSString *otp;

// Sign Up Screen
@property (nonatomic,strong)NSString *firstName;
@property (nonatomic,strong)NSString *lastName;
@property (nonatomic,strong)NSString *confirmPassword;
@property (nonatomic,strong)NSString *dob;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *arrAddress;

@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *lng;
@property (nonatomic,strong)NSString *countryCode;
@property (nonatomic,strong)NSString *countryNCode;
@property (nonatomic,strong)NSString *countryName;

// Post a New Add Screen
@property (nonatomic,strong)NSString *requirementName;
@property (nonatomic,strong)NSString *addDescription;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *categoryID;
@property (nonatomic,strong)NSString *serviceType;
@property (nonatomic,strong)NSString *transpotation;
@property (nonatomic,strong)NSString *serviceName;

@property (nonatomic,strong)NSString *subject;
@property (nonatomic,strong)NSString *report;

// Filter
@property (nonatomic,strong)NSString *from;
@property (nonatomic,strong)NSString *to;
@property (nonatomic,strong)NSString *distance;


// EditService
@property (nonatomic,assign)BOOL isAvailable;
@property (nonatomic,assign)BOOL isNotAvailable;

+(SLUserInfoModel *)profileFromResponse:(NSDictionary*)dictTemp;




@end
