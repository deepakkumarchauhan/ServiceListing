//
//  SLForgotViewController.m
//  ServiceListing
//
//  Created by Deepak Chauhan on 16/12/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "SLForgotViewController.h"
#import "SLCustomTextFieldBlackPlaceholder.h"
#import "Header.h"

@interface SLForgotViewController ()<UITextFieldDelegate,LanguageChangeDelegate> {
    SLUserInfoModel *userInfo;
    char test;
}

// TextField Properties
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *emailTextField;

// UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *forgotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//UIButton Properties
@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (weak, nonatomic) IBOutlet UIView *navView;

@end

@implementation SLForgotViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Method
-(void)initialSetup {
    
    // Alloc Model Class
    userInfo = [[SLUserInfoModel alloc]init];
    [self loginScreenLocalizationAndSemanticManagement];
}

-(void)loginScreenLocalizationAndSemanticManagement {
    
    if ([APPDELEGATE isArabic])
        self.emailTextField.textAlignment = NSTextAlignmentRight;
    else
        self.emailTextField.textAlignment = NSTextAlignmentLeft;
    
    // Set Titles
    self.forgotTitleLabel.text = SLLocalizedString(@"FORGOT PASSWORD");
    self.contentLabel.text = SLLocalizedString(@"Content");
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.emailTextField.placeholder = SLLocalizedString(@"Email/Mobile Number");
}


- (BOOL)validateFields {
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if (!userInfo.email.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter email and mobile") andController:self];
    
    else if ([userInfo.email rangeOfCharacterFromSet:notDigits].location == NSNotFound){
        if (userInfo.email.length<10 || userInfo.email.length>10)
            [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
        else
            return YES;
    }
    else if ([userInfo.email validateEmailWithString])
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate email") andController:self];
    else
        return YES;
    
    return NO;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    userInfo.email = TRIM_SPACE(textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if(str.length == 65){
        return NO;
    }
    
    return YES;
}


#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    self.emailTextField.textAlignment = NSTextAlignmentLeft;
    [self loginScreenLocalizationAndSemanticManagement];
}
- (void)didConfirmWithArabic {
    
    [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.emailTextField.textAlignment = NSTextAlignmentRight;
    [self loginScreenLocalizationAndSemanticManagement];
}

#pragma mark - UITouch Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIButton Action

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validateFields]) {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:([userInfo.email rangeOfCharacterFromSet:notDigits].location == NSNotFound)?SLLocalizedString(@"Password has been send to your mobile number"):SLLocalizedString(@"Password has been send to your email id") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:NO completion:nil];
        });
    }
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

@end
