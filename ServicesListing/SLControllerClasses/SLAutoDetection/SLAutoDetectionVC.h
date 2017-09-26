//
//  SLAutoDetectionVC.h
//  ServicesListing
//
//  Created by Shreya Singh on 24/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLAutoDetectionLocationVCDelegate <NSObject>

//-(void)SetAutoDetectionLocation:(NSString *)countryName;
-(void)delegateToGetCountryCode;
@end

@interface SLAutoDetectionVC : UIViewController

@property (assign, nonatomic) id <SLAutoDetectionLocationVCDelegate>delegate;
@property (assign, nonatomic) BOOL isAutoDetectionOn;
@property (assign, nonatomic) BOOL fromSidePanel;

@property (assign, nonatomic) BOOL fromHome;


@end
