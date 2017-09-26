//
//  SLCategoriesViewController.m
//  ServicesListing
//
//  Created by Tejas Pareek on 16/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLCategoriesViewController.h"
#import "Header.h"

static NSString *cellIdentifier = @"homeCellId";

@interface SLCategoriesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *arrCategory;
    
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UIButton           *addAdvertisementButton;

@property (weak, nonatomic) IBOutlet UIView             *searchView;
@property (weak, nonatomic) IBOutlet UIView             *bottomAdvertiseView;

@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;

@property (weak, nonatomic) IBOutlet SLCustomTextFieldBlackPlaceholder *searchTextField;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SLCategoriesViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    arrCategory = [[NSMutableArray alloc] init];
    
    // Register CollectionView Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEngMessage) name:@"languageEngNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveArbMessage) name:@"languageArbNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToCategoryList:) name:@"getCategoryList" object:nil];

    
    [self makeWebApiCallToGetCategoryList];
    [self addPullToRefresh];
    
//    if (self.isComingFromNavigation) {
//        SLServicesViewController *serviceVC = [[SLServicesViewController alloc]initWithNibName:@"SLServicesViewController" bundle:nil];
//        serviceVC.categoryId = @"34234234";
//        [[AppSettingsManager sharedinstance] setObject:[NSString string] forKey:KcategoryType];
//        
//        [[APPDELEGATE sidePanelNavigation] pushViewController:serviceVC animated:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialSetup];
    
    if (self.isComingFromNavigation) {
        SLServicesViewController *serviceVC = [[SLServicesViewController alloc]initWithNibName:@"SLServicesViewController" bundle:nil];
        serviceVC.categoryId = @"34234234";
        [[AppSettingsManager sharedinstance] setObject:[NSString string] forKey:KcategoryType];
        
        [[APPDELEGATE sidePanelNavigation] pushViewController:serviceVC animated:NO];
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"ndfegrerfgerf" onController:self];
    }
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - Pull To Refresh Methods

- (void)addPullToRefresh {
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refreshWorkorders) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
}

- (void)refreshWorkorders {
    
    [self makeWebApiCallToGetCategoryList];
    [self performSelector:@selector(endrefresing) withObject:nil afterDelay:0.2];
}

- (void)endrefresing {
    
    [refreshControl endRefreshing];
}

#pragma mark - Custom Method

-(void)initialSetup {
    
    self.searchTextField.placeholder = SLLocalizedString(@"Search");
    
    if ([APPDELEGATE isArabic]) {
        self.searchTextField.textAlignment = NSTextAlignmentRight;
        self.addAdvertisementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }else{
        self.searchTextField.textAlignment = NSTextAlignmentLeft;
        self.addAdvertisementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return arrCategory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SLHomeCollectionViewCell *homeCell = (SLHomeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SLCategoryInfo *catInfoTemp = arrCategory[indexPath.item];
                                
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:catInfoTemp.service_name];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [catInfoTemp.service_name length])];
    homeCell.lblServiceDesc.hidden = YES;
    homeCell.serviceNameLabel.attributedText = attributedString;
    [homeCell.bgImageView setImageWithURL:[NSURL URLWithString:catInfoTemp.image] placeholderImage:[UIImage imageNamed:@"placeholder-2"]];
    [homeCell.serviceImageView setImageWithURL:[NSURL URLWithString:catInfoTemp.icon_image] placeholderImage:[UIImage imageNamed:@"pl"]];
    
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
    SLCategoryInfo *catInfoTemp = arrCategory[indexPath.item];
    
    SLServicesViewController *serviceVC = [[SLServicesViewController alloc]initWithNibName:@"SLServicesViewController" bundle:nil];
    serviceVC.categoryId = catInfoTemp.service_category_id;
    serviceVC.categoryName = catInfoTemp.service_name;
    [[AppSettingsManager sharedinstance] setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.item] forKey:KcategoryType];
    
   // [[AppSettingsManager sharedinstance] setObject:[categoryArray objectAtIndex:indexPath.row] forKey:KcategoryType];
    NSLog(@"%ld",(long)indexPath.item);
    
    [self.navigationController pushViewController:serviceVC animated:YES];
}

#pragma mark - Selector Method

- (void)receiveEngMessage {
    
    [self.collectionView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.bottomAdvertiseView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self.searchView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [self initialSetup];
    [self makeWebApiCallToGetCategoryList];
}

- (void)receiveArbMessage {
    [self.collectionView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.bottomAdvertiseView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.searchView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self initialSetup];
    [self makeWebApiCallToGetCategoryList];
}
    
- (void)goToCategoryList:(NSNotification*)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    [self.view endEditing:YES];
    
    SLServicesViewController *serviceVC = [[SLServicesViewController alloc]initWithNibName:@"SLServicesViewController" bundle:nil];
    
    serviceVC.categoryId = [userInfo valueForKey:@"categoryId"];
    serviceVC.categoryName = [userInfo valueForKey:@"categoryName"];
    
    [self.navigationController pushViewController:serviceVC animated:NO];
    
   }
    
    

#pragma mark - UIButton Action

- (IBAction)addAdvertiseButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAddVC = [[SLPostNewAddViewController alloc]initWithNibName:@"SLPostNewAddViewController" bundle:nil];
    [[AppSettingsManager sharedinstance] setObject:@"" forKey:KcategoryType];

    [self.navigationController pushViewController:postAddVC animated:YES];
}

#pragma mark - Touch Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - Web Service API Methods

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
                [arrCategory removeAllObjects];
                [arrCategory addObjectsFromArray:[SLCategoryInfo categoryArrayFromResponse:[response objectForKeyNotNull:Kservice_category_list expectedClass:[NSArray class]]]];
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

@end
