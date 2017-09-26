//
//  AppDelegate.h
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JASidePanelController.h"
#import <UserNotifications/UserNotifications.h>
#import "SLTabBaseViewController.h"
@class JASidePanelController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
       CLLocationManager *locationManager;
}


typedef void(^addressCompletion)(NSString *);

@property (strong, nonatomic) UIWindow                * window;
@property (strong, nonatomic) UINavigationController  * navigationController;
@property (strong, nonatomic) UINavigationController  * sidePanelNavigation;
@property (strong, nonatomic) JASidePanelController   * customSlidePanel;
@property(strong,nonatomic)   NSString                * latitude;
@property(strong,nonatomic)   NSString                * longitude;
@property(strong,nonatomic)   NSString                * language;
@property (strong, nonatomic) NSString                * currentLocation;
@property (strong, nonatomic) CLLocation              * curLocation;
@property(strong,nonatomic)   NSString                * countryCode;

@property(assign,nonatomic)   NSInteger               notificationCount;
@property(assign,nonatomic)   BOOL                    isDontAllowPopUp;



@property(strong,nonatomic) SLTabBaseViewController *tabBar;
-(void)startLocationManager;
-(void)stopLocationManager;
-(JASidePanelController *)getNewRevealView;
-(void)logout;
- (UIImage *) captureScreen;

- (void)makeWebApiCallToGetNotificationCount;

-(BOOL)isArabic;
-(void)setIsArabic:(BOOL)arabic;
-(void)loginScreen;

@end

