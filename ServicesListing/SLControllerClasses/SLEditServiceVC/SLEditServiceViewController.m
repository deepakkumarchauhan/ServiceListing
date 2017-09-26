//
//  SLEditServiceViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLEditServiceViewController.h"
#import "Header.h"

static NSString *editServiceCellIdentifier = @"editServiceCellId";

@interface SLEditServiceViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,LanguageChangeDelegate>{
    SLServiceDetailModal *editServiceInfo;
    NSMutableArray *createCategoryArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (strong, nonatomic) IBOutlet UIButton *postAddButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLEditServiceViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Alloc Model Class
    editServiceInfo = [[SLServiceDetailModal alloc]init];
    [self updatingLocalModelClassWithData];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:editServiceInfo.image] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
    
    // Notification Count Set
    self.notificationCountLabel.layer.cornerRadius = self.notificationCountLabel.frame.size.width/2;
    self.notificationCountLabel.layer.masksToBounds = YES;

    if ([APPDELEGATE notificationCount] == 0)
        self.notificationCountLabel.hidden = YES;
    else {
        self.notificationCountLabel.hidden = NO;
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE notificationCount]];
    }
    
    // Alloc Arrar
    createCategoryArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(increaseNotificationCount) name:@"getNotificationCount" object:nil];
    
    [self makeWebApiCallToGetCategoryList];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom Method
-(void)initialSetup {
    
    // Set title
    self.titleLabel.text = SLLocalizedString(@"Edit service");
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLEditServiceTableViewCell" bundle:nil] forCellReuseIdentifier:editServiceCellIdentifier];
    
      [self.saveButton setTitle:SLLocalizedString(@"Save") forState:UIControlStateNormal];
    if ([APPDELEGATE isArabic])
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    else
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");
    //[self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];

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

- (BOOL)validateFields {
    
    if (!editServiceInfo.strServiceName.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please enter service name") andController:self];
    else if (!editServiceInfo.strCategory.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please select category") andController:self];
    else
        return YES;
    
    return NO;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updatingLocalModelClassWithData {
    editServiceInfo.strServiceName = self.serviceModel.strServiceName;
    editServiceInfo.strCategory = self.serviceModel.strCategory;
    editServiceInfo.strPrice = self.serviceModel.strPrice;
    editServiceInfo.strTransportationAvail = self.serviceModel.strTransportationAvail;
    editServiceInfo.image = self.serviceModel.image;
    editServiceInfo.strCategoryId = self.serviceModel.strCategoryId;

}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (editServiceInfo.strPrice.length) {
        return 4;
    }
    else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLEditServiceTableViewCell *editCell = (SLEditServiceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:editServiceCellIdentifier];
    
    editCell.editServiceButton.hidden = YES;
    editCell.editServiceTextField.userInteractionEnabled = NO;
    editCell.editServiceTextField.delegate = self;
    editCell.editServiceTextField.keyboardType = UIKeyboardTypeDefault;
    editCell.arrowImageView.hidden = NO;
    editCell.editServiceTextField.tag = indexPath.row + 100;
    editCell.editServiceButton.tag = indexPath.row + 200;
    editCell.availableButton.hidden = YES;
    editCell.notAvailableButton.hidden = YES;
    editCell.seperatorLabel.hidden = NO;
    editCell.transportationLabel.hidden = YES;
    editCell.availableButton.tag = indexPath.row + 300;
    editCell.notAvailableButton.tag = indexPath.row + 301;

    if ([APPDELEGATE isArabic]) {
        editCell.editServiceTextField.textAlignment = NSTextAlignmentRight;
        editCell.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        editCell.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        editCell.transportationLabel.textAlignment = NSTextAlignmentRight;
        [editCell.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [editCell.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [editCell.availableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];
        [editCell.notAvailableButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 8)];
    }
    else {
        editCell.editServiceTextField.textAlignment = NSTextAlignmentLeft;
        editCell.availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        editCell.notAvailableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        editCell.transportationLabel.textAlignment = NSTextAlignmentLeft;
        [editCell.notAvailableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [editCell.availableButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    long index = indexPath.row;
    if (index == 2 && !editServiceInfo.strPrice.length) {
        index = 3;
    }
    switch (index) {
        case 0:
            editCell.editServiceTextField.placeholder = SLLocalizedString(@"Service name");
            editCell.editServiceTextField.userInteractionEnabled = YES;
            editCell.arrowImageView.hidden = YES;
            editCell.editServiceTextField.returnKeyType = UIReturnKeyDone;
            editCell.editServiceTextField.text =editServiceInfo.strServiceName;
            break;
            
        case 1:
            editCell.editServiceTextField.placeholder = SLLocalizedString(@"Category");
            editCell.editServiceButton.hidden = NO;
            editCell.editServiceTextField.text = SLLocalizedString(editServiceInfo.strCategory);
            break;
            
        case 2:
            editCell.editServiceTextField.placeholder = SLLocalizedString(@"Price in $");
            editCell.arrowImageView.hidden = YES;
            editCell.editServiceTextField.returnKeyType = UIReturnKeyDone;
            editCell.editServiceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            editCell.editServiceTextField.userInteractionEnabled = YES;
            editCell.editServiceTextField.text = editServiceInfo.strPrice;
            break;
            
        case 3:
            if ([editServiceInfo.strTransportationAvail isEqualToString:@"available"]) {
                editCell.availableButton.selected = YES;
            }
            else {
                editCell.availableButton.selected = NO;
            }
            editCell.transportationLabel.text = SLLocalizedString(@"Transportation");
            [editCell.availableButton setTitle:SLLocalizedString(@"Available") forState:UIControlStateNormal];
            [editCell.notAvailableButton setTitle:SLLocalizedString(@"Not Available") forState:UIControlStateNormal];
            editCell.transportationLabel.hidden = NO;
            editCell.arrowImageView.hidden = YES;
            editCell.seperatorLabel.hidden = YES;
            editCell.availableButton.hidden = NO;
            [editCell.availableButton addTarget:self action:@selector(transportationButton:) forControlEvents:UIControlEventTouchUpInside];
            //editCell.notAvailableButton.hidden = NO;
            break;
            
        default:
            break;
    }
    [editCell.editServiceButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    //[editCell.notAvailableButton addTarget:self action:@selector(transportationButton:) forControlEvents:UIControlEventTouchUpInside];

    return editCell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 3 && editServiceInfo.strPrice.length)||(indexPath.row == 2 && !editServiceInfo.strPrice.length))
        return 60;
    else
        return 48;
}


#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
            case 100:
                editServiceInfo.strServiceName = TRIM_SPACE(textField.text);
                break;
            case 102:
                editServiceInfo.strPrice = TRIM_SPACE(textField.text);
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

    if (textField.tag == 100 && str.length == 101)
        return NO;
    else if (textField.tag == 102 && str.length == 8)
        return NO;
    else if (textField.tag == 102  && ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound ||  [string containsString:@"."]))
        return YES;
    else if (textField.tag == 102 )
        return NO;
    
    else
    return YES;
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    self.profileImageView.image = image;
    editServiceInfo.editImage = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Selector Method

- (void)doneWithNumberPad {
    [self.view endEditing:YES];
}

- (void)editButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    if (sender.tag == 201) {
        [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:createCategoryArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            
            SLCategoryInfo *catInfoTemp = createCategoryArray[selectedIndex];
            editServiceInfo.strCategory = selectedText;
            editServiceInfo.strCategoryId = catInfoTemp.service_category_id;
            [self.tableView reloadData];
        }];
    }
    else if (sender.tag == 203) {
        [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:[NSArray arrayWithObjects:@"D",@"E",@"F",nil] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            editServiceInfo.strTransportationAvail = selectedText;
            [self.tableView reloadData];
        }];
    }
    else if (sender.tag == 204) {
        [[OptionsPickerSheetView sharedPicker]showPickerSheetWithOptions:createCategoryArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            editServiceInfo.strServiceType = selectedText;
            [self.tableView reloadData];
        }];
    }
}

- (void)transportationButton:(UIButton *)sender {
    
    if (sender.selected) {
        editServiceInfo.strTransportationAvail = @"not available";
    }
    else
        editServiceInfo.strTransportationAvail = @"available";

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

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self makeWebApiCallToGetCategoryList];
}

- (IBAction)notificationButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)saveButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validateFields]) {
        [self makeWebApiCallForEditService];
    }
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}


- (IBAction)cameraButtonAction:(id)sender {
    
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


#pragma mark - Web Api Method

- (void)makeWebApiCallForEditService {
    
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:self.serviceModel.strNid forKey:Knid];
    [dictRequest setValue:editServiceInfo.strServiceName forKey:KrequirementName];
    [dictRequest setValue:editServiceInfo.strCategoryId forKey:Kcategory];
    [dictRequest setValue:editServiceInfo.strPrice forKey:Kprice];
    [dictRequest setValue:([editServiceInfo.strTransportationAvail isEqualToString:@"available"])?@"available":@"not available" forKey:Ktransportation];
    NSData *dataImage = UIImageJPEGRepresentation(editServiceInfo.editImage, 0.1);
    [dictRequest setValue:[dataImage base64EncodedString] forKey:Kimage];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiedit_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"editServiceNotification" object:nil];
                
               // [self.delegate editAdd];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

- (void)makeWebApiCallToGetCategoryList {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiservice_category_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [createCategoryArray removeAllObjects];
                [createCategoryArray addObjectsFromArray:[SLCategoryInfo categoryArrayFromResponse:[response objectForKeyNotNull:Kservice_category_list expectedClass:[NSArray class]]]];
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


#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    [self.saveButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    [self.saveButton setTitle:SLLocalizedString(@"Save") forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



@end
