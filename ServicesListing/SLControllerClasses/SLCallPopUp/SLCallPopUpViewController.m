//
//  SLCallPopUpViewController.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/22/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLCallPopUpViewController.h"

@interface SLCallPopUpViewController () 
@property (strong, nonatomic) IBOutlet SLCustomButton *btnCall;
@property (strong, nonatomic) IBOutlet SLCustomButton *btnSms;
@property (strong, nonatomic) IBOutlet SLCustomButton *btnEmail;
@property (strong, nonatomic) IBOutlet SLCustomButton *btnReport;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet SLCustomButton *btnDelete;

@end

@implementation SLCallPopUpViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialSetUp];
}



#pragma mark - Custom Method

- (void)initialSetUp {
    
    [_btnCall setTitle:SLLocalizedString(@"Call") forState:UIControlStateNormal];
    [_btnSms setTitle:SLLocalizedString(@"SMS") forState:UIControlStateNormal];
    [_btnEmail setTitle:SLLocalizedString(@"Email") forState:UIControlStateNormal];
    [_btnReport setTitle:SLLocalizedString(@"Report") forState:UIControlStateNormal];
    [_btnDelete setTitle:SLLocalizedString(@"Delete") forState:UIControlStateNormal];

    NSLog(@"commentid= %@",self.commentUserIdString);
    NSLog(@"commentid= %@",self.userIdString);

    if ([[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] isEqualToString:self.userIdString]) {
        self.viewHeightConstraint.constant = 202.0f;
        
    } else {
        self.viewHeightConstraint.constant = 166.0f;
    }
}

#pragma mark - UIButton Action Method

-(IBAction)commonBtnActionMethod:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
            break;
            
        case 11:
        {
            //call
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.delegate dismisWithEmailOption:11 popUp:YES];
            
        }
            break;
            
        case 12:
        {
            //sms
             //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:1234567890"]];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate dismisWithEmailOption:12 popUp:YES];

            }];

        }
            break;
            
        case 13:
        {
            //email
            [self.delegate dismisWithEmailOption:13 popUp:YES];
            [self dismissViewControllerAnimated:NO completion:nil];

        }
            break;
            
        case 14:
        {
            //report
            [self.delegate dismisWithEmailOption:14 popUp:YES];
            [self dismissViewControllerAnimated:NO completion:nil];

            // [[AlertView sharedManager] displayInformativeAlertwithTitle:SLLocalizedString(@"Alert") andMessage:SLLocalizedString(@"Work In Progress!") onController:self];
        }
        case 15:
        {
            //Delete
            [self.delegate dismisWithEmailOption:15 popUp:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
            break;
        default:
            break;
    }
    
    
}



#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
