//
//  NSString+EWCategory.m
//  EWallet
//
//  Created by Deepak Chauhan on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "NSString+EWCategory.h"

@implementation NSString (EWCategory)


#pragma mark - email validation method

-(BOOL)validateEmailAddressAndMobileNumber {
    
   // NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    NSString *mobileNumberPattern = @"[1-9][0-9]";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    if ([emailTest evaluateWithObject:self] || [mobileNumberPred evaluateWithObject:self]) {
        return NO;
    }
    else{
        return YES;
    }
}

-(BOOL)validatePhoneNumber{
    
    NSString *mobileNumberPattern = @"[123456789][0-9]{9}";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    if ([mobileNumberPred evaluateWithObject:self])
        return NO;
    else
        return YES;
}

-(BOOL)validateFirstName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exprs];
    if ([emailTest evaluateWithObject:self]) {
        return NO;
    }
    else{
        return YES;
    }
}


-(BOOL)validateFirstNameWithSpace{
    
    NSString *stricterFilterString = @"^[a-zA-Z\\s]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if ([emailTest evaluateWithObject:self]) {
        return NO;
    }
    else{
        return YES;
    }

}

-(BOOL)validateServiceNameWithSpace{
    
    NSString *stricterFilterString = @"^[a-zA-Z0-9\\s]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if ([emailTest evaluateWithObject:self]) {
        return NO;
    }
    else{
        return YES;
    }
    
}



-(BOOL)validateEmailWithString{
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if ([emailTest evaluateWithObject:self]) {
        return NO;
    }
    else{
        return YES;
    }
}

@end
