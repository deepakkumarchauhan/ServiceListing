//
//  SLOtpViewController.h
//  ServiceListing
//
//  Created by Deepak Chauhan on 16/12/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTPVCDelegate <NSObject>

@optional

-(void)didUpdateMobilewithResponse:(NSDictionary*)dictTemp;

@end

@interface SLOtpViewController : UIViewController

@property (nonatomic,strong) NSString *otp;

@property (nonatomic,strong) NSDictionary *dictProfile;

@property (nonatomic,assign) BOOL isMobileUpdate;
@property (nonatomic,assign) BOOL fromSignUp;




@property (nonatomic,assign) id<OTPVCDelegate> delegate;

@end
