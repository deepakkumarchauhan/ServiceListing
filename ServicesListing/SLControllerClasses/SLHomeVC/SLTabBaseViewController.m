//
//  SLHomeViewController.m
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLTabBaseViewController.h"
#import "Header.h"

@interface SLTabBaseViewController ()<LanguageChangeDelegate> {
    
    SLCategoriesViewController *categoryVC;
    SLFavoritesViewController *favouritesVC;
    SLMyAdsViewController *myAdVC;
    NSInteger tabNumber;
}

// UIButton Properties
@property (weak, nonatomic) IBOutlet UIButton *btnCategoriesImg;
@property (weak, nonatomic) IBOutlet UIButton *btnCategText;
@property (weak, nonatomic) IBOutlet UIButton *btnMyAdsImg;
@property (weak, nonatomic) IBOutlet UIButton *btnMyAdstext;
@property (weak, nonatomic) IBOutlet UIButton *btnFavImg;
@property (weak, nonatomic) IBOutlet UIButton *btnFavText;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//UIView Properties
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *customTabBarView;

@end

@implementation SLTabBaseViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    tabNumber = 0;
    
        self.titleLabel.text = SLLocalizedString(@"I'M IN HOME");
   
    if ([NSUSERDEFAULT boolForKey:@"isDontAllowPopUp"]) {
        SLAutoDetectionVC *countryVC = [[SLAutoDetectionVC alloc]initWithNibName:@"SLAutoDetectionVC" bundle:nil];
        countryVC.fromHome = YES;
        [self.navigationController presentViewController:countryVC animated:YES completion:nil];
    }

    
        if ([APPDELEGATE notificationCount] == 0)
            self.notificationCountLabel.hidden = YES;
        else {
            self.notificationCountLabel.hidden = NO;
            self.notificationCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE notificationCount]];
        }
        // Alloc Controller
        categoryVC = [[SLCategoriesViewController alloc]initWithNibName:@"SLCategoriesViewController" bundle:nil];
        categoryVC.isComingFromNavigation = self.isFromNotification;
        
        favouritesVC = [[SLFavoritesViewController alloc]initWithNibName:@"SLFavoritesViewController" bundle:nil];
        myAdVC = [[SLMyAdsViewController alloc]initWithNibName:@"SLMyAdsViewController" bundle:nil];
        
        // Notification Count Set
        self.notificationCountLabel.layer.cornerRadius = self.notificationCountLabel.frame.size.width/2;
        self.notificationCountLabel.layer.masksToBounds = YES;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(increaseNotificationCount) name:@"getNotificationCount" object:nil];
        
        [self restoreButtonState];
        [_btnCategoriesImg setSelected:YES];
        [_btnCategText setSelected:YES];
        [self displayController:categoryVC];

}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initialSetup];
    self.navigationController.navigationBarHidden = YES;
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


# pragma mark - * * * HELPER METHOD * * *

-(void)restoreButtonState{
    
    [_btnCategoriesImg setSelected:NO];
    [_btnCategText setSelected:NO];
    
    [_btnMyAdsImg setSelected:NO];
    [_btnMyAdstext setSelected:NO];
    
    [_btnFavImg setSelected:NO];
    [_btnFavText setSelected:NO];
}

- (void)initialSetup {
    
    if (tabNumber == 0)
        self.titleLabel.text = SLLocalizedString(@"I'M IN HOME");
    else if (tabNumber == 1)
        self.titleLabel.text = SLLocalizedString(@"MY ADS");
    else
        self.titleLabel.text = SLLocalizedString(@"FAVORITES");
    
    [self.btnCategText setTitle:SLLocalizedString(@"CATEGORIES") forState:UIControlStateNormal];
    [self.btnMyAdstext setTitle:SLLocalizedString(@"MY ADS") forState:UIControlStateNormal];
    [self.btnFavText setTitle:SLLocalizedString(@"FAVORITES") forState:UIControlStateNormal];
     [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    if ([APPDELEGATE isArabic]) {
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.customTabBarView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"languageArbNotification" object:nil];
    }
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.customTabBarView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"languageEngNotification" object:nil];
    }
}


# pragma mark - * * * BUTTON ACTION * * *

- (IBAction)customTabbarBtnAction:(UIButton *)sender {

    if (sender.tag == self.tabItem)
        return;
    switch (sender.tag) {
        case 200: {
            [self restoreButtonState];
            tabNumber = 0;
            self.titleLabel.text = SLLocalizedString(@"I'M IN HOME");
            [_btnCategoriesImg setSelected:YES];
            [_btnCategText setSelected:YES];
            [self displayController:categoryVC];
        }
            break;
            
        case 201:{
            [self restoreButtonState];
            tabNumber = 1;
            self.titleLabel.text = SLLocalizedString(@"MY ADS");
            [_btnMyAdsImg setSelected:YES];
            [_btnMyAdstext setSelected:YES];
            [self displayController:myAdVC];
        }
            break;
            
        case 202:{
            [self restoreButtonState];
            tabNumber = 2;
            self.titleLabel.text = SLLocalizedString(@"FAVORITES");
            [_btnFavImg setSelected:YES];
            [_btnFavText setSelected:YES];
            [self displayController:favouritesVC];
        }
            break;
            
        default:
            break;
    }
    [self initialSetup];
}


#pragma mark - other methods

- (void)displayController:(UIViewController *)viewController {
    
    [self replaceCurrentVCWithVC:viewController];
}

- (void)replaceCurrentVCWithVC:(UIViewController *)newVC {
    
    [newVC willMoveToParentViewController:nil];
    [newVC.view removeFromSuperview];
    [newVC removeFromParentViewController];
    [self addChildViewController:newVC];
    [self.mainView addSubview:newVC.view];
    newVC.view.frame = self.mainView.bounds;
    [newVC didMoveToParentViewController:self];
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.customTabBarView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageEngNotification" object:nil];
}

- (void)didConfirmWithArabic {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.customTabBarView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageArbNotification" object:nil];
}

#pragma mark - UIButton Action

- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([APPDELEGATE isArabic]) {
        [self.sidePanelController showRightPanelAnimated:YES];
    }else{
        [self.sidePanelController showLeftPanelAnimated:YES];
        
    }
    [[AppSettingsManager sharedinstance] setObject:@"" forKey:KcategoryType];

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

- (IBAction)notificationButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
    [[AppSettingsManager sharedinstance] setObject:@"" forKey:KcategoryType];

    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [[AppSettingsManager sharedinstance] setObject:@"" forKey:KcategoryType];

    [self.navigationController pushViewController:postAdd animated:YES];
}

@end
