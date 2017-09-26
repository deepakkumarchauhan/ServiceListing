//
//  DatePickerSheetView.h
//  VPW
//
//  Created by Sunil Verma on 9/30/14.
//  Copyright (c) 2014 Halosys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerPickDateBlock)(NSDate  *date);

@interface DatePickerSheetView : UIView

// class method use to show date picker
+(void)showDatePickerWithDate:(NSDate *)date andMimumDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate AndTimeZone:(NSString *)timeZone WithReturnDate :(PickerPickDateBlock)block;

@end
