//
//  SLCountryCodeViewController.m
//  ServicesListing
//
//  Created by Deepak Chauhan on 07/02/17.
//  Copyright © 2017 Tejas Pareek. All rights reserved.
//

#import "SLCountryCodeViewController.h"
#import "Header.h"
#import "SLCountryCodeTableViewCell.h"
#import "SLCountryListWithCode.h"

static NSString *cellIdentifier = @"countryCodeCellId";

@interface SLCountryCodeViewController ()<UITableViewDelegate,UISearchBarDelegate> {

    NSMutableArray * filterArray;
    NSMutableArray * listOfCountriesArray;
    NSArray        * BDVCountryNameAndCodePlist;
    NSInteger index;

    
}

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SLCountryCodeViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.navTitleLabel.text = SLLocalizedString(@"CHOOSE COUNTRY");
    [self.doneButton setTitle:SLLocalizedString(@"Done") forState:UIControlStateNormal];
    
    // Register Table View
    [self.tableView registerNib:[UINib nibWithNibName:@"SLCountryCodeTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.estimatedRowHeight = 54.0;
    
    filterArray = [NSMutableArray array];
    listOfCountriesArray = [NSMutableArray array];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"BDVCountryNameAndCode" ofType:@"plist"];
    BDVCountryNameAndCodePlist = [NSArray arrayWithContentsOfFile:path];
    
    
//    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    
    // Disable Done Button
    
    self.doneButton.userInteractionEnabled = NO;
    self.doneButton.alpha = 0.5;
    index = -1;
    
    for (NSDictionary * dict in BDVCountryNameAndCodePlist) {
        SLCountryListWithCode *countryWithCode = [SLCountryListWithCode new];
        
        countryWithCode.countryCode = [dict objectForKeyNotNull:@"dial_code" expectedClass:[NSString class]];
        
        countryWithCode.countryName = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];
        countryWithCode.countryNameCode = [dict objectForKeyNotNull:@"code" expectedClass:[NSString class]];
        countryWithCode.countryNameArabic = [dict objectForKeyNotNull:@"nameArabic" expectedClass:[NSString class]];
        countryWithCode.isSelect = NO;
        
        [filterArray addObject:countryWithCode];
        [listOfCountriesArray addObject:countryWithCode];
        
    }
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     SLCountryCodeTableViewCell *cell = (SLCountryCodeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.isMobileCode) {
        cell.countryCodeLabel.hidden = YES;
    }
    else
        cell.countryCodeLabel.hidden = NO;

    SLCountryListWithCode *countryWithCode = [filterArray objectAtIndex:indexPath.row];
    
    if ([APPDELEGATE isArabic])
        cell.countryNameLabel.text = countryWithCode.countryNameArabic;
    else
        cell.countryNameLabel.text = countryWithCode.countryName;
    
    cell.countryCodeLabel.text = countryWithCode.countryCode;
    cell.flagImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"CountryPicker.bundle/%@",countryWithCode.countryCode]];
    
    
    if (indexPath.row == index)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        
      //  SLCountryListWithCode *countryWithCode = [filterArray objectAtIndex:indexPath.row];
        
        index = indexPath.row;
    
        self.doneButton.userInteractionEnabled = YES;
        self.doneButton.alpha = 1.0;
    
        [self.tableView reloadData];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETCountryCodeNotification" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:([APPDELEGATE isArabic])?countryWithCode.countryNameArabic:countryWithCode.countryName,@"cName",countryWithCode.countryNameCode,@"countryNameCode",countryWithCode.countryCode,@"mobilePrefix", nil]];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETCountryCodeNotification" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:countryWithCode.countryNameArabic,@"cNameArr",countryWithCode.countryName,@"cName",countryWithCode.countryNameCode,@"countryNameCode",countryWithCode.countryCode,@"mobilePrefix", nil]];
//        
//        if (!self.isFromPostAdd) {
//            [NSUSERDEFAULT setValue:countryWithCode.countryNameArabic forKey:@"CountryFullNameArabic"];
//            [NSUSERDEFAULT setValue:countryWithCode.countryName forKey:@"CountryFullName"];
//            [NSUSERDEFAULT setValue:countryWithCode.countryCode forKey:@"selectedCountryCode"];
//            [NSUSERDEFAULT setValue:countryWithCode.countryNameCode forKey:@"countryNCode"];
//        }
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
}

#pragma mark - UISearchBar Action


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    

    if (searchText.length) {
        [filterArray removeAllObjects]; // clearing filter array
        NSPredicate *filterPredicate;
        NSString *language = [UITextInputMode currentInputMode].primaryLanguage;
        
        if ([language isEqualToString:@"ar"]) {
            filterPredicate = [NSPredicate predicateWithFormat:@"SELF.countryNameArabic contains[c] %@",searchText]; // Creating filter condition
        }else {
            filterPredicate = [NSPredicate predicateWithFormat:@"SELF.countryName contains[c] %@",searchText]; // Creating filter condition
        }
        filterArray = [NSMutableArray arrayWithArray:[listOfCountriesArray filteredArrayUsingPredicate:filterPredicate]];
        
        [self.tableView reloadData];// filtering result
    }
   
}

#pragma mark - UIButton Action

- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SLCountryListWithCode *countryWithCode = [filterArray objectAtIndex:index];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETCountryCodeNotification" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:countryWithCode.countryNameArabic,@"cNameArr",countryWithCode.countryName,@"cName",countryWithCode.countryNameCode,@"countryNameCode",countryWithCode.countryCode,@"mobilePrefix", nil]];
        
        if (!self.isFromPostAdd) {
            [NSUSERDEFAULT setValue:countryWithCode.countryNameArabic forKey:@"CountryFullNameArabic"];
            [NSUSERDEFAULT setValue:countryWithCode.countryName forKey:@"CountryFullName"];
            [NSUSERDEFAULT setValue:countryWithCode.countryCode forKey:@"selectedCountryCode"];
            [NSUSERDEFAULT setValue:countryWithCode.countryNameCode forKey:@"countryNCode"];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
