//
//  SLOtpViewController.m
//  ServiceListing
//
//  Created by Deepak Chauhan on 16/12/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLOtpViewController.h"
#import "Header.h"


@interface SLOtpViewController ()<UITextFieldDelegate,LanguageChangeDelegate>{
    SLUserInfoModel *userInfo;
}

// UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otpContentLabel;

@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *otpTextField;

// UIButton Properties
@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *resendOtpButton;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *resendActivityIndicator;

@end

@implementation SLOtpViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.otp = @"";
//    userInfo.otp = @"";
//    self.otpTextField.text = self.otp;
    
    if (self.isMobileUpdate) {
        self.btnBack.hidden = NO;
    }else{
        self.btnBack.hidden = YES;
    }
    
    [self initialSetup];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    // Alloc Model Class
    userInfo = [[SLUserInfoModel alloc]init];
//    userInfo.otp = self.otp;
    [self.resendActivityIndicator setHidden:YES];
    [self loginScreenLocalizationAndSemanticManagement];
}

- (void)loginScreenLocalizationAndSemanticManagement {
    
    if ([APPDELEGATE isArabic])
        self.otpTextField.textAlignment = NSTextAlignmentRight;
    else
        self.otpTextField.textAlignment = NSTextAlignmentLeft;
    
    // Set Titles
    self.otpTextField.placeholder = SLLocalizedString(@"Please enter the activation code");
    self.titleLabel.text = SLLocalizedString(@"OTP");
    self.otpContentLabel.text = SLLocalizedString(@"OTPContent");
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedStringOtp = [[NSMutableAttributedString alloc] init];
    [attributedStringOtp appendAttributedString:[[NSAttributedString alloc] initWithString:SLLocalizedString(@"Resend OTP")
                                                                                attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: LBLUE_COLOR}]];
    
    [self.resendOtpButton setAttributedTitle:attributedStringOtp forState:UIControlStateNormal];
}

- (BOOL)validateFields {
    
    if (!userInfo.otp.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter otp") andController:self];
    else
        return YES;
    
    return NO;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    userInfo.otp = TRIM_SPACE(textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length == 13)
        return NO;
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.inputAccessoryView = toolBarForNumberPad(self,SLLocalizedString(@"Done"));
}

#pragma mark - Selector Method
- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    self.otpTextField.textAlignment = NSTextAlignmentLeft;
    [self loginScreenLocalizationAndSemanticManagement];
}
- (void)didConfirmWithArabic {
    
    [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.otpTextField.textAlignment = NSTextAlignmentRight;
    [self loginScreenLocalizationAndSemanticManagement];
}


#pragma mark - UIButton Action

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

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateFields]) {
        if (self.isMobileUpdate) {
            [self makeWebApiCallForUpdateMobileNo];
        }else{
            [self makeWebApiCallForVerifyOtp];
        }
    }
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if (self.isMobileUpdate) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)resendButtonAction:(id)sender {
    
    [self makeWebApiCallForResendOtp];
}

#pragma mark - Web Service API Methods

- (void)makeWebApiCallForVerifyOtp {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    
    NSString *stringOtp = [[userInfo.otp componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
    
    NSString *NumberString = stringOtp;
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:NumberString];
    
    [dictRequest setValue:newNum forKey:Kotp];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiVerifyOTP WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [APPDELEGATE makeWebApiCallToGetNotificationCount];
                
                if (self.fromSignUp) {
                    [NSUSERDEFAULT setBool:NO forKey:@"isDontAllowPopUp"];
                }
                [[AppSettingsManager sharedinstance] setBool:YES forKey:KDefaultUserVerification];
                
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

- (void)makeWebApiCallForResendOtp {
    
    [self.resendActivityIndicator startAnimating];
    [self.resendActivityIndicator setHidden:NO];
    [self.resendOtpButton setHidden:YES];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiResendOTP WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self.resendActivityIndicator stopAnimating];
        [self.resendActivityIndicator setHidden:YES];
        [self.resendOtpButton setHidden:NO];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [SLUtility alertWithTitle:SLLocalizedString(@"Success!") andMessage:strResponseMessage andController:self];
                
//                self.otpTextField.text = [response objectForKeyNotNull:Kotp expectedClass:[NSString class]];
                //userInfo.otp  = [response objectForKeyNotNull:Kotp expectedClass:[NSString class]];
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

- (void)makeWebApiCallForUpdateMobileNo {
    
    [self showLoader];
    
    [self.dictProfile setValue:userInfo.otp forKey:Kotp];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:self.dictProfile AndPath:apiupdateProfilebyOTP WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateMobilewithResponse:)]) {
                    [self.delegate didUpdateMobilewithResponse:response];
                }
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
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
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
