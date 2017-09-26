//
//  SLServiceDetailModal.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLServiceDetailModal : NSObject

+(SLServiceDetailModal *)serviceDetailFromResponse:(NSDictionary*)dictTemp;
+(SLServiceDetailModal *)serviceCurrentCommentResponse:(NSDictionary*)dictTemp;

@property (nonatomic,strong)NSString *strServiceName;
@property (nonatomic,strong)NSString *strCategory;
@property (nonatomic,strong)NSString *strPrice;
@property (nonatomic,strong)NSString *strTransportationAvail;
@property (nonatomic,strong)NSString *strServiceType;
@property (nonatomic,strong)NSString *strNid;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *strDescription;
@property (nonatomic,strong)NSString *strTotalLike;
@property (nonatomic,strong)NSString *strTotalView;
@property (nonatomic,strong)NSString *strDistance;
@property (nonatomic,strong)NSString *strUser_image;
@property (nonatomic,strong)NSString *strUser_firstName;
@property (nonatomic,strong)NSString *strUser_lastName;
@property (nonatomic,strong)NSString *strUser_mobileNo;
@property (nonatomic,strong)NSString *strUser_email;
@property (nonatomic,strong)NSString *strUser_transport;
@property (nonatomic,strong)NSString *strComm_firstName;
@property (nonatomic,strong)NSString *strComm_lastName;
@property (nonatomic,strong)NSString *strComm_commentedOn;
@property (nonatomic,strong)NSString *strComm_mobile;
@property (nonatomic,strong)NSString *strComment;
@property (nonatomic,strong)NSString *strComm_image;
@property (nonatomic,strong)NSString *strComm_UserId;
@property (nonatomic,strong)NSString *strComm_Email;
@property (nonatomic,strong)NSString *strLike_status;
@property (nonatomic,strong)NSString *strCategoryId;
@property (nonatomic,strong)NSString *strFav_status;
@property (nonatomic,strong)NSString *strIs_current_user_post;
@property (nonatomic,strong)NSString *strCommentId;

@property (nonatomic,strong)NSString *strPostDate;




@property (nonatomic,strong) UIImage *editImage;

@property (nonatomic,strong)NSMutableArray *commentArray;

@end
