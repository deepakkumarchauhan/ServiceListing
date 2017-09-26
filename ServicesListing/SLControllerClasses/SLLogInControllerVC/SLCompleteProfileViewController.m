//
//  SLCompleteProfileViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLCompleteProfileViewController.h"
#import "Header.h"

static NSString *signUpCellIdentifier = @"signUpCellId";

@interface SLCompleteProfileViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,LanguageChangeDelegate>{
    SLUserInfoModel *userInfo;
}


@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet SLCustomButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@end

@implementation SLCompleteProfileViewController
- (IBAction)submitButton:(id)sender {
}

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Alloc Modal Class
    userInfo = [[SLUserInfoModel alloc]init];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self initialSetup];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    if (windowWidth <= 480) {
        self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17];
    }
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:signUpCellIdentifier];
    
    [self.view layoutIfNeeded];
    
    // Set ImageView Coener Radius
    self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;

    [self.submitButton setTitle:SLLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    self.titleLabel.text = SLLocalizedString(@"COMPLETE YOUR PROFILE");
    
    [self.tableView reloadData];
}

- (BOOL)validateFields {

     if (!userInfo.email.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter email") andController:self];
    else if ([userInfo.email validateEmailWithString])
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate email") andController:self];
    else if (!userInfo.mobile.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter mobile") andController:self];
    else if (userInfo.mobile.length<10)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Validate mobile") andController:self];
    else if (!userInfo.address.length)
        [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Enter location") andController:self];
    else
        return YES;
    
    return NO;
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSignUpTableViewCell *signupCell = (SLSignUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:signUpCellIdentifier];

    signupCell.signUpTextField.tag = indexPath.row+100;
    signupCell.signUpButton.hidden = YES;
    
    signupCell.transportLabel.hidden = YES;
    signupCell.availableButton.hidden = YES;
    signupCell.notAvailableButton.hidden = YES;

    signupCell.signUpImageView.hidden = YES;
    signupCell.signUpTextField.delegate = self;
    
    if ([APPDELEGATE isArabic])
        signupCell.signUpTextField.textAlignment = NSTextAlignmentRight;
    else
        signupCell.signUpTextField.textAlignment = NSTextAlignmentLeft;

    switch (indexPath.row) {
        case 0:
            signupCell.signUpTextField.placeholder= SLLocalizedString(@"Email");
            signupCell.signUpTextField.returnKeyType = UIReturnKeyNext;
            signupCell.signUpTextField.text = userInfo.email;
            signupCell.signUpTextField.keyboardType = UIKeyboardTypeEmailAddress;
            return signupCell;
            
        case 1:
            signupCell.signUpTextField.placeholder= SLLocalizedString(@"Mobile Number");
            signupCell.signUpTextField.keyboardType = UIKeyboardTypeNumberPad;
            signupCell.signUpTextField.text = userInfo.mobile;
            return signupCell;

        case 2:
            signupCell.signUpButton.hidden = NO;
            signupCell.signUpImageView.hidden = NO;
            userInfo.address = [APPDELEGATE currentLocation];
            signupCell.signUpTextField.text = [APPDELEGATE currentLocation];
            signupCell.signUpImageView.image = [UIImage imageNamed:@"loc"];
            signupCell.signUpTextField.placeholder= SLLocalizedString(@"Current location");
            [signupCell.signUpButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            return signupCell;
            
        default:
            break;
    }
    return signupCell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 100:
            userInfo.email = TRIM_SPACE(textField.text);
            break;
        case 101:
            userInfo.mobile = TRIM_SPACE(textField.text);
            break;
        case 102:
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
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if (textField.tag == 100  && str.length == 65)
        return NO;
    else if (textField.tag == 101  && str.length == 21)
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 101)
        textField.inputAccessoryView = toolBarForNumberPad(self,SLLocalizedString(@"Done"));
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    self.profileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Selector Method

- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

- (void)locationButtonAction:(UIButton*)sender {
    [self.tableView reloadData];
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.tableView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableView reloadData];
}

- (void)didConfirmWithArabic {
    
    [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
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
        [self.navigationController pushViewController:[APPDELEGATE getNewRevealView] animated:YES];
    }
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
