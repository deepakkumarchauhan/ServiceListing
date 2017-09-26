//
//  SLLanguageVC.h
//  ServicesListing
//
//  Created by Anil Kumar on 25/05/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLlanguageDelegate <NSObject>

-(void)delegateToGetLanguage:(NSString*)language;
-(void)delegateToSetUserLogin:(NSString*)type;

@end
@interface SLLanguageVC : UIViewController
@property(assign) BOOL isLanguagePopUp;
@property (strong,nonatomic)id <SLlanguageDelegate> delegate;
@end
