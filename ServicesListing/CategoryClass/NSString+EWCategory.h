//
//  NSString+EWCategory.h
//  EWallet
//
//  Created by Deepak Chauhan on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EWCategory)

-(BOOL)validateEmailAddressAndMobileNumber;
-(BOOL)validateEmailWithString;
-(BOOL)validatePhoneNumber;
//-(BOOL)containsOnlyNumbersAndDot;
-(BOOL)validateFirstName;
-(BOOL)validateFirstNameWithSpace;
-(BOOL)validateServiceNameWithSpace;

@end
