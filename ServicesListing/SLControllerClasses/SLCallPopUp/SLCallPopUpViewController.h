//
//  SLCallPopUpViewController.h
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/22/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol callPopUpDelegate <NSObject>

-(void)dismisWithEmailOption:(NSInteger)buttonTag popUp:(BOOL)fromPopUp;

@end

@interface SLCallPopUpViewController : UIViewController

@property(assign,nonatomic)id <callPopUpDelegate>delegate;
@property (strong, nonatomic) NSString * commentUserIdString;
@property (strong, nonatomic) NSString * userIdString;


@end
