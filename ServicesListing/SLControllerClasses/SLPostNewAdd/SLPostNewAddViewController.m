//
//  SLPostNewAddViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 20/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLPostNewAddViewController.h"
#import "Header.h"

static NSString *signUpCellIdentifier = @"signUpCellId";
static NSString *cellIdentifier = @"sortCellId";

static NSString *cellLocationIdentifier = @"locationSwitchCellId";



@interface SLPostNewAddViewController ()<UITextFieldDelegate,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,LanguageChangeDelegate,VSDropdownDelegate> {
    
    SLCategoryInfo *categoryInfoSelected;
    SLUserInfoModel *userInfo;
    NSMutableArray *categoryArray;
    NSMutableArray *serviceTypeArray;
    NSMutableArray *createCategoryArray;;
    BOOL showCategory;
    BOOL showPrice;
    VSDropdown *tableCity;

    NSMutableArray *arrCategory;
    NSInteger indexSelected;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *addProfileImageView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;

@property (assign, nonatomic) BOOL isAutoDectectOn;
@property (strong, nonatomic) IBOutlet UIView *headerLocationView;
@property (strong, nonatomic) IBOutlet UILabel *changeLocationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cameraImageView;

@property (strong, nonatomic) IBOutlet UILabel *plusLabel;

//for google auto complete api
@property(nonatomic, retain)NSTimer             *connectionTimer;
@property(nonatomic, retain)NSURLConnection     *theConnection;
@property(nonatomic, retain) NSMutableData      *receivedData;
@property (strong, nonatomic) NSMutableArray    *arrSearchResult;

@property (strong, nonatomic) IBOutlet UILabel *changeLocationTitleLabel;

@property (strong, nonatomic) IBOutlet UIView *locationTitleView;

@end

@implementation SLPostNewAddViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.plusLabel.hidden = NO;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationMessage) name:@"GetLocationNotification" object:nil];
    
    arrCategory = [[NSMutableArray alloc] init];
    
    self.tableView.tableHeaderView = self.tableHeaderView;

    // Alloc Modal Class
    userInfo = [[SLUserInfoModel alloc]init];
    userInfo.address = [[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation];
    userInfo.countryNCode = [NSUSERDEFAULT valueForKey:@"countryNCode"];
    userInfo.countryName = [NSUSERDEFAULT valueForKey:@"CountryFullName"];
    self.isAutoDectectOn = [[NSUSERDEFAULT valueForKey:@"autoDetection"] boolValue];
    
    if (self.isAutoDectectOn)
        [self.locationSwitch setOn:YES];
    else
        [self.locationSwitch setOn:NO];


    userInfo.isAvailable = YES;
    self.tableView.hidden = YES;
    
    self.arrSearchResult = [NSMutableArray array];
    
    tableCity = [[VSDropdown alloc]initWithDelegate:self];
    [tableCity setAdoptParentTheme:YES];
    
//    if ([APPDELEGATE isArabic])
//        categoryArray = [[NSMutableArray alloc] initWithObjects:@"Teaching",@"Painting",@"Cooking",@"Construction",@"computer",@"Tailor",@"Other",@"Mechanic",@"shipping", nil];
//    else
        categoryArray = [[NSMutableArray alloc] initWithObjects:@"Painting",@"Teaching",@"Construction",@"Cooking",@"Tailor",@"computer",@"Mechanic",@"Other",@"shipping", nil];
    

      [self makeWebApiCallToGetCategoryList];

}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self initialSetup];
}


#pragma mark - Custom Method
-(void)initialSetup {
    
    if (self.fromSidePanel) {
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        self.menuButton.hidden = YES;
    }
    else {
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        self.menuButton.hidden = NO;
    }
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUpCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSortTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SLLocationSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:cellLocationIdentifier];

    
    // Alloc MutableArray
   // categoryArray = [[NSMutableArray alloc]initWithObjects:@"Teaching",@"Painting",@"Cooking",@"Tailor",@"Mechanic",nil];
    
    serviceTypeArray = [[NSMutableArray alloc]initWithObjects:@"Study",@"Food Service",nil];
    
    createCategoryArray = [[NSMutableArray alloc]initWithObjects:SLLocalizedString(@"Services offered"),SLLocalizedString(@"Services required"),SLLocalizedString(@"Sales"),SLLocalizedString(@"Required"),SLLocalizedString(@"Inquiry"),nil];
    
    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.titleLabel.text = SLLocalizedString(@"POST A NEW ADD");
    
    self.changeLocationTitleLabel.text = SLLocalizedString(@"Use current location switch to get current location or select country by using drop down");
    
    self.changeLocationLabel.text = SLLocalizedString(@"Current Location");
    
    if ([APPDELEGATE isArabic]) {
        
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.locationTitleView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.changeLocationLabel.textAlignment = NSTextAlignmentRight;
        self.changeLocationTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.headerLocationView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.locationTitleView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.changeLocationLabel.textAlignment = NSTextAlignmentLeft;
        self.changeLocationTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.headerLocationView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
  
    [self makeWebApiCallToGetCategoryList];
    [self.tableView reloadData];
}

- (BOOL)validateFields {
    
    if (!userInfo.requirementName.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter service name") andController:self];
     else if (!userInfo.category.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please select category") andController:self];
    else if (!userInfo.addDescription.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter description") andController:self];
       else if (!userInfo.address.length && [[NSUSERDEFAULT valueForKey:@"autoDetection"] boolValue])
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter location") andController:self];
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

-(void)doCodeToObServeGetCountryCode:(NSNotification *)userINfo {
    NSDictionary * dict = userINfo.userInfo;
    if ([APPDELEGATE isArabic])
        userInfo.countryName = [dict valueForKey:@"cNameArr" ];
    else
        userInfo.countryName = [dict valueForKey:@"cName" ];
    
    self.isAutoDectectOn = NO;
    userInfo.countryNCode = [dict valueForKey:@"countryNameCode"];
  //  strCountyCode = [dict valueForKey:@"mobilePrefix"];
    [self.tableView reloadData];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (!showCategory){
//        if (showPrice)
//            return 6;
//        else
            return 6;
//    } else
//        return 1;
        //return createCategoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSignUpTableViewCell *postAddCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];
    
    SLSortTableViewCell *sortCell = (SLSortTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SLLocationSwitchTableViewCell *locationCell = (SLLocationSwitchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellLocationIdentifier];


    postAddCell.mainView.layer.borderColor = [[UIColor grayColor] CGColor];
    postAddCell.mainView.layer.borderWidth = 1.0;
    postAddCell.mainView.layer.cornerRadius = 5.0;
    
    postAddCell.mainView.hidden = NO;
    postAddCell.signUpTextField.tag = indexPath.row+100;
    postAddCell.signUpTextField.hidden = NO;
    postAddCell.signUpButton.tag = indexPath.row+200;
    postAddCell.signUpButton.hidden = YES;
    postAddCell.transportLabel.hidden = YES;
    postAddCell.availableButton.hidden = YES;
    postAddCell.notAvailableButton.hidden = YES;
    postAddCell.seperatorLabel.hidden = YES;
    postAddCell.signUpImageView.hidden = YES;
    postAddCell.signUpTextField.delegate = self;
    postAddCell.signUpTextField.keyboardType = UIKeyboardTypeDefault;
    postAddCell.availableButton.tag = indexPath.row + 300;
    postAddCell.notAvailableButton.tag = indexPath.row + 301;
    postAddCell.signUpTextField.userInteractionEnabled = YES;
    self.submitButton.hidden = NO;
    
    if ([APPDELEGATE isArabic]) {
        postAddCell.signUpTextField.textAlignment = NSTextAlignmentRight;
        postAddCell.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        postAddCell.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [postAddCell.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [postAddCell.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [postAddCell.availableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];
        [postAddCell.notAvailableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];
        postAddCell.transportLabel.textAlignment = NSTextAlignmentRight;
    }
    else {
        postAddCell.signUpTextField.textAlignment = NSTextAlignmentLeft;
        postAddCell.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        postAddCell.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [postAddCell.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [postAddCell.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        postAddCell.transportLabel.textAlignment = NSTextAlignmentLeft;
    }
    
//    long index;
//    index = indexPath.row;
//    if (!showPrice && index == 4) {
//        index = 5;
//    }
    postAddCell.signUpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    if (!showCategory) {
        
        switch (indexPath.row) {
            case 0:
                postAddCell.signUpTextField.placeholder= SLLocalizedString(@"Service Name");
                postAddCell.signUpTextField.returnKeyType = UIReturnKeyDone;
                postAddCell.signUpTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                break;
                
            case 1:
                postAddCell.signUpButton.hidden = NO;
                postAddCell.signUpTextField.placeholder= SLLocalizedString(@"Select Category");
                postAddCell.signUpImageView.hidden = NO;
                postAddCell.signUpTextField.userInteractionEnabled = NO;
                postAddCell.signUpImageView.image = [UIImage imageNamed:@"downBlue.png"];
                postAddCell.signUpTextField.text = SLLocalizedString(userInfo.category);
                break;
                
            case 2:
                if (userInfo.isAvailable) {
                    postAddCell.availableButton.selected = YES;
                    //postAddCell.notAvailableButton.selected = NO;
                }
                else {
                   // postAddCell.notAvailableButton.selected = YES;
                    postAddCell.availableButton.selected = NO;
                }
                postAddCell.mainView.hidden = YES;

                postAddCell.signUpTextField.hidden = YES;
                postAddCell.transportLabel.text = SLLocalizedString(@"Transportation");
                [postAddCell.availableButton setTitle:SLLocalizedString(@"Available") forState:UIControlStateNormal];
                [postAddCell.notAvailableButton setTitle:SLLocalizedString(@"Not Available") forState:UIControlStateNormal];
                postAddCell.transportLabel.hidden = NO;
                postAddCell.availableButton.hidden = NO;
              //  postAddCell.notAvailableButton.hidden = NO;
                postAddCell.seperatorLabel.hidden = YES;
                break;
                
            case 3:
                postAddCell.signUpTextField.placeholder= SLLocalizedString(@"Description");
                if (showPrice)
                    postAddCell.signUpTextField.returnKeyType = UIReturnKeyNext;
                else
                    postAddCell.signUpTextField.returnKeyType = UIReturnKeyDone;
                break;
                
//            case 4:
//                postAddCell.signUpTextField.placeholder= SLLocalizedString(@"Price in $");
//                postAddCell.signUpTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//                postAddCell.signUpTextField.returnKeyType = UIReturnKeyDone;
//                break;
                
            case 4: {
                locationCell.changeLocationLabel.text= SLLocalizedString(@"Current Location");
                [locationCell.locationSwitch addTarget:self action:@selector(locationSwitch:) forControlEvents:UIControlEventValueChanged];
                
                if (self.isAutoDectectOn)
                    [locationCell.locationSwitch setOn:YES];
                else
                    [locationCell.locationSwitch setOn:NO];
                

                return locationCell;
            }
                break;

            case 5:
                if (self.isAutoDectectOn) {
                    postAddCell.signUpButton.hidden = YES;
                    postAddCell.signUpImageView.image = [UIImage imageNamed:@"loc"];
                    postAddCell.signUpTextField.text = userInfo.address;

                }
                else {
                    postAddCell.signUpTextField.text = userInfo.countryName;
                    postAddCell.signUpButton.hidden = NO;
                    postAddCell.signUpImageView.image = [UIImage imageNamed:@"downBlue.png"];
                }
                postAddCell.signUpTextField.userInteractionEnabled = NO;
                postAddCell.signUpTextField.placeholder= SLLocalizedString(@"Select Location");
                postAddCell.signUpTextField.tag = 600;
                postAddCell.signUpImageView.hidden = NO;
                
                
//                if (self.isAutoDectectOn) {
//                    postAddCell.signUpTextField.text = userInfo.address;
////                    [self.locationSwitch setOn:YES];
//                }
//                else {
//                    postAddCell.signUpTextField.text = userInfo.countryName;
////                    [self.locationSwitch setOn:NO];
//                }
//                
                postAddCell.signUpTextField.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }
        [postAddCell.signUpButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [postAddCell.availableButton addTarget:self action:@selector(transportationButton:) forControlEvents:UIControlEventTouchUpInside];
        [postAddCell.notAvailableButton addTarget:self action:@selector(transportationButton:) forControlEvents:UIControlEventTouchUpInside];
        return postAddCell;
        
    }
    else {
        self.submitButton.hidden = YES;
        sortCell.sortTitleLabel.textAlignment = NSTextAlignmentCenter;
        sortCell.sortTitleLabel.text = [createCategoryArray objectAtIndex:indexPath.row];
        sortCell.checkButton.hidden = YES;
        return sortCell;
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSortTableViewCell *sortCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([sortCell isKindOfClass:[SLSortTableViewCell class]]) {
        
      //  self.tableView.tableHeaderView = self.tableHeaderView;
        indexSelected = indexPath.row;
        
        if (indexPath.row == 2)
            showPrice = YES;
        else
            showPrice = NO;
        
        showCategory = YES;
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 3) {
        return 85;
    }
    return 58;
}

#pragma mark - UITextField Delegate

//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (textField.tag == 600) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
//        SLAutoDetectionVC *countryVC = [[SLAutoDetectionVC alloc]initWithNibName:@"SLAutoDetectionVC" bundle:nil];
//        countryVC.delegate = self;
//        [self.view endEditing:YES];
//        [self presentViewController:countryVC animated:YES completion:nil];
//    }
//}

//-(void)doCodeToObServeGetCountryCode:(NSNotification *)userINfo {
//    userInfo.address = [userINfo valueForKey:@"object" ];
//    [self.tableView reloadData];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 100:
            userInfo.requirementName = TRIM_SPACE(textField.text);
            break;
        case 103:
            userInfo.addDescription = TRIM_SPACE(textField.text);
            break;
        case 104:
            userInfo.price = TRIM_SPACE(textField.text);
            break;
        case 600:
            userInfo.address = TRIM_SPACE(textField.text);
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
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if (textField.tag == 100 && str.length == 31)
        return NO;
    else if (textField.tag == 103  && str.length == 501)
        return NO;
    else if (textField.tag == 104  && str.length == 8)
        return NO;
    else if (textField.tag == 600  && str.length == 300)
        return NO;
    else if (textField.tag == 104  && ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound ||  [string containsString:@"."]))
        return YES;
    else if (textField.tag == 104 )
        return NO;
    
    if (textField.tag == 600) {
        NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        BOOL isSkip = NO;
        
        if (searchStr.length == 0 ) {
            [tableCity remove];
            //  [tableCity hideDropDown:textField];
            textField.text = @"";
            isSkip = YES;
        }
        if (!isSkip) {
            [self googleAPICallWithText:searchStr];
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    self.addProfileImageView.image = image;
    userInfo.imageProfile = image;
    self.plusLabel.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Selector Method

- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

- (void)receiveLocationMessage {
    
    userInfo.address = [[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation];
    [self.tableView reloadData];
}

- (void)buttonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    
    if (sender.tag == 201) {
        [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:arrCategory AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            
            SLCategoryInfo *catInfoTemp = arrCategory[selectedIndex];
            userInfo.category = selectedText;
            userInfo.categoryID = catInfoTemp.service_category_id;
            [self.tableView reloadData];
        }];
    }
    else if (sender.tag == 205){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCodeToObServeGetCountryCode:) name:@"GETCountryCodeNotification" object:nil];
        
        SLCountryCodeViewController *countryVC = [[SLCountryCodeViewController alloc]initWithNibName:@"SLCountryCodeViewController" bundle:nil];
        countryVC.isMobileCode = YES;
        countryVC.isFromPostAdd = YES;
        [self presentViewController:countryVC animated:YES completion:nil];

    }
}

- (void)transportationButton:(UIButton *)sender {
    
  //  if (sender.tag == 302) {
        userInfo.isAvailable = !userInfo.isAvailable;
        //userInfo.isNotAvailable = NO;
 //   }
//    else {
//        userInfo.isAvailable = NO;
//        userInfo.isNotAvailable = YES;
//    }
    [self.tableView reloadData];
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

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.fromSidePanel) {
        if ([APPDELEGATE isArabic])
            [self.sidePanelController showRightPanelAnimated:YES];
        else
            [self.sidePanelController showLeftPanelAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LanguageChageNotificationOnSidePannel"
         object:self];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateFields]) {
        
        [self showLoader];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:userInfo.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count) {
                CLPlacemark *placemark = placemarks.firstObject;
                [self makeWebApiCallToCreateAdvertisement:placemark.location.coordinate];
            }else{
                [self makeWebApiCallToCreateAdvertisement:CLLocationCoordinate2DMake(0, 0)];
            }
        }];    }
}

- (IBAction)notificationButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    BOOL isNotificationVC = NO;
    for (UIViewController *viewcontroller in self.navigationController.viewControllers) {
        if ([viewcontroller isKindOfClass:[SLNotificationViewController class]]) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.35f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName :kCAMediaTimingFunctionEaseIn];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            [self.navigationController popToViewController:viewcontroller animated:NO];
            isNotificationVC = YES;
            break;
        }
    }
    if (!isNotificationVC) {
        SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]init];
        [self.navigationController pushViewController:notificationVC animated:YES];
        
    }
}


#pragma mark - Switch Button Action

- (IBAction)locationButtonAction:(id)sender {
    
//    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        
//        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Please enable location services in settings to continue using the app!") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            [self.locationSwitch setOn:NO];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            [self.locationSwitch setOn:NO];
//            
//        }];
//        [alert addAction:okAction];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:NO completion:nil];
//        
//    }else if(self.locationSwitch.on){
//        self.isAutoDectectOn = YES;
//        userInfo.address = [APPDELEGATE currentLocation];
//    }else{
//        self.isAutoDectectOn = NO;
//    }
//    [self.tableView reloadData];
//
}



- (void)locationSwitch:(UISwitch *)sender {
    
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Please enable location services in settings to continue using the app!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.locationSwitch setOn:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender setOn:NO];
            
        }];
        [alert addAction:okAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:NO completion:nil];
        
    }else if(sender.on){
        self.isAutoDectectOn = YES;
        userInfo.address = [APPDELEGATE currentLocation];
    }else{
        self.isAutoDectectOn = NO;
    }
    [self.tableView reloadData];
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallToGetCategoryList {
    
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiservice_category_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        self.tableView.hidden = NO;

        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [arrCategory removeAllObjects];
                [arrCategory addObjectsFromArray:[SLCategoryInfo categoryArrayFromResponse:[response objectForKeyNotNull:Kservice_category_list expectedClass:[NSArray class]]]];
                
                if (![[[AppSettingsManager sharedinstance] objectForKey:KcategoryType] isEqualToString:@""]) {
                    
                    SLCategoryInfo *catInfoTemp = arrCategory[[[[AppSettingsManager sharedinstance] objectForKey:KcategoryType] intValue]];
                    userInfo.category = catInfoTemp.service_name;
                 //   userInfo.category = [categoryArray objectAtIndex:[[[AppSettingsManager sharedinstance] objectForKey:KcategoryType] intValue]];

                    userInfo.categoryID = catInfoTemp.service_category_id;
                    [self.tableView reloadData];
   
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

- (void)makeWebApiCallToCreateAdvertisement:(CLLocationCoordinate2D)locTemp {
    
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];

    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:userInfo.requirementName forKey:KrequirementName];
    [dictRequest setValue:userInfo.categoryID forKey:Kcategory];
    [dictRequest setValue:[NSString stringWithFormat:@"%ld",(long)indexSelected + 2] forKey:KserviceType];
    [dictRequest setValue:(userInfo.isAvailable ? @"available" : @"not available") forKey:Ktransportation];
    [dictRequest setValue:userInfo.price forKey:Kprice];
    [dictRequest setValue:userInfo.addDescription forKey:Kdescription];
    
    NSData *dataImage = UIImageJPEGRepresentation(userInfo.imageProfile, 0.1);
    [dictRequest setValue:[dataImage base64EncodedString] forKey:Kimage];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    if (self.isAutoDectectOn) {
        [dictRequest setValue:userInfo.address forKey:Klocation];
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
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiAddAdvertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
            
                [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"Success!") message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"OK"), nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    BOOL isHomeVisible = NO;
                    
                    id centerPanelObj = [[APPDELEGATE customSlidePanel] centerPanel];
                    if ([centerPanelObj isKindOfClass:[UINavigationController class]]) {
                        centerPanelObj = (UINavigationController*)centerPanelObj;
                        UIViewController *viewControllerRoot = [[(UINavigationController*)centerPanelObj viewControllers] firstObject];
                        if ([viewControllerRoot isKindOfClass:[SLTabBaseViewController class]]) {
                            isHomeVisible = YES;
                        }
                    }
                    
                    if (isHomeVisible) {
                        [[APPDELEGATE sidePanelNavigation] popToRootViewControllerAnimated:NO];
                        
                    }else{
                        SLTabBaseViewController *homeVC = [[SLTabBaseViewController  alloc] initWithNibName:@"SLTabBaseViewController" bundle:nil];
                        [APPDELEGATE setSidePanelNavigation:[[UINavigationController alloc] initWithRootViewController:homeVC]];
                        [self.sidePanelController setCenterPanel:[APPDELEGATE sidePanelNavigation]];
                    }
                    
                    [self performSelector:@selector(notificationFire) withObject:nil afterDelay:0.001];

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
    
    
- (void)notificationFire {
    
    NSMutableDictionary* userInfoDict = [[NSMutableDictionary alloc]init];
    
    [userInfoDict setValue:userInfo.category forKey:@"categoryName"];
    [userInfoDict setValue:userInfo.categoryID forKey:@"categoryId"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"getCategoryList" object:self userInfo:userInfoDict];
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    self.view.userInteractionEnabled = NO;
    self.submitButton.enabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    self.view.userInteractionEnabled = YES;
    self.submitButton.enabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



#pragma mark - Google Suggestion API

-(void)googleAPICallWithText:(NSString*)strData {
    
    strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //  NSString   *web_service_URL = [NSString stringWithFormat:@"%@js?v=3&language=en&sensor=false&libraries=places&input=%@&key=%@",@"maps.googleapis.com/maps/api/",strData,GOOGLE_CLIENT_ID ];
    
    
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Ca&types=geocode&sensor=false&key=
    //google api url
    NSString   *web_service_URL = [NSString stringWithFormat:@"%@json?input=%@&sensor=%@&types=&key=%@",GOOGLE_GEOLOCATION_URL,strData,@"false",GOOGLE_API_KEY ];
    
    NSMutableString *reqData = [NSMutableString stringWithFormat:@""];
    id jsonDta= [reqData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString   *jsonRepresantationFormat = [[NSString alloc]initWithData:jsonDta encoding:NSUTF8StringEncoding];
    [self WebsewrviceAPICall:web_service_URL webserviceBodyInfo:jsonRepresantationFormat];
}

-(void)WebsewrviceAPICall:(NSString *)serviceURL  webserviceBodyInfo:(NSString *)bodyString{
    
    self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(cancelInsingAPICall) userInfo:nil repeats:NO];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serviceURL]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if( self.theConnection ){
        self.receivedData = [NSMutableData data];
    }
}

-(void)cancelInsingAPICall {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.receivedData length] == 0) {
        [self.theConnection cancel];
    }
}

#pragma mark Implementation callbacksh

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(self.connectionTimer){
        [self.connectionTimer invalidate];
        self.connectionTimer = nil;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if(self.connectionTimer){
        [self.connectionTimer invalidate];
        self.connectionTimer = nil;
    }
    //    [COMMON RemoveLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:self.receivedData options: NSJSONReadingMutableContainers error: nil];
    
    //remove all objects from array
    [self.arrSearchResult removeAllObjects];
    
    [self.arrSearchResult addObjectsFromArray:[PlaceSuggestion getSearchInfoFromDict:[JSON objectForKey:PARAM_PRIDICTION]]];
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (PlaceSuggestion *obj in self.arrSearchResult) {
        [arrTemp addObject:obj.discription];
    }
    //  if (!tableCity)
    //  {
    UITextField *textFieldLocation = (UITextField *)[self.view viewWithTag:600];
    //  tableCity.dataArr = self.arrSearchResult;
    // tableCity = [[VSDropdown  alloc] showDropDown:textFieldLocation height:150 arr:arrTemp imgArr:arrTemp direction:@"down"];
    [self showDropDownForTextField:textFieldLocation adContents:arrTemp multipleSelection:NO];
    
    // }else{
    // [tableCity reloadTable:[arrTemp count]>0 ? arrTemp:(NSMutableArray *)@[@"City / Zip not found"]];
    //  }
}

#pragma mark - VSDropDown Delegate methdos

-(void)showDropDownForTextField:(UITextField *)txt adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [tableCity setDrodownAnimation:rand()%2];
    
    [tableCity setAllowMultipleSelection:multipleSelection];
    
    [tableCity setupDropdownForView:txt];
    
    [tableCity setBackgroundColor:[UIColor whiteColor]];
    
    [tableCity setSeparatorColor:txt.textColor];
    
    if (tableCity.allowMultipleSelection)
    {
        [tableCity reloadDropdownWithContents:contents andSelectedItems:[txt.text componentsSeparatedByString:@";"]];
    }
    else
    {
        [tableCity reloadDropdownWithContents:contents andSelectedItems:@[txt.text]];
    }
    
}

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    UITextField *txtField = (UITextField *)dropDown.dropDownView;
    [self.view endEditing:YES];
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1)    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    }
    else{
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    txtField.text = allSelectedItems;
     userInfo.address = allSelectedItems;
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    UITextField *btn = (UITextField *)dropdown.dropDownView;
    return btn.textColor;
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 0.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 0.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}


@end
