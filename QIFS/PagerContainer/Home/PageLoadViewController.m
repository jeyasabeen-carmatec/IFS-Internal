//
//  PageLoadViewController.m
//  QIFS
//
//  Created by zylog on 02/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "PageLoadViewController.h"

@interface PageLoadViewController ()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIButton *buttonCall;
@property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
@property (nonatomic, weak) IBOutlet UIView *viewGraph;
@property (nonatomic, assign) UIDeviceOrientation orientation;

@end

@implementation PageLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.products = [NSArray arrayWithObjects:@"Google", @"Facebook", @"Apple", @"Samsung", @"Twitter", @"Yahoo", nil];
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.products count]];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];
    _orientation = [[UIDevice currentDevice] orientation];
    if (_orientation == UIDeviceOrientationUnknown || _orientation == UIDeviceOrientationFaceUp || _orientation == UIDeviceOrientationFaceDown) {
        _orientation = UIDeviceOrientationPortrait;
    }
}

-(void)didRotate:(NSNotification *)notification {
    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];
    if (newOrientation != UIDeviceOrientationUnknown && newOrientation != UIDeviceOrientationFaceUp && newOrientation != UIDeviceOrientationFaceDown) {
        _orientation = newOrientation;
    }
    
    // Do your orientation logic here
    if ((_orientation == UIDeviceOrientationLandscapeLeft || _orientation == UIDeviceOrientationLandscapeRight)) {
        // Clear the current view and insert the orientation specific view.
        [_viewGraph setHidden:NO];
            self.tabBarController.tabBar.hidden = YES;
    } else if (_orientation == UIDeviceOrientationPortrait || _orientation == UIDeviceOrientationPortraitUpsideDown) {
        // Clear the current view and insert the orientation specific view.
//        if (_viewGraph.superview) {
//            [_viewGraph removeFromSuperview];
//        }
        [_viewGraph setHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - Button actions

- (IBAction)actionPhoneCall:(id)sender {
    //    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"44498818"];
    //    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSearch:(id)sender {
    [self.buttonCall setHidden:YES];
    [self.buttonSearch setHidden:YES];
    [self.tableView setHidden:NO];
    [self.searchBar setHidden:NO];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchBar.text length] > 0) {
        return [self.searchResults count];
    } else {
        return [self.products count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.searchBar.text length] > 0) {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.products objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    
    NSString *scope = nil;
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    [self.tableView reloadData];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.products count]];
    
    NSString *scope = nil;
    searchBar.text = @"";
    NSString *searchString = searchBar.text;
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    [self.tableView reloadData];
    
    [searchBar resignFirstResponder];
    [self.buttonCall setHidden:NO];
    [self.buttonSearch setHidden:NO];
    [self.tableView setHidden:YES];
    [self.searchBar setHidden:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchString = [searchBar text];
    
    NSString *scope = nil;
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    [self.tableView reloadData];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((productName == nil) || [productName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [self.products mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (NSString *product in self.products) {
                if ([product isEqualToString:typeName]) {
                    [searchResults addObject:product];
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (NSString *product in self.products) {
        if ((typeName == nil) || [product isEqualToString:typeName]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, product.length);
            NSRange foundRange = [product rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:product];
            }
        }
    }
}

@end
