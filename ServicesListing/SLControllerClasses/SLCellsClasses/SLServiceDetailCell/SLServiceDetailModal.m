//
//  SLServiceDetailModal.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLServiceDetailModal.h"
#import "Header.h"

@implementation SLServiceDetailModal

+(SLServiceDetailModal *)serviceDetailFromResponse:(NSDictionary*)dictTemp{
    
    SLServiceDetailModal *serviceInfoTemp = [[SLServiceDetailModal alloc] init];
    serviceInfoTemp.commentArray = [NSMutableArray array];
    
    serviceInfoTemp.strNid = [dictTemp objectForKeyNotNull:Knid expectedClass:[NSString class]];
    serviceInfoTemp.image = [dictTemp objectForKeyNotNull:Kimage expectedClass:[NSString class]];
    serviceInfoTemp.strServiceName = [dictTemp objectForKeyNotNull:Kservice_name expectedClass:[NSString class]];
    serviceInfoTemp.strCategory = [dictTemp objectForKeyNotNull:Kcategory_name expectedClass:[NSString class]];
    serviceInfoTemp.strCategoryId = [dictTemp objectForKeyNotNull:Kcategory_id expectedClass:[NSString class]];
    serviceInfoTemp.strCategoryId = [dictTemp objectForKeyNotNull:Kcategory_id expectedClass:[NSString class]];
    
    serviceInfoTemp.strPostDate = [dictTemp objectForKeyNotNull:KpostDate expectedClass:[NSString class]];


    serviceInfoTemp.strFav_status = [dictTemp objectForKeyNotNull:Kfav_status expectedClass:[NSString class]];
    
    serviceInfoTemp.strIs_current_user_post = [dictTemp objectForKeyNotNull:Kis_current_user_post expectedClass:[NSString class]];
    
    serviceInfoTemp.strPrice = [dictTemp objectForKeyNotNull:Kprice expectedClass:[NSString class]];
    serviceInfoTemp.strTransportationAvail = [dictTemp objectForKeyNotNull:Ktransport expectedClass:[NSString class]];
    serviceInfoTemp.strServiceType = [dictTemp objectForKeyNotNull:Kservice_Type expectedClass:[NSString class]];
    serviceInfoTemp.strDescription = [dictTemp objectForKeyNotNull:Kdescription expectedClass:[NSString class]];
    serviceInfoTemp.strTotalLike = [dictTemp objectForKeyNotNull:KtotalLikes expectedClass:[NSString class]];
    serviceInfoTemp.strTotalView = [dictTemp objectForKeyNotNull:Ktotalviews expectedClass:[NSString class]];
    serviceInfoTemp.strLike_status = [dictTemp objectForKeyNotNull:Klike_status expectedClass:[NSString class]];
    
    
    
    if ([[dictTemp objectForKeyNotNull:Kdistance expectedClass:[NSString class]]isEqualToString:@""]) {
        //serviceInfoTemp.strDistance = @"Unknown";
        serviceInfoTemp.strDistance = @"";
    }else
        serviceInfoTemp.strDistance     = [NSString stringWithFormat:@"%.2f",[[dictTemp objectForKeyNotNull:Kdistance expectedClass:[NSString class]] floatValue]];

    
   // serviceInfoTemp.strDistance = [NSString stringWithFormat:@"%.2f",[[dictTemp objectForKeyNotNull:Kdistance expectedClass:[NSString class]] floatValue]];
    
    serviceInfoTemp.strUser_image = [dictTemp objectForKeyNotNull:Kuser_image expectedClass:[NSString class]];
    serviceInfoTemp.strUser_firstName = [dictTemp objectForKeyNotNull:Kuser_firstName expectedClass:[NSString class]];
    serviceInfoTemp.strUser_lastName = [dictTemp objectForKeyNotNull:Kuser_lastName expectedClass:[NSString class]];
    serviceInfoTemp.strUser_mobileNo = [dictTemp objectForKeyNotNull:Kuser_mobileNo expectedClass:[NSString class]];
    serviceInfoTemp.strUser_email = [dictTemp objectForKeyNotNull:Kuser_email expectedClass:[NSString class]];
    serviceInfoTemp.strUser_transport = [dictTemp objectForKeyNotNull:Kuser_transport expectedClass:[NSString class]];
    
    [serviceInfoTemp.commentArray addObjectsFromArray:[self serviceCommentResponse:[dictTemp objectForKeyNotNull:Kcomments expectedClass:[NSArray class]]]];
    
    return serviceInfoTemp;
}

+(NSMutableArray *)serviceCommentResponse:(NSArray*)arrTemp {
    
    
    NSMutableArray *arrComment = [[NSMutableArray alloc]init];
    for (NSDictionary *commentDict in arrTemp) {
        
        SLServiceDetailModal *commentInfoTemp = [[SLServiceDetailModal alloc] init];
        commentInfoTemp.strComm_firstName = [commentDict objectForKeyNotNull:Kcomm_firstName expectedClass:[NSString class]];
        commentInfoTemp.strComm_lastName = [commentDict objectForKeyNotNull:Kcomm_lastName expectedClass:[NSString class]];
        commentInfoTemp.strComm_commentedOn = [commentDict objectForKeyNotNull:Kcomm_commentedOn expectedClass:[NSString class]];
        commentInfoTemp.strComm_mobile = [commentDict objectForKeyNotNull:Kcomm_mobile expectedClass:[NSString class]];
        commentInfoTemp.strComment = [commentDict objectForKeyNotNull:Kcomment expectedClass:[NSString class]];
        commentInfoTemp.strComm_image = [commentDict objectForKeyNotNull:Kcomm_image expectedClass:[NSString class]];
        
        commentInfoTemp.strComm_UserId = [commentDict objectForKeyNotNull:Kcomm_uid expectedClass:[NSString class]];
        commentInfoTemp.strComm_Email = [commentDict objectForKeyNotNull:Kcomm_email expectedClass:[NSString class]];
        commentInfoTemp.strCommentId = [commentDict objectForKeyNotNull:KcommentId expectedClass:[NSString class]];

        
        [arrComment addObject:commentInfoTemp];
    }
    return arrComment;
}


+(SLServiceDetailModal *)serviceCurrentCommentResponse:(NSDictionary*)dictTemp {
    
        SLServiceDetailModal *commentInfoTemp = [[SLServiceDetailModal alloc] init];
    
        commentInfoTemp.strComm_firstName = [dictTemp objectForKeyNotNull:Kcomm_firstName expectedClass:[NSString class]];
        commentInfoTemp.strComm_lastName = [dictTemp objectForKeyNotNull:Kcomm_lastName expectedClass:[NSString class]];
    
        commentInfoTemp.strComm_commentedOn = [SLUtility getCurrentDate];
       // commentInfoTemp.strComm_commentedOn = [dictTemp objectForKeyNotNull:Kcomm_commentedOn expectedClass:[NSString class]];
        commentInfoTemp.strComm_mobile = [dictTemp objectForKeyNotNull:Kcomm_mobile expectedClass:[NSString class]];
        commentInfoTemp.strComment = [dictTemp objectForKeyNotNull:Kcomment expectedClass:[NSString class]];
        commentInfoTemp.strComm_image = [dictTemp objectForKeyNotNull:Kcomm_image expectedClass:[NSString class]];
        
        commentInfoTemp.strComm_UserId = [dictTemp objectForKeyNotNull:Kcomm_uid expectedClass:[NSString class]];
        commentInfoTemp.strComm_Email = [dictTemp objectForKeyNotNull:Kcomm_email expectedClass:[NSString class]];
    commentInfoTemp.strCommentId = [dictTemp objectForKeyNotNull:@"comm_id" expectedClass:[NSString class]];
        
    return commentInfoTemp;
}


@end
