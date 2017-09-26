//
//  SLHomeViewController.h
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//
typedef enum Tab_Type{
    Tab_Type_None = 199,
    Tab_Type_Categories,
    Tab_Type_MyAds,
    Tab_Type_Favorites


}TabBarItem;

#import <UIKit/UIKit.h>

@interface SLTabBaseViewController : UIViewController
@property (assign, nonatomic) TabBarItem tabItem;

@property (assign, nonatomic) BOOL isFromNotification;


@end
