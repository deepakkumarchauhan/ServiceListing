//
//  SLCategoryInfo.h
//  ServicesListing
//
//  Created by Mirza Zuhaib Beg on 1/9/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface SLCategoryInfo : NSObject

@property (strong ,nonatomic) NSString *service_name;
@property (strong ,nonatomic) NSString *service_category_id;
@property (strong ,nonatomic) NSString *image;
@property (strong ,nonatomic) NSString *icon_image;

+(NSMutableArray *)categoryArrayFromResponse:(NSArray*)arrTemp;

@end
