//
//  SLSidePanelViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 19/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLSidePanelViewController.h"
#import "SLAutoDetectionVC.h"
#import "Header.h"

static NSString *sidePanelCellIdentifier = @"sidePanelCellId";

@interface SLSidePanelViewController ()<UITableViewDelegate,LanguageChangeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLSidePanelViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialSetup];
    [self updateProfile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile) name:KNOTIFICATION_UPDATE_PROFILE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeMethodForTableReload:) name:@"LanguageChageNotificationOnSidePannel" object:nil];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateProfile{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.nameLabel.text = [[AppSettingsManager sharedinstance] objectForKey:KDefaultUserName];
        
        NSString *strProfile = [[AppSettingsManager sharedinstance] objectForKey:KDefaultUserProfile];
        if (strProfile.length) {
            [self.imgViewProfile setImageWithURL:[NSURL URLWithString:strProfile] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else{
            [self.imgViewProfile setImage:[UIImage imageNamed:@"placeholder"]];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)makeMethodForTableReload:(NSNotification*)notification {
    
    if ([APPDELEGATE isArabic]) {
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.tableView.frame = CGRectMake(97, 0, windowWidth-97, windowHeight);
        
    }else{
        
        [[self.sidePanelController view] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.tableView.frame = CGRectMake(0, 0, windowWidth-97, windowHeight);
        
    }
    [self initialSetup];
    [self.tableView reloadData];
}

- (void)initialSetup {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSidePanelTableViewCell" bundle:nil] forCellReuseIdentifier:sidePanelCellIdentifier];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.size.width / 2;
    self.profileImageView.layer.masksToBounds = YES;
    
    if ([APPDELEGATE isArabic])
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    else
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSidePanelTableViewCell *sidePanelCell = (SLSidePanelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:sidePanelCellIdentifier];
    sidePanelCell.topSeperatorLabel.hidden = YES;
    
    
    if ([APPDELEGATE isArabic]) {
        [sidePanelCell.mainViewCell setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.headerView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        sidePanelCell.sideTitleLabel.textAlignment = NSTextAlignmentRight;
    }else{
        [sidePanelCell.mainViewCell setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.headerView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        sidePanelCell.sideTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    switch (indexPath.row) {
        case 0:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Home");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"home.png"];
            sidePanelCell.topSeperatorLabel.hidden = NO;
            break;
        case 1:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Notification");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"notification.png"];
            break;
        case 2:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"My ads");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"myad.png"];
            break;
        case 3:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Post a new ad");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"postadd.png"];
            break;
        case 4:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"My service");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"service.png"];
            break;
        case 5:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Change Location");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"Location.png"];
            break;
        case 6:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Terms & Services");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"terms.png"];
            break;
            
        case 7:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Contact us");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"contact.png"];
            break;
            
        case 8:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Privacy policy");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"privacy.png"];
            break;
            
        case 9:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Favorite");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"favorite.png"];
            break;
            
        case 10:
            sidePanelCell.sideTitleLabel.text = SLLocalizedString(@"Logout");
            sidePanelCell.sideImageView.image = [UIImage imageNamed:@"logout.png"];
            break;
            
        default:
            break;
    }
    return sidePanelCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            SLTabBaseViewController *homeVC = [[SLTabBaseViewController  alloc] initWithNibName:@"SLTabBaseViewController" bundle:nil];
            [self.sidePanelController setCenterPanel:[[APPDELEGATE sidePanelNavigation] initWithRootViewController:homeVC]];
        }
            break;
        case 1:{
            SLNotificationViewController *notificationVC = [[SLNotificationViewController  alloc] initWithNibName:@"SLNotificationViewController" bundle:nil];
            notificationVC.fromSidePanel = YES;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:notificationVC]];
        }
            break;
        case 2:{
            // My Add
            SLMyAdsViewController *adVC = [[SLMyAdsViewController  alloc] initWithNibName:@"SLMyAdsViewController" bundle:nil];
            adVC.fromSidePanel = YES;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:adVC]];
        }
            break;
        case 3:{
            // Post New Add
            SLPostNewAddViewController *postNewAdVC = [[SLPostNewAddViewController  alloc] initWithNibName:@"SLPostNewAddViewController" bundle:nil];
            postNewAdVC.fromSidePanel = YES;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:postNewAdVC]];
        }
            break;
        case 4:{
            // My Service
            SLServicesViewController *servicesVC = [[SLServicesViewController  alloc] initWithNibName:@"SLServicesViewController" bundle:nil];
            servicesVC.fromSidePanel = YES;
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            app.sidePanelNavigation = [[UINavigationController alloc]initWithRootViewController:servicesVC];

            [self.sidePanelController setCenterPanel:app.sidePanelNavigation];
        }
            break;
            
        case 5:{
            // Policy
            SLAutoDetectionVC *termsVC = [[SLAutoDetectionVC  alloc] initWithNibName:@"SLAutoDetectionVC" bundle:nil];
            termsVC.fromSidePanel = YES;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:termsVC]];
        }
            break;

            
        case 6:{
            // Policy
            SLPolicyViewController *termsVC = [[SLPolicyViewController  alloc] initWithNibName:@"SLPolicyViewController" bundle:nil];
            termsVC.type = @"terms&services";
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:termsVC]];
        }
            break;
        case 7:{
            // Contact Us
            SLContactUsViewController *contactUsVC = [[SLContactUsViewController  alloc] initWithNibName:@"SLContactUsViewController" bundle:nil];
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:contactUsVC]];
        }
            break;
        case 8:{
            // Policy
            SLPolicyViewController *privacyVC = [[SLPolicyViewController  alloc] initWithNibName:@"SLPolicyViewController" bundle:nil];
            privacyVC.type = @"privacypolicy";
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:privacyVC]];
        }
            break;
        case 9:{
            // Favorite Screen
            SLFavoritesViewController *favVC = [[SLFavoritesViewController  alloc] initWithNibName:@"SLFavoritesViewController" bundle:nil];
            favVC.fromSidePanel = YES;
            [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:favVC]];
        }
            break;
        case 10:{
            // Logout Alert
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Are you sure you want to Logout ?") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self makeWebApiCallForLogOut];
                }];
                [alert addAction:okAction];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:NO completion:nil];
            });
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self initialSetup];
    [self.tableView reloadData];
    SLTabBaseViewController *homeVC = [[SLTabBaseViewController  alloc] initWithNibName:@"SLTabBaseViewController" bundle:nil];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:homeVC]];
}

- (void)didConfirmWithArabic {
    
    [self initialSetup];
    [self.tableView reloadData];
    SLTabBaseViewController *homeVC = [[SLTabBaseViewController  alloc] initWithNibName:@"SLTabBaseViewController" bundle:nil];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:homeVC]];
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
    
    SLProfileViewController *profileVC = [[SLProfileViewController  alloc] initWithNibName:@"SLProfileViewController" bundle:nil];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:profileVC]];
}

#pragma mark - Web Service API Methods

- (void)makeWebApiCallForLogOut {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:Kios forKey:KdeviceType];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultDeviceToken] forKey:KdeviceToken];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiLogout WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AppSettingsManager sharedinstance] setBool:NO forKey:KDefaultUserVerification];
                [[AppSettingsManager sharedinstance] setObject:@"" forKey:KDefaultUserID];
                [[AppSettingsManager sharedinstance] setObject:@"" forKey:KDefaultUserName];
                [[AppSettingsManager sharedinstance] setObject:@"" forKey:KDefaultUserProfile];
                
//                SLLoginViewController *logInVC = [[SLLoginViewController alloc]initWithNibName:@"SLLoginViewController" bundle:nil];
//                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
//                [self.navigationController setNavigationBarHidden:YES];
                
                [APPDELEGATE loginScreen];
              //  [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    [[APPDELEGATE window] setUserInteractionEnabled:NO];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    [[APPDELEGATE window] setUserInteractionEnabled:YES];
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
