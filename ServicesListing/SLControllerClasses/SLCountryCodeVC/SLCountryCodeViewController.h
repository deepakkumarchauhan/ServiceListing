//
//  SLCountryCodeViewController.h
//  ServicesListing
//
//  Created by Deepak Chauhan on 07/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol countryProtocol <NSObject>

-(void)setCountryCode:(NSString *)countryCode;
@end

@interface SLCountryCodeViewController : UIViewController

@property(nonatomic,assign) NSArray *countryArray;
@property(nonatomic,strong) id <countryProtocol> delegate;
@property(nonatomic ,assign) BOOL isMobileCode;

@property(nonatomic ,assign) BOOL isFromPostAdd;


@end
