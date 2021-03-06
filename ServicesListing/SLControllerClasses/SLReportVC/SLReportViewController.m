//
//  SLReportViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 21/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLReportViewController.h"
#import "Header.h"

static NSString *signUpCellIdentifier = @"signUpCellId";

@interface SLReportViewController ()<UITextFieldDelegate,LanguageChangeDelegate> {
    SLUserInfoModel *userInfo;
    NSMutableArray *subjectArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLReportViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Alloc Modal Class
    userInfo = [[SLUserInfoModel alloc]init];
    
    // Notification Count Set
    self.notificationCountLabel.layer.cornerRadius = self.notificationCountLabel.frame.size.width/2;
    self.notificationCountLabel.layer.masksToBounds = YES;
    
    if ([APPDELEGATE notificationCount] == 0)
        self.notificationCountLabel.hidden = YES;
    else {
        self.notificationCountLabel.hidden = NO;
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE notificationCount]];
    }
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(increaseNotificationCount) name:@"getNotificationCount" object:nil];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self initialSetup];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUpCellIdentifier];
    
    // Alloc Mutable Array
    subjectArray = [[NSMutableArray alloc]initWithObjects:@"Complain",@"Suggestion", nil];
    
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.titleLabel.text = SLLocalizedString(@"ReportCap");
    
    if ([APPDELEGATE isArabic]) {
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
  //  [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");

    [self.tableView reloadData];
}

- (BOOL)validateFields {
    
    if (!userInfo.subject.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please select subject") andController:self];
    else if (!userInfo.report.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter problem") andController:self];
    else
        return YES;
    
    return NO;
}



#pragma mark - Observer Method
- (void)increaseNotificationCount {

    if ([APPDELEGATE notificationCount] == 0)
        self.notificationCountLabel.hidden = YES;
    else {
        self.notificationCountLabel.hidden = NO;
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE notificationCount]];
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSignUpTableViewCell *reportCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];
    
    reportCell.signUpButton.hidden = YES;
    reportCell.signUpImageView.hidden = YES;
    reportCell.signUpTextField.delegate = self;
    
    reportCell.transportLabel.hidden = YES;
    reportCell.availableButton.hidden = YES;
    reportCell.notAvailableButton.hidden = YES;
    reportCell.signUpTextField.userInteractionEnabled = NO;
    
    if ([APPDELEGATE isArabic])
        reportCell.signUpTextField.textAlignment = NSTextAlignmentRight;
    else
        reportCell.signUpTextField.textAlignment = NSTextAlignmentLeft;
    
    switch (indexPath.row) {
        case 0:
            reportCell.signUpTextField.placeholder= SLLocalizedString(@"Subject");
            reportCell.signUpTextField.text = userInfo.subject;
            reportCell.signUpButton.hidden = NO;
            reportCell.signUpImageView.hidden = NO;
            reportCell.signUpImageView.image = [UIImage imageNamed:@"downBlue"];
            [reportCell.signUpButton addTarget:self action:@selector(subjectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 1:
            reportCell.signUpTextField.userInteractionEnabled = YES;
            reportCell.signUpTextField.placeholder= SLLocalizedString(@"Report your problem");
            reportCell.signUpTextField.returnKeyType = UIReturnKeyDone;
            reportCell.signUpTextField.text = userInfo.report;
            break;
            
        default:
            break;
    }
    return reportCell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    userInfo.report = TRIM_SPACE(textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if (str.length == 501)
        return NO;
    
    return YES;
}


#pragma mark - Selector Method

- (void)subjectButtonAction:(UIButton*)sender {
    
    [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:subjectArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        userInfo.subject = selectedText;
        [self.tableView reloadData];
    }];
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
}

- (void)didConfirmWithArabic {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
}

#pragma mark - UIButton Action

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validateFields])
        [self makeWebApiCallForReport];
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)notificationButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
    [self.navigationController pushViewController:notificationVC animated:YES];
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


#pragma mark - Api Method

- (void)makeWebApiCallForReport {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:userInfo.subject forKey:Ksubject];
    [dictRequest setValue:userInfo.report forKey:Kdescription];
    [dictRequest setValue:self.nid forKey:Kid];
    [dictRequest setValue:@"advertisement" forKey:Ktype];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apireport WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"Success!") message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"OK"),nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    [self.navigationController popViewControllerAnimated:YES];

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
