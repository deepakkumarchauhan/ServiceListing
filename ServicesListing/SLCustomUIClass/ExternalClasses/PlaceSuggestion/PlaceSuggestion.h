//
//  PlaceSuggestion.h
//  My Vina
//
//  Created by Yasmin Tahira on 3/26/14.
//  Copyright (c) 2014 Nidhi Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NSDictionary+NullChecker.h"

@interface PlaceSuggestion : NSObject

@property (strong, nonatomic) NSString      *discription;
@property (strong, nonatomic) NSString      *strShortdiscription;

+(NSMutableArray *)getSearchInfoFromDict:(id)array;

@end
