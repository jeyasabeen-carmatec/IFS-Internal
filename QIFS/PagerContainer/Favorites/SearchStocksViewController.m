//
//  SearchStocksViewController.m
//  QIFS
//
//  Created by zylog on 13/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "SearchStocksViewController.h"
#import "AppDelegate.h"
#import "SearchStocksCell.h"

NSString *const kSearchStocksCellIdentifier = @"SearchStocksCell";

@interface SearchStocksViewController ()<NSURLSessionDelegate>
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIButton *buttonApply;
@property (nonatomic, strong) NSMutableArray *arrayFilter;
@property (nonatomic, strong) NSArray *arrayTitles;
@property (nonatomic, strong) NSMutableArray *arrayFilterList;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property (nonatomic, assign) BOOL isSearchClicked;

@end

@implementation SearchStocksViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Add Favorites", @"Add Favorites")];
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.arrayFilter = [[NSMutableArray alloc] init];

    self.arrayList = [[NSMutableArray alloc] init];
//    self.arrayFilterList = [[NSMutableArray alloc] init];

//    NSArray *techCount = [globalShare.sectorValues valueForKeyPath:@"@distinctUnionOfObjects.SectorVal"];
//
//    for(int i=0;i<[techCount count];i++) {
//        NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.Sector matches %@", techCount[i]];
//        NSArray *arrFiltered = [globalShare.sectorValues filteredArrayUsingPredicate:applePred];
//        [self.arrayFilter addObjectsFromArray:arrFiltered];
//    }
    
//    _buttonApply.layer.cornerRadius = 3;
//    _buttonApply.layer.masksToBounds = YES;
//    _buttonApply.layer.borderWidth = 1.0;
//    _buttonApply.layer.borderColor = [UIColor whiteColor].CGColor;
    NSLog(@"The values of ticker selction are:%@",globalShare.dictValues);
    self.arrayTitles = [[globalShare.dictValues allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for(int i=0;i<self.arrayTitles.count;i++)
    {
        NSString *sectionTitle = [self.arrayTitles objectAtIndex:i];
        NSLog(@"The Dictionary Values are:%@",globalShare.dictValues);
        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
        for(int j=0;j<sectionVals.count;j++)
        {
        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:j];
        for(int k = 0; k< globalShare.favouritesArray.count;k++)
        {
            if([[dictVal valueForKey:@"ticker"] isEqualToString:[[globalShare.favouritesArray objectAtIndex:k]valueForKey:@"Ticker"]])
            {
                [dictVal setValue:@"YES" forKey:@"is_checked"];
                [sectionVals replaceObjectAtIndex:j withObject:dictVal];
                [globalShare.dictValues setValue:sectionVals forKey:sectionTitle];
            }
        }
        }
    }
    [self.searchBar setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    [self.searchBar setImage:[UIImage imageNamed:@"icon_greysearch"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.tintColor = [UIColor darkGrayColor];
}
-(void)viewWillAppear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCancel:(id)sender {
    [self.delegate callBackResults:self.arrayFilter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionApply:(id)sender {
    NSString *strTickerParams;
    NSString *strUpdateParams;
    NSMutableArray *Temparry = [[NSMutableArray alloc]init];
    NSLog(@"The array count :%lu",(unsigned long)self.arrayFilter.count);
    if(self.arrayFilter.count > 0)
    {
     //   strUpdateParams = [NSString stringWithFormat:@"%@", self.arrayFilter[0][@"ticker"]];
 //   [Temparry addObject:strUpdateParams];
        NSLog(@"The values in filter array is : %@",self.arrayFilter);
    for (int i=0; i<self.arrayFilter.count; i++) {
        NSMutableDictionary *dictVal = self.arrayFilter[i];
        if([[dictVal valueForKey:@"is_checked"]boolValue])
        {
            
        strTickerParams = [NSString stringWithFormat:@"%@",dictVal[@"ticker"]];
            [Temparry addObject:strTickerParams];
            
//        strTickerParams = [NSString stringWithFormat:@"%@ or ticker = '%@'", strTickerParams, dictVal[@"ticker"]];
//        strUpdateParams = [NSString stringWithFormat:@"update tbl_SecurityList set is_checked = '%@' where %@", @"YES", strTickerParams];
        }
        else{
         strTickerParams = [NSString stringWithFormat:@"%@",dictVal[@"ticker"]];
            [Temparry addObject:strTickerParams];

        }
       
      //  [globalShare.fmDBObject executeUpdate:strUpdateParams];
    }
    NSString *strTickerParamsString = [NSString stringWithFormat:@"%@",[Temparry componentsJoinedByString:@","]];

    [self favouritesAddorRemove:strTickerParamsString];
    }
    else
    {
         [GlobalShare showBasicAlertView:self :CHECK_ITEMS];
    }

}

- (IBAction)actionCheckFavorite:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewStocks];
    NSIndexPath *indexPath = [self.tableViewStocks indexPathForRowAtPoint:buttonPosition];
    
    if(self.isSearchClicked) {
        SearchStocksCell* cell = (SearchStocksCell *)[self.tableViewStocks cellForRowAtIndexPath:indexPath];
        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];
        
        if([[dictVal valueForKey:@"is_checked"]boolValue]) {
//        if(cell.selected == YES) {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
            
            [dictVal setValue:@"NO" forKey:@"is_checked"];
            
            cell.selected=NO;
            
            [self.arrayFilter removeObject:dictVal];
        }
        else {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.buttonTick setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
            
            [dictVal setValue:@"YES" forKey:@"is_checked"];
            cell.selected=YES;
            
            [self.arrayFilter addObject:dictVal];
        }
    }
    else {
        SearchStocksCell* cell = (SearchStocksCell *)[self.tableViewStocks cellForRowAtIndexPath:indexPath];
        
        
        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
        
        if([[dictVal valueForKey:@"is_checked"]boolValue]) {
//        if(cell.selected == YES) {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
            
            [dictVal setValue:@"NO" forKey:@"is_checked"];
            [sectionVals replaceObjectAtIndex:indexPath.row withObject:dictVal];
            [globalShare.dictValues setValue:sectionVals forKey:sectionTitle];
            cell.selected=NO;
            
            [self.arrayFilter addObject:dictVal];
        }
        else {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.buttonTick setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
            
            [dictVal setValue:@"YES" forKey:@"is_checked"];
            [sectionVals replaceObjectAtIndex:indexPath.row withObject:dictVal];
            [globalShare.dictValues setValue:sectionVals forKey:sectionTitle];
            cell.selected=YES;
            
            [self.arrayFilter addObject:dictVal];
        }
    }
    [self.tableViewStocks reloadData];

    
//    
//    if ([buttonReceive.currentImage isEqual:[UIImage imageNamed:@"tickmark.png"]]) {
//        [buttonReceive setImage:nil forState:UIControlStateNormal];
//        
//        if(self.isSearchClicked)
//        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];
//
//        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
//        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
//        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
//
//        for (int i=0; i<arrayCheckList.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            UITableViewCell *cell = [tblCheckList cellForRowAtIndexPath:indexPath];
//            
//            for (UIView *view in  cell.contentView.subviews) {
//                if ([view isKindOfClass:[UIButton class]]) {
//                    
//                    UIButton *button = (UIButton *)view;
//                    [button setBackgroundImage:[UIImage imageNamed:@"checkbox_on_background.png"] forState:UIControlStateNormal];
//                }
//            }
//        }
//
////        [_viewCheck setBackgroundColor:[UIColor clearColor]];
////        _viewCheck.layer.borderWidth = 1.0;
////        _viewCheck.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    }
//    else {
//        [buttonReceive setImage:[UIImage imageNamed:@"tickmark.png"] forState:UIControlStateNormal];
////        [_viewCheck setBackgroundColor:[UIColor orangeColor]];
////        _viewCheck.layer.borderWidth = 1.0;
////        _viewCheck.layer.borderColor = [UIColor orangeColor].CGColor;
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearchClicked) return 1;
    else return [self.arrayTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearchClicked) return [self.arrayFilterList count];
    else {
        NSString *sectionTitle = [self.arrayTitles objectAtIndex:section];
        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
        return [sectionVals count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    if(self.isSearchClicked) {
//        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];
//
//        cell.textLabel.text = dictVal[@"Symbol"];
//        cell.detailTextLabel.text = dictVal[@"Name"];
//        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if([dictVal[@"IsChecked"] boolValue] == YES)
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        else
//            cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    else {
//        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
//        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
//        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
//        
//        cell.textLabel.text = dictVal[@"Symbol"];
//        cell.detailTextLabel.text = dictVal[@"Name"];
//        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if([dictVal[@"IsChecked"] boolValue] == YES)
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        else
//            cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    return cell;
    
    SearchStocksCell *cell = (SearchStocksCell *) [tableView dequeueReusableCellWithIdentifier:kSearchStocksCellIdentifier forIndexPath:indexPath];

    if(self.isSearchClicked) {
        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];

        cell.labelSymbol.text = dictVal[@"ticker"];
        cell.labelCompanyName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? dictVal[@"security_name_e"] : dictVal[@"security_name_a"];;

        [cell.buttonTick setImage:nil forState:UIControlStateNormal];
        cell.viewTick.layer.cornerRadius = 3;
        cell.viewTick.layer.masksToBounds = YES;
        cell.viewTick.layer.borderWidth = 2.0;
        cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
        cell.viewTick.backgroundColor = [UIColor clearColor];

        if([dictVal[@"is_checked"] boolValue] == YES) {
//        if(cell.selected == YES) {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.buttonTick setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
        }
        else {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
        }
    }
    else {
        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
        NSLog(@"The Dictionary Values are:%@",globalShare.dictValues);
        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
        
        
        cell.labelSymbol.text = dictVal[@"ticker"];
        cell.labelCompanyName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? dictVal[@"security_name_e"] : dictVal[@"security_name_a"];;

        [cell.buttonTick setImage:nil forState:UIControlStateNormal];
        cell.viewTick.layer.cornerRadius = 3;
        cell.viewTick.layer.masksToBounds = YES;
        cell.viewTick.layer.borderWidth = 2.0;
        cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
        cell.viewTick.backgroundColor = [UIColor clearColor];
        
        if([dictVal[@"is_checked"] boolValue] == YES) {
//        if(cell.selected == YES) {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.buttonTick setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
        }
        else {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
            cell.viewTick.layer.borderWidth = 1.0;
            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
        }
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if(indexPath.row % 2 == 0)
//        cell.backgroundColor = [UIColor whiteColor];
//    else
//        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    return cell;

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.arrayLocal objectAtIndex:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.isSearchClicked) return 0;
    else return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
    sectionHeader.backgroundColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.f];
    sectionHeader.textAlignment = NSTextAlignmentLeft;
    sectionHeader.font = [UIFont boldSystemFontOfSize:15];
    sectionHeader.textColor = [UIColor whiteColor];
    if(!self.isSearchClicked)
        sectionHeader.text = [self.arrayTitles objectAtIndex:section];

    return sectionHeader;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.isSearchClicked) {
//        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];
//        
//        if([[dictVal valueForKey:@"IsChecked"]boolValue]) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            [dictVal setValue:@"NO" forKey:@"IsChecked"];
//            cell.selected=FALSE;
//            
//            [self.arrayFilter removeObject:dictVal];
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            [dictVal setValue:@"YES" forKey:@"IsChecked"];
//            cell.selected=TRUE;
//            
//            [self.arrayFilter addObject:dictVal];
//        }
//    }
//    else {
//        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
//        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
//        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
//        
//        if([[dictVal valueForKey:@"IsChecked"]boolValue]) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            [dictVal setValue:@"NO" forKey:@"IsChecked"];
//            cell.selected=FALSE;
//            
//            [self.arrayFilter removeObject:dictVal];
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            [dictVal setValue:@"YES" forKey:@"IsChecked"];
//            cell.selected=TRUE;
//            
//            [self.arrayFilter addObject:dictVal];
//        }
//    }
//    [self.tableViewStocks reloadData];
    
//    if(self.isSearchClicked) {
//        SearchStocksCell* cell = (SearchStocksCell *)[tableView cellForRowAtIndexPath:indexPath];
//        NSMutableDictionary *dictVal = [self.arrayFilterList objectAtIndex:indexPath.row];
//        
//        if([[dictVal valueForKey:@"IsChecked"]boolValue]) {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
//            cell.viewTick.layer.borderWidth = 1.0;
//            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
//            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
//
//            [dictVal setValue:@"NO" forKey:@"IsChecked"];
//            cell.selected=FALSE;
//            
//            [self.arrayFilter removeObject:dictVal];
//        }
//        else {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
//            cell.viewTick.layer.borderWidth = 1.0;
//            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
//            [cell.buttonTick setImage:[UIImage imageNamed:@"tickmark.png"] forState:UIControlStateNormal];
//
//            [dictVal setValue:@"YES" forKey:@"IsChecked"];
//            cell.selected=TRUE;
//            
//            [self.arrayFilter addObject:dictVal];
//        }
//    }
//    else {
//        SearchStocksCell* cell = (SearchStocksCell *)[tableView cellForRowAtIndexPath:indexPath];
//        
//        NSString *sectionTitle = [self.arrayTitles objectAtIndex:indexPath.section];
//        NSMutableArray *sectionVals = [globalShare.dictValues objectForKey:sectionTitle];
//        NSMutableDictionary *dictVal = [sectionVals objectAtIndex:indexPath.row];
//        
//        if([[dictVal valueForKey:@"IsChecked"]boolValue]) {
//            [cell.viewTick setBackgroundColor:[UIColor clearColor]];
//            cell.viewTick.layer.borderWidth = 1.0;
//            cell.viewTick.layer.borderColor = [UIColor darkGrayColor].CGColor;
//            [cell.buttonTick setImage:nil forState:UIControlStateNormal];
//            
//            [dictVal setValue:@"NO" forKey:@"IsChecked"];
//            cell.selected=FALSE;
//            
//            [self.arrayFilter removeObject:dictVal];
//        }
//        else {
//            [cell.viewTick setBackgroundColor:[UIColor orangeColor]];
//            cell.viewTick.layer.borderWidth = 1.0;
//            cell.viewTick.layer.borderColor = [UIColor orangeColor].CGColor;
//            [cell.buttonTick setImage:[UIImage imageNamed:@"tickmark.png"] forState:UIControlStateNormal];
//            
//            [dictVal setValue:@"YES" forKey:@"IsChecked"];
//            cell.selected=TRUE;
//            
//            [self.arrayFilter addObject:dictVal];
//        }
//    }
//    [self.tableViewStocks reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    self.isSearchClicked = NO;
    [self.tableViewStocks reloadData];
    
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isSearchClicked = YES;
    
    [self.arrayList removeAllObjects];
    self.arrayTitles = [[globalShare.dictValues allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for(NSString *str in self.arrayTitles) {
        NSArray *sectionVals = [globalShare.dictValues objectForKey:str];
        [self.arrayList addObjectsFromArray:sectionVals];
    }
    self.arrayFilterList = [self.arrayList mutableCopy];
    [self.tableViewStocks reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    NSString *searchString = searchBar.text;
    
    [self updateFilteredContentForProductName:searchString];
    
    self.isSearchClicked = NO;
    [self.tableViewStocks reloadData];
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    [self.tableViewStocks reloadData];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName {
    if ((productName == nil) || [productName length] == 0) {
        [self.arrayList removeAllObjects];
        self.arrayTitles = [[globalShare.dictValues allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for(NSString *str in self.arrayTitles) {
            NSArray *sectionVals = [globalShare.dictValues objectForKey:str];
            [self.arrayList addObjectsFromArray:sectionVals];
        }
        self.arrayFilterList = [self.arrayList mutableCopy];
        return;
    }
    
    [self.arrayFilterList removeAllObjects];
    
//    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"self.Name contains[c] %@", productName];
//    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"self.Symbol contains[c] %@", productName];
//    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
    
    NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.security_name_e contains [c] %@ OR self.security_name_a contains [c] %@ OR self.ticker contains [c] %@", productName, productName, productName];
    NSArray *arrFiltered = [self.arrayList filteredArrayUsingPredicate:applePred];
    [self.arrayFilterList addObjectsFromArray:arrFiltered];
}
#pragma Favourites Functionality

-(void)favouritesAddorRemove:(NSString *)tickerParams
{
    @try {
        [self.indicatorView setHidden:NO];
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSString *strURL = [NSString stringWithFormat:@"%@SaveFavorites?Tickers=%@", REQUEST_URL, tickerParams];
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSLog(@"The favourites :%@",returnedDict);
                                                               if([returnedDict[@"status"] hasPrefix:@"error"]) {
                                                                   if([returnedDict[@"result"] hasPrefix:@"T5"])
                                                                       [GlobalShare showSessionExpiredAlertView:self :SESSION_EXPIRED];
                                                                   else if([returnedDict[@"result"] hasPrefix:@"T4"])
                                                                       [GlobalShare showBasicAlertView:self :INVALID_HEADER];
                                                                   else if([returnedDict[@"result"] hasPrefix:@"T3"] || [returnedDict[@"result"] hasPrefix:@"T2"])
                                                                       [GlobalShare showBasicAlertView:self :INVALID_TOKEN];
                                                                   else
                                                                       [GlobalShare showBasicAlertView:self :returnedDict[@"result"]];
                                                                   return;
                                                               }
                                                               if([[returnedDict valueForKey:@"status"] isEqualToString:@"authenticated"])
                                                               {
                                                                   [self.delegate callBackResults:self.arrayFilter];
                                                                   [self dismissViewControllerAnimated:YES completion:nil];


                                                                   //globalShare.favouritesArray= [returnedDict valueForKey:@"result"];
                                                          
                                                                   
                                                               }
                                                           }
                                                           else {
                                                               [GlobalShare showBasicAlertView:self :[error localizedDescription]];
                                                           }
                                                           
                                                       }];
        
        [dataTask resume];
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        
    }
    
}

@end
