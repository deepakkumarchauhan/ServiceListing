//
//  ULPaginationInfo.h
//  UniLink
//
//  Created by Rakesh Bajeli on 26/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPaginationInfo : NSObject

@property (assign , nonatomic) NSInteger pageNumber;
@property (assign , nonatomic) NSInteger per_page;
@property (assign , nonatomic) NSInteger totalRecord;
@property (assign , nonatomic) NSInteger maxpage;

+(SLPaginationInfo *)getPageInfo:(NSDictionary *)pageDict;
@end
