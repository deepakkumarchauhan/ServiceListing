//
//  DatePickerSheetView.m
//  VPW
//
//  Created by Sunil Verma on 9/30/14.
//  Copyright (c) 2014 Halosys. All rights reserved.
//

#import "DatePickerSheetView.h"
#import "AppDelegate.h"
#import "SLLanguageHandler.h"

@implementation DatePickerSheetView

PickerPickDateBlock datePickerBlock;
UIDatePicker *datePicker;

static DatePickerSheetView *datePickerManager = nil;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

+(void)showDatePickerWithDate:(NSDate *)date andMimumDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate AndTimeZone:(NSString *)timeZone WithReturnDate :(PickerPickDateBlock)block;
{
    datePickerBlock = [block copy];
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    datePickerManager = [[DatePickerSheetView alloc] init];

        datePicker = [[UIDatePicker alloc] init];
    [datePicker setBackgroundColor:[UIColor whiteColor]];

        [datePickerManager addSubview:datePicker];
    
    [datePickerManager setBackgroundColor:[UIColor whiteColor]];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, appDel.window.frame.size.width, 40)];
        [toolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:SLLocalizedString(@"Done") style:UIBarButtonItemStylePlain target:self action:@selector(doneActionSheet:)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:SLLocalizedString(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelActionSheet:)];
    
        UIBarButtonItem *flexibleSpace =   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems: [NSArray arrayWithObjects:cancelBtn,flexibleSpace,doneBtn, nil] animated:NO];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    [toolBar setBarTintColor:[UIColor lightGrayColor]];
    [datePickerManager addSubview:toolBar];
    
    [datePicker setFrame:CGRectMake(0, 40, appDel.window.frame.size.width, 216)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [datePicker setLocale:locale];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    if (date)
        [datePicker setDate:date animated:YES];
    else
        [datePicker setDate:[NSDate date] animated:YES];
    
    if(timeZone)
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    else
        [datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (minDate)
        [datePicker setMinimumDate:minDate];
    
    if (maxDate)
        [datePicker setMaximumDate:maxDate];

    UIView *tempView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [tempView setBackgroundColor:[UIColor blackColor]];
    [tempView setAlpha:0.0];
    [tempView setTag:111111];

    
    [appDel.window addSubview:tempView];
    [appDel.window addSubview:datePickerManager];
    [appDel.window bringSubviewToFront:datePickerManager];
    
    datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 260);

    [UIView animateWithDuration:0.1 animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -260, appDel.window.frame.size.width, 260);
        [tempView setAlpha:0.50];

    } completion:^(BOOL finished) {

    }];
}


+(void)cancelActionSheet:(id)sender
{
    //datePickerBlock(nil);
    [DatePickerSheetView removePickerView];
}


+(void)removePickerView
{
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [UIView animateWithDuration:0.1 animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 260);
        
    } completion:^(BOOL finished) {
        for (id obj  in datePickerManager.subviews) {
            [obj removeFromSuperview];
        }
        [datePickerManager removeFromSuperview];
        datePickerManager =nil;
        [[appDel.window viewWithTag:111111] removeFromSuperview];
    }];

}

#pragma mark - Action Sheet Callback function

+(void)doneActionSheet:(id)sender{
    datePickerBlock(datePicker.date);
    [DatePickerSheetView removePickerView];
}

@end
