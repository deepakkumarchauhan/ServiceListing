//
//  SLSelectLanguageViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLSelectLanguageViewController.h"
#import "Header.h"

@interface SLSelectLanguageViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;

// UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *chooseLanguageLabel;

// UIButton Properties
@property (weak, nonatomic) IBOutlet SLCustomButton *englishButton;
@property (weak, nonatomic) IBOutlet SLCustomButton *arabicButton;

@end

@implementation SLSelectLanguageViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    // Ser MainView Corner Radius
    self.mainView.layer.cornerRadius = 5.0;
    self.chooseLanguageLabel.text = SLLocalizedString(@"Choose your language");
    [self.englishButton setTitle:SLLocalizedString(@"English") forState:UIControlStateNormal];
    [self.arabicButton setTitle:SLLocalizedString(@"Arabic") forState:UIControlStateNormal];
}

#pragma mark - UIButton Action

- (IBAction)englishButtonAction:(id)sender {
    
    [APPDELEGATE setIsArabic:NO];
    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
    
    [self.delegate didConfirmWithEnglish];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)arabicButtonAction:(id)sender {
    
    [APPDELEGATE setIsArabic:YES];
    
    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate didConfirmWithArabic];
    }];
}

- (IBAction)crossButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
