//
//  AppSettingsManager.h
//  IdeaPlayInterface
//
//  Created by Krishna Kant Kaira on 08/07/14.
//  Copyright (c) 2014 Mobiloitte Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#define windowHeight            [UIScreen mainScreen].bounds.size.height
#define windowWidth             [UIScreen mainScreen].bounds.size.width
@interface AppSettingsManager : NSObject

+ (AppSettingsManager *) sharedinstance;
- (void)setBool:(BOOL)value      forKey:(NSString*)key;
- (void)setFloat:(float)value    forKey:(NSString*)key;
- (void)setDouble:(double)value  forKey:(NSString*)key;
- (void)setInteger:(int)value    forKey:(NSString*)key;
- (void)setObject:(id)value      forKey:(NSString*)key;
- (BOOL)boolForKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;
- (int)integerForKey:(NSString*)key;
- (id)objectForKey:(NSString*)key;


@property (strong, readwrite) UIColor *app_blueColor;
@property (strong, readwrite) UIColor *app_greenColor;
@property (strong, readwrite) UIColor *app_redColor;
@property (strong, readwrite) UIColor *app_lightGreyColor;
@property (strong, readwrite) UIColor *app_darkGreyColor;


-(UIFont*)app_HelveticaRegularWithSize:(CGFloat)size;
-(UIFont*)app_HelveticaThinWithSize:(CGFloat)size;
-(UIFont*)app_HelveticaBoldWithSize:(CGFloat)size;
-(UIFont*)app_HelveticaNeueMediumWithSize:(CGFloat)size;

+(float)getCurrentWindowWidth;


@end
