//
//  SLProfileViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 19/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLProfileViewController.h"
#import "Header.h"

static NSString *profileCellIdentifier = @"profileCellId";

@interface SLProfileViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,LanguageChangeDelegate,OTPVCDelegate,SLAutoDetectionLocationVCDelegate>{
    
    BOOL isEdit;
    SLUserInfoModel *profileInfo;
}

@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//UIButton Properties
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *postAddButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLProfileViewController

#pragma mark - UIView LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
    isEdit = NO;
    
    [self makeWebApiCallForProfile];
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

#pragma mark - Custom Methods

- (void)initialSetup {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SLProfileTableViewCell" bundle:nil] forCellReuseIdentifier:profileCellIdentifier];
    self.tableView.estimatedRowHeight = 56.0;
    [self.view layoutIfNeeded];
    
    // Set ImageView Coener Radius
    self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    [self customizeViewWithEditInfo];

    
    if ([APPDELEGATE isArabic]) {
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    }
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    //[self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");
}

- (BOOL)validateFields {
    
    NSString *phoneNumber = profileInfo.mobile;
    NSString *testNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
//    if (!profileInfo.firstName.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter first name") andController:self];
//    else if (!profileInfo.lastName.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter last name") andController:self];
//    else if (!profileInfo.email.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter email") andController:self];
    if ([profileInfo.email validateEmailWithString] && profileInfo.email.length != 0)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate email") andController:self];
//    else if (!profileInfo.mobile.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter mobile") andController:self];
//    else if (profileInfo.mobile.length<6 || testNumber.length == 0)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
//    else if (!profileInfo.dob.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Select dob") andController:self];
//    else if (!profileInfo.address.length)
//        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter address") andController:self];
    else {
        isEdit = !isEdit;
        return YES;
    }
    
    return NO;
}


- (void)delegateToGetCountryCode {
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (void)customizeViewWithEditInfo {

    if (!isEdit) {
        [self.editButton setImage:[UIImage imageNamed:@"edit-1.png"] forState:UIControlStateNormal];
        self.titleLabel.text = SLLocalizedString(@"My profile");
        self.profileButton.userInteractionEnabled = NO;
    }else {
        [self.editButton setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        self.titleLabel.text = SLLocalizedString(@"Edit profile");
        self.profileButton.userInteractionEnabled = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLProfileTableViewCell *profileCell = (SLProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    profileCell.titleDescTextField.delegate = self;
    profileCell.titleDescTextField.keyboardType = UIKeyboardTypeDefault;
    profileCell.titleDescTextField.returnKeyType = UIReturnKeyNext;
    profileCell.descLabel.hidden = YES;
    profileCell.dobButton.hidden = YES;
    profileCell.titleDescTextField.hidden = NO;
    [profileCell.dobButton addTarget:self action:@selector(dobButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [profileCell.crossButton addTarget:self action:@selector(crossButtonAction:) forControlEvents:UIControlEventTouchUpInside];


    // Set Tag
    profileCell.titleDescTextField.tag = indexPath.row+100;
    profileCell.dobButton.tag = indexPath.row+200;
    profileCell.titleDescTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    profileCell.crossButton.hidden = YES;

    if (!isEdit) {
        profileCell.titleDescTextField.userInteractionEnabled = NO;
    }else {
        profileCell.titleDescTextField.userInteractionEnabled = YES;
    }
    
    if ([APPDELEGATE isArabic]) {
        profileCell.userInfoTitleLabel.textAlignment = NSTextAlignmentRight;
        profileCell.titleDescTextField.textAlignment = NSTextAlignmentRight;
        profileCell.descLabel.textAlignment = NSTextAlignmentRight;
    }
    else{
        profileCell.userInfoTitleLabel.textAlignment = NSTextAlignmentLeft;
        profileCell.titleDescTextField.textAlignment = NSTextAlignmentLeft;
        profileCell.descLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    switch (indexPath.row) {
        case 0:
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"First name");
            profileCell.titleDescTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            profileCell.titleDescTextField.text = profileInfo.firstName;
            break;
        case 1:
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"Last Name");
            profileCell.titleDescTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            profileCell.titleDescTextField.text = profileInfo.lastName;
            break;
        case 2:
            if (!isEdit) {
                profileCell.descLabel.hidden = NO;
                profileCell.titleDescTextField.hidden = YES;
            }
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"Email");
            profileCell.titleDescTextField.text = profileInfo.email;
            profileCell.descLabel.text = profileInfo.email;
            profileCell.titleDescTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 3:
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"Mobile Number");
            profileCell.titleDescTextField.text = profileInfo.mobile;
            profileCell.titleDescTextField.userInteractionEnabled = NO;
            profileCell.titleDescTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 4:
        if (isEdit){
                profileCell.dobButton.hidden = NO;
                profileCell.crossButton.hidden = NO;
        }
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"DOB");
            profileCell.titleDescTextField.text = profileInfo.dob;
            break;
        case 5:
            
            if (isEdit)
                profileCell.dobButton.hidden = NO;
//            if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
//                profileInfo.address = [APPDELEGATE currentLocation];
//            }
//            if ([profileInfo.address isEqualToString:@""]) {
//                profileInfo.address = profileInfo.countryNCode;
//            }

            profileCell.titleDescTextField.hidden = YES;
            profileCell.descLabel.hidden = NO;
            profileCell.descLabel.text = profileInfo.address;
            profileCell.userInfoTitleLabel.text = SLLocalizedString(@"Location");
            break;
           
        default:
            break;
    }
    return profileCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return UITableViewAutomaticDimension;

}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 100:
            profileInfo.firstName = TRIM_SPACE(textField.text);
            break;
        case 101:
            profileInfo.lastName = TRIM_SPACE(textField.text);
            break;
        case 102:
            profileInfo.email = TRIM_SPACE(textField.text);
            break;
        case 103:
            profileInfo.mobile = TRIM_SPACE(textField.text);
            break;
        case 105:
            profileInfo.address = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if ((textField.tag == 100 || textField.tag == 101) && str.length == 31)
        return NO;
    else if (textField.tag == 102 && str.length == 65)
        return NO;
    else if (textField.tag == 103 && str.length > 16)
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 103)
        textField.inputAccessoryView = toolBarForNumberPad(self,SLLocalizedString(@"Done"));
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    self.profileImageView.image = image;
    profileInfo.imageProfile = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Selector Method

- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

- (void)dobButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    
    if (sender.tag == 204) {
        [DatePickerSheetView showDatePickerWithDate:[NSDate date] andMimumDate:nil andMaxDate:[NSDate date] AndTimeZone:nil WithReturnDate:^(NSDate *date) {
            
            if ([self differenceBetweenTwoDate:date]) {
                
                NSDateFormatter *ndateFormatter = [[NSDateFormatter alloc] init];
                [ndateFormatter setDateFormat:@"dd-MM-yyyy"];
                NSString *showdateValue = [ndateFormatter stringFromDate:date];
                profileInfo.dob = showdateValue;
                [self.tableView reloadData];
            }else{
                [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Your age should be atleast 14 years") andController:self];
            }
            
        }];
    } else if (sender.tag == 205) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
//        SLAutoDetectionVC *countryVC = [[SLAutoDetectionVC alloc]initWithNibName:@"SLAutoDetectionVC" bundle:nil];
//        countryVC.delegate = self;
//        [self.view endEditing:YES];
//        [self presentViewController:countryVC animated:YES completion:nil];

    }
    else{
        profileInfo.address = [APPDELEGATE currentLocation];
        [self.tableView reloadData];
    }
}

    
-(void)crossButtonAction:(UIButton *)sender {
    
    profileInfo.dob = @"";
    [self.tableView reloadData];
}


- (BOOL)differenceBetweenTwoDate:(NSDate*)date {
    
    NSDate *date1 = [NSDate date];
    NSDate *date2 = date;
    NSTimeInterval secondsBetween = [date1 timeIntervalSinceDate:date2];
    int numberOfDays = secondsBetween / 86400;
    if (numberOfDays >= 5110) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableView reloadData];
}

- (void)didConfirmWithArabic {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [self.tableView reloadData];
}

#pragma mark - UIButton Action

- (IBAction)editButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (isEdit == YES) {
        if ([self validateFields]) {
            [self makeWebApiCallForUpdateProfile];
        }
    }else{
        isEdit = YES;
        [self.tableView reloadData];
        [self customizeViewWithEditInfo];
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

- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([APPDELEGATE isArabic]) {
        [self.sidePanelController showRightPanelAnimated:YES];
    }else{
        [self.sidePanelController showLeftPanelAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LanguageChageNotificationOnSidePannel"
     object:self];
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}

- (IBAction)profileButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [[ActionSheet sheetManager] presentSheetWithTitle:nil message:nil cancelBttonTitle:SLLocalizedString(@"CancelSmall") destrictiveButtonTitle:nil andButtonsWithTitle:@[SLLocalizedString(@"TakeAPhoto"),SLLocalizedString(@"Choose from Gallery")] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        switch (index) {
                
            case 0:{
                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                      [self.navigationController presentViewController:picker animated:YES completion:nil];
                }
                else{
                    [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Check camera") andController:self];
                }
            }
                break;
                
            case 1:{
                   picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                   picker.allowsEditing = NO;
                   [self presentViewController:picker animated:YES completion:nil];
            }
                break;
                
            default:
                return;
                break;
        }
    }];
}

#pragma mark - Web Service API Methods

- (void)makeWebApiCallForProfile {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiGetprofile WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                profileInfo = [SLUserInfoModel profileFromResponse:[response objectForKeyNotNull:KprofileDetail expectedClass:[NSDictionary class]]];
                [self.profileImageView setImageWithURL:[NSURL URLWithString:profileInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [self.tableView reloadData];
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

- (void)makeWebApiCallForUpdateProfile {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation] forKey:Klocation];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlatitude] forKey:Klatitude];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlongitude] forKey:Klongitude];
        [dictRequest setValue:[APPDELEGATE countryCode] forKey:KCountry];
    }
    else {
        [dictRequest setValue:@"" forKey:Klocation];
        [dictRequest setValue:@"" forKey:Klatitude];
        [dictRequest setValue:@"" forKey:Klongitude];
        [dictRequest setValue:[NSUSERDEFAULT valueForKey:@"CountryNmCode"] forKey:KCountry];
    }
    
    [dictRequest setValue:profileInfo.firstName forKey:Kfirstname];
    [dictRequest setValue:profileInfo.lastName forKey:Klastname];
    [dictRequest setValue:profileInfo.email forKey:Kemail];
    [dictRequest setValue:profileInfo.dob forKey:Kdob];
    
   NSString *string = [profileInfo.mobile stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    NSString *NumberString = string;
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:NumberString];

   // NSString *encryptedMobile = [AESTool encryptData:[NSString stringWithFormat:@"%@",newNum] withKey:KAES_ENCRYPT_KEY];
    [dictRequest setValue:newNum forKey:Kmobile];
    
    if (profileInfo.imageProfile) {
        NSData *dataProfileImg = UIImageJPEGRepresentation(profileInfo.imageProfile, 0.1);
        [dictRequest setValue:[dataProfileImg base64EncodedString] forKey:Kimage];
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiUpdateProfile WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                NSString *strMobileStatus = [response objectForKeyNotNull:KchangeMobileStatus expectedClass:[NSString class]];
                //[NSUSERDEFAULT setValue:profileInfo.countryNCode forKey:@"countryNCode"];
                [NSUSERDEFAULT synchronize];
                if ([strMobileStatus isEqualToString:@"1"]) {
                    
                    SLOtpViewController *otpVC = [[SLOtpViewController alloc]initWithNibName:@"SLOtpViewController" bundle:nil];
                    otpVC.dictProfile = dictRequest;
                    otpVC.isMobileUpdate = YES;
                    otpVC.delegate = self;
                    [self.navigationController presentViewController:otpVC animated:YES completion:^{
                        
                    }];
                    
                }else{
                    profileInfo = [SLUserInfoModel profileFromResponse:response];
                    
                    isEdit = NO;
                    [self.tableView reloadData];
                    [self customizeViewWithEditInfo];
                    
                    [[AppSettingsManager sharedinstance] setObject:[NSString stringWithFormat:@"%@ %@",profileInfo.firstName,profileInfo.lastName] forKey:KDefaultUserName];
                    [[AppSettingsManager sharedinstance] setObject:profileInfo.imgUrl forKey:KDefaultUserProfile];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_UPDATE_PROFILE object:nil];
                }
                
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
    
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - OTPVC Delegate Methods

- (void)didUpdateMobilewithResponse:(NSDictionary *)dictTemp {

    profileInfo = [SLUserInfoModel profileFromResponse:dictTemp];
    
    isEdit = NO;
    [self.tableView reloadData];
    [self customizeViewWithEditInfo];
    
    [[AppSettingsManager sharedinstance] setObject:[NSString stringWithFormat:@"%@ %@",profileInfo.firstName,profileInfo.lastName] forKey:KDefaultUserName];
    [[AppSettingsManager sharedinstance] setObject:profileInfo.imgUrl forKey:KDefaultUserProfile];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_UPDATE_PROFILE object:nil];
}

@end
