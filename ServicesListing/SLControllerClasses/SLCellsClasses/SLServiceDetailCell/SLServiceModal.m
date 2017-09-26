//
//  SLServiceModal.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/21/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLServiceModal.h"
#import "Header.h"

@implementation SLServiceModal

+(NSMutableArray *)serviceArrayFromResponse:(NSArray*)arrTemp{
    
    NSMutableArray *arrFavourite = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictTemp in arrTemp) {
        
        SLServiceModal *favouriteInfoTemp = [[SLServiceModal alloc] init];
        
        favouriteInfoTemp.strNid          = [dictTemp objectForKeyNotNull:Knid expectedClass:[NSString class]];
        favouriteInfoTemp.strTitle        = [dictTemp objectForKeyNotNull:Ktitle expectedClass:[NSString class]];
        favouriteInfoTemp.strBody         = [dictTemp objectForKeyNotNull:Kbody expectedClass:[NSString class]];
        favouriteInfoTemp.strImage        = [dictTemp objectForKeyNotNull:Kimage expectedClass:[NSString class]];
        favouriteInfoTemp.strLikeCount    = [dictTemp objectForKeyNotNull:Klikecount expectedClass:[NSString class]];
        favouriteInfoTemp.strCommentcount = [dictTemp objectForKeyNotNull:Kcommentcount expectedClass:[NSString class]];
        favouriteInfoTemp.like_status     = [dictTemp objectForKeyNotNull:Klike_status expectedClass:[NSString class]];
        
        favouriteInfoTemp.postDate     = [dictTemp objectForKeyNotNull:KpostDate expectedClass:[NSString class]];

        
        if ([[dictTemp objectForKeyNotNull:Kdistance expectedClass:[NSString class]]isEqualToString:@""]) {
            favouriteInfoTemp.strDistance = @"";
        }else
        favouriteInfoTemp.strDistance     = [NSString stringWithFormat:@"%.2f Km",[[dictTemp objectForKeyNotNull:Kdistance expectedClass:[NSString class]] floatValue]];

        [arrFavourite addObject:favouriteInfoTemp];
        
    }
    return arrFavourite;

}

@end
