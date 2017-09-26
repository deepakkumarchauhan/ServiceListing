//
//  PlaceSuggestion.m
//  My Vina
//
//  Created by Yasmin Tahira on 3/26/14.
//  Copyright (c) 2014 Nidhi Sharma. All rights reserved.
//
//{
//    description = "Okhla Phase II, New Delhi, Delhi, India";
//    id = 60d3dc2b37cb9efd8d0fbaaac9407c377e2acfd0;
//    "matched_substrings" =     (
//                                {
//                                    length = 5;
//                                    offset = 0;
//                                }
//                                );
//    "place_id" = "ChIJyUwY-VfhDDkRMR44bYmEefw";
//    reference = "CkQ_AAAAQ8QB8G0fx_XizvqF9YKUqtS2c04JowPWh-tESO21Uih5mrxPH409OjK93ml_ZqCsucWuO1cNpop_dB4Okyq5jBIQevVWdahN0PqKCxF0kxTXfhoU5hnpWRJ04XXY_6RFyfbD9cr0fnA";
//    terms =     (
//                 {
//                     offset = 0;
//                     value = "Okhla Phase II";
//                 },
//                 {
//                     offset = 16;
//                     value = "New Delhi";
//                 },
//                 {
//                     offset = 27;
//                     value = Delhi;
//                 },
//                 {
//                     offset = 34;
//                     value = India;
//                 }
//                 );
//    types =     (
//                 "sublocality_level_2",
//                 sublocality,
//                 political,
//                 geocode
//                 );
//}

#import "PlaceSuggestion.h"

@implementation PlaceSuggestion

+(NSMutableArray *)getSearchInfoFromDict:(id)array {
    
    NSMutableArray *tempArray = [NSMutableArray array];

    for (id item in array) {
        
        PlaceSuggestion *searchObj = [[PlaceSuggestion alloc] init];
        NSLog(@"%@",item);
        [searchObj setDiscription:[item objectForKey:@"description"]];
        
//        NSMutableArray *arrTemp = [item objectForKeyNotNull:@"terms" expectedObj:[NSArray array]];
//        
//        if (arrTemp.count) {
//           NSDictionary *dictTemp =  [arrTemp firstObject];
//            if (dictTemp) {
//                searchObj.strShortdiscription = [dictTemp objectForKeyNotNull:@"value" expectedObj:@""];
//            }
//        }
        [tempArray addObject:searchObj];
    }

    return tempArray;
}

@end
