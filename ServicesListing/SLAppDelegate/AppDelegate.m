//
//  AppDelegate.m
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//o

#import "Header.h"
#import "Macro.h"
#import "SLTabBaseViewController.h"
#import "Branch.h"


@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate {

    BOOL isAppInBackground;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self getUserLocation];
    [self initialController];
    [self registerUserForPushNotification];
    
    if ([APPDELEGATE isArabic]) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[self.customSlidePanel view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];
    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[self.customSlidePanel view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
    }
    
    if (![[AppSettingsManager sharedinstance] boolForKey:KDefaultFilterState]) {
        [[AppSettingsManager sharedinstance] setObject:@"available" forKey:KDefaultAvailable];
        [[AppSettingsManager sharedinstance] setObject:@"10000" forKey:KDefaultDistance];
        [[AppSettingsManager sharedinstance] setBool:YES forKey:KDefaultFilterState];
    }

    // deeplinking
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error && params) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            NSLog(@"params: %@", params.description);
            
        }
        NSLog(@"params: %@", params.description);

    }];
    
    return YES;
}

// Respond to URI scheme links
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // pass the url to the handle deep link call
    [[Branch getInstance] handleDeepLink:url];
    // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    isAppInBackground = YES;
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (![[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] isEqualToString:@""]) {
        
        [self makeWebApiCallToGetNotificationCount];
    }
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    isAppInBackground = NO;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Initial Controller

-(void)initialController {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.navigationController.navigationBarHidden = YES;
    
    if ([[AppSettingsManager sharedinstance] boolForKey:KDefaultUserVerification]) {
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[APPDELEGATE getNewRevealView]];
        [self makeWebApiCallToGetNotificationCount];
    }else{
        SLLanguageVC * languageVC = [[SLLanguageVC alloc] initWithNibName:@"SLLanguageVC" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:languageVC];
        // self.isArabic = YES;
        languageVC.isLanguagePopUp = YES;
    }

    [self.navigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:self.navigationController];
    
//    SLLanguageVC * languageVC = [[SLLanguageVC alloc] initWithNibName:@"SLLanguageVC" bundle:nil];
//    languageVC.isLanguagePopUp = YES;
//    [self.navigationController presentViewController:languageVC animated:NO completion:nil];

}

#pragma mark - Add Reveal Method

-(void)logoutWithNotificationDict: (NSDictionary *)notificationDict{
    
    
    if (self.customSlidePanel) {
        
        if([[self.navigationController topViewController] isKindOfClass:[JASidePanelController class]]) {
            
            SLServiceDetailsViewController *slDetailsVC = [[SLServiceDetailsViewController alloc]initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
            [slDetailsVC setNotificationIdString:[notificationDict objectForKeyNotNull:Knid expectedClass:[NSString class]]];
            [slDetailsVC setIsFromPushNotification:YES];
            [self.navigationController pushViewController:slDetailsVC animated:YES];
            
        }
        else {
            self.navigationController = [[UINavigationController alloc]initWithRootViewController:[self getNewRevealView]];
            self.navigationController.navigationBarHidden = YES;
            SLServiceDetailsViewController *slDetailsVC = [[SLServiceDetailsViewController alloc]initWithNibName:@"SLServiceDetailsViewController" bundle:nil];

            [slDetailsVC setNotificationIdString:[notificationDict objectForKeyNotNull:Knid expectedClass:[NSString class]]];
            [slDetailsVC setIsFromPushNotification:YES];

            [self.navigationController pushViewController:slDetailsVC animated:YES];
        }
    }
}

-(void)loginScreen {
    
    self.navigationController.navigationBarHidden = YES;
    SLLoginViewController *logInVC = [[SLLoginViewController alloc]initWithNibName:@"SLLoginViewController" bundle:nil];

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:logInVC];
    [self.window setRootViewController:self.navigationController];
}

-(JASidePanelController *)getNewRevealView {
    
    self.customSlidePanel = nil;
    self.customSlidePanel = [[JASidePanelController alloc] init];
    self.customSlidePanel.leftFixedWidth = [[UIScreen mainScreen] bounds].size.width-97;
    self.customSlidePanel.rightFixedWidth = [[UIScreen mainScreen] bounds].size.width-97;
    self.customSlidePanel.shouldDelegateAutorotateToVisiblePanel = NO;
    self.sidePanelNavigation = [[UINavigationController alloc]initWithRootViewController:[[SLTabBaseViewController alloc] initWithNibName:@"SLTabBaseViewController" bundle:nil]];
    self.sidePanelNavigation.navigationBarHidden = YES;
    self.customSlidePanel.centerPanel = self.sidePanelNavigation;
    self.customSlidePanel.leftPanel = [[SLSidePanelViewController alloc] initWithNibName:@"SLSidePanelViewController" bundle:nil];
    self.customSlidePanel.rightPanel = [[SLSidePanelViewController alloc] initWithNibName:@"SLSidePanelViewController" bundle:nil];;
    return self.customSlidePanel;
}

//#pragma mark - Get User Location Method
-(void)getUserLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
   // [NSUSERDEFAULT setBool:YES forKey:@"autoDetection"];

}

-(void)startLocationManager {
    [NSUSERDEFAULT setBool:YES forKey:@"autoDetection"];
    [locationManager startUpdatingLocation];
}

-(void)stopLocationManager {
    [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.latitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
    
    
    [[AppSettingsManager sharedinstance] setObject:self.latitude forKey:KDefaultlatitude];
    [[AppSettingsManager sharedinstance] setObject:self.longitude forKey:KDefaultlongitude];
    
    [locationManager stopUpdatingLocation];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[self.latitude floatValue] longitude:[self.longitude floatValue]];
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self.currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        
        self.countryCode = placemark.ISOcountryCode;
        
        [[AppSettingsManager sharedinstance] setObject:self.currentLocation forKey:KDefaultLocation];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GetLocationNotification"
         object:self];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            
            [NSUSERDEFAULT setBool:YES forKey:@"isDontAllowPopUp"];
            //self.isDontAllowPopUp = YES;
            
//            [SLUtility alertWithTitle:@"App Permission Denied" andMessage:@"To re-enable, please go to Settings and turn on Location Services for this app." andController:self];
        }
    }
}

//// get lat long from string
//-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
//    double latitude = 0, longitude = 0;
//    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//    if (result) {
//        NSScanner *scanner = [NSScanner scannerWithString:result];
//        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
//            [scanner scanDouble:&latitude];
//            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
//                [scanner scanDouble:&longitude];
//            }
//        }
//    }
//    CLLocationCoordinate2D center;
//    center.latitude=latitude;
//    center.longitude = longitude;
//    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
//    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
//    return center;
//    
//}

#pragma mark - Push notification

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[AppSettingsManager sharedinstance] setObject:token forKey:KDefaultDeviceToken];
    if (![[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] isEqualToString:@""]) {
        [self makeWebApiCallForDeviceToken];
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

}

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//    
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"%@",userInfo);
    [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Test Alert" andMessage:@"testing" onController:[[APPDELEGATE navigationController] topViewController]];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =  [UIApplication sharedApplication].applicationIconBadgeNumber +1;
    
    NSDictionary * tempDict = [NSDictionary dictionaryWithDictionary:userInfo];
    NSDictionary * apsDict = [NSDictionary dictionaryWithDictionary:[tempDict objectForKeyNotNull:@"type" expectedClass:[NSDictionary class]]];
    
        dispatch_async(dispatch_get_main_queue(), ^{
        if (isAppInBackground) {
            if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] length]) {
                if([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[SLServiceDetailsViewController class]]){
                }
                else
                [self logoutWithNotificationDict:apsDict];
            }
        } else {
            if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] length]) {
                if([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[SLServiceDetailsViewController class]]){
                }
                else
                [self logoutWithNotificationDict:apsDict];
            }
        }
    });
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{

    NSDictionary *userInfo = notification.request.content.userInfo;
    
    [SLUtility alertWithTitle:@"" andMessage:[[userInfo objectForKeyNotNull:@"aps" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"alert" expectedClass:[NSString class]] andController:[APPDELEGATE navigationController]];
    [self makeWebApiCallToGetNotificationCount];

}


#pragma mark - Helper Methods

/** Register For Push notification service**/
-(void)registerUserForPushNotification{
    
    //For iOS version 10 and above
    if ([UIDevice currentDevice].systemVersion.floatValue  >= 10.0) {
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
    }else{
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
}

#pragma mark - Notification Method for ios 10

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    

    [self makeWebApiCallToGetNotificationCount];
    
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"getNotificationCount" object:nil];

    NSDictionary * tempDict = [NSDictionary dictionaryWithDictionary:response.notification.request.content.userInfo];
    NSDictionary * apsDict = [NSDictionary dictionaryWithDictionary:[tempDict objectForKeyNotNull:@"info" expectedClass:[NSDictionary class]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isAppInBackground) {
            if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] length]) {
                if([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[SLServiceDetailsViewController class]]){
                }
                else
                    [self logoutWithNotificationDict:apsDict];
            }
        } else {
            if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] length]) {
                if([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[SLServiceDetailsViewController class]]){
                }
                else
                    [self logoutWithNotificationDict:apsDict];
            }
        }
    });
}

-(void)toGetController {
    
    if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] length]) {
        
        if([[[APPDELEGATE navigationController] topViewController] isKindOfClass:[SLServiceDetailsViewController class]]){
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:nil andMessage:[NSString stringWithFormat:@"%@",[[APPDELEGATE navigationController] topViewController]]onController:[[APPDELEGATE navigationController] topViewController]];
              //[AlertController title:@"Nofication"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshScreenForTheItem" object:nil];
            
        }
        else {
           [[AlertView sharedManager] displayInformativeAlertwithTitle:nil andMessage:[NSString stringWithFormat:@"%@",[[APPDELEGATE navigationController] topViewController]]onController:[[APPDELEGATE navigationController] topViewController]];
            
            SLServiceDetailsViewController *tabVC = [[SLServiceDetailsViewController alloc]initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
            tabVC.isFromPushNotification = YES;
            [self.navigationController pushViewController:tabVC animated:YES];
//              [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshScreenForTheItem" object:nil];
            //            for (UIViewController *viewController in [APPDELEGATE navigationController].viewControllers) {
            //                if([viewController isKindOfClass:[SLServiceDetailsViewController class]]) {
            //                    [[APPDELEGATE navigationController] popViewControllerAnimated:YES];
            //                    break;
            //                }
        }
    }
}

- (UIImage *) captureScreen {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Language Methods

-(BOOL)isArabic{

    BOOL arabic = [[AppSettingsManager sharedinstance] boolForKey:KDefaultLanguage];
    return arabic;
}

-(void)setIsArabic:(BOOL)arabic{

    [[AppSettingsManager sharedinstance] setBool:arabic forKey:KDefaultLanguage];
}


- (void)makeWebApiCallForDeviceToken {
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultDeviceToken] forKey:KdeviceToken];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:Kios forKey:KdeviceType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiUpdateDeviceToken WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
        }else{
            
        }
    }];
}


- (void)makeWebApiCallToGetNotificationCount {
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiNotificationCount WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            self.notificationCount = [[response objectForKeyNotNull:@"unread_count" expectedClass:[NSString class]]intValue];
            //self.notificationCount = 2;

            [[NSNotificationCenter defaultCenter]postNotificationName:@"getNotificationCount" object:nil];
            
        }else{
            
        }
    }];
}





@end
