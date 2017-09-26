//
//  EWUtility.h
//  EWallet
//
//  Created by Deepak Chauhan on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLUtility : NSObject

+(void)alertWithTitle : (NSString*)title andMessage:(NSString*)message andController:(id)controller;

+(UIBarButtonItem *) rightBarButton:(id)controller andImageName:(NSString*) imageName;
+(UIBarButtonItem *) leftBarButton:(id)controller andImageName:(NSString*) imageName;

+(UIBarButtonItem *) rightBarButtonTitle:(id)controller andTitle:(NSString*) title;

+(UIBarButtonItem *) leftBarButtonTitle:(id)controller andTitle:(NSString*) title;

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);


- (void) rightBarBtnAction:(UIButton *)sender;
- (void) leftBarBtnAction:(UIButton *)sender;

+(NSString*)getJSONFromDict:(NSDictionary*)dict;
+(NSString *)getHoursAgo:(NSString*)timestamp;
+ (NSString *) getDateFromTimestamp:(NSString *)timestamp;
+ (NSString *)getStringDateFromTimestamp:(NSString *)timestamp;
+ (NSString *)getCurrentDate;

@end
