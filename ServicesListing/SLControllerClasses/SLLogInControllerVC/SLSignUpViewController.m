//
//  SLSignUpViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLSignUpViewController.h"
#import "AESTool.h"
#import "SLCountryCodeViewController.h"
#import "Header.h"
#import "AppDelegate.h"


static NSString *signUpCellIdentifier = @"signUpCellId";
static NSString *signUpTwoFieldCellIdentifier = @"signUpTwoFieldCellId";
static NSString *signUpMobeleCellIdentifier = @"signUpMobileCellId";

@interface SLSignUpViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,LanguageChangeDelegate,SLAutoDetectionLocationVCDelegate> {
    
    SLUserInfoModel *userInfo;
    NSString *strCountyCode;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// UILabel Properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *agreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomApplicationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *termsHeightConstraint;

// UIView Properties
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *bottomTermsView;

// UIButton Properties
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (strong, nonatomic) IBOutlet UIButton *termButton;
@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;
@property (assign) BOOL isAddress;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *topLocationSwitchView;
@property (strong, nonatomic) IBOutlet UILabel *autoLocationLabel;

@end

@implementation SLSignUpViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Alloc Model Class
    userInfo = [[SLUserInfoModel alloc]init];
    [self.switchButton setOn:NO];
    
    if ([NSUSERDEFAULT boolForKey:@"autoDetection"])
        [self.switchButton setOn:YES];
    else
        [self.switchButton setOn:NO];


   // userInfo.address = [APPDELEGATE currentLocation];


//    countryPrefix = [[NSArray alloc] initWithObjects:@"+93",@"+335",@"+213",@"+1684",@"+376",@"+376",@"+244",@"+1264",@"+672",@"+1268",@"+54", @"+374",@"+297", @"+61",@"+43", @"+994",@"+1242",@"+973",@"+880",@"+1246"@"+375",@"+32",@"+501",@"+229",@"+1441",@"+975",@"+591",@"+387",@"+267"@"+55",@"+1284",@"+673",@"+359",@"+226",@"+95",@"+257",@"+855",@"+237",@"+1",@"+238",@"+1345",@"+236",@"+235",@"+56",@"+86",@"+61",@"+61",@"+57",@"+269",@"+682",@"+506",@"+385",@"+53",@"+357",@"+420",@"+243",@"+45",@"+253",@"+1767",@"+1809",@"+593",@"+20",@"+503",@"+240",@"+291",@"+372",@"+251",@"+500",@"+298",@"+679",@"+358",@"+33",@"+689",@"+241",@"+220",@"+970",@"+995",@"+49",@"+233",@"+350",@"+30",@"+299",@"+1473",@"+1671",@"+502",@"+224",@"+245",@"+592",@"+509",@"+39",@"+504",@"+852",@"+36",@"+354",@"+91",@"+62",@"+98",@"+964",@"+353",@"+44",@"+972",@"+39",@"+225",@"+1876",@"+81",@"+962",@"+7",@"+254",@"+686",@"+381",@"+965",@"+996",@"+856",@"+371",@"+961",@"+266",@"+231",@"+218",@"+423",@"+370",@"+352",@"+853",@"+389",@"+261",@"+265",@"+60",@"+960",@"+223",@"+356",@"+692",@"+222",@"+230",@"+262",@"+52",@"+691",@"+373",@"+377",@"+976",@"+382",@"+1664",@"+212",@"+258",@"+264",@"+674",@"+977",@"+31",@"+599",@"+687",@"+64",@"+505",@"+227",@"+234",@"+683",@"+672",@"+850",@"+1670",@"+47",@"+968",@"+92",@"+680",@"+507",@"+675",@"+595",@"+51",@"+63",@"+870",@"+48",@"+351",@"+1",@"+974",@"+242",@"+40",@"+7",@"+250",@"+590",@"+290",@"+1869",@"+1758",@"+1599",@"+508",@"+1784",@"+685",@"+378",@"+239",@"+966",@"+221",@"+381",@"+248",@"+232",@"+65",@"+421",@"+386",@"+677",@"+252",@"+27",@"+82",@"+34",@"+94",@"+249",@"+597",@"+268",@"+46",@"+41",@"+963",@"+886",@"+992",@"+255",@"+66",@"+670",@"+228",@"+690",@"+676",@"+1868",@"+216",@"+90",@"+993",@"+1649",@"+688",@"+256",@"+380",@"+971",@"+44",@"+1",@"+598",@"+1340",@"+998",@"+678",@"+58",@"+84",@"+681",@"970",@"+967",@"+260",@"+263", nil];
    
    [self initialSetup];

    BDVCountryNameAndCode *bDVCountryNameAndCode = [[BDVCountryNameAndCode alloc] init];
    strCountyCode = [bDVCountryNameAndCode prefixForCurrentLocaleFromGoogle:[APPDELEGATE countryCode]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationMessage) name:@"GetLocationNotification" object:nil];
    
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [self initialSetup];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUpCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTwoFieldTableViewCell" bundle:nil] forCellReuseIdentifier:signUpTwoFieldCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpMobileTableViewCell" bundle:nil] forCellReuseIdentifier:signUpMobeleCellIdentifier];
    
    [self.view layoutIfNeeded];
    
    // Set ImageView Coener Radius
    self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    
    
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.titleLabel.text = SLLocalizedString(@"SIGN UP");
    self.autoLocationLabel.text = SLLocalizedString(@"Auto detection location");

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:SLLocalizedString(@"I agree to the Terms & Services of the application")];
    
    
    if ([APPDELEGATE isArabic])
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 19)];
    else
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(15, 16)];
    
    self.agreeLabel.attributedText = attributedString;
    
    if ([APPDELEGATE isArabic]) {
        //20 29
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.bottomTermsView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.topLocationSwitchView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        self.agreeLabel.textAlignment = NSTextAlignmentRight;
        self.autoLocationLabel.textAlignment = NSTextAlignmentRight;

        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

       // userInfo.address = [NSUSERDEFAULT valueForKey:@"CountryFullNameArabic"];
    }
    else {
        
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.bottomTermsView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.topLocationSwitchView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.agreeLabel.textAlignment = NSTextAlignmentLeft;
        self.autoLocationLabel.textAlignment = NSTextAlignmentLeft;

        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];

       // userInfo.address = [NSUSERDEFAULT valueForKey:@"CountryFullName"];
    }
    //strCountyCode = [NSUSERDEFAULT valueForKey:@"selectedCountryCode"];
    [_submitButton setTitle:SLLocalizedString(@"Next") forState:UIControlStateNormal];
    [_bottomTermsView setHidden:YES];
    [self.tableView reloadData];
}
-(BOOL)validateCountry{
    NSString *phoneNumber = userInfo.mobile;
    NSString *testNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@""];
    //    NSString *code = [NSString stringWithFormat:@"%@",strCountyCode];
    
    if (strCountyCode == nil){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter your country code") andController:self];
    }
    else if (!userInfo.mobile.length){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter mobile") andController:self];
    }
    else if (userInfo.mobile.length<6 || testNumber.length == 0){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
    }
    else{
        return YES;
    }
    return NO;

}
- (BOOL)validateFields {
    
    NSString *phoneNumber = userInfo.mobile;
    NSString *testNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@""];
//    NSString *code = [NSString stringWithFormat:@"%@",strCountyCode];
    
    if (strCountyCode == nil){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter your country code") andController:self];
    }
    else if (!userInfo.mobile.length){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter mobile") andController:self];
    }
    else if (userInfo.mobile.length<6 || testNumber.length == 0){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
    }
    
    else if (!userInfo.address.length){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter address") andController:self];
    }
    
    else if(!self.agreeButton.selected){
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please agree to term and conditions") andController:self];
    }
    else{
        return YES;
    }
    return NO;
}



- (void)delegateToGetCountryCode {
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {

        case 0:
        {
            if (_isAddress) {
                SLSignUpTableViewCell *signupCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];
                
                self.tableTopConstraint.constant = 48.0;
                self.topLocationSwitchView.hidden = NO;
                signupCell.transportLabel.hidden = YES;
                signupCell.availableButton.hidden = YES;
                signupCell.notAvailableButton.hidden = YES;
                signupCell.signUpTextField.tag = 101;
                signupCell.signUpButton.tag = 201;
                signupCell.signUpButton.hidden = YES;
                signupCell.signUpImageView.hidden = YES;
                self.switchButton.hidden = NO;
                signupCell.signUpTextField.userInteractionEnabled = NO;
                [signupCell.signUpButton addTarget:self action:@selector(getCountryName:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([APPDELEGATE isArabic]) {
                    signupCell.signUpTextField.textAlignment = NSTextAlignmentRight;
                }
                else{
                    signupCell.signUpTextField.textAlignment = NSTextAlignmentLeft;
                }
                
                if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
                    userInfo.address = [APPDELEGATE currentLocation];
                }
                signupCell.signUpTextField.text = userInfo.address;
                signupCell.signUpButton.hidden = NO;
                signupCell.signUpImageView.hidden = NO;
                
                if (self.switchButton.on) {
                    signupCell.signUpButton.hidden = YES;
                    signupCell.signUpImageView.image = [UIImage imageNamed:@"loc"];
                }
                else {
                    signupCell.signUpButton.hidden = NO;
                    signupCell.signUpImageView.image = [UIImage imageNamed:@"downBlue.png"];
                }
                
               // signupCell.signUpImageView.image = [UIImage imageNamed:@"loc"];
                signupCell.signUpTextField.placeholder= SLLocalizedString(@"Address");
                [signupCell.signUpButton addTarget:self action:@selector(dateOfBirthAction:) forControlEvents:UIControlEventTouchUpInside];
                
                return signupCell;
            }else{
                SLSignUpMobileTableViewCell *signUpMobileCell = (SLSignUpMobileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpMobeleCellIdentifier];
                self.tableTopConstraint.constant = 0.0;
                self.topLocationSwitchView.hidden = YES;

                signUpMobileCell.mobileTextField.delegate = self;
                signUpMobileCell.mobileCodeTextField.delegate = self;
                signUpMobileCell.mobileTextField.tag     = 100;
                signUpMobileCell.mobileCodeTextField.tag = 305;
                signUpMobileCell.countryPickerButton.tag = 306;
                self.switchButton.hidden = YES;

                
                if ([APPDELEGATE isArabic]) {
                    signUpMobileCell.mobileTextField.textAlignment = NSTextAlignmentRight;
                }
                else {
                    signUpMobileCell.mobileTextField.textAlignment = NSTextAlignmentLeft;
                }
                signUpMobileCell.mobileTextField.returnKeyType =UIReturnKeyDone;
                signUpMobileCell.mobileCodeTextField.placeholder= SLLocalizedString(@"");
                signUpMobileCell.mobileCodeTextField.text = (strCountyCode == nil)?@"":[NSString stringWithFormat:@"+%@",strCountyCode];
                
                signUpMobileCell.mobileTextField.placeholder= SLLocalizedString(@"Mobile Number");
                signUpMobileCell.mobileTextField.text = userInfo.mobile;
                signUpMobileCell.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
                signUpMobileCell.mobileCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
                
                [signUpMobileCell.countryPickerButton addTarget:self action:@selector(dateOfBirthAction:) forControlEvents:UIControlEventTouchUpInside];
                
                return signUpMobileCell;
            }

        }
            
        case 1:
        default:
        {
            SLSignUpTableViewCell *signupCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];
            
            signupCell.transportLabel.hidden = YES;
            signupCell.availableButton.hidden = YES;
            signupCell.notAvailableButton.hidden = YES;
            signupCell.signUpTextField.tag = 101;
            signupCell.signUpButton.tag = 201;
            signupCell.signUpButton.hidden = YES;
            signupCell.signUpImageView.hidden = YES;
            
            [signupCell.signUpButton addTarget:self action:@selector(getCountryName:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([APPDELEGATE isArabic]) {
                signupCell.signUpTextField.textAlignment = NSTextAlignmentRight;
            }
            else{
                signupCell.signUpTextField.textAlignment = NSTextAlignmentLeft;
            }
            
            if ([NSUSERDEFAULT boolForKey:@"autoDetection"]) {
                 userInfo.address = [APPDELEGATE currentLocation];
            }
            signupCell.signUpTextField.text = userInfo.address;
            signupCell.signUpButton.hidden = NO;
            signupCell.signUpImageView.hidden = NO;
            signupCell.signUpImageView.image = [UIImage imageNamed:@"loc"];
            signupCell.signUpTextField.placeholder= SLLocalizedString(@"Address");
            [signupCell.signUpButton addTarget:self action:@selector(dateOfBirthAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return signupCell;
        }
            
//        default:
//            return nil;
            break;
    }
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 58;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
      
        case 100:
            userInfo.mobile = TRIM_SPACE(textField.text);
            break;
            
        case 305: {
            NSString *newStr = [TRIM_SPACE(textField.text) substringWithRange:NSMakeRange(1, [TRIM_SPACE(textField.text) length]-1)];
            strCountyCode = newStr;
        }
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
    
    else if ((textField.tag == 100) && str.length > 16)
        return NO;
    
    else if ((textField.tag == 305) && (str.length == 0 || str.length > 5)) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 100 || textField.tag == 305)
        textField.inputAccessoryView = toolBarForNumberPad(self,SLLocalizedString(@"Done"));
}

-(void)getCountryName:(UIButton *)sender{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
    
    SLCountryCodeViewController *countryVC = [[SLCountryCodeViewController alloc]initWithNibName:@"SLCountryCodeViewController" bundle:nil];
    countryVC.isMobileCode = YES;
    [self presentViewController:countryVC animated:YES completion:nil];
//    SLAutoDetectionVC *countryVC = [[SLAutoDetectionVC alloc]initWithNibName:@"SLAutoDetectionVC" bundle:nil];
//    self.fromLogIn = NO;
//    countryVC.fromSidePanel = NO;
//    countryVC.delegate = self;
//    [self.view endEditing:YES];
//    [self presentViewController:countryVC animated:YES completion:nil];
}

-(void)doCodeToObServeGetCountryCode:(NSNotification *)userINfo {
    NSDictionary * dict = userINfo.userInfo;
    if ([APPDELEGATE isArabic])
        userInfo.address = [dict valueForKey:@"cNameArr" ];
    else
        userInfo.address = [dict valueForKey:@"cName" ];
    
    userInfo.countryNCode = [dict valueForKey:@"countryNameCode"];
    strCountyCode = [dict valueForKey:@"mobilePrefix"];
    [self.tableView reloadData];
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    self.profileImageView.image = image;
    userInfo.imageProfile = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Switch Action Method

- (IBAction)switchButtonAction:(id)sender {
    
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Please enable location services in settings to continue using the app!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.switchButton setOn:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.switchButton setOn:NO];
            
        }];
        [alert addAction:okAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:NO completion:nil];
     
    }else{
       userInfo.address = [APPDELEGATE currentLocation];
        [self.tableView reloadData];
    }
    
    if (!self.switchButton.on) {
        [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];
        [NSUSERDEFAULT synchronize];
        userInfo.address = @"";
    }else {
        [NSUSERDEFAULT setBool:YES forKey:@"autoDetection"];
        [NSUSERDEFAULT synchronize];
    }
    
}

#pragma mark - Selector Method

- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

- (void)receiveLocationMessage {
    
    BDVCountryNameAndCode *bDVCountryNameAndCode = [[BDVCountryNameAndCode alloc] init];
    strCountyCode = [bDVCountryNameAndCode prefixForCurrentLocaleFromGoogle:[APPDELEGATE countryCode]];
  //  userInfo.address = [APPDELEGATE currentLocation];
    [self.tableView reloadData];
}

- (void)dateOfBirthAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    if (sender.tag == 205) {
        [DatePickerSheetView showDatePickerWithDate:[NSDate date] andMimumDate:nil andMaxDate:[NSDate date] AndTimeZone:nil WithReturnDate:^(NSDate *date) {
            
            if([self differenceBetweenTwoDate:date]){
                NSDateFormatter *ndateFormatter = [[NSDateFormatter alloc] init];
                [ndateFormatter setDateFormat:@"dd-MM-yyyy"];
                NSString *showdateValue = [ndateFormatter stringFromDate:date];
                userInfo.dob = showdateValue;
                [self.tableView reloadData];
            }else{
                [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Your age should be atleast 14 years") andController:self];
            }
        }];
    }
    else if (sender.tag == 306) {

        SLCountryCodeViewController *countryVC = [[SLCountryCodeViewController alloc]initWithNibName:@"SLCountryCodeViewController" bundle:nil];
        countryVC.isMobileCode = NO;
        [self presentViewController:countryVC animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];

    }
    else if (sender.tag == 206)
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
    
    if (self.fromLogIn) {
        userInfo.address = [NSUSERDEFAULT valueForKey:@"CountryFullName"];
    }
    [self initialSetup];


}

- (void)didConfirmWithArabic {
    
    if (self.fromLogIn) {
        userInfo.address = [NSUSERDEFAULT valueForKey:@"CountryFullNameArabic"];
    }
    [self initialSetup];

}

#pragma mark - Custom Delegate Method

//-(void)delegateToSendCountryCode:(NSString *)countryCode
//{
//    strCountyCode = countryCode;
//    [self.tableView reloadData];
//}



#pragma mark - UIButton Action

- (IBAction)selectLanguageButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    [APPDELEGATE setIsArabic:![APPDELEGATE isArabic]];
    
    if ([APPDELEGATE isArabic]) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"ar"];
        [self didConfirmWithArabic];
        [self.bottomTermsView setHidden:_isAddress?NO:YES];
        [self.submitButton setTitle:_isAddress?SLLocalizedString(@"SUBMIT"):SLLocalizedString(@"Next") forState:UIControlStateNormal];

    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[SLLanguageHandler sharedLocalSystem] setLanguage:@"en"];
        [self didConfirmWithEnglish];
        [self.bottomTermsView setHidden:_isAddress?NO:YES];
        [self.submitButton setTitle:_isAddress?SLLocalizedString(@"SUBMIT"):SLLocalizedString(@"Next") forState:UIControlStateNormal];

    }
}
-(void)pushWithAnimation {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"pushIn"];
}
- (IBAction)submitButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([sender.titleLabel.text isEqualToString:SLLocalizedString(@"Next")] && [self validateCountry]) {
        [self pushWithAnimation];
        self.isAddress = YES;
        [_bottomTermsView setHidden:NO];
        [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else if([self validateFields]){
        [self makeWebApiCallForSignUp];
    }
    
//    if ([self validateFields]) {
//        [self makeWebApiCallForSignUp];
//    }
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

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [APPDELEGATE loginScreen];
}

- (IBAction)termsButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLPolicyViewController *termsVC = [[SLPolicyViewController alloc]initWithNibName:@"SLPolicyViewController" bundle:nil];
    termsVC.type = @"terms&services";
    termsVC.fromSignUp = YES;
    [self.navigationController pushViewController:termsVC animated:YES];
}


- (IBAction)agreeButtonAction:(id)sender {
    
    self.agreeButton.selected = !self.agreeButton.selected;
}

#pragma mark - Web Service API Methods

- (void)makeWebApiCallForSignUp {

    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    NSString *stringMobile = [[userInfo.mobile componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
    
    NSString *NumberString = stringMobile;
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:NumberString];
    

    //NSString *encryptedMobile = [AESTool encryptData:[NSString stringWithFormat:@"%@",newNum] withKey:KAES_ENCRYPT_KEY];

    [dictRequest setValue:newNum forKey:KmobileNo];
    
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
        [dictRequest setValue:userInfo.countryNCode forKey:KCountry];
    }
    [dictRequest setValue:[NSString stringWithFormat:@"+%@",strCountyCode] forKey:KcountryCode];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];

    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultDeviceToken] forKey:KdeviceToken];
    [dictRequest setValue:Kios forKey:KdeviceType];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [dictRequest setValue:uniqueIdentifier forKey:KdeviceID];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiSignUp WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"Response = %@",response);
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            [NSUSERDEFAULT setValue:userInfo.countryNCode forKey:@"countryNCode"];

            if (strResponseCode.integerValue == KSuccessCode) {
            
                [[AppSettingsManager sharedinstance] setObject:[response objectForKeyNotNull:Kuid expectedClass:[NSString class]] forKey:KDefaultUserID];
                
                if ([NSUSERDEFAULT boolForKey:@"autoDetection"])
                    [NSUSERDEFAULT setBool:YES forKey:@"autoDetection"];
                else
                    [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];

                //remove previous value stored in keychain.
                [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-user-jwt"];
                
                // Store data in keychain here.
                [[A0SimpleKeychain keychain] setString:[response objectForKeyNotNull:Kuid expectedClass:[NSString class]] forKey:@"auth0-user-jwt"];
                [[A0SimpleKeychain keychain] setString:uniqueIdentifier forKey:@"auth0-user-Id"];

                NSString *jwtObj = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-jwt"];
                NSString *jwtId = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-Id"];

                NSLog(@"%@",jwtObj);
                NSLog(@"%@",jwtId);

                
                SLOtpViewController *otpVC = [[SLOtpViewController alloc]initWithNibName:@"SLOtpViewController" bundle:nil];
                otpVC.fromSignUp = YES;
                otpVC.otp = [response objectForKeyNotNull:Kotp expectedClass:[NSString class]];
                [self.navigationController pushViewController:otpVC animated:YES];

            }else{
                [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            [NSUSERDEFAULT setBool:NO forKey:@"autoDetection"];
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
