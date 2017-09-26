//
//  SLServiceDetailsViewController.m
//  ServicesListing
//
//  Created by Manoj Kumar Sahu on 12/20/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLServiceDetailsViewController.h"
#import "Header.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]


static NSString *cellIdentifier = @"SLPostedByTableViewCell";
static NSString *cellIdentifierForComment = @"SLCommentsTableViewCell";
static NSString *cellIdentifierForTextField = @"SLTextFieldAndButtonTableViewCell";
static NSString *cellID = @"SLServiceDetailCell";

@interface SLServiceDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,LanguageChangeDelegate,callPopUpDelegate,editServiceProtocol>
{
    SLServiceDetailModal *objServiceDetail;
    SLServiceDetailModal *objSelectedComUserDetail;

   // NSMutableArray *arrayLeftTtl;
    BOOL isCollapse,isLike ;
    NSString *strComment;
    NSInteger commentCount;
    NSMutableArray *LastLines;
    NSInteger indexrow;
}
@property (weak, nonatomic) IBOutlet UILabel *serviceNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UIButton *postAddButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewServiceDetail;
@property (strong, nonatomic) IBOutlet UITableView *tableServiceDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelNavTtl;
@property (weak, nonatomic) IBOutlet UIView *viewHeaderTemp;
//footerView For section 0
@property (strong, nonatomic) IBOutlet UIButton *btnRetwit;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnNumberOfLike;
@property (strong, nonatomic) IBOutlet UIButton *btnNumberOfViews;
@property (strong, nonatomic) IBOutlet UIButton *btnDistanceInKM;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;

@property (strong, nonatomic) IBOutlet UIView *footerViewSectionZero;
@property (strong, nonatomic) IBOutlet UITextView *textviewComment;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
//Header and footer View for section 2
@property (strong, nonatomic) IBOutlet UIView *headerViewSectionTwo;
@property (strong, nonatomic) IBOutlet UIView *footerViewSectionTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelCommentCount;
//Header view for section 1
@property (strong, nonatomic) IBOutlet UIView *headerViewForSectionOne;
@property (weak, nonatomic) IBOutlet UIView *commentTypeView;


@property (strong, nonatomic) IBOutlet UIImageView *imageViewPostedby;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelPhoneNmber;
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelTransection;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnSms;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnReport;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UILabel *labelPostedByStaticText;
@property (strong, nonatomic) UIActivityViewController *activityViewController;
@property (strong, nonatomic) IBOutlet UILabel *addNewPostLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repostLeftConstraint;

@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDateLabel;

@end

@implementation SLServiceDetailsViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableServiceDetail.hidden = YES;
    self.commentTypeView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeWebApiCallForServiceDetail) name:@"editServiceNotification" object:nil];
    
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

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshScreenWithObject:) name:@"refreshScreenForTheItem" object:nil];
    
    [self registerTheTableView];
    
}
-(void)refreshScreenWithObject:(NSNotification *)userInfo{
    [self makeWebApiCallForServiceDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

    [self initialSetup];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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

#pragma mark - Notification Methods

- (void)keyboardWillShow:(NSNotification *)note {
    
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.buttonConstraint.constant = kbSize.height;
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        if ([objServiceDetail.commentArray count] && (isCollapse)) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[objServiceDetail.commentArray count]-1 inSection:2];
            [self.tableServiceDetail scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.buttonConstraint.constant = 0;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        if ([objServiceDetail.commentArray count] && (isCollapse)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[objServiceDetail.commentArray count]-1 inSection:2];
            [self.tableServiceDetail scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}


#pragma mark - Custom Method

- (void)registerTheTableView {
    
    objServiceDetail = [[SLServiceDetailModal alloc] init];
    objSelectedComUserDetail = [[SLServiceDetailModal alloc] init];
    
  //  arrayLeftTtl = [[NSMutableArray alloc] initWithObjects:@"Service name",@"Category",@"Price",@"Transportation\nAvailability",@"Service Type", nil];
    
    // Register Table View
    [self.tableServiceDetail registerNib:[UINib nibWithNibName:@"SLServiceDetailCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableServiceDetail registerNib:[UINib nibWithNibName:@"SLPostedByTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableServiceDetail registerNib:[UINib nibWithNibName:@"SLCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierForComment];
    [self.tableServiceDetail registerNib:[UINib nibWithNibName:@"SLTextFieldAndButtonTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierForTextField];
    self.tableServiceDetail.estimatedRowHeight = 44;
    self.tableServiceDetail.rowHeight = UITableViewAutomaticDimension;
    [self makeWebApiCallForServiceDetail];
}


- (void)initialSetup {
    
    [self.btnSubmit setEnabled:NO];
    [self.btnSubmit setAlpha:0.5];
    self.footerViewSectionTwo.hidden = YES;
    self.labelNavTtl.text = SLLocalizedString(@"SERVICE DETAILS");
    self.labelNavTtl.adjustsFontSizeToFitWidth = YES;
    self.textviewComment.text = SLLocalizedString(@"Share your comment...");
    [self.btnSubmit setTitle:SLLocalizedString(@"Submit") forState:UIControlStateNormal];
    [self.btnCall setTitle:SLLocalizedString(@"Call") forState:UIControlStateNormal];
    [self.btnSms setTitle:SLLocalizedString(@"SMS") forState:UIControlStateNormal];
    [self.btnEmail setTitle:SLLocalizedString(@"Email") forState:UIControlStateNormal];
    self.serviceNameTitleLabel.text = SLLocalizedString(@"Service name");
//    [self.postAddButton setTitle:SLLocalizedString(@"Add new Post") forState:UIControlStateNormal];
    self.addNewPostLabel.text = SLLocalizedString(@"Add new Post");
    if ([objServiceDetail.strFav_status boolValue]) {
        [self.btnAddToFavorite setTitle:SLLocalizedString(@"Remove from Favorites") forState:UIControlStateNormal];
    }
    else {
        [self.btnAddToFavorite setTitle:SLLocalizedString(@"Add to favorite") forState:UIControlStateNormal];
    }
    [self.btnReport setTitle:SLLocalizedString(@"Report") forState:UIControlStateNormal];
    [self.btnShare setTitle:SLLocalizedString(@"Share") forState:UIControlStateNormal];
    self.labelPostedByStaticText.text = SLLocalizedString(@"Posted by");
    [self.btnNumberOfLike setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strTotalLike,SLLocalizedString(@"Likes")] forState:UIControlStateNormal];
    [self.btnNumberOfViews setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strTotalView,SLLocalizedString(@"Views")] forState:UIControlStateNormal];
    
    if ([self.postDateLabel.text isEqualToString:@"Today"] || [self.postDateLabel.text isEqualToString:@"اليوم"]) {
        self.postDateLabel.text = SLLocalizedString(@"Today");
    }
    
    if (!objServiceDetail.strDistance.length)
        [self.btnDistanceInKM setTitle:@"" forState:UIControlStateNormal];
    else
       [self.btnDistanceInKM setTitle:[NSString stringWithFormat:@"%@ -%@ %@",SLLocalizedString(@"Dis"),objServiceDetail.strDistance,SLLocalizedString(@"Km")] forState:UIControlStateNormal];

    if ([APPDELEGATE isArabic]) {
        
        [self.btnLanguage setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
        [self.btnCall setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        [self.btnSms setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        [self.btnEmail setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
        [self.btnReport setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
        [self.btnShare setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
        [_btnNumberOfLike setImageEdgeInsets:UIEdgeInsetsMake(0,0,-3,0)];
        
//        [_postAddButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,7,22)];
//        [_postAddButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,-12,-2)];


        [_btnNumberOfViews setImageEdgeInsets:UIEdgeInsetsMake(0,0,-3,0)];
        [_btnDistanceInKM setImageEdgeInsets:UIEdgeInsetsMake(0,0,-3,0)];
        [self.viewHeaderTemp setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.commentTypeView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        [self.headerViewSectionTwo setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        [self.tableServiceDetail setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.textviewComment.textAlignment = NSTextAlignmentRight;
        [self.footerViewSectionTwo setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.labelName.textAlignment = NSTextAlignmentRight;
        self.postDateLabel.textAlignment = NSTextAlignmentRight;

        self.labelEmail.textAlignment = NSTextAlignmentRight;
        self.labelPhoneNmber.textAlignment = NSTextAlignmentRight;
        self.labelTransection.textAlignment = NSTextAlignmentRight;
        
        [self.view endEditing:YES];
    }else {
        
        [self.btnLanguage setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];
        [self.btnCall setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self.btnSms setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self.btnEmail setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        
//        [_postAddButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,7,22)];
//        [_postAddButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,-12,0)];
        
        
        if ([objServiceDetail.strFav_status boolValue]) {
            [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
            [self.btnAddToFavorite setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 8)];
        }
        else {
            [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        }
        self.postDateLabel.textAlignment = NSTextAlignmentLeft;
        [self.btnReport setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        [self.btnShare setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        [self.viewHeaderTemp setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.commentTypeView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.headerViewSectionTwo setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableServiceDetail setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view endEditing:YES];
        self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.textviewComment.textAlignment = NSTextAlignmentLeft;
        [self.footerViewSectionTwo setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.labelName.textAlignment = NSTextAlignmentLeft;
        self.labelEmail.textAlignment = NSTextAlignmentLeft;
        self.labelPhoneNmber.textAlignment = NSTextAlignmentLeft;
        self.labelTransection.textAlignment = NSTextAlignmentLeft;
    }
    [self.tableServiceDetail reloadData];
}


#pragma mark - Custom Delegate Method



- (void)editAdd {
    
    [self makeWebApiCallForServiceDetail];
}

-(void)callToUser:(BOOL)fromPopUp {
    
    NSString *phNo = (fromPopUp)?objSelectedComUserDetail.strComm_mobile:objServiceDetail.strUser_mobileNo;
    
    NSString *stringPhone = [[phNo componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",stringPhone]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }else{
        [[AlertView sharedManager] displayInformativeAlertwithTitle:SLLocalizedString(@"Alert") andMessage:SLLocalizedString(@"Call facility is not available.") onController:self];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
//        if(objServiceDetail.strPrice.length){
//            return 2;
//        }else
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        if (isCollapse)
            return objServiceDetail.commentArray.count;
        else
            return LastLines.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
//        SLTextFieldAndButtonTableViewCell *cell = (SLTextFieldAndButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierForTextField];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SLServiceDetailCell *cell1 = (SLServiceDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;

        //cell.textFieldRight.tag = indexPath.row + 100;
       // cell.btnRight.tag = indexPath.row + 200;
//        cell.labelLeftttl.text = SLLocalizedString([arrayLeftTtl objectAtIndex:indexPath.row]);
       // cell.textFieldRight.userInteractionEnabled = NO;
       // cell.btnRight.userInteractionEnabled = NO;
       // [cell.btnRight addTarget:self action:@selector(rightButtonActionMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([APPDELEGATE isArabic]){
            cell1.categoryLabel.textAlignment = NSTextAlignmentRight;
            cell1.priceLabel.textAlignment = NSTextAlignmentLeft;
            cell1.serviceTypeLabel.textAlignment = NSTextAlignmentLeft;
            cell1.priceLabel.textAlignment = NSTextAlignmentLeft;
//            cell1.btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else{
            cell1.categoryLabel.textAlignment = NSTextAlignmentCenter;
            cell1.priceLabel.textAlignment = NSTextAlignmentCenter;
            cell1.serviceTypeLabel.textAlignment = NSTextAlignmentCenter;

//            cell1.btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        
        
       long index = indexPath.row;
//        if (index == 2 && !objServiceDetail.strPrice.length) {
//            index = 3;
//        }
//        else if(index == 3 && !objServiceDetail.strPrice.length){
//            index = 4;
//        }

        if (!objServiceDetail.strPrice.length) {
            cell1.priceWidthConstraint.constant = 0.0f;
            cell1.priceTitleWidthConstraint.constant = 0.0f;
        } else {
            cell1.priceWidthConstraint.constant = windowWidth/4;
            cell1.priceTitleWidthConstraint.constant = windowWidth/4;
            
        }
        switch (index) {
            case 0:
//                cell.btnRight.hidden = YES;
//                cell.textFieldRight.hidden = NO;
//                cell.labelLeftttl.text = SLLocalizedString(@"Service name");
//                cell.textFieldRight.text = objServiceDetail.strServiceName;
                cell1.categoryLabel.text = SLLocalizedString(@"Category");
                cell1.transportAvailabilityLabel.text =SLLocalizedString(@"Transportation Availability");
                cell1.serviceTypeLabel.text = SLLocalizedString(@"Service Type");
                cell1.priceLabel.text = SLLocalizedString(@"Price");
                break;
            case 1:
//                cell.btnRight.hidden = NO;
//                cell.textFieldRight.hidden = YES;
//                cell.labelLeftttl.text = SLLocalizedString(@"Category");
//                [cell.btnRight setTitle:objServiceDetail.strCategory forState:UIControlStateNormal];
//                NSLog(@"%@",objServiceDetail.strPrice);
                
                cell1.categoryLabel.text = SLLocalizedString(objServiceDetail.strCategory);
                cell1.transportAvailabilityLabel.text = SLLocalizedString(objServiceDetail.strTransportationAvail);
                cell1.serviceTypeLabel.text = SLLocalizedString(objServiceDetail.strServiceType);
                cell1.priceLabel.text = SLLocalizedString(objServiceDetail.strPrice);
                
                break;
           /* case 2:
                cell.btnRight.hidden = YES;
                cell.textFieldRight.hidden = NO;
                cell.labelLeftttl.text = SLLocalizedString(@"Price");
                cell.textFieldRight.text = (objServiceDetail.strPrice.length)?[NSString stringWithFormat:@"$%@",objServiceDetail.strPrice]:@"";
                break;
            case 3:
                cell.btnRight.hidden = NO;
                cell.textFieldRight.hidden = YES;
                cell.labelLeftttl.text = SLLocalizedString(@"Transportation\nAvailability");
                [cell.btnRight setTitle:objServiceDetail.strTransportationAvail forState:UIControlStateNormal];
                break;
            case 4:
                cell.btnRight.hidden = NO;
                cell.textFieldRight.hidden = YES;
                cell.labelLeftttl.text = SLLocalizedString(@"Service Type");
                [cell.btnRight setTitle:objServiceDetail.strServiceType forState:UIControlStateNormal];
                break;
            */
                
            default:
                break;
        }
        
        return cell1;
        
        
    }else if (indexPath.section == 1) {
        
        SLPostedByTableViewCell *cell = (SLPostedByTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        // Change language
        self.labelName.text = (objServiceDetail.strUser_firstName.length)?[NSString stringWithFormat:@"%@ %@",objServiceDetail.strUser_firstName,objServiceDetail.strUser_lastName]:SLLocalizedString(@"(unknown)");
        self.labelCommentCount.text = [NSString stringWithFormat:@"%@ (%lu)",SLLocalizedString(@"Comments"),(unsigned long)objServiceDetail.commentArray.count];
        self.labelEmail.text = (objServiceDetail.strUser_email.length)?objServiceDetail.strUser_email:SLLocalizedString(@"(Not available)");

        
        if ([APPDELEGATE isArabic]) {
            cell.labelDescStaticText.textAlignment = NSTextAlignmentRight;
            cell.labelDescription.textAlignment = NSTextAlignmentRight;
        }else{
            cell.labelDescStaticText.textAlignment = NSTextAlignmentLeft;
            cell.labelDescription.textAlignment = NSTextAlignmentLeft;
        }
        
        cell.labelDescStaticText.text = SLLocalizedString(@"Description:");
        cell.labelDescription.text = objServiceDetail.strDescription;
        
        return cell;
        
    }else{
        
        SLCommentsTableViewCell *cell = (SLCommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierForComment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnMore.tag = indexPath.row + 10000;
        [cell.btnMore addTarget:self action:@selector(moreOptionBtnActionMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        SLServiceDetailModal *detail;
        if (LastLines.count && !isCollapse) {
           detail = [LastLines objectAtIndex:indexPath.row];
        }
        
        else {
            detail = [objServiceDetail.commentArray objectAtIndex:indexPath.row];
        }
        
        [cell.imageViewCommentPerson setImageWithURL:[NSURL URLWithString:detail.strComm_image] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
        cell.labelNameCommentPerson.text = (detail.strComm_firstName.length)?[NSString stringWithFormat:@"%@ %@",detail.strComm_firstName,detail.strComm_lastName]:SLLocalizedString(@"(unknown)");
        cell.labelPhoneNumberCommentPerson.text = detail.strComm_mobile;
        cell.labelDescriptionCommentPerson.text = detail.strComment;
        self.labelCommentCount.text = [NSString stringWithFormat:@"%@ (%lu)",SLLocalizedString(@"Comments"),(unsigned long)objServiceDetail.commentArray.count];
        cell.labelTimeCommentPerson.text = [SLUtility getHoursAgo:detail.strComm_commentedOn];
        
        if ([APPDELEGATE isArabic]){
            cell.labelNameCommentPerson.textAlignment = NSTextAlignmentRight;
            cell.labelPhoneNumberCommentPerson.textAlignment = NSTextAlignmentRight;
            cell.labelDescriptionCommentPerson.textAlignment = NSTextAlignmentRight;
            cell.labelTimeCommentPerson.textAlignment = NSTextAlignmentLeft;
        }else{
            cell.labelNameCommentPerson.textAlignment = NSTextAlignmentLeft;
            cell.labelPhoneNumberCommentPerson.textAlignment = NSTextAlignmentLeft;
            cell.labelDescriptionCommentPerson.textAlignment = NSTextAlignmentLeft;
            cell.labelTimeCommentPerson.textAlignment = NSTextAlignmentRight;
        }
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        return 38;
    }else if (section == 1){
        return 237;
    }
    else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 105;
    }else if (section == 2){
        return 0;
    }else{
        return 0;
        
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 237)];
        [self.headerViewForSectionOne setFrame:CGRectMake(0, 0, windowWidth, 237)];
        [hView addSubview:self.headerViewForSectionOne];
        return hView;
    }else  if (section == 2) {
        
        UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 40)];
        [self.headerViewSectionTwo setFrame:CGRectMake(0, 0, windowWidth, 40)];
        [hView addSubview:self.headerViewSectionTwo];
        return hView;
        
    }else {
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 0)];
        return dummyView;
        
    }
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 105)];
        [self.footerViewSectionZero setFrame:CGRectMake(0, 0, windowWidth, 105)];
        [fView addSubview:self.footerViewSectionZero];
        return fView;
        
    }else if (section == 2) {
        
        UIView *fsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
        [self.footerViewSectionTwo setFrame:CGRectMake(0, 0, windowWidth, 50)];
        [fsView addSubview:self.footerViewSectionTwo];
        return fsView;
    }
    else {
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 0)];
        return dummyView;
    }
    
    
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 39;
    }else if (indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }else{
        return 122;
    }
}

#pragma mark - UITextview Delegate Method

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    isCollapse = YES;
    [self.commentButton setImage:[UIImage imageNamed:@"upAr"] forState:UIControlStateNormal];
    [self.tableServiceDetail reloadData];
    if ([textView.text isEqualToString:SLLocalizedString(@"Share your comment...")])
        textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    strComment = textView.text;
    if (!strComment.length) {
        self.textviewComment.text = SLLocalizedString(@"Share your comment...");

    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    strComment = TRIM_SPACE(str);

    if (strComment.length == 501)
        return NO;
    else if (strComment.length){
        [self.btnSubmit setEnabled:YES];
        [self.btnSubmit setAlpha:1.0];
    }
    else{
        [self.btnSubmit setEnabled:NO];
        [self.btnSubmit setAlpha:0.5];
    }
    
    return YES;
}


#pragma mark - language selection Delegate method

- (void)didConfirmWithEnglish {
    [self initialSetup];
}

- (void)didConfirmWithArabic {
    [self initialSetup];
}

#pragma mark - UIButton Action Method

- (IBAction)commonButtonActionMethod:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            
            //back btn Action
            if (commentCount < objServiceDetail.commentArray.count) {
                [self.delegate deletePost];
                [self.navigationController popViewControllerAnimated:YES];

            }
            else
                [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case 11:
        {
            //notification  btn Action
            [self.view endEditing:YES];
            SLNotificationViewController *notificationVC = [[SLNotificationViewController alloc]initWithNibName:@"SLNotificationViewController" bundle:nil];
            if (self.isFromPushNotification) {
                [self dismissViewControllerAnimated:NO completion:^{
                    [[APPDELEGATE sidePanelNavigation] pushViewController:notificationVC animated:YES];
                }];
            }else{
                
                [self.navigationController pushViewController:notificationVC animated:YES];            }
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LANGUAGE" object:self];
        }
            break;
            
        case 13:
        {
            //repost btn Action
            
            [self.view endEditing:YES];
            [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"") message:SLLocalizedString(@"Are you sure! You want to repost this advertisement.") andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"Yes"),SLLocalizedString(@"No"), nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                if (index == 1) {
                    // [self.navigationController popViewControllerAnimated:YES];
                }else{
                    //Repost the add.
                    [self makeWebApiCallForRePostAdd];
                }
            }];
            
        }
            break;
            
        case 14:
        {
            //delete btn Action
            [self.view endEditing:YES];
            [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"") message:SLLocalizedString(@"Are you sure! You want to delete this post.") andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"Yes"),SLLocalizedString(@"No"), nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                if (index == 1) {
                }else{
                    //delete this post.
                    [self makeWebApiCallForDeletePost];
                }
            }];
            
        }
            break;
            
        case 15:
        {
            //edit btn Action
            [self.view endEditing:YES];
            SLEditServiceViewController *editServiceVC = [[SLEditServiceViewController alloc]initWithNibName:@"SLEditServiceViewController" bundle:nil];
            editServiceVC.serviceModel = objServiceDetail;
            editServiceVC.delegate = self;
            [self.navigationController pushViewController:editServiceVC animated:YES];
        }
            break;
            
        case 16:
        {
            
            [self makeWebApiCallForLike];

        }
            break;
            
            
        case 17:
        {
            //submit the comment btn Action
            self.textviewComment.text = @"";
            [self.btnSubmit setEnabled:NO];
            [self.btnSubmit setAlpha:0.5];
            [self makeWebApiCallForComment];
        }
            break;
            
        case 18:
        {
            //expand collapase btn Action
            if (isCollapse) {
                isCollapse = NO;
                [self.commentButton setImage:[UIImage imageNamed:@"dAr"] forState:UIControlStateNormal];
            }else{
                isCollapse = YES;
                [self.commentButton setImage:[UIImage imageNamed:@"upAr"] forState:UIControlStateNormal];
            }
            [self.tableServiceDetail reloadData];
        }
            break;
            
        default:
            break;
    }
}


-(IBAction)rightButtonActionMethod:(UIButton*)sender{
    
    switch (sender.tag) {
        case 201:
        {
            //categoty btn action
            [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:[NSArray arrayWithObjects:SLLocalizedString(@"Teaching"),SLLocalizedString(@"Painting"),SLLocalizedString(@"Cooking"),SLLocalizedString(@"Construction"),SLLocalizedString(@"Tailor"),SLLocalizedString(@"Mechanic"), nil] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                objServiceDetail.strCategory = selectedText;
                [self.tableServiceDetail reloadData];
            }];
        }
            break;
            
        case 203:
        {
            //transportation availability btn action
            [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:[NSArray arrayWithObjects:SLLocalizedString(@"YES"),SLLocalizedString(@"NO"), nil] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                objServiceDetail.strTransportationAvail = selectedText;
                [self.tableServiceDetail reloadData];
            }];
        }
            break;
            
        case 204:
        {
            //service type btn action
            [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:[NSArray arrayWithObjects:SLLocalizedString(@"Offered"),SLLocalizedString(@"Required"),SLLocalizedString(@"Sales"),SLLocalizedString(@"Inquiry"), nil] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                objServiceDetail.strServiceType = selectedText;
                [self.tableServiceDetail reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
    
}

-(IBAction)postedByCellExistingButtonAction:(UIButton*)sender{
    
    switch (sender.tag) {
        case 50:
        {
            //call btn Action
            [self callToUser:NO];
        }
            break;
            
        case 51:
        {
            //sms btn Action
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:1234567890"]];
            NSString *stringPhone = [[objServiceDetail.strUser_mobileNo componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",stringPhone]]];
        }
            break;
            
        case 52:
        {
            //email btn Action
            if (objServiceDetail.strUser_email.length) {
                
                [self openEmailController:NO];
            }
            else {
                [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Email id is not available") andController:self];
            }
        }
            break;
            
        case 53:
        {
            //Add to Favorite btn Action
            [self makeWebApiCallForFavourite];
            
        }
            break;
            
        case 54:
        {
            //Report btn Action
            SLReportViewController *reportVC = [[SLReportViewController alloc]initWithNibName:@"SLReportViewController" bundle:nil];
            reportVC.nid = objServiceDetail.strNid;
            [self.navigationController pushViewController:reportVC animated:YES];
        }
            break;
            
        case 55:
        {
            //Share btn Action
            NSString *strSahre;
            if (objServiceDetail.strUser_firstName.length) {
              //  strSahre =[NSString stringWithFormat:@"%@ %@ has created service: %@",objServiceDetail.strUser_firstName,objServiceDetail.strUser_lastName,objServiceDetail.strServiceName];
//                strSahre = @"89z0.test-app.link";
                strSahre = @"uwe1.test-app.link/XxVNTRJd8A";

            }
            else {
              // strSahre =[NSString stringWithFormat:@"Someone has created service: %@",objServiceDetail.strServiceName];
                //strSahre = @"89z0.test-app.link";
                strSahre = @"uwe1.test-app.link/XxVNTRJd8A";
            }

//            UIImage *imgForShare = [APPDELEGATE captureScreen];

           // [[AlertView sharedManager]displayInformativeAlertwithTitle:@"" andMessage:[NSString stringWithFormat:@"%@",[NSURL URLWithString:objServiceDetail.image]] onController:self ];
                self.activityViewController= [[UIActivityViewController alloc] initWithActivityItems:@[self.imageViewServiceDetail.image,[NSURL URLWithString:@"servicelisting://uwe1.test-app.link"]] applicationActivities:nil];
           // self.activityViewController= [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:objServiceDetail.image],[NSURL URLWithString:@"servicelisting://uwe1.test-app.link"]] applicationActivities:nil];
                
                [self presentViewController:self.activityViewController animated:YES completion:nil];

           // });
//            self.activityViewController= [[UIActivityViewController alloc] initWithActivityItems:@[imgForShare,@"<html><body><b>This is a bold string</b><br\\>Check out this amazing site: <a href='http://89z0.test-app.link/XxVNTRJd8A'>Apple</a></body></html>"] applicationActivities:nil];
//            [self presentViewController:self.activityViewController animated:YES completion:nil];

            
        }
            break;
            
        default:
            break;
    }
    
}


- (IBAction)moreOptionBtnActionMethod:(UIButton*)sender {
    
    [self.view endEditing:YES];
    
    if (LastLines.count && !isCollapse) {
        objSelectedComUserDetail = [LastLines objectAtIndex:sender.tag-10000];
    }
    else {
        objSelectedComUserDetail = [objServiceDetail.commentArray objectAtIndex:sender.tag-10000];
        indexrow = sender.tag-10000;
    }
 
    SLCallPopUpViewController *callPopVC = [[SLCallPopUpViewController alloc]initWithNibName:@"SLCallPopUpViewController" bundle:nil];
    callPopVC.commentUserIdString = objSelectedComUserDetail.strCommentId;
    callPopVC.userIdString = objSelectedComUserDetail.strComm_UserId;
    callPopVC.delegate = self;
    callPopVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:callPopVC animated:NO completion:nil];
}

- (IBAction)postAddButtonAction:(id)sender {
    
    SLPostNewAddViewController *postAdd = [[SLPostNewAddViewController alloc]init];
    [self.navigationController pushViewController:postAdd animated:YES];
}


#pragma mark - call pop up delegate method

-(void)dismisWithEmailOption:(NSInteger)buttonTag popUp:(BOOL)fromPopUp{
    
    if (buttonTag == 11) {
        
        [self callToUser:YES];
    }
    else if (buttonTag == 12) {
        
    NSString *string = [[objSelectedComUserDetail.strComm_mobile componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",string]]];
    }
    else if (buttonTag == 13) {
        [self openEmailController:YES];
    }
    else if (buttonTag == 14) {
        [self makeWebApiCallForReport];
    }
    else if (buttonTag == 15) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"" message:SLLocalizedString(@"Are you sure you want to delete this comment?") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"CancelSmall") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"Yes")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self makeWebApicallToDeleteComments];
            }];
            [alert addAction:okAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:NO completion:nil];
        });
    }
}


- (void)openEmailController:(BOOL)fromPopUp {
    
    if (!fromPopUp || (objSelectedComUserDetail.strComm_Email.length && fromPopUp)) {
       
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"Service Listing"];
            [mail setMessageBody:[NSString stringWithFormat:@"Hi, I have created service : %@",objServiceDetail.strServiceName] isHTML:NO];
            [mail setToRecipients:@[(fromPopUp)?objSelectedComUserDetail.strComm_Email:objServiceDetail.strUser_email]];
            
            [self presentViewController:mail animated:YES completion:NULL];
        }
        else
        {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:SLLocalizedString(@"Alert") andMessage:SLLocalizedString(@"email facility is not available.") onController:self];
            
        }
    }
    else
    [[AlertView sharedManager] displayInformativeAlertwithTitle:SLLocalizedString(@"Alert") andMessage:SLLocalizedString(@"Email id is not available") onController:self];
}


#pragma mark - Mail composer delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Web Service API Methods

- (void)makeWebApiCallForFavourite {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:self.serviceModel.strNid forKey:Knid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:([objServiceDetail.strFav_status boolValue])?apimake_unfavourite_advertisement:apiMake_favourite_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                ([objServiceDetail.strFav_status boolValue])?(objServiceDetail.strFav_status = @"0"):(objServiceDetail.strFav_status = @"1");
                
                if ([objServiceDetail.strFav_status boolValue]) {
                    [self.btnAddToFavorite setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
                    [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
                    [self.btnAddToFavorite setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 8)];

                    [self.btnAddToFavorite setTitle:SLLocalizedString(@"Remove from Favorites") forState:UIControlStateNormal];
                }
                else{
                    [self.btnAddToFavorite setImage:[UIImage imageNamed:@"Favorites_S"] forState:UIControlStateNormal];
                    [self.btnAddToFavorite setTitle:SLLocalizedString(@"Add to favorite") forState:UIControlStateNormal];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_UPDATE_FAVORITE_LIST object:self];
                [SLUtility alertWithTitle:SLLocalizedString(@"Success!") andMessage:strResponseMessage andController:self];
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}


- (void)makeWebApiCallForServiceDetail {
    
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:(self.notificationIdString)?self.notificationIdString:self.serviceModel.strNid  forKey:Knid];

    [dictRequest setValue:@"1" forKey:Kview];
//    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlatitude] forKey:Klatitude];
//    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultlongitude]  forKey:Klongitude];
    
    
    
    
    
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

    
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiadvertisement_detail WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"%@", response);

        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                self.tableServiceDetail.hidden = NO;
                self.commentTypeView.hidden = NO;
                objServiceDetail = [SLServiceDetailModal serviceDetailFromResponse:response];
                
                [self.btnNumberOfLike setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strTotalLike,SLLocalizedString(@"Likes")] forState:UIControlStateNormal];
                self.serviceLabel.text = SLLocalizedString(objServiceDetail.strServiceName);
                
                if ([objServiceDetail.strLike_status boolValue]) {
                    [self.btnNumberOfLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                }
                else{
                    [self.btnNumberOfLike setImage:[UIImage imageNamed:@"likeGray"] forState:UIControlStateNormal];
                }
                
                if ([objServiceDetail.strFav_status boolValue]) {
                    [self.btnAddToFavorite setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
                    [self.btnAddToFavorite setTitle:SLLocalizedString(@"Remove from Favorites") forState:UIControlStateNormal];
                    [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
                    [self.btnAddToFavorite setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 8)];
                }
                else{
                    [self.btnAddToFavorite setImage:[UIImage imageNamed:@"Favorites_S"] forState:UIControlStateNormal];
                    [self.btnAddToFavorite setTitle:SLLocalizedString(@"Add to favorite") forState:UIControlStateNormal];
                    [self.btnAddToFavorite setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
                }
                
                if (![objServiceDetail.strIs_current_user_post boolValue]) {
                    self.btnDelete.hidden = YES;
                    self.btnEdit.hidden = YES;
                    self.repostLeftConstraint.constant = -122;
                }
                else {
                    self.btnDelete.hidden = NO;
                    self.btnEdit.hidden = NO;
                    self.repostLeftConstraint.constant = 15;
                }
                commentCount = objServiceDetail.commentArray.count;
                
                if (objServiceDetail.commentArray.count < 5) {
                    isCollapse = YES;
                }
                else {
                    
                    LastLines = [[objServiceDetail.commentArray subarrayWithRange:NSMakeRange(([objServiceDetail.commentArray count]-4), 4)] mutableCopy];

                }
                
                [self.btnNumberOfViews setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strTotalView,SLLocalizedString(@"Views")] forState:UIControlStateNormal];
                
                if (!objServiceDetail.strDistance.length) {
                    [self.btnDistanceInKM setTitle:@"" forState:UIControlStateNormal];
                }else
                 [self.btnDistanceInKM setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strDistance,SLLocalizedString(@"Km")] forState:UIControlStateNormal];
                
                
                
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                
                NSString *str = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble: timeStamp]];
                
                if ([[SLUtility getStringDateFromTimestamp:objServiceDetail.strPostDate] isEqualToString:[SLUtility getStringDateFromTimestamp:str]])
                    
                    self.postDateLabel.text = SLLocalizedString(@"Today");
                else
                    self.postDateLabel.text = [SLUtility getStringDateFromTimestamp:objServiceDetail.strPostDate];

                
                
                [self.imageViewServiceDetail setImageWithURL:[NSURL URLWithString:objServiceDetail.image] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
                self.labelName.text = (objServiceDetail.strUser_firstName.length)?[NSString stringWithFormat:@"%@ %@",objServiceDetail.strUser_firstName,objServiceDetail.strUser_lastName]:SLLocalizedString(@"(unknown)");
                self.labelCommentCount.text = [NSString stringWithFormat:@"%@ (%lu)",SLLocalizedString(@"Comments"),(unsigned long)objServiceDetail.commentArray.count];
                self.labelPhoneNmber.text = objServiceDetail.strUser_mobileNo;
                self.labelEmail.text = (objServiceDetail.strUser_email.length)?objServiceDetail.strUser_email:SLLocalizedString(@"(Not available)");
                self.labelTransection.text = [NSString stringWithFormat:@"Transportation availability : %@",objServiceDetail.strTransportationAvail];
                [self.imageViewPostedby setImageWithURL:[NSURL URLWithString:objServiceDetail.strUser_image] placeholderImage:[UIImage imageNamed:@"placeholder-1"]];
                
                [self.tableServiceDetail reloadData];
                
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}


- (void)makeWebApiCallForComment {
    
    self.tableServiceDetail.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:(self.serviceModel.strNid?self.serviceModel.strNid:self.notificationIdString) forKey:Knid];
    [dictRequest setValue:strComment forKey:Kcomment];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apipost_comment WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"%@", response);
        self.tableServiceDetail.userInteractionEnabled = YES;
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView startAnimating];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
//                SLServiceDetailModal *commentModelInfo = [[SLServiceDetailModal alloc]init];
//                commentModelInfo.strComment = strComment;
//                commentModelInfo.strComm_mobile = objServiceDetail.strUser_mobileNo;
//                commentModelInfo.strComm_firstName = objServiceDetail.strUser_firstName;
//                commentModelInfo.strComm_lastName = objServiceDetail.strUser_lastName;
//                commentModelInfo.strComm_image = objServiceDetail.strUser_image;
//                commentModelInfo.strComm_UserId = [[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID];
//                commentModelInfo.strComm_Email = objServiceDetail.strUser_email;
//
//                commentModelInfo.strComm_commentedOn = [SLUtility getCurrentDate];
                
                [objServiceDetail.commentArray addObject:[SLServiceDetailModal serviceCurrentCommentResponse:[response valueForKey:Kcomments]]];
//                [self.btnSubmit setEnabled:NO];
//                [self.btnSubmit setAlpha:0.5];

                [self.tableServiceDetail reloadData];
                strComment = @"";
                self.textviewComment.text = @"";

                if ([objServiceDetail.commentArray count] && (isCollapse)) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([objServiceDetail.commentArray count] - 1) inSection:2];
                    [self.tableServiceDetail scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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


- (void)makeWebApiCallForDeletePost {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:self.serviceModel.strNid forKey:Knid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apidelete_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [self.delegate deletePost];
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


- (void)makeWebApiCallForLike {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:self.serviceModel.strNid forKey:Knid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:([objServiceDetail.strLike_status boolValue])?apiUnlike_advertisement:apiLike_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [self.delegate deletePost];
                ([objServiceDetail.strLike_status boolValue])?(objServiceDetail.strLike_status = @"0"):(objServiceDetail.strLike_status = @"1");
                
                if ([objServiceDetail.strLike_status boolValue]) {
                    [self.btnNumberOfLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                }
                else{
                    [self.btnNumberOfLike setImage:[UIImage imageNamed:@"likeGray"] forState:UIControlStateNormal];
                }
                
                objServiceDetail.strTotalLike = [response objectForKeyNotNull:KtotalLikes expectedClass:[NSString class]];
                [self.btnNumberOfLike setTitle:[NSString stringWithFormat:@"%@ %@",objServiceDetail.strTotalLike,SLLocalizedString(@"Likes")] forState:UIControlStateNormal];
            }else{
                [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
            }
            
        }else{
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            [SLUtility alertWithTitle:SLLocalizedString(@"Error!") andMessage:strResponseMessage andController:self];
        }
    }];
}


- (void)makeWebApiCallForRePostAdd {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:self.serviceModel.strNid forKey:Knid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apirepost_advertisement WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [self.delegate deletePost];
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


- (void)makeWebApiCallForReport {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:objSelectedComUserDetail.strComm_UserId forKey:Kid];
    [dictRequest setValue:@"user" forKey:Ktype];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apireport WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                
                [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"Success!") message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"OK"),nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
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


-(void)makeWebApicallToDeleteComments {
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:[[AppSettingsManager sharedinstance] objectForKey:KDefaultUserID] forKey:KuserID];
    [dictRequest setValue:([APPDELEGATE isArabic] ? Kar : Ken) forKey:KlanguageType];
    [dictRequest setValue:objSelectedComUserDetail.strCommentId forKey:KCid];
    
    NSLog(@"dictRequest = %@", dictRequest);
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:apiDeleteComment WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        NSLog(@"response = %@", response);

        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedClass:[NSString class]];
            
            if (strResponseCode.integerValue == KSuccessCode) {
                [objServiceDetail.commentArray removeObjectAtIndex:indexrow];
                [self.tableServiceDetail reloadData];

                [[AlertView sharedManager] presentAlertWithTitle:SLLocalizedString(@"Success!") message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:SLLocalizedString(@"OK"),nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
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


-(void)pushNotificationGetValue:(NSDictionary *)dict {
    
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
