//
//  SLServicesViewController.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/19/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLServicesViewController.h"
#import "Header.h"

@interface SLServicesViewController ()<LanguageChangeDelegate,CAPSPageMenuDelegate,UITextFieldDelegate>
{
    NSInteger currentPageNumber;
    NSArray *controllerArray;
}

@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet SLCustomTextField *searchTextField;

// UIButton Properties
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *btnFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnSort;
@property (strong, nonatomic) IBOutlet UIButton *btnGrid;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *postAddButton;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostlabel;

@property (strong, nonatomic) IBOutlet UILabel *plusLabel;
@property (strong, nonatomic) CAPSPageMenu *pageMenu;

// UIView Properties
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *searchBackgroundView;
@property(weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;


@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelNavTtl;
@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;

@end

@implementation SLServicesViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
//    NSLog(@"%@",self.navigationController.viewControllers);
//    NSLog(@"%@",[APPDELEGATE navigationController].viewControllers);

    currentPageNumber = 0;
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.searchView.hidden = YES;
    [self customizeViewAfterLanguageChange];
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Method

- (void)initialSetup {
    
    
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
    
    if (self.fromSidePanel) {
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        _labelNavTtl.text = SLLocalizedString(@"MY SERVICES");
        self.plusLabel.hidden = YES;
        self.addNewPostlabel.hidden = YES;
        self.postAddButton.hidden = YES;
    }
    else{
        
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        _labelNavTtl.text = SLLocalizedString(self.categoryName);
        self.postAddButton.hidden = NO;
        self.plusLabel.hidden = NO;
        self.addNewPostlabel.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEngMessage) name:@"EndEditingYes" object:nil];
    
    self.searchTextField.placeholder = SLLocalizedString(@"Search");
    self.searchBackgroundView.layer.cornerRadius = 5.0;
    
    [self.navigationController setNavigationBarHidden:YES];
    [_btnFilter setTitle:SLLocalizedString(@"FILTER") forState:UIControlStateNormal];
    [_btnSort setTitle:SLLocalizedString(@"SORT") forState:UIControlStateNormal];
    
    if (self.fromSidePanel) {
        SLServicesDataViewController *controller1 = [[SLServicesDataViewController alloc]initWithNibName:@"SLServicesDataViewController" bundle:nil];
        controller1.title = SLLocalizedString(@"Services offered");
        controller1.serviceType = 2;
        
        SLServicesDataViewController *controller2 = [[SLServicesDataViewController alloc]initWithNibName:@"SLServicesDataViewController" bundle:nil];
        controller2.title = SLLocalizedString(@"Services required");
        controller2.serviceType = 3;
        
        SLServicesDataViewController *controller3 = [[SLServicesDataViewController alloc] initWithNibName:@"SLServicesDataViewController" bundle:nil];
        controller3.title = SLLocalizedString(@"Sales");
        controller3.serviceType = 4;
        
        SLServicesDataViewController *controller4 = [[SLServicesDataViewController alloc] initWithNibName:@"SLServicesDataViewController" bundle:nil];
        controller4.title = SLLocalizedString(@"Required");
        controller4.serviceType = 5;
        
        SLServicesDataViewController *controller5 = [[SLServicesDataViewController alloc] initWithNibName:@"SLServicesDataViewController" bundle:nil];
        controller5.title = SLLocalizedString(@"Inquiry");
        controller5.serviceType = 6;
        controllerArray = @[controller1];

    }
    else {
    SLAllServiceViewController *controller1 = [[SLAllServiceViewController alloc]initWithNibName:@"SLAllServiceViewController" bundle:nil];
    controller1.title = SLLocalizedString(@"Services offered");
    controller1.serviceType = 2;
    controller1.categoryId = self.categoryId;
    
    SLAllServiceViewController *controller2 = [[SLAllServiceViewController alloc]initWithNibName:@"SLAllServiceViewController" bundle:nil];
    controller2.title = SLLocalizedString(@"Services required");
    controller2.serviceType = 3;
    controller2.categoryId = self.categoryId;

    SLAllServiceViewController *controller3 = [[SLAllServiceViewController alloc] initWithNibName:@"SLAllServiceViewController" bundle:nil];
    controller3.title = SLLocalizedString(@"Sales");
    controller3.serviceType = 4;
    controller3.categoryId = self.categoryId;

    SLAllServiceViewController *controller4 = [[SLAllServiceViewController alloc] initWithNibName:@"SLAllServiceViewController" bundle:nil];
    controller4.title = SLLocalizedString(@"Required");
    controller4.serviceType = 5;
    controller4.categoryId = self.categoryId;

    SLAllServiceViewController *controller5 = [[SLAllServiceViewController alloc] initWithNibName:@"SLAllServiceViewController" bundle:nil];
    controller5.title = SLLocalizedString(@"Inquiry");
    controller5.serviceType = 6;
    controller5.categoryId = self.categoryId;

    //controllerArray = @[controller1, controller2, controller3, controller4,controller5];
        
    controllerArray = @[controller1];

    }
    [self.view setFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:76.0/255.0 green:90.0/255.0 blue:146.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"OpenSans" size:13.0],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor colorWithRed:76.0/255.0 green:90.0/255.0 blue:146.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuHeight: @(0),
                                 CAPSPageMenuOptionMenuItemWidth: @(windowWidth)
                                 };
    
    _pageMenu.menuItemSeparatorWidth = 0;
    _pageMenu.menuItemWidthBasedOnTitleTextWidth = YES;
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 63.0, self.view.frame.size.width, self.view.frame.size.height-114) options:parameters];
    [self.view addSubview:_pageMenu.view];
    _pageMenu.delegate = self;
    
    [_pageMenu moveToPage:currentPageNumber];
    
}

- (void)customizeViewAfterLanguageChange {
    
    if (self.fromSidePanel) {
        _labelNavTtl.text = SLLocalizedString(@"MY SERVICES");
    }else{
        _labelNavTtl.text = SLLocalizedString(self.categoryName);
    }
    
    _addNewPostlabel.text = SLLocalizedString(@"Add new Post");

    self.searchTextField.placeholder = SLLocalizedString(@"Search");
    [_btnFilter setTitle:SLLocalizedString(@"FILTER") forState:UIControlStateNormal];
    [_btnSort setTitle:SLLocalizedString(@"SORT") forState:UIControlStateNormal];
    [self.cancelButton setTitle:SLLocalizedString(@"CancelSmall") forState:UIControlStateNormal];
   // [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    if ([APPDELEGATE isArabic]) {
        
        [self.btnLanguage setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.bottomLabel setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.searchView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.searchBackgroundView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.searchTextField.textAlignment = NSTextAlignmentRight;
    }
    else {
        [self.btnLanguage setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.bottomLabel setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.searchView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.searchBackgroundView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.searchTextField.textAlignment = NSTextAlignmentLeft;
    }
    
    BOOL grid = [NSUSERDEFAULT boolForKey:KDefaultView];
    if (!grid){
        [self.btnGrid setTitle:SLLocalizedString(@"LIST") forState:UIControlStateNormal];
    }else{
        [self.btnGrid setTitle:SLLocalizedString(@"GRID") forState:UIControlStateNormal];
    }
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

#pragma mark - CSPageMenu Delegate method

- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index{
    
    currentPageNumber = index;
}
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index{
    
}


#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self customizeViewAfterLanguageChange];
}
- (void)didConfirmWithArabic {
    
    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self customizeViewAfterLanguageChange];
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:self.searchTextField.text forKey:@"searchText"];
    if (self.fromSidePanel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callSearchApi" object:nil userInfo:dict];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KCALL_ALL_SEARCH_API object:nil userInfo:dict];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    else if (str.length == 65)
        return NO;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:str forKey:@"searchText"];
    if (self.fromSidePanel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SEARCH_VIEW_EDITED object:nil userInfo:dict];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_ALL_SEARCH_VIEW_EDITED object:nil userInfo:dict];

    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"" forKey:@"searchText"];
    if (self.fromSidePanel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SEARCH_VIEW_EDITED object:nil userInfo:dict];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_ALL_SEARCH_VIEW_EDITED object:nil userInfo:dict];
    }
    
    return YES;
}

#pragma mark - Selector Method

- (void)receiveEngMessage {
    [self.view endEditing:YES];
}

#pragma mark - IBACTION Method

- (IBAction)btnFilterAction:(UIButton*)btn {

    [self.view endEditing:YES];
    SLFilterViewController *filterVC = [[SLFilterViewController alloc]initWithNibName:@"SLFilterViewController" bundle:nil];
    [self presentViewController:filterVC animated:YES completion:nil];
}

- (IBAction)btnSortAction:(UIButton*)btn {
    
    [self.view endEditing:YES];
    SLSortViewController *sortVC = [[SLSortViewController alloc]initWithNibName:@"SLSortViewController" bundle:nil];
    [self presentViewController:sortVC animated:YES completion:nil];
}

- (IBAction)btnGridAction:(UIButton*)btn {
    
    [self.view endEditing:YES];
    self.btnGrid.selected = !self.btnGrid.selected;
    
    if (!self.btnGrid.selected)
        [self.btnGrid setTitle:SLLocalizedString(@"LIST") forState:UIControlStateNormal];
    else
        [self.btnGrid setTitle:SLLocalizedString(@"GRID") forState:UIControlStateNormal];
    
    [NSUSERDEFAULT setBool:(![NSUSERDEFAULT boolForKey:KDefaultView]) forKey:KDefaultView];
    [NSUSERDEFAULT synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_GRID_LIST_VIEW object:nil];
}

- (IBAction)backBtnAction:(UIButton*)btn {
    
    [self.view endEditing:YES];
    //back btn Action
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

- (IBAction)commonBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    switch (sender.tag) {

        case 11:
        {
            SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
            [self.navigationController pushViewController:notificationVC animated:YES];
        }
            break;
            
        case 12:
        {
            //Language Btn Action
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
            break;
            
        case 13:
        {
            SLFilterViewController *filterVC = [[SLFilterViewController alloc]initWithNibName:@"SLFilterViewController" bundle:nil];
            [self presentViewController:filterVC animated:YES completion:nil];
        }
            break;
            
        case 14:
        {
            SLSortViewController *sortVC = [[SLSortViewController alloc]initWithNibName:@"SLSortViewController" bundle:nil];
            [self presentViewController:sortVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)postAddButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}

- (IBAction)searchButtonAction:(id)sender {
    
    [UIView transitionWithView:self.searchView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        self.searchView.hidden = NO;
                    }
                    completion:NULL];
    [self.searchTextField becomeFirstResponder];
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:self.searchTextField.text forKey:@"searchText"];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SEARCH_VIEW_CANCELLED object:nil userInfo:dict];
    [UIView transitionWithView:self.searchView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        self.searchView.hidden = YES;
                    }
                    completion:NULL];
}

@end
