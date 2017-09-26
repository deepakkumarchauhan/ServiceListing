//
//  SLLanguageVC.m
//  ServicesListing
//
//  Created by Anil Kumar on 25/05/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import "SLLanguageVC.h"
#import "Header.h"

@interface SLLanguageVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *englishBtn;
@property (weak, nonatomic) IBOutlet UIButton *arabicBtn;
@property (weak, nonatomic) IBOutlet UIButton *freshUser;
@property (weak, nonatomic) IBOutlet UIButton *existingUser;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLLanguageVC

# pragma mark - View life cycle method.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitial];
}
-(void)setUpInitial{
    if (_isLanguagePopUp) {
        [self.titleLabel setHidden:NO];
        [self.englishBtn setHidden:NO];
        [self.arabicBtn setHidden:NO];
        [self.freshUser setHidden:YES];
        [self.existingUser setHidden:YES];
        [self.englishLabel setHidden:NO];
        [self.arabicLabel setHidden:NO];

    }else{
        [self.titleLabel setHidden:YES];
        [self.englishBtn setHidden:YES];
        [self.arabicBtn setHidden:YES];
        [self.freshUser setHidden:NO];
        [self.existingUser setHidden:NO];
        [self.englishLabel setHidden:YES];
        [self.arabicLabel setHidden:YES];
    }
    
    [self.freshUser setTitle:SLLocalizedString(@"NEW USER") forState:UIControlStateNormal];
    [self.existingUser setTitle:SLLocalizedString(@"EXISTING USER") forState:UIControlStateNormal];

}


# pragma mark - Memory Management Method.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBOutlet button Actions.
- (IBAction)englishLanguageBtnAction:(UIButton *)sender {
//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SLlanguageDelegate)]) {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [self.delegate delegateToGetLanguage:@"english"];
//        }];
//    }
    [APPDELEGATE setIsArabic:NO];
    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
    [self pushWithAnimation];
    self.isLanguagePopUp = NO;
    [self setUpInitial];

}
-(void)pushWithAnimation {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"pushIn"];
}
- (IBAction)arabicLanguageBtnAction:(UIButton *)sender {
    
    [APPDELEGATE setIsArabic:YES];
    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];

    [self pushWithAnimation];
    self.isLanguagePopUp = NO;
    [self setUpInitial];
//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SLlanguageDelegate)]) {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [self.delegate delegateToGetLanguage:@"arabic"];
//        }];
//    };
}
- (IBAction)newUserBtnAction:(UIButton *)sender {
    
    
    SLSignUpViewController *signUpVC = [[SLSignUpViewController alloc]initWithNibName:@"SLSignUpViewController" bundle:nil];
    signUpVC.fromLogIn = YES;
    [self.navigationController pushViewController:signUpVC animated:YES];
//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SLlanguageDelegate)]) {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [self.delegate delegateToSetUserLogin:@"new"];
//        }];
//    };
}

- (IBAction)existingUserBtnAction:(UIButton *)sender {
    
    //if user is existing.
    NSString *jwtObj = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-jwt"];
     [self makeWebApiCallForToRegisterUUID];


//    NSLog(@"%@",jwtObj);
//    if ([jwtObj intValue]) {
//        [[AppSettingsManager sharedinstance] setObject:jwtObj forKey:KDefaultUserID];
//        [[AppSettingsManager sharedinstance] setBool:YES forKey:KDefaultUserVerification];
//        [self.navigationController pushViewController:[APPDELEGATE getNewRevealView] animated:YES];
//    }else{
//       // [self makeWebApiCallForToRegisterUUID];
//        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"" andMessage:SLLocalizedString(@"Not an existing user.") onController:self];
//    }

//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SLlanguageDelegate)]) {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [self.delegate delegateToSetUserLogin:@"existing"];
//        }];
//    };
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallForToRegisterUUID {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
      [dictRequest setValue:Kios forKey:KdeviceType];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    NSString *jwtObj = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-Id"];
    [dictRequest setValue:jwtObj forKey:KdeviceID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiGetUserId WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"%@",response);
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AppSettingsManager sharedinstance] setBool:YES forKey:KDefaultUserVerification];
                [[AppSettingsManager sharedinstance] setObject:[response objectForKeyNotNull:KuserID expectedClass:[NSString class]] forKey:KDefaultUserID];
                [self.navigationController pushViewController:[APPDELEGATE getNewRevealView] animated:YES];
                
                }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    self.existingUser.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    [self.existingUser setTitle:@"" forState:UIControlStateNormal];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    self.existingUser.userInteractionEnabled = YES;
    [self.existingUser setTitle:@"EXISTING USER" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
