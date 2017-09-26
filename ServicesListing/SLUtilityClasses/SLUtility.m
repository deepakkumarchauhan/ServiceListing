//
//  EWUtility.m
//  EWallet
//
//  Created by Deepak Chauhan on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLUtility.h"
#import "Macro.h"
#import "SLLanguageHandler.h"

@implementation SLUtility
//
+(void)alertWithTitle : (NSString*)title andMessage:(NSString*)message andController:(id)controller{
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:NO completion:nil];
}


+(UIBarButtonItem *) rightBarButtonTitle:(id)controller andTitle:(NSString*)rightTitle {
    //NSString *str = [NSString stringWithFormat:title,nil];
    NSString *str = rightTitle;
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTitle:str forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, 50,25 );
    [aButton  addTarget:controller action:@selector(rightBarBtnAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    return aBarButtonItem;
    
}
+(UIBarButtonItem *) leftBarButtonTitle:(id)controller andTitle:(NSString *)leftTitle {
    NSString *string = leftTitle;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTitle:string forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0.0, 0.0,50,25);
    [leftButton  addTarget:controller action:@selector(leftBarBtnAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    return aBarButtonItem;
}

+(UIBarButtonItem *) rightBarButton:(id)controller andImageName:(NSString*) imageName{
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height );
    [aButton  addTarget:controller action:@selector(rightBarBtnAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    return aBarButtonItem;
}


-(void) rightBarBtnAction:(UIButton *)sender{
    
}

+(UIBarButtonItem *) leftBarButton:(id)controller andImageName:(NSString*) imageName{
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height );
    [aButton  addTarget:controller action:@selector(leftBarBtnAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    return aBarButtonItem;
}

-(void) leftBarBtnAction:(UIButton *)sender{
    
}


UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],nil];
    
    numberToolbar.barTintColor = [UIColor whiteColor];
    
    [numberToolbar sizeToFit];
    
    return numberToolbar;
}

-(void)doneWithNumberPad {
    
}

+(NSString*)getJSONFromDict:(NSDictionary*)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)getDateFromTimestamp:(NSString *)timestamp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy, hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //NSDate *date = [dateFormatter dateFromString:publicationDate];
    NSString *dte=[dateFormatter stringFromDate:date];
    
    return dte;
}


+ (NSString *)getStringDateFromTimestamp:(NSString *)timestamp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //NSDate *date = [dateFormatter dateFromString:publicationDate];
    NSString *dte=[dateFormatter stringFromDate:date];
    
    return dte;
}

+(NSString *)getHoursAgo:(NSString*)timestamp {
    
        NSString *_timeElapsed = nil;
        
        NSDate *date_current = [NSDate date];
        
        NSTimeInterval noOfSec = [date_current timeIntervalSince1970] - [timestamp doubleValue];
        
        int sec = noOfSec;
        
        int days = noOfSec / (60 * 60 * 24);
        
        int hours = noOfSec / (60 * 60);
        
        int minutes = noOfSec / 60;
        
        int weeks = days/7;
        
        if (weeks == 0) {
            
            if (days == 0) {
                
                if (hours == 0) {
                    
                    if (minutes == 0) {
                        
                        if (sec <= 0) {
                            _timeElapsed = @"just now";
                        }else{
                            _timeElapsed = [NSString stringWithFormat:@"%d sec",sec];

                        }
                    }else{
                        
                        _timeElapsed = [NSString stringWithFormat:@"%d min",minutes];
                        
                    }
                }
                
                else{
                    
                    _timeElapsed = [NSString stringWithFormat:@"%d hour",hours];
                    
                }
            }
            
            else{
                
                _timeElapsed = [NSString stringWithFormat:@"%d day",days];
                
            }
        }
        else{
            
            _timeElapsed = [NSString stringWithFormat:@"%d week",weeks];
        }
        
        return _timeElapsed;
    
}

+(NSString*)getCurrentDate
{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *result = [NSString stringWithFormat:@"%f",timeStamp];
    return result;
}


@end
