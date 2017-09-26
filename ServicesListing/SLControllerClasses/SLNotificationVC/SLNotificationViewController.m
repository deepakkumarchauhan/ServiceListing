//
//  SLNotificationViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 20/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLNotificationViewController.h"
#import "Header.h"

static NSString *notificationCellIdentifier = @"notificationCellId";

@interface SLNotificationViewController ()<LanguageChangeDelegate> {
    NSMutableArray *dataArray;
    SLNotificationModal *objNotification;
    SLPaginationInfo *pageInfo;
    NSInteger index;
    BOOL isLoading;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDataFoundLabel;

@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;

@end

@implementation SLNotificationViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadInitial];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.notificationButton.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self initialSetup];
}


#pragma mark - Custom Method

- (void)initialSetup {
   // [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");

    self.titleLabel.text = SLLocalizedString(@"NOTIFICATION");
    self.noDataFoundLabel.text = SLLocalizedString(@"Currently no data are available. Please drag down to refresh");
    
    if ([APPDELEGATE isArabic]) {
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    }
    
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
    }

}

- (void)loadInitial {
    
    if (self.fromSidePanel)
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    else
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    objNotification = [[SLNotificationModal alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    self.noDataFoundLabel.hidden = YES;
    pageInfo = [SLPaginationInfo new];
    pageInfo.pageNumber = 1;
    
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:notificationCellIdentifier];
    self.tableView.estimatedRowHeight = 102.0;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = LNAV_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(getAddList)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self makeWebApiCallForNotificationList];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLNotificationTableViewCell *notificationCell = (SLNotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    
    objNotification = [dataArray objectAtIndex:indexPath.row];
    
    notificationCell.notificatinTitleLabel.text = (objNotification.strUsername.length)?objNotification.strUsername:SLLocalizedString(@"(unknown)");
    notificationCell.notificationDescriptionLabel.text = objNotification.strNotificationTitle;
    notificationCell.notificationDateLabel.text = [SLUtility getDateFromTimestamp:objNotification.strNotificationDate];
    
    [notificationCell.notificationImageView setImageWithURL:[NSURL URLWithString:objNotification.image] placeholderImage:[UIImage imageNamed:@"noti"]];

    if ([APPDELEGATE isArabic]){
        notificationCell.notificatinTitleLabel.textAlignment = NSTextAlignmentRight;
        notificationCell.notificationDescriptionLabel.textAlignment = NSTextAlignmentRight;
        notificationCell.notificationDateLabel.textAlignment = NSTextAlignmentLeft;
        [notificationCell.mainViewCell setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else{
        notificationCell.notificatinTitleLabel.textAlignment = NSTextAlignmentLeft;
        notificationCell.notificationDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        notificationCell.notificationDateLabel.textAlignment = NSTextAlignmentRight;
        [notificationCell.mainViewCell setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }
    
    return notificationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   objNotification = [dataArray objectAtIndex:indexPath.row];
//    if ([objNotification.strNotificationType isEqualToString:@"like"]) {
//        
//    }
    if ([objNotification.strNotificationId length]) {
        
    }
    SLServiceDetailsViewController * vcObj = [[SLServiceDetailsViewController alloc]initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
    vcObj.notificationIdString = objNotification.strNotificationAddID;
    [self.navigationController pushViewController:vcObj animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    return YES;
}



#pragma mark - UITableView Delegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:SLLocalizedString(@"Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        SLNotificationModal *notiObj = [dataArray objectAtIndex:indexPath.row];
                                        index = indexPath.row;
                                        [self makeWebApiCallForDeleteNotification:notiObj.strNotificationId];
                                    }];
    button.backgroundColor = LNAV_COLOR;
    //arbitrary color
    
    return @[button];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
    NSInteger currentOffset = self.tableView.contentOffset.y;
    NSInteger maximumOffset = self.tableView.contentSize.height - self.tableView.frame.size.height;
    if ((maximumOffset - currentOffset <= 10.0) && isLoading) {
        if (pageInfo.pageNumber  < pageInfo.maxpage) {
            
            pageInfo.pageNumber += 1;
            [self makeWebApiCallForNotificationList];
        }
    }
}

#pragma mark - language selection Delegate method

- (void)getAddList {
    
    pageInfo.pageNumber = 1;
    isLoading = NO;
    [self makeWebApiCallForNotificationList];
    [self.refreshControl endRefreshing];
}

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableView reloadData];
}

- (void)didConfirmWithArabic {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LANGUAGE" object:nil];

}

- (IBAction)backButtonAction:(id)sender {
    
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
- (IBAction)deleteButtonAction:(id)sender {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Are you sure you want to delete all notifications?") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self makeWebApiCallForDeleteAllNotification];
        }];
        [alert addAction:okAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:NO completion:nil];
    });
}

- (IBAction)postAddButtonAction:(id)sender {
    
    BOOL isPostVC = NO;
    
    for (UIViewController *viewcontroller in self.navigationController.viewControllers) {
        if ([viewcontroller isKindOfClass:[SLPostNewAddViewController class]]) {
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.35f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName :kCAMediaTimingFunctionEaseIn];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            [self.navigationController popToViewController:viewcontroller animated:NO];
            isPostVC = YES;
            break;
        }
    }
    if (!isPostVC) {
        SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
        [self.navigationController pushViewController:postAdd animated:YES];
    }
}

#pragma mark - Web Service API Methods

- (void)makeWebApiCallForNotificationList {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[NSString stringWithFormat:@"%li",(long)pageInfo.pageNumber] forKey:KpageNumber];
    [dictRequest setValue:@"8" forKey:KpageSize];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiNotification_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"response = %@", response);
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [APPDELEGATE makeWebApiCallToGetNotificationCount];
                NSMutableArray *arr = [response objectForKeyNotNull:KnotificationList expectedClass:[NSArray class]];
                
                if (pageInfo.pageNumber == 1) {
                    [dataArray removeAllObjects];
                }
                pageInfo = [SLPaginationInfo getPageInfo:response];
                if (arr.count) {
                    [dataArray addObjectsFromArray:[SLNotificationModal notificationArrayFromResponse:[response objectForKeyNotNull:KnotificationList expectedClass:[NSArray class]]]];
                    self.noDataFoundLabel.hidden = YES;
                    isLoading = YES;
                    [self.tableView reloadData];
                }
                else if(pageInfo.totalRecord == 0) {
                    self.noDataFoundLabel.hidden = NO;
                }
                if (dataArray.count)
                    self.notificationButton.hidden = NO;
                else
                    self.notificationButton.hidden = YES;
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

- (void)makeWebApiCallForDeleteNotification:(NSString*)notificationId {
    
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:notificationId forKey:Knoti_id];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apidelete_notification WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [dataArray removeObjectAtIndex:index];
                if (![dataArray count]) {
                    self.noDataFoundLabel.hidden = NO;
                    self.notificationButton.hidden = YES;
                }
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


- (void)makeWebApiCallForDeleteAllNotification {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiClearNotification WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [dataArray removeAllObjects];
                self.notificationButton.hidden = YES;
                self.noDataFoundLabel.hidden = NO;
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
    
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideLoader {
    
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
