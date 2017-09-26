//
//  SLAllServiceViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 17/01/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import "SLAllServiceViewController.h"
#import "Header.h"

static NSString *cellIdentifier = @"SLServicesTableViewCell";

@interface SLAllServiceViewController () <serviceDetailProtocol>{
    SLServiceModal *objService;
    SLPaginationInfo *pageInfo;
    NSMutableArray *dataArray;
    NSString *strSearchText;
    NSString *strSort;
    NSString *strTransportation;
    NSString *strDistance;
    BOOL isLoading;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *noDataFoundLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@end

@implementation SLAllServiceViewController

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad {
    
    NSLog(@"%@",self.navigationController.viewControllers);
    NSLog(@"%@",[APPDELEGATE navigationController].viewControllers);

    [super viewDidLoad];
    [self addObserver];
    [self initialSetup];
}

#pragma mark - Observer methods

- (void)showGridViewWithStatus:(NSNotification*)notif {
    
    BOOL grid = [[NSUserDefaults standardUserDefaults] boolForKey:KDefaultView];
    
    self.collectionView.hidden = grid;
    self.tblView.hidden = !grid;
    
    [self.collectionView reloadData];
    [self.tblView reloadData];
}

- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGridViewWithStatus:) name:KNOTIFICATION_GRID_LIST_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSearchString:) name:KNOTIFICATION_ALL_SEARCH_VIEW_EDITED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callSearchApi:) name:KCALL_ALL_SEARCH_API object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callServiceApiWithCancelSearch:) name:KNOTIFICATION_SEARCH_VIEW_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:KNOTIFICATION_RELOAD_TABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSortString:) name:KNOTIFICATION_SORT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFilterString:) name:KNOTIFICATION_FILTER object:nil];
}


- (void)getSortString:(NSNotification*)notif {
    
    pageInfo.pageNumber = 1;
    NSDictionary *tempDict = notif.userInfo;
    strSort = [tempDict valueForKey:@"sortStr"];
    
    [self makeWebApiCallForServiceList];
}

- (void)getFilterString:(NSNotification*)notif {
    
    pageInfo.pageNumber = 1;
    NSDictionary *tempDict = notif.userInfo;
    strTransportation = [tempDict valueForKey:@"transportationStr"];
    strDistance = [tempDict valueForKey:@"distanceStr"];
    
    [self makeWebApiCallForServiceList];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellId"];
    
    // Register Table View
    [self.tblView registerNib:[UINib nibWithNibName:@"SLServicesTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    self.noDataFoundLabel.text = SLLocalizedString(@"Currently no data are available. Please drag down to refresh");
    
    BOOL grid = [[NSUserDefaults standardUserDefaults] boolForKey:KDefaultView];
    
    self.collectionView.hidden = grid;
    self.tblView.hidden = !grid;
    
    [self.collectionView reloadData];
    [self.tblView reloadData];
    
    dataArray = [[NSMutableArray alloc] init];
    
    self.noDataFoundLabel.hidden = YES;
    objService = [[SLServiceModal alloc] init];
    pageInfo = [SLPaginationInfo new];
    pageInfo.pageNumber = 1;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = LNAV_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(getAddList)
                  forControlEvents:UIControlEventValueChanged];
    [self.tblView addSubview:self.refreshControl];
    
    if (strSearchText.length)
        [self makeWebApiCallForSearchServiceList:strSearchText];
    else
        [self makeWebApiCallForServiceList];
    
    
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
    cell.btnDistance.tag = indexPath.row + 10000;
    
    cell.btnComment.userInteractionEnabled = NO;
    cell.btnDistance.userInteractionEnabled = NO;
    
    [cell.btnLike addTarget:self action:@selector(likeBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(commentBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDistance addTarget:self action:@selector(distanceBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    objService = [dataArray objectAtIndex:indexPath.row];
    
    if ([APPDELEGATE isArabic]) {
        cell.btnLike.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cell.btnComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cell.btnDistance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cell.labelServiceName.textAlignment = NSTextAlignmentRight;
        cell.labelServiceDesc.textAlignment = NSTextAlignmentRight;
    }
    else {
        cell.btnLike.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.btnComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.btnDistance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.labelServiceName.textAlignment = NSTextAlignmentLeft;
        cell.labelServiceDesc.textAlignment = NSTextAlignmentLeft;
    }
    
    cell.labelServiceName.text = objService.strTitle;
    cell.labelServiceDesc.text = objService.strBody;
    cell.dateLabel.text = [SLUtility getStringDateFromTimestamp:objService.postDate];

    [cell.imageViewService setImageWithURL:[NSURL URLWithString:objService.strImage] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
    [cell.btnLike setTitle:([objService.strLikeCount intValue] == 0)?@"":[NSString stringWithFormat:@" %@", objService.strLikeCount] forState:UIControlStateNormal];
    [cell.btnComment setTitle:objService.strCommentcount forState:UIControlStateNormal];
    
    if ([objService.strDistance isEqualToString:@""])
        [cell.btnDistance setTitle:@"" forState:UIControlStateNormal];
    else
        [cell.btnDistance setTitle:objService.strDistance forState:UIControlStateNormal];
    
    ([objService.like_status boolValue]) ? ([cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal]) : ([cell.btnLike setImage:[UIImage imageNamed:@"likeGray"] forState:UIControlStateNormal]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EndEditingYes"
     object:self];
    objService = [dataArray objectAtIndex:indexPath.row];
    
    SLServiceDetailsViewController *detailVC = [[SLServiceDetailsViewController alloc] initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
    detailVC.serviceModel = objService;
    
    NSLog(@"%@",self.navigationController.viewControllers);
    NSLog(@"%@",[APPDELEGATE navigationController].viewControllers);
    

    detailVC.delegate = self;
    [[APPDELEGATE sidePanelNavigation] pushViewController:detailVC animated:YES];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 121;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SLHomeCollectionViewCell *homeCell = (SLHomeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"homeCellId" forIndexPath:indexPath];
    objService = [dataArray objectAtIndex:indexPath.item];
    
    homeCell.serviceNameLabel.hidden = YES;
    [homeCell.bgImageView setImageWithURL:[NSURL URLWithString:objService.strImage] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
    
    homeCell.lblServiceDesc.text = objService.strTitle;
    homeCell.dateLabel.text = [SLUtility getStringDateFromTimestamp:objService.postDate];
    
    return homeCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0;
    CGSize size = CGSizeMake(cellWidth-16, cellWidth-16);
    
    return size;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    objService = [dataArray objectAtIndex:indexPath.item];

    SLServiceDetailsViewController *detailVC = [[SLServiceDetailsViewController alloc] initWithNibName:@"SLServiceDetailsViewController" bundle:nil];
    detailVC.serviceModel = objService;
    detailVC.delegate = self;

    [[APPDELEGATE sidePanelNavigation] pushViewController:detailVC animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
    NSInteger currentOffset = self.tblView.contentOffset.y;
    NSInteger maximumOffset = self.tblView.contentSize.height - self.tblView.frame.size.height;
    if ((maximumOffset - currentOffset <= 10.0) && isLoading) {
        if (pageInfo.pageNumber  < pageInfo.maxpage) {
            
            pageInfo.pageNumber += 1;
            if (!strSearchText.length) {
                [self makeWebApiCallForServiceList];
            }
        }
    }
}


#pragma mark - UIButton Action Method

- (IBAction)commentBtnActionMethod:(id)sender {
    
}

- (IBAction)distanceBtnActionMethod:(id)sender {
    
}

#pragma mark - Selector Method


- (void)getAddList {
    
    pageInfo.pageNumber = 1;
    isLoading = NO;
    
    if (strSearchText.length)
        [self makeWebApiCallForSearchServiceList:strSearchText];
    else
        [self makeWebApiCallForServiceList];
    
    [self.refreshControl endRefreshing];
}

- (IBAction)likeBtnActionMethod:(UIButton*)sender {
    
    objService = [dataArray objectAtIndex:sender.tag - 2000];
    
    [self makeWebApiCallForLike:objService];
}


- (void)updateSearchString:(NSNotification *)notif {
    
    NSDictionary *tempDict = notif.userInfo;
    strSearchText = [tempDict valueForKey:@"searchText"];
}

-(void)callSearchApi:(NSNotification*)notif {
    
    NSDictionary *tempDict = notif.userInfo;
    strSearchText = [tempDict valueForKey:@"searchText"];
    if (strSearchText.length) {
        [self makeWebApiCallForSearchServiceList:strSearchText];
    }
    
}

-(void)callServiceApiWithCancelSearch:(NSNotification*)notif {
    
    pageInfo.pageNumber = 1;
    strSearchText = @"";
    [self makeWebApiCallForServiceList];
}

-(void)reloadTable {
    
    if ([APPDELEGATE isArabic]) {
        [self.tblView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else{
        [self.tblView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    self.noDataFoundLabel.text = SLLocalizedString(@"Currently no data are available. Please drag down to refresh");

    [self.tblView reloadData];
    [self.collectionView reloadData];
}


#pragma mark - Custom Delegate Method

- (void)deletePost {
    
    objService = [[SLServiceModal alloc] init];
    pageInfo.pageNumber = 1;
    if (strSearchText.length) {
        [self makeWebApiCallForSearchServiceList:strSearchText];
    }
    else{
        [self makeWebApiCallForServiceList];
    }
}


#pragma mark - Web Service API Methods

- (void)makeWebApiCallForSearchServiceList:(NSString *)str {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    
    if ([[NSUSERDEFAULT valueForKey:@"autoDetection"] boolValue]) {
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultLocation] forKey:Klocation];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlatitude] forKey:Klatitude];
        [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlongitude] forKey:Klongitude];
    }
    else {
        [dictRequest setValue:@"" forKey:Klocation];
        [dictRequest setValue:@"" forKey:Klatitude];
        [dictRequest setValue:@"" forKey:Klongitude];
        [dictRequest setValue:[NSUSERDEFAULT valueForKey:@"countryNCode"] forKey:KCountry];
    }

    [dictRequest setValue:@"0" forKey:KownserviceSearch];

    // NSDictionary *tempDict = notif.userInfo;
    [dictRequest setValue:[NSString stringWithFormat:@"%ld",(long)self.serviceType] forKey:KserviceType];
    
    [dictRequest setValue:str forKey:Ktitle];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apisearch_serviceList WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                NSMutableArray *arrFav = [response objectForKeyNotNull:Kmyservices_list expectedClass:[NSArray class]];
                
                [dataArray removeAllObjects];
                
                if (arrFav.count) {
                    [dataArray addObjectsFromArray:[SLServiceModal serviceArrayFromResponse:[response objectForKeyNotNull:Kmyservices_list expectedClass:[NSArray class]]]];
                    self.noDataFoundLabel.hidden = YES;
                    isLoading = YES;
                }
                else {
                    self.noDataFoundLabel.hidden = NO;
                }
                [self.tblView reloadData];
                [self.collectionView reloadData];
                
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
                [self.tblView reloadData];
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}

- (void)makeWebApiCallForServiceList {
    
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

    
    [dictRequest setValue:[NSString stringWithFormat:@"%ld",(long)self.serviceType] forKey:KserviceType];
    [dictRequest setValue:strDistance forKey:Kdistance];
    [dictRequest setValue:strTransportation forKey:Ktransportation];
    [dictRequest setValue:strSort forKey:Ksorttype];
    
    [dictRequest setValue:self.categoryId forKey:Kservice_category];

    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:[NSString stringWithFormat:@"%li",(long)pageInfo.pageNumber] forKey:KpageNumber];
    [dictRequest setValue:@"8" forKey:KpageSize];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apihome_services_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                NSMutableArray *arrFav = [response objectForKeyNotNull:Kmyservices_list expectedClass:[NSArray class]];
                
                if (pageInfo.pageNumber == 1) {
                    [dataArray removeAllObjects];
                }
                pageInfo = [SLPaginationInfo getPageInfo:response];
                
                if (arrFav.count) {
                    [dataArray addObjectsFromArray:[SLServiceModal serviceArrayFromResponse:[response objectForKeyNotNull:Kmyservices_list expectedClass:[NSArray class]]]];
                    self.noDataFoundLabel.hidden = YES;
                    isLoading = YES;
                }
                else if(pageInfo.totalRecord == 0) {
                    [dataArray removeAllObjects];
                    self.noDataFoundLabel.hidden = NO;
                }
                [self.tblView reloadData];
                [self.collectionView reloadData];
                
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
