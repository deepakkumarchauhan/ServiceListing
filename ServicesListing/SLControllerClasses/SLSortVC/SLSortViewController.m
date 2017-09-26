//
//  SLSortViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 22/12/16.
//  Copyright © 2016 Tejas Pareek. All rights reserved.
//

#import "SLSortViewController.h"
#import "Header.h"

static NSString *cellIdentifier = @"sortCellId";

@interface SLSortViewController ()<LanguageChangeDelegate>{
    
    SLServiceModal *objService;
    NSMutableArray *titleArray;
    NSMutableArray *sortArray;
    long index;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet SLCustomButton *applyButton;
@property (weak, nonatomic) IBOutlet SLCustomButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@end

@implementation SLSortViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self initialSetup];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

- (void)initialSetup {
    
    [self.navigationController setNavigationBarHidden:YES];
    self.titleLabel.text = SLLocalizedString(@"SORT");
    
    // Alloc MutableArray
    titleArray = [[NSMutableArray alloc]initWithObjects:SLLocalizedString(@"Latest ads"),SLLocalizedString(@"Most commented today"),SLLocalizedString(@"Most commented last week"),SLLocalizedString(@"Last month"),SLLocalizedString(@"Last week"),SLLocalizedString(@"Most liked"), nil];
    
    [self.cancelButton setTitle:SLLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [self.applyButton setTitle:SLLocalizedString(@"Apply") forState:UIControlStateNormal];

    sortArray = [NSMutableArray array];
    
    for (int i = 0; i<=5; i++) {
        objService = [[SLServiceModal alloc] init];
        objService.isLike = NO;
        [sortArray addObject:objService];
    }
    
    if ([APPDELEGATE isArabic])
        [self.languageButton setImage:[UIImage imageNamed:@"eng"] forState:UIControlStateNormal];
    else
       [self.languageButton setImage:[UIImage imageNamed:@"arabic"] forState:UIControlStateNormal];

    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLSortTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSortTableViewCell *sortCell = (SLSortTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    sortCell.sortTitleLabel.text = [titleArray objectAtIndex:indexPath.row];
    objService = [sortArray objectAtIndex:indexPath.row];
    
    if (objService.isLike) {
        sortCell.checkButton.selected = YES;
        [sortCell.checkButton setBackgroundColor:[UIColor colorWithRed:57.0/255.0 green:72.0/255.0 blue:135.0/255.0 alpha:1.0]];
    }
    else{
        sortCell.checkButton.selected = NO;
        [sortCell.checkButton setBackgroundColor:[UIColor whiteColor]];

    }
    
    if ([APPDELEGATE isArabic])
        sortCell.sortTitleLabel.textAlignment = NSTextAlignmentRight;
    else
        sortCell.sortTitleLabel.textAlignment = NSTextAlignmentLeft;

    return sortCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    objService = [sortArray objectAtIndex:indexPath.row];
    index = indexPath.row;
    for (SLServiceModal *obj in sortArray) {
        obj.isLike = NO;
    }
    objService.isLike = YES;
    [self.tableView reloadData];
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (IBAction)applyButtonAction:(id)sender {
    
    BOOL isPresent = NO;

    for (SLServiceModal *obj in sortArray) {
        if (obj.isLike) {
            isPresent = YES;
            
//            [[AppSettingsManager sharedinstance] setObject:[titleArray objectAtIndex:index] forKey:KDefaultSort];
            
            NSMutableDictionary *sortDict = [[NSMutableDictionary alloc]init];
            [sortDict setValue:[titleArray objectAtIndex:index] forKey:@"sortStr"];
            [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFICATION_SORT object:nil userInfo:sortDict];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }else
            isPresent = NO;
    }
    if (!isPresent) {
         [SLUtility alertWithTitle:@"" andMessage:SLLocalizedString(@"Please select any sorting category") andController:self];
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
