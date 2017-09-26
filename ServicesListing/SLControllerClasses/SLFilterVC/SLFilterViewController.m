//
//  SLFilterViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLFilterViewController.h"
#import "Header.h"

@interface SLFilterViewController ()<UITextFieldDelegate,LanguageChangeDelegate> {
    NSArray *transportationArray;
    NSArray *distanceArray;
    SLUserInfoModel *filterInfo;
    NSString *transportationStr;
    NSString *distanceStr;

}

// UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transpotationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

// UITextFields Properties
@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *distanceTextField;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet SLCustomButton *applyButton;
@property (weak, nonatomic) IBOutlet SLCustomButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transpotationTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *availableButton;
@property (weak, nonatomic) IBOutlet UIButton *notAvailableButton;
@property (weak, nonatomic) IBOutlet UIView *transportView;

@end

@implementation SLFilterViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Alloc Model Class
    filterInfo = [[SLUserInfoModel alloc]init];
    filterInfo.transpotation = @"Yes";

    self.availableButton.selected = YES;
    transportationStr = @"available";
    distanceStr = @"10";

    self.distanceTextField.text = SLLocalizedString(@"10");
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    // Set Titles and TextField Placeholder
    self.titleLabel.text = SLLocalizedString(@"FILTER");
    self.transpotationLabel.text = SLLocalizedString(@"Transportation");
    self.distanceLabel.text = SLLocalizedString(@"Distance (Km)");
    
    [self.availableButton setTitle:SLLocalizedString(@"Available") forState:UIControlStateNormal];
    [self.notAvailableButton setTitle:SLLocalizedString(@"Not Available") forState:UIControlStateNormal];

    [self.cancelButton setTitle:SLLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [self.applyButton setTitle:SLLocalizedString(@"Apply") forState:UIControlStateNormal];
    
    self.distanceTextField.placeholder = SLLocalizedString(@"Distance");
    self.transpotationTopConstraint.constant = 30;
    
//    self.availableButton.selected = YES;
    
    // Alloc Array
    transportationArray = [[NSArray alloc]initWithObjects:@"Yes",@"No",@"Both",nil];
    distanceArray = [[NSArray alloc]initWithObjects:@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"1000",@"10000",nil];
    
    if ([APPDELEGATE isArabic]){
        
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.headerView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.transpotationLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceTextField.textAlignment = NSTextAlignmentRight;
        
        [self.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        self.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.availableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];
        [self.notAvailableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];

    }else{
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];

        [self.headerView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.transpotationLabel.textAlignment = NSTextAlignmentLeft;
        self.distanceLabel.textAlignment = NSTextAlignmentLeft;
        self.distanceTextField.textAlignment = NSTextAlignmentLeft;
        self.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UITextField *txtField;
    if (textField.returnKeyType == UIReturnKeyNext) {
        txtField = [self.view viewWithTag:textField.tag+1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 100:
            filterInfo.from = textField.text;
            break;
        case 101:
            filterInfo.to = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    if (str.length == 8)
        return NO;
    
    else if (([string rangeOfCharacterFromSet:notDigits].location == NSNotFound ||  [string containsString:@"."]))
        return YES;
    else
        return NO;
    
    return YES;
}


#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish{
    [self initialSetup];
}

- (void)didConfirmWithArabic {
    
    [self initialSetup];
}

#pragma mark - UIButton Action


- (IBAction)distanceButtonaction:(id)sender {
    
    [self.view endEditing:YES];
    [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:distanceArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        filterInfo.distance = selectedText;
        self.distanceTextField.text = selectedText;
        distanceStr = selectedText;

//        distanceStr = [NSString stringWithFormat:@"%d",[selectedText intValue]*1000];
       // [[AppSettingsManager sharedinstance] setObject:[NSString stringWithFormat:@"%d",[selectedText intValue]*1000] forKey:KDefaultDistance];
    }];
}

- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LANGUAGE" object:self];
}

- (IBAction)applyButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *sortDict = [[NSMutableDictionary alloc]init];
    //[sortDict setValue:transportationStr forKey:@"transportationStr"];
    [sortDict setValue:(self.availableButton.selected)?@"available":@"not available" forKey:@"transportationStr"];
    [sortDict setValue:distanceStr forKey:@"distanceStr"];

    [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFICATION_FILTER object:nil userInfo:sortDict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelbuttonAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)availableButtonAction:(id)sender {
    
   // [[AppSettingsManager sharedinstance] setObject:@"available" forKey:KDefaultAvailable];

    transportationStr = @"available";
    self.availableButton.selected = !self.availableButton.selected;
    self.notAvailableButton.selected = NO;
}

- (IBAction)notAvailableButtonAction:(id)sender {
    
  //  [[AppSettingsManager sharedinstance] setObject:@"not available" forKey:KDefaultAvailable];
    
    transportationStr = @"not available";
    self.notAvailableButton.selected = YES;
    self.availableButton.selected = NO;
}

@end
