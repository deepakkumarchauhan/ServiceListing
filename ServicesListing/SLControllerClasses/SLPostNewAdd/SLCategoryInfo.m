//
//  SLCategoryInfo.m
//  ServicesListing
//
//  Created by Mirza Zuhaib Beg on 1/9/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import "SLCategoryInfo.h"

@implementation SLCategoryInfo


+(NSMutableArray *)categoryArrayFromResponse:(NSArray*)arrTemp{

    NSMutableArray *arrCategory = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictTemp in arrTemp) {
        
        SLCategoryInfo *catInfoTemp = [[SLCategoryInfo alloc] init];
        catInfoTemp.service_name = [dictTemp objectForKeyNotNull:Kservice_name expectedClass:[NSString class]];
        catInfoTemp.service_category_id = [dictTemp objectForKeyNotNull:Kservice_category_id expectedClass:[NSString class]];
        catInfoTemp.image = [dictTemp objectForKeyNotNull:Kimage expectedClass:[NSString class]];
        catInfoTemp.icon_image = [dictTemp objectForKeyNotNull:Kicon_image expectedClass:[NSString class]];
        
        [arrCategory addObject:catInfoTemp];
        
    }
    return arrCategory;
}

@end
