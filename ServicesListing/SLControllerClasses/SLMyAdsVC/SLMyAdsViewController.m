//
//  SLMyAdsViewController.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/21/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLMyAdsViewController.h"

static NSString *cellIdentifier = @"SLServicesTableViewCell";

@interface SLMyAdsViewController ()<UITableViewDataSource,UITableViewDelegate,LanguageChangeDelegate,serviceDetailProtocol>
{
    NSMutableArray *dataArray;
    SLServiceModal *objService;
    SLPaginationInfo *pageInfo;
    BOOL isLoading;
}


@property (strong, nonatomic) IBOutlet UITableView *tableViewMyAds;
@property (strong, nonatomic) IBOutlet UIView *navView;

@property (strong, nonatomic) IBOutlet UILabel *labelNavTtl;
@property (weak, nonatomic) IBOutlet UILabel *noDataFoundLabel;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraints;
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@end

@implementation SLMyAdsViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deletePost) name:@"editServiceNotification" object:nil];
    
    [self loadInitial];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initialSetup];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)methodForRegisterTable {
    
    // Register Table View
    [self.tableViewMyAds registerNib:[UINib nibWithNibName:@"SLServicesTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)initialSetup {
    
    if (self.fromSidePanel) {
        [self.backButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        self.tableViewTopConstraints.constant = 64.0;
    }
    else {
        [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        self.tableViewTopConstraints.constant = 0.0;
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    self.labelNavTtl.text = SLLocalizedString(@"MY ADS");
    self.noDataFoundLabel.text = SLLocalizedString(@"Currently no data are available. Please drag down to refresh");
    
    
    if ([APPDELEGATE isArabic]) {
        
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    //[self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");

    [self.tableViewMyAds reloadData];
}

- (void)loadInitial {
    
    // Notification Count Set
    self.notificationCountLabel.layer.cornerRadius = self.notificationCountLabel.frame.size.width/2;
    self.notificationCountLabel.layer.masksToBounds = YES;
    
    if ([APPDELEGATE notificationCount] == 0)
        self.notificationCountLabel.hidden = YES;
    else {
        self.notificationCountLabel.hidden = NO;
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[APPDELEGATE notificationCount]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEngMessage) name:@"languageEngNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveArbMessage) name:@"languageArbNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(increaseNotificationCount) name:@"getNotificationCount" object:nil];

    self.noDataFoundLabel.hidden = YES;
    objService = [[SLServiceModal alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    pageInfo = [SLPaginationInfo new];
    pageInfo.pageNumber = 1;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = LNAV_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(getAddList)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableViewMyAds addSubview:self.refreshControl];
    
    [self methodForRegisterTable];
    [self makeWebApiCallForMyAddList];
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
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLServicesTableViewCell *cell = (SLServicesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btnLike.tag = indexPath.row + 2000;
    cell.btnComment.tag = indexPath.row + 1000;
    
    [cell.btnLike addTarget:self action:@selector(likeBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(commentBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDistance setHidden:YES];
    
    objService = [dataArray objectAtIndex:indexPath.row];
    
    //Show Static Data remove at the time of functionality
    cell.labelServiceName.text = objService.strTitle;
    cell.labelServiceDesc.text = objService.strBody;
    cell.dateLabel.text = [SLUtility getStringDateFromTimestamp:objService.postDate];

    [cell.btnLike setTitle:([objService.strLikeCount intValue] == 0)?@"":objService.strLikeCount forState:UIControlStateNormal];
    [cell.btnComment setTitle:objService.strCommentcount forState:UIControlStateNormal];
    
    [cell.imageViewService setImageWithURL:[NSURL URLWithString:objService.strImage] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
    
    [cell.btnDistance setTitle:SLLocalizedString(@"11 Km") forState:UIControlStateNormal];
    
    if ([APPDELEGATE isArabic]) {
        cell.labelServiceName.textAlignment = NSTextAlignmentRight;
        cell.labelServiceDesc.textAlignment = NSTextAlignmentRight;
    }
    else {
        cell.labelServiceName.textAlignment = NSTextAlignmentLeft;
        cell.labelServiceDesc.textAlignment = NSTextAlignmentLeft;
    }
    
    ([objService.like_status boolValue]) ? ([cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal]) : ([cell.btnLike setImage:[UIImage imageNamed:@"likeGray"] forState:UIControlStateNormal]);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    objService = [dataArray objectAtIndex:indexPath.row];
    SLServiceDetailsViewController *detailVC = [[SLServiceDetailsViewController alloc] initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
    detailVC.serviceModel = objService;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
    NSInteger currentOffset = self.tableViewMyAds.contentOffset.y;
    NSInteger maximumOffset = self.tableViewMyAds.contentSize.height - self.tableViewMyAds.frame.size.height;
    if ((maximumOffset - currentOffset <= 10.0) && isLoading) {
        if (pageInfo.pageNumber  < pageInfo.maxpage) {
            
            pageInfo.pageNumber += 1;
            [self makeWebApiCallForMyAddList];
        }
    }
}

#pragma mark - Selector Method

- (void)getAddList {
    
    pageInfo.pageNumber = 1;
    isLoading = NO;
    [self makeWebApiCallForMyAddList];
    [self.refreshControl endRefreshing];
}

- (void)receiveEngMessage {
    
    [self.tableViewMyAds setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableViewMyAds reloadData];
}

- (void)receiveArbMessage {
    
    [self.tableViewMyAds setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [self.tableViewMyAds reloadData];
}

#pragma mark - Custom Delegate Method

- (void)deletePost {
    
    objService = [[SLServiceModal alloc] init];
    pageInfo.pageNumber = 1;
    [self makeWebApiCallForMyAddList];
}

#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.tableViewMyAds setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self.tableViewMyAds reloadData];
}

-(void)didConfirmWithArabic{
    
    [self.navView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.tableViewMyAds setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [self.tableViewMyAds reloadData];
}



#pragma mark - UIButton Action Method

-(IBAction)likeBtnActionMethod:(UIButton*)sender{
    
    objService = [dataArray objectAtIndex:sender.tag - 2000];
    
    [self makeWebApiCallForLike:objService];
}

-(IBAction)commentBtnActionMethod:(id)sender{
    
    
    
}

- (IBAction)commonBtnAction:(UIButton*)sender {
    
    switch (sender.tag) {
        case 10:{
            //menu brn Action
            if (self.fromSidePanel){
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
            break;
            
        case 11:
        {
            SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
            [self.navigationController pushViewController:notificationVC animated:YES];
        }
            break;
            
        case 12:
        {
            //language change btn Action
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
            break;
            
        default:
            break;
    }
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}

#pragma mark - Web Service API Methods

-(void)makeWebApiCallForMyAddList{
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    if ([[NSUSERDEFAULT valueForKey:@"autoDetection"] boolValue]) {
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation] forKey:Klocation];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlatitude] forKey:Klatitude];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlongitude] forKey:Klongitude];
        [dictRequest setValue:[APPDELEGATE countryCode] forKey:KCountry];
    }
    else {
        [dictRequest setValue:@"" forKey:Klocation];
        [dictRequest setValue:@"" forKey:Klatitude];
        [dictRequest setValue:@"" forKey:Klongitude];
        [dictRequest setValue:[NSUSERDEFAULT valueForKey:@"countryNCode"] forKey:KCountry];
    }
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[NSString stringWithFormat:@"%li",(long)pageInfo.pageNumber] forKey:KpageNumber];
    [dictRequest setValue:@"8" forKey:KpageSize];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiMy_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                NSMutableArray *arrFav = [response objectForKeyNotNull:Kmyadvertisement_list expectedClass:[NSArray class]];
                
                if (pageInfo.pageNumber == 1) {
                    [dataArray removeAllObjects];
                }
                pageInfo = [SLPaginationInfo getPageInfo:response];

                if (arrFav.count) {
                    [dataArray addObjectsFromArray:[SLServiceModal serviceArrayFromResponse:[response objectForKeyNotNull:Kmyadvertisement_list expectedClass:[NSArray class]]]];
                    self.noDataFoundLabel.hidden = YES;
                    isLoading = YES;
                }
                else if(pageInfo.totalRecord == 0) {
                    self.noDataFoundLabel.hidden = NO;
                }
                [self.tableViewMyAds reloadData];
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

-(void)makeWebApiCallForLike:(SLServiceModal *)obj {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:obj.strNid forKey:Knid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:([obj.like_status boolValue])?apiUnlike_advertisement:apiLike_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                ([obj.like_status boolValue])?(obj.like_status = @"0"):(obj.like_status = @"1");
                obj.strLikeCount = [response objectForKeyNotNull:KtotalLikes expectedClass:[NSString class]];
                [self.tableViewMyAds reloadData];
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

-(void)showLoader{
    
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
