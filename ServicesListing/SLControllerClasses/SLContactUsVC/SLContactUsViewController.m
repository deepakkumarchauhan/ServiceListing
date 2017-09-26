//
//  SLContactUsViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 21/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLContactUsViewController.h"
#import "Header.h"

static NSString *signUpCellIdentifier = @"signUpCellId";

@interface SLContactUsViewController ()<UITextFieldDelegate,LanguageChangeDelegate>{
    SLUserInfoModel *userInfo;
    NSMutableArray *subjectArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet SLCustomButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) IBOutlet UILabel *addNewPostlabel;

@end

@implementation SLContactUsViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Alloc Modal Class
    userInfo = [[SLUserInfoModel alloc]init];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self initialSetup];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

-(void)initialSetup {
    
    self.titleLabel.text = SLLocalizedString(@"CONTACT US");
    
    self.addNewPostlabel.text = SLLocalizedString(@"Add new Post");

   // [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUpCellIdentifier];
    
    // Alloc Mutable Array
    subjectArray = [[NSMutableArray alloc]initWithObjects:@"Complain",@"Suggestion", nil];
    [self.sendButton setTitle:SLLocalizedString(@"SEND") forState:UIControlStateNormal];
    
    if ([APPDELEGATE isArabic])
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    else
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
}

- (BOOL)validateFields {
    
    if (!userInfo.subject.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please select subject") andController:self];
    else if (!userInfo.addDescription.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter description") andController:self];
    else if (userInfo.addDescription.length<2)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Valid description name") andController:self];
    else
        return YES;
    
    return NO;
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSignUpTableViewCell *contactCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];
    
    contactCell.signUpButton.hidden = YES;
    contactCell.signUpImageView.hidden = YES;
    contactCell.transportLabel.hidden = YES;
    contactCell.availableButton.hidden = YES;
    contactCell.notAvailableButton.hidden = YES;
    contactCell.signUpTextField.userInteractionEnabled = NO;
    contactCell.signUpTextField.delegate = self;
    
    if ([APPDELEGATE isArabic])
        contactCell.signUpTextField.textAlignment = NSTextAlignmentRight;
    else
        contactCell.signUpTextField.textAlignment = NSTextAlignmentLeft;

    switch (indexPath.row) {
        case 0:
            contactCell.signUpTextField.placeholder= SLLocalizedString(@"Subject");
            contactCell.signUpTextField.text = userInfo.subject;
            contactCell.signUpButton.hidden = NO;
            contactCell.signUpImageView.hidden = NO;
            contactCell.signUpImageView.image = [UIImage imageNamed:@"downBlue"];
            [contactCell.signUpButton addTarget:self action:@selector(subjectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 1:
            contactCell.signUpTextField.userInteractionEnabled = YES;
            contactCell.signUpTextField.placeholder= SLLocalizedString(@"Description");
            contactCell.signUpTextField.returnKeyType = UIReturnKeyDone;
            contactCell.signUpTextField.text = userInfo.addDescription;
            break;
            
        default:
            break;
    }
    return contactCell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    userInfo.addDescription = TRIM_SPACE(textField.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if (str.length == 501) {
        return NO;
    }
    
    return YES;
}


#pragma mark - language selection Delegate method
-(void)didConfirmWithEnglish{
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableView reloadData];
}

-(void)didConfirmWithArabic{
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [self.tableView reloadData];
}

#pragma mark - Selector Method
-(void)subjectButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:subjectArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        userInfo.subject = selectedText;
        [self.tableView reloadData];
    }];
}

#pragma mark - UIButton Action
- (IBAction)sendButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validateFields]) {
        
        [self makeWebApiCallForContactUs];
    }

}

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([APPDELEGATE isArabic])
        [self.sidePanelController showRightPanelAnimated:YES];
    else
        [self.sidePanelController showLeftPanelAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LanguageChageNotificationOnSidePannel"
     object:self];
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

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallForContactUs {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:userInfo.subject forKey:Ksubject];
    [dictRequest setValue:userInfo.addDescription forKey:Kdescription];

    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiContact_us WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"Success!") message:[response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]] andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"OK"), nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if ([APPDELEGATE isArabic])
                        [self.sidePanelController showRightPanelAnimated:YES];
                    else
                        [self.sidePanelController showLeftPanelAnimated:YES];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"LanguageChageNotificationOnSidePannel"
                     object:self];
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
    
    [self.sendButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    [self.sendButton setTitle:SLLocalizedString(@"SEND") forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
