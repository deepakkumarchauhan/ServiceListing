//
//  SLCountryListWithCode.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 07/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCountryListWithCode : NSObject

@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *countryNameCode;
@property (strong, nonatomic) NSString *countryNameArabic;

@property (assign, nonatomic) BOOL isSelect;


@end
