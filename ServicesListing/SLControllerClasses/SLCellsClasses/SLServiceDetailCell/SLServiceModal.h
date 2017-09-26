//
//  SLServiceModal.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/21/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLServiceModal : NSObject

+(NSMutableArray *)serviceArrayFromResponse:(NSArray*)arrTemp;

@property (nonatomic,assign)BOOL isLike;
@property (nonatomic,strong)NSString *strLikeCount;
@property (nonatomic,strong)NSString *strServiceName;

@property (nonatomic,strong)NSString *strNid;
@property (nonatomic,strong)NSString *strTitle;
@property (nonatomic,strong)NSString *strBody;
@property (nonatomic,strong)NSString *strImage;
@property (nonatomic,strong)NSString *strCommentcount;
@property (nonatomic,strong)NSString *like_status;
@property (nonatomic,strong)NSString *strDistance;

@property (nonatomic,strong)NSString *postDate;




@end
