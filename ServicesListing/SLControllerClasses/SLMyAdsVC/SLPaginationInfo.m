//
//  ULPaginationInfo.m
//  UniLink
//
//  Created by Rakesh Bajeli on 26/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLPaginationInfo.h"
#import "NSDictionary+NullChecker.h"

@implementation SLPaginationInfo

+(SLPaginationInfo *)getPageInfo:(NSDictionary *)pageDict {

    
    SLPaginationInfo *page = [SLPaginationInfo new];
    [page setValue:[pageDict objectForKeyNotNull:@"pageNumber" expectedClass:[NSString class]] forKey:@"pageNumber"];
    [page setValue:[pageDict objectForKeyNotNull:@"per_page" expectedClass:[NSString class]] forKey:@"per_page"];
    [page setValue:[pageDict objectForKeyNotNull:@"totalRecord" expectedClass:[NSString class]] forKey:@"totalRecord"];
    [page setValue:[pageDict objectForKeyNotNull:@"maxpage" expectedClass:[NSString class]] forKey:@"maxpage"];
    
    return page;

    
}
@end
