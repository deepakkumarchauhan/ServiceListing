//
//  SLLoginViewController.m
//  ServiceListing
//
//  Created by Deepak Chauhan on 16/12/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLTabBaseViewController.h"
#import "SLLanguageHandler.h"
#import "Header.h"

#define WindowHeight [UIScreen mainScreen].bounds.size.height

@interface SLLoginViewController () <UITextFieldDelegate,LanguageChangeDelegate,SLlanguageDelegate> {
    
    SLUserInfoModel *userInfo;
}

//TextFields Properties
@property (weak, nonatomic) IBOutlet SLCustomTextField *emailTextField;
@property (weak, nonatomic) IBOutlet SLCustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet SLCustomTextField *mobileTextField;

//UIButton Properties
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


//UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rememberMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *freshUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *orEmailMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *orSocialLabel;

@property (strong, nonatomic) IBOutlet EDKeyboardAvoidingScrollView *scrollView;

//UIView Properties
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation SLLoginViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    userInfo = [[SLUserInfoModel alloc]init];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialAppearMethod];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    if (WindowHeight == 480)
        self.scrollView.scrollEnabled = YES;
    else
        self.scrollView.scrollEnabled = NO;
    
    // Set Submit Button Border Width
    self.submitButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.submitButton.layer.borderWidth = 1.0;
    [self loginScreenLocalizationAndSemanticManagement];
}

- (void)initialAppearMethod {
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([APPDELEGATE isArabic])
        [self didConfirmWithArabic];
    else
        [self didConfirmWithEnglish];
}

- (void)loginScreenLocalizationAndSemanticManagement {
    
    NSMutableAttributedString *attributedStringForgot = [[NSMutableAttributedString alloc] init];
    [attributedStringForgot appendAttributedString:[[NSAttributedString alloc] initWithString:SLLocalizedString(@"Forgot password?")
                                                                                   attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    
    [self.forgotButton setAttributedTitle:attributedStringForgot forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedStringSignUp = [[NSMutableAttributedString alloc] init];
    [attributedStringSignUp appendAttributedString:[[NSAttributedString alloc] initWithString:SLLocalizedString(@"Sign up")
                                                                                   attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    
    [self.signUpButton setAttributedTitle:attributedStringSignUp forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedStringTerms = [[NSMutableAttributedString alloc] init];
    [attributedStringTerms appendAttributedString:[[NSAttributedString alloc] initWithString:SLLocalizedString(@"Terms & Services")
                                                                                  attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    
    [self.submitButton setTitle:SLLocalizedString(@"LOGIN") forState:UIControlStateNormal];
    [self.forgotButton setTitle:SLLocalizedString(@"Forgot password?") forState:UIControlStateNormal];
    self.rememberMeLabel.text = SLLocalizedString(@"Remember me");
    self.freshUserLabel.text = SLLocalizedString(@"New user?");
    self.orEmailMobileLabel.text = SLLocalizedString(@"OR");
    self.orSocialLabel.text = SLLocalizedString(@"OR");
    self.emailTextField.placeholder = SLLocalizedString(@"Email");
    self.passwordTextField.placeholder = SLLocalizedString(@"Password");
    self.mobileTextField.placeholder = SLLocalizedString(@"Mobile Number");
}

- (BOOL)validateFields {
    
    NSString *phoneNumber = userInfo.mobile;
    NSString *testNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    if (!userInfo.mobile.length) {
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter mobile") andController:self];
    }else if (userInfo.mobile.length<6 || testNumber.length == 0){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
    }else
        return YES;
    
    return NO;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 102)
        textField.inputAccessoryView = toolBarForNumberPad(self,SLLocalizedString(@"Done"));
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    switch (textField.tag) {
        case 100:
            userInfo.email = TRIM_SPACE(textField.text);
            break;
        case 101:
            userInfo.password = TRIM_SPACE(textField.text);
            break;
        case 102:
            userInfo.mobile = TRIM_SPACE(textField.text);
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 100) {
        UITextField *txtField = [self.view viewWithTag:101];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    else if (textField.tag == 100 && str.length == 65)
        return NO;
    
    else if (textField.tag == 101 && str.length == 17)
        return NO;
    
    else if (textField.tag == 102 && str.length > 16)
        return NO;
    
    return YES;
}


#pragma mark - Selector Method
- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

#pragma mark - language selection Delegate method
- (void)didConfirmWithEnglish {
    
    [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    self.emailTextField.textAlignment = NSTextAlignmentLeft;
    self.passwordTextField.textAlignment = NSTextAlignmentLeft;
    self.mobileTextField.textAlignment = NSTextAlignmentLeft;
    [self.mainView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
}

- (void)didConfirmWithArabic {
    
    [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    self.emailTextField.textAlignment = NSTextAlignmentRight;
    self.passwordTextField.textAlignment = NSTextAlignmentRight;
    self.mobileTextField.textAlignment = NSTextAlignmentRight;
    [self.mainView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
}
-(void)delegateToSetUserLogin:(NSString*)type{
    NSLog(@"i'm here");
    [self.view endEditing:YES];
    if ([type isEqualToString:@"new"]) {
        SLSignUpViewController *signUpVC = [[SLSignUpViewController alloc]initWithNibName:@"SLSignUpViewController" bundle:nil];
        signUpVC.fromLogIn = YES;
        [self.navigationController pushViewController:signUpVC animated:YES];
    }else{
        //if user is existing.
        NSString *jwtObj = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-jwt"];
        NSLog(@"%@",jwtObj);
        if ([jwtObj intValue]) {
            [[AppSettingsManager sharedinstance] setObject:jwtObj forKey:KDefaultUserID];
            [self.navigationController pushViewController:[APPDELEGATE getNewRevealView] animated:YES];
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:@"" andMessage:SLLocalizedString(@"Not an existing user.") onController:self];
        }
    }

}
-(void)delegateToGetLanguage:(NSString *)language{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //load your data here.
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([language isEqualToString:@"english"]) {
                [APPDELEGATE setIsArabic:NO];
                [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
                [self didConfirmWithEnglish];
            }else{
                [APPDELEGATE setIsArabic:YES];
                [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];
                [self didConfirmWithArabic];
            }        });
    });
    [self performSelector:@selector(showPopUp) withObject:nil afterDelay:0.2];
    
}
-(void)showPopUp{
    //     Present language options.
    SLLanguageVC *objVC = [[SLLanguageVC alloc]initWithNibName:@"SLLanguageVC" bundle:nil];
    objVC.delegate = self;
    [self.navigationController presentViewController:objVC animated:YES completion:nil];
}
#pragma mark - UIButton Action
- (IBAction)loginButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateFields]) {
        [self makeWebApiCallForLogIn];
    }
}

- (IBAction)signUpButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLSignUpViewController *signUpVC = [[SLSignUpViewController alloc]initWithNibName:@"SLSignUpViewController" bundle:nil];
    signUpVC.fromLogIn = YES;
    [self.navigationController pushViewController:signUpVC animated:YES];
}


- (IBAction)forgotButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLForgotViewController *forgotVC = [[SLForgotViewController alloc]initWithNibName:@"SLForgotViewController" bundle:nil];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (IBAction)selectLanguageButtonAction:(id)sender {
    
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

- (IBAction)rememberMeButtonAction:(id)sender {
    
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
}

- (IBAction)facebookButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLCompleteProfileViewController *profileVC = [[SLCompleteProfileViewController alloc]initWithNibName:@"SLCompleteProfileViewController" bundle:nil];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)googleButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLCompleteProfileViewController *profileVC = [[SLCompleteProfileViewController alloc]initWithNibName:@"SLCompleteProfileViewController" bundle:nil];
    [self.navigationController pushViewController:profileVC animated:YES];
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallForLogIn {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    NSString *NumberString = userInfo.mobile;
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:NumberString];
    
   // NSString *encryptedMobile = [AESTool encryptData:[NSString stringWithFormat:@"%@",newNum] withKey:KAES_ENCRYPT_KEY];
    
    [dictRequest setValue:newNum forKey:KmobileNo];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultDeviceToken] forKey:KdeviceToken];
    [dictRequest setValue:Kios forKey:KdeviceType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation] forKey:Klocation];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [dictRequest setValue:uniqueIdentifier forKey:KdeviceID];
  //  NSLog(@"%@",dictRequest);

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiLogIn WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"%@",response);
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AppSettingsManager sharedinstance] setObject:[response objectForKeyNotNull:Kuid expectedClass:[NSString class]] forKey:KDefaultUserID];
                
                [[AppSettingsManager sharedinstance] setObject:[NSString stringWithFormat:@"%@ %@",[response objectForKeyNotNull:Kfirstname expectedClass:[NSString class]],[response objectForKeyNotNull:Klastname expectedClass:[NSString class]]] forKey:KDefaultUserName];
                [[AppSettingsManager sharedinstance] setObject:[response objectForKeyNotNull:Kimage expectedClass:[NSString class]] forKey:KDefaultUserProfile];
                
                userInfo.mobile = @"";
                self.mobileTextField.text = @"";
                
                [APPDELEGATE makeWebApiCallToGetNotificationCount];
                [[AppSettingsManager sharedinstance] setBool:YES forKey:KDefaultUserVerification];
                
                //remove previous value stored in keychain.
                [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-user-jwt"];
                
                // Store data in keychain here.
                [[A0SimpleKeychain keychain] setString:[response objectForKeyNotNull:Kuid expectedClass:[NSString class]] forKey:@"auth0-user-jwt"];
                NSString *jwtObj = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-jwt"];
                NSLog(@"%@",jwtObj);
                
                [self.navigationController pushViewController:[APPDELEGATE getNewRevealView] animated:YES];
//                SLOtpViewController *otpVC = [[SLOtpViewController alloc]initWithNibName:@"SLOtpViewController" bundle:nil];
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
    
    [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.submitButton.enabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    [self.submitButton setTitle:SLLocalizedString(@"LOGIN") forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.submitButton.enabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
