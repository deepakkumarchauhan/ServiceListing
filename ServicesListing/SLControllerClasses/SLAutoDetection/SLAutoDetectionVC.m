//
//  SLAutoDetectionVC.m
//  ServicesListing
//
//  Created by Shreya Singh on 24/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import "SLAutoDetectionVC.h"
#import "Header.h"
#import "SLContactUsViewController.h"

@interface SLAutoDetectionVC () <countryProtocol> {
    
    NSString * countryCodeString;
    SLUserInfoModel *userInfo;
}

@property (weak, nonatomic) IBOutlet UIButton * countryButton;
@property (weak, nonatomic) IBOutlet UIButton * languageButton;
@property (weak, nonatomic) IBOutlet UIView   * navView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoDetectionSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoDetectionLabel;
@property (weak, nonatomic) IBOutlet UIView *autoDetectview;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *dropImageView;

@end

@implementation SLAutoDetectionVC

#pragma mark - UIViewController LifeCycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Method

-(void)initialSetUp {
    
    [self.countryButton setTitle:SLLocalizedString(@"Country") forState:UIControlStateNormal];
    
    if (self.fromSidePanel) {
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    }
    else {
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }

    // Alloc Mode Class
    userInfo = [[SLUserInfoModel alloc] init];
    
    [self.navigationController setNavigationBarHidden:YES];
    
 if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
     [self.countryButton setHidden:YES];
     self.dropImageView.hidden = YES;
     self.addressLabel.text = [APPDELEGATE currentLocation];
     [self.autoDetectionSwitchButton setOn:YES];
     [self.addressLabel setHidden:NO];
     [self.backButton setHidden:NO];

 } else {
     [self.addressLabel setHidden:YES];
     [self.autoDetectionSwitchButton setOn:NO];
     [self.countryButton setHidden:NO];
     self.dropImageView.hidden = NO;

     if (self.fromSidePanel)
         [self.backButton setHidden:NO];
     else
         [self.backButton setHidden:YES];
 }
    self.navigationTitleLabel.text = SLLocalizedString(@"COUNTRY");
    
    if (!([[NSUSERDEFAULT valueForKey:@"CountryFullName"] isEqualToString:@""] || [[NSUSERDEFAULT valueForKey:@"CountryFullNameArabic"] isEqualToString:@""])) {
        if ([APPDELEGATE isArabic])
            [self.countryButton setTitle:[NSUSERDEFAULT valueForKey:@"CountryFullNameArabic"] forState:UIControlStateNormal];
        else
           [self.countryButton setTitle:[NSUSERDEFAULT valueForKey:@"CountryFullName"] forState:UIControlStateNormal];
    }
    else
        [self.countryButton setTitle:SLLocalizedString(@"Select Country") forState:UIControlStateNormal];

    self.autoDetectionLabel.text = SLLocalizedString(@"Auto detection location");

    if ([APPDELEGATE isArabic]) {
        [self.countryButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"languageArbNotification" object:nil];
        self.autoDetectionLabel.textAlignment = NSTextAlignmentRight;
        self.addressLabel.textAlignment = NSTextAlignmentRight;
        self.countryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    else {
        [self.countryButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"languageEngNotification" object:nil];
        self.autoDetectionLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.countryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationMessage) name:@"GetLocationNotification" object:nil];


}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.autoDetectview setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.locationView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    self.navigationTitleLabel.text = SLLocalizedString(@"COUNTRY");
    self.autoDetectionLabel.text = SLLocalizedString(@"Auto detection location");
    self.autoDetectionLabel.textAlignment = NSTextAlignmentLeft;
    self.countryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.countryButton setTitle:[NSUSERDEFAULT valueForKey:@"CountryFullName"] forState:UIControlStateNormal];
    
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageEngNotification" object:nil];
}

- (void)didConfirmWithArabic {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.autoDetectview setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.locationView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.navigationTitleLabel.text = SLLocalizedString(@"COUNTRY");
    self.autoDetectionLabel.text = SLLocalizedString(@"Auto detection location");
    self.autoDetectionLabel.textAlignment = NSTextAlignmentRight;
    self.addressLabel.textAlignment = NSTextAlignmentRight;
    self.countryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.countryButton setTitle:[NSUSERDEFAULT valueForKey:@"CountryFullNameArabic"] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageArbNotification" object:nil];
}

-(void)doCodeToObServeGetCountryCode:(NSNotification *)userINfo {
    
    NSDictionary * dict = userINfo.userInfo;
//    [NSUSERDEFAULT setBool:YES forKey:@"isSelectCountryWhenLaunch"];
    userInfo.address = [dict valueForKey:@"cName"];
    userInfo.arrAddress = [dict valueForKey:@"cNameArr"];
    userInfo.countryNCode = [dict valueForKey:@"countryNameCode"];
    
    if ([APPDELEGATE isArabic])
         [self.countryButton setTitle:userInfo.arrAddress forState:UIControlStateNormal];
    else
         [self.countryButton setTitle:userInfo.address forState:UIControlStateNormal];

    if (self.fromSidePanel || self.fromHome) {
        [self makeWebApiCallForUpdateLocation];
    }
}

- (void)receiveLocationMessage {
    
    if (self.autoDetectionSwitchButton.on)
        self.addressLabel.text = [[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation];
    
}


#pragma mark - Button Action Methods

- (IBAction)backButtonAction:(id)sender {
    
    if (self.fromSidePanel) {
        
        if ([APPDELEGATE isArabic])
            [self.sidePanelController showRightPanelAnimated:YES];
        else
            [self.sidePanelController showLeftPanelAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LanguageChageNotificationOnSidePannel"
         object:self];
    }
    else {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)countryButtonAction:(id)sender {
    
    SLCountryCodeViewController *countryVC = [[SLCountryCodeViewController alloc]initWithNibName:@"SLCountryCodeViewController" bundle:nil];
    
    if (self.fromSidePanel) {
        countryVC.isMobileCode = YES;
        [self presentViewController:countryVC animated:YES completion:nil];
    }
    else {
    countryVC.delegate = self;
    [self dismissViewControllerAnimated:NO completion:^{
        [[APPDELEGATE navigationController] presentViewController:countryVC animated:YES completion:nil];
}];
    }
    
//    SLCountryCodeViewController *countryVC = [[SLCountryCodeViewController alloc]initWithNibName:@"SLCountryCodeViewController" bundle:nil];
//    countryVC.delegate = self;
//    countryVC.isMobileCode = NO;
//    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:countryVC];
//    [navController setNavigationBarHidden:true];
//    [self presentViewController:navController animated:YES completion:^{
//    }];
////    [self dismissViewControllerAnimated:YES completion:^{
////        
////    }];
}

- (IBAction)languageButtonAction:(id)sender {
    [self.view endEditing:YES];
    [APPDELEGATE setIsArabic:![APPDELEGATE isArabic]];
    
    if ([APPDELEGATE isArabic]) {
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];
        [self didConfirmWithArabic];
    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
        [self didConfirmWithEnglish];
    }

}
- (IBAction)autoDetectionButtonAction:(UISwitch *)sender {
    
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {

        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Please enable location services in settings to continue using the app!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.autoDetectionSwitchButton setOn:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.autoDetectionSwitchButton setOn:NO];

                     }];
        [alert addAction:okAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:NO completion:nil];

        
       // [alert show];
    }
    else {
    
    if (sender.on) {
        [NSUSERDEFAULT setBool:YES forKey:@"autoDetection"];
        [NSUSERDEFAULT synchronize];
        self.addressLabel.text = [APPDELEGATE currentLocation];
        [self.countryButton setHidden:YES];
        self.dropImageView.hidden = YES;
        [self.addressLabel setHidden:NO];
        [self.backButton setHidden:NO];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GetLocationNotification"
         object:self];
        
        [self.delegate delegateToGetCountryCode];
        
        if (self.fromSidePanel || self.fromHome) {
            [self makeWebApiCallForUpdateLocation];
        }
        

    } else {
        [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];
        [NSUSERDEFAULT synchronize];
        [self.addressLabel setHidden:YES];
        [self.countryButton setHidden:NO];
        self.dropImageView.hidden = NO;

        if (self.fromSidePanel) {
            [self.backButton setHidden:NO];
        }
        else
            [self.backButton setHidden:YES];

    }
  }
}

#pragma mark - Custom Delegate Method

-(void)setCountryCode:(NSString *)countryCode {
    
   countryCodeString = countryCode;
    
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Service helper method

- (void)makeWebApiCallForUpdateLocation {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation] forKey:Klocation];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlatitude] forKey:Klatitude];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlongitude] forKey:Klongitude];
        [dictRequest setValue:[APPDELEGATE countryCode] forKey:KCountry];
    }
    else {
        [dictRequest setValue:userInfo.arrAddress forKey:KlocationArr];
        [dictRequest setValue:userInfo.address forKey:Klocation];
        [dictRequest setValue:@"" forKey:Klatitude];
        [dictRequest setValue:@"" forKey:Klongitude];
        [dictRequest setValue:userInfo.countryNCode forKey:KCountry];
    }

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiUpdateLocation WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
          //  NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                    [NSUSERDEFAULT setBool:NO forKey:@"isDontAllowPopUp"];
                    //[APPDELEGATE setIsDontAllowPopUp:NO];
                [NSUSERDEFAULT setValue:userInfo.countryNCode forKey:@"countryNCode"];
              //  [SLUtility alertWithTitle:SLLocalizedString(@"Success!") andMessage:strResponseMessage andController:self];
               
            }else{
               // [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



@end
