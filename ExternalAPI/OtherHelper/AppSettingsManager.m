//
//  AppSettingsManager.m
//  IdeaPlayInterface
//
//  Created by Krishna Kant Kaira on 08/07/14.
//  Copyright (c) 2014 Mobiloitte Technologies. All rights reserved.
//

#import "AppSettingsManager.h"

@implementation AppSettingsManager

- (id) initSingleton {
    if ((self = [super init])) {
        _app_blueColor      = [UIColor colorWithRed:10.0/255.0 green:144.0/255.0 blue:208.0/255.0 alpha:1.00f];
        _app_greenColor     = [UIColor colorWithRed:0.0/255.0 green:179.0/255.0 blue:134.0/255.0 alpha:1.00f];
        _app_darkGreyColor  = [UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0];
        _app_redColor       = [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0];
        _app_lightGreyColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.925];    }
    return self;
}

+ (AppSettingsManager *) sharedinstance {
    
    // Persistent instance.
    static AppSettingsManager *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
        return _default;
    
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    
    dispatch_once(&safer, ^(void){
        _default = [[AppSettingsManager alloc] initSingleton];
    });
    
    return _default;
}

- (void)setObject:(id)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString*)key {
    
    return (key!=nil)?[[NSUserDefaults standardUserDefaults] objectForKey:key]:nil;
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setInteger:(int)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
    return [[self objectForKey:key] boolValue];
}

- (float)floatForKey:(NSString*)key {
    return [[self objectForKey:key] floatValue];
}
- (int)integerForKey:(NSString*)key {
    return [[self objectForKey:key] intValue];
}

- (double)doubleForKey:(NSString*)key {
    return [[self objectForKey:key] doubleValue];
}

-(UIFont*)app_HelveticaRegularWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Helvetica" size:size];
    
}
-(UIFont*)app_HelveticaThinWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    
}
-(UIFont*)app_HelveticaBoldWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}

-(UIFont*)app_HelveticaNeueMediumWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(float)getCurrentWindowWidth{
    
    float width;
    if (isiPaddevice()) {
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
            width = windowHeight;
        }else{
            width = windowWidth;
        }
    }else{
        width = 320;
    }
    return width;
}

BOOL isiPaddevice () {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+(BOOL)isIPadLandscape{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
        return YES;
    }else{
        return NO;
    }

}

@end
