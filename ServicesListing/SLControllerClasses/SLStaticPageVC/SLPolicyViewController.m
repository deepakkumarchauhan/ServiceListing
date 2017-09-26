//
//  SLPolicyViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 20/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLPolicyViewController.h"
#import "Header.h"

@interface SLPolicyViewController ()<LanguageChangeDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addPostButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;

@end

@implementation SLPolicyViewController

#pragma mark - UIView LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self initialSetup];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
   // [self.addPostButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");

    if (self.fromSignUp) {
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.addPostButton setHidden:YES];
    }
    else {
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [self.addPostButton setHidden:NO];
    }
    
    [self makeWebApiCallForStaticPage];
    
    if ([self.type isEqualToString:@"terms&services"]) {
        self.titleLabel.text = SLLocalizedString(@"TERMS & SERVICES");
    }
    else{
        self.titleLabel.text = SLLocalizedString(@"PRIVACY POLICY");
    }
    
    if ([APPDELEGATE isArabic]) {
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
}

- (void)didConfirmWithArabic {
    
    [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoader];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoader];
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

- (IBAction)backButtonAction:(id)sender {
    
    if (self.fromSignUp)
        [self.navigationController popViewControllerAnimated:YES];
    else {
        if ([APPDELEGATE isArabic])
            [self.sidePanelController showRightPanelAnimated:YES];
        else
            [self.sidePanelController showLeftPanelAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LanguageChageNotificationOnSidePannel"
         object:self];
    }
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallForStaticPage {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:self.type forKey:Ktype];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiStaticPage WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [self.webView loadHTMLString:strResponseMessage baseURL:nil];

            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
                [self hideLoader];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            [self hideLoader];
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
