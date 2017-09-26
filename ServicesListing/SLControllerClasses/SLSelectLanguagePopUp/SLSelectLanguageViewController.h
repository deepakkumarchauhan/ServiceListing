//
//  SLSelectLanguageViewController.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LanguageChangeDelegate <NSObject>

-(void)didConfirmWithEnglish;
-(void)didConfirmWithArabic;

@end


@interface SLSelectLanguageViewController : UIViewController


@property (nonatomic,assign) id<LanguageChangeDelegate>delegate;

@end
