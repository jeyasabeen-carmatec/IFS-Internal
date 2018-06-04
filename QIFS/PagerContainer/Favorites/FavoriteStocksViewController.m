//
//  FavoriteStocksViewController.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "FavoriteStocksViewController.h"
#import "FavoriteStocksCell.h"

#import "AlertsViewController.h"
#import "CashPositionViewController.h"
#import "OrderHistoryViewController.h"
#import "ContactUsViewController.h"
#import "SettingsViewController.h"
#import "CompanyStocksViewController.h"
#import "OptionsViewCell.h"

NSString *const kFavoriteStocksCellIdentifier = @"FavoriteStocksCell";
NSString *const kFavoriteOptionsViewCellIdentifier = @"OptionsViewCell";

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height

@interface FavoriteStocksViewController () <tabBarManageCashDelegate, NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayFavoriteStocks;

@property (nonatomic, strong) NSArray *arrayMenu;
@property (nonatomic, weak) IBOutlet UIView *viewOptionMenu;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOptionMenu;
@property (nonatomic, strong) UIButton *transparencyButton;

@property (nonatomic, weak) IBOutlet UIButton *buttonCall;
@property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
@property (nonatomic, weak) IBOutlet UIButton *buttonAlert;
@property (nonatomic, weak) IBOutlet UIButton *buttonOptionMenu;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

@property (nonatomic, weak) IBOutlet UITableView *tableResults;
@property (nonatomic, weak) IBOutlet UISearchBar *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *allResults;
@property (readwrite, copy) NSArray *visibleResults;
@property (nonatomic, strong) CashPositionViewController *cashContentView;

@property (nonatomic, strong) UIImageView *normalImageView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) NSString *securityList;

@property (weak, nonatomic) IBOutlet UILabel *labelDayHLCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelChangeCaption;

@end

@implementation FavoriteStocksViewController

@synthesize tableViewStocks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"My Favorites", @"My Favorites")];
    [self.searchResults setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    globalShare.sectorValues = [[NSMutableArray alloc] init];
//    self.arrayFavoriteStocks = [[NSMutableArray alloc] init];
    
    self.tableResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableResults setHidden:YES];
    
//    self.arrayMenu = [NSArray arrayWithObjects:@"Cash Position", @"My Orders History", @"Contact Us", @"Settings", @"Sign Out", nil];
    self.arrayMenu = @[
                         @{
                             @"menu_title": NSLocalizedString(@"Cash Position", @"Cash Position"),
                             @"menu_image": @"icon_cash_position"
                             },
                         @{
                             @"menu_title": NSLocalizedString(@"My Orders History", @"My Orders History"),
                             @"menu_image": @"icon_my_order_history"
                             },
                         @{
                             @"menu_title": NSLocalizedString(@"Contact Us", @"Contact Us"),
                             @"menu_image": @"icon_contact_us"
                             },
                         @{
                             @"menu_title": NSLocalizedString(@"Settings", @"Settings"),
                             @"menu_image": @"icon_settings"
                             },
                         @{
                             @"menu_title": NSLocalizedString(@"Sign Out", @"Sign Out"),
                             @"menu_image": @"icon_signout"
                             }
                         ];

//    [self.tableViewOptionMenu setSeparatorInset:UIEdgeInsetsZero];
//    [self.tableViewOptionMenu setLayoutMargins:UIEdgeInsetsZero];
    self.tableViewOptionMenu.scrollEnabled = NO;

//    self.arrayFavoriteStocks = @[
//                         @{
//                             @"SectorVal": @"Telecom",
//                             @"Symbol": @"CMCSA",
//                             @"Name": @"Comcast Corp",
//                             @"Price": @"59.47",
//                             @"Change": @"-0.72",
//                             @"Volume": @"1.2M",
//                             @"IsChecked": @"0",
//                             @"Sector": @"0"
//                             },
//                         @{
//                             @"SectorVal": @"Telecom",
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Price": @"566.24",
//                             @"Change": @"+2.57",
//                             @"Volume": @"1.2M",
//                             @"IsChecked": @"0",
//                             @"Sector": @"0"
//                             },
//                         @{
//                             @"SectorVal": @"Financial Services",
//                             @"Symbol": @"AAPL",
//                             @"Name": @"Apple",
//                             @"Price": @"93.59",
//                             @"Change": @"+1.15",
//                             @"Volume": @"1.2M",
//                             @"IsChecked": @"0",
//                             @"Sector": @"1"
//                             },
//                         @{
//                             @"SectorVal": @"Industries",
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Price": @"93.59",
//                             @"Change": @"+1.15",
//                             @"Volume": @"1.2M",
//                             @"IsChecked": @"0",
//                             @"Sector": @"2"
//                             }
//                         ];
    
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
//    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
//    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
//    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
//
//    [dict1 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict1 setValue:@"CMCSA" forKey:@"Symbol"];
//    [dict1 setValue:@"Comcast Corp" forKey:@"Name"];
//    [dict1 setValue:@"59.47" forKey:@"Price"];
//    [dict1 setValue:@"-0.72" forKey:@"Change"];
//    [dict1 setValue:@"1.2M" forKey:@"Volume"];
//    [dict1 setValue:@"NO" forKey:@"IsChecked"];
//    [dict1 setValue:@"0" forKey:@"Sector"];
//    [arr1 addObject:dict1];
//    
//    [dict2 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict2 setValue:@"GOOGL" forKey:@"Symbol"];
//    [dict2 setValue:@"Google Class A" forKey:@"Name"];
//    [dict2 setValue:@"566.24" forKey:@"Price"];
//    [dict2 setValue:@"+2.57" forKey:@"Change"];
//    [dict2 setValue:@"1.2M" forKey:@"Volume"];
//    [dict2 setValue:@"NO" forKey:@"IsChecked"];
//    [dict2 setValue:@"0" forKey:@"Sector"];
//    [arr1 addObject:dict2];
//    
//    [dict3 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict3 setValue:@"AAPL" forKey:@"Symbol"];
//    [dict3 setValue:@"Apple" forKey:@"Name"];
//    [dict3 setValue:@"93.59" forKey:@"Price"];
//    [dict3 setValue:@"+1.15" forKey:@"Change"];
//    [dict3 setValue:@"1.2M" forKey:@"Volume"];
//    [dict3 setValue:@"NO" forKey:@"IsChecked"];
//    [dict3 setValue:@"0" forKey:@"Sector"];
//    [arr2 addObject:dict3];
//    
//    [dict4 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict4 setValue:@"FB" forKey:@"Symbol"];
//    [dict4 setValue:@"Facebook" forKey:@"Name"];
//    [dict4 setValue:@"93.59" forKey:@"Price"];
//    [dict4 setValue:@"+0.72" forKey:@"Change"];
//    [dict4 setValue:@"1.2M" forKey:@"Volume"];
//    [dict4 setValue:@"NO" forKey:@"IsChecked"];
//    [dict4 setValue:@"0" forKey:@"Sector"];
//    [arr3 addObject:dict4];
//    
//    globalShare.dictValues = [[NSMutableDictionary alloc]init];
//    [globalShare.dictValues setValue:arr1 forKey:@"Telecom"];
//    [globalShare.dictValues setValue:arr2 forKey:@"Financial Services"];
//    [globalShare.dictValues setValue:arr3 forKey:@"Industries"];

//    NSDictionary *dic = @{@"Telecom" : @[@{
//                                       @"SectorVal": @"Telecom",
//                                       @"Symbol": @"CMCSA",
//                                       @"Name": @"Comcast Corp",
//                                       @"Price": @"59.47",
//                                       @"Change": @"-0.72",
//                                       @"Volume": @"1.2M",
//                                       @"IsChecked": @"NO",
//                                       @"Sector": @"0"
//                                       },
//                                   @{
//                                       @"SectorVal": @"Telecom",
//                                       @"Symbol": @"GOOGL",
//                                       @"Name": @"Google Class A",
//                                       @"Price": @"566.24",
//                                       @"Change": @"+2.57",
//                                       @"Volume": @"1.2M",
//                                       @"IsChecked": @"NO",
//                                       @"Sector": @"0"
//                                       }],
//                          @"Financial Services" : @[@{
//                                       @"SectorVal": @"Financial Services",
//                                       @"Symbol": @"AAPL",
//                                       @"Name": @"Apple",
//                                       @"Price": @"93.59",
//                                       @"Change": @"+1.15",
//                                       @"Volume": @"1.2M",
//                                       @"IsChecked": @"NO",
//                                       @"Sector": @"1"
//                                       }],
//                          @"Industries" : @[@{
//                                       @"SectorVal": @"Industries",
//                                       @"Symbol": @"FB",
//                                       @"Name": @"Facebook",
//                                       @"Price": @"93.59",
//                                       @"Change": @"+1.15",
//                                       @"Volume": @"1.2M",
//                                       @"IsChecked": @"NO",
//                                       @"Sector": @"2"
//                                       }
//                                   ]};
//    globalShare.dictValues = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    
    
//    NSMutableArray *arrayFilter = [[NSMutableArray alloc] init];
    
//    self.arrayFavoriteStocks = [[globalShare.dictValues allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//
//    animalSectionTitles = [[animals allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    [globalShare.sectorValues addObjectsFromArray:arrVal];

//    NSMutableArray *arrayFilter = [[NSMutableArray alloc] init];
////    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//
//    NSArray *techCount = [globalShare.sectorValues valueForKeyPath:@"@distinctUnionOfObjects.Sector"];
//    for(int i=0;i<[techCount count];i++) {
//        NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.Sector matches %@", techCount[i]];
//        NSArray *arrFiltered = [globalShare.sectorValues filteredArrayUsingPredicate:applePred];
//        [arrayFilter addObjectsFromArray:arrFiltered];
//        
//        
//    }

    [self setupFloatingButton];
}

-(void)setupFloatingButton {
    CGRect floatFrame;
    if(globalShare.myLanguage == ARABIC_LANGUAGE)
        floatFrame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 44 - 20 - 49, 44, 44);
    else
        floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 20 - 49, 44, 44);

    _buttonView = [[UIView alloc]initWithFrame:floatFrame];
    _buttonView.backgroundColor = [UIColor clearColor];
    _buttonView.userInteractionEnabled = YES;
    
    _normalImageView = [[UIImageView alloc]initWithFrame:_buttonView.bounds];
    _normalImageView.userInteractionEnabled = YES;
    _normalImageView.contentMode = UIViewContentModeScaleAspectFit;
    _normalImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _normalImageView.layer.shadowRadius = 5.f;
    _normalImageView.layer.shadowOffset = CGSizeMake(-10, -10);
    _normalImageView.image = [UIImage imageNamed:@"icon_favorite_add"];

    UITapGestureRecognizer *buttonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [_buttonView addGestureRecognizer:buttonTap];

    [_buttonView addSubview:_normalImageView];
    [self.view addSubview:_buttonView];
}

-(void)handleTap:(id)sender //Show Menu
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.normalImageView.transform = CGAffineTransformMakeRotation(0.75);
     }
         completion:^(BOOL finished)
     {
         SearchStocksViewController *searchStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchStocksViewController"];
         searchStocksViewController.delegate = self;
         [self.navigationController presentViewController:searchStocksViewController animated:YES completion:nil];
     }];
}

-(void) dismissMenu

{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.normalImageView.transform = CGAffineTransformMakeRotation(0);
     } completion:^(BOOL finished)
     {
     }];
}

-(void)viewWillAppear:(BOOL)animated {
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
//    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
//    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
//    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
//    
//    [dict1 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict1 setValue:@"CMCSA" forKey:@"Symbol"];
//    [dict1 setValue:@"Comcast Corp" forKey:@"Name"];
//    [dict1 setValue:@"59.47" forKey:@"Price"];
//    [dict1 setValue:@"60.34" forKey:@"DayHigh"];
//    [dict1 setValue:@"58.47" forKey:@"DayLow"];
//    [dict1 setValue:@"-0.72" forKey:@"Change"];
//    [dict1 setValue:@"-0.72%" forKey:@"PercentageChange"];
//    [dict1 setValue:@"237,891,346" forKey:@"Volume"];
//    [dict1 setValue:@"NO" forKey:@"IsChecked"];
//    [dict1 setValue:@"0" forKey:@"Sector"];
//    [arr1 addObject:dict1];
//    
//    [dict2 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict2 setValue:@"GOOGL" forKey:@"Symbol"];
//    [dict2 setValue:@"Google Class A" forKey:@"Name"];
//    [dict2 setValue:@"566.24" forKey:@"Price"];
//    [dict2 setValue:@"570.34" forKey:@"DayHigh"];
//    [dict2 setValue:@"562.47" forKey:@"DayLow"];
//    [dict2 setValue:@"+2.57" forKey:@"Change"];
//    [dict2 setValue:@"+2.57%" forKey:@"PercentageChange"];
//    [dict2 setValue:@"647,891,346" forKey:@"Volume"];
//    [dict2 setValue:@"NO" forKey:@"IsChecked"];
//    [dict2 setValue:@"0" forKey:@"Sector"];
//    [arr1 addObject:dict2];
//    
//    [dict3 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict3 setValue:@"AAPL" forKey:@"Symbol"];
//    [dict3 setValue:@"Apple" forKey:@"Name"];
//    [dict3 setValue:@"93.59" forKey:@"Price"];
//    [dict3 setValue:@"94.34" forKey:@"DayHigh"];
//    [dict3 setValue:@"92.47" forKey:@"DayLow"];
//    [dict3 setValue:@"+1.15" forKey:@"Change"];
//    [dict3 setValue:@"+1.15%" forKey:@"PercentageChange"];
//    [dict3 setValue:@"787,891,346" forKey:@"Volume"];
//    [dict3 setValue:@"NO" forKey:@"IsChecked"];
//    [dict3 setValue:@"0" forKey:@"Sector"];
//    [arr2 addObject:dict3];
//    
//    [dict4 setValue:@"Telecom" forKey:@"SectorVal"];
//    [dict4 setValue:@"FB" forKey:@"Symbol"];
//    [dict4 setValue:@"Facebook" forKey:@"Name"];
//    [dict4 setValue:@"93.59" forKey:@"Price"];
//    [dict4 setValue:@"95.34" forKey:@"DayHigh"];
//    [dict4 setValue:@"92.47" forKey:@"DayLow"];
//    [dict4 setValue:@"+0.72" forKey:@"Change"];
//    [dict4 setValue:@"+0.72%" forKey:@"PercentageChange"];
//    [dict4 setValue:@"289,891,346" forKey:@"Volume"];
//    [dict4 setValue:@"NO" forKey:@"IsChecked"];
//    [dict4 setValue:@"0" forKey:@"Sector"];
//    [arr3 addObject:dict4];
//    
//    globalShare.dictValues = [[NSMutableDictionary alloc]init];
//    [globalShare.dictValues setValue:arr1 forKey:@"Telecom"];
//    [globalShare.dictValues setValue:arr2 forKey:@"Financial Services"];
//    [globalShare.dictValues setValue:arr3 forKey:@"Industries"];
    
//    globalShare.dictValues = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mySectors"] mutableCopy];
//    NSDictionary *dicts = [[NSUserDefaults standardUserDefaults] objectForKey:@"mySectors"];
//    globalShare.dictValues = [[NSMutableDictionary alloc]initWithDictionary:dicts];
    
//    NSMutableArray *arrayParams = [[NSMutableArray alloc] init];
//    NSString *strQuery = [NSString stringWithFormat:@"select ticker from tbl_SecurityList where is_checked = '%@'", @"YES"];
//    globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:strQuery];
//    while ([globalShare.fmRSObject next]) {
//        [arrayParams addObject:[globalShare.fmRSObject stringForColumn:@"ticker"]];
//    }
//    [globalShare.fmRSObject close];
//
//    if(arrayParams.count > 0) {
//        NSString *strTickerParams;
//        if(arrayParams.count > 0)
//            strTickerParams = [NSString stringWithFormat:@"%@", arrayParams[0]];
//        for (int i=1; i<arrayParams.count; i++) {
//            strTickerParams = [NSString stringWithFormat:@"%@,%@", strTickerParams, arrayParams[i]];
//        }
//        self.securityList = strTickerParams;
//        [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];
//    }
//
    //    [tableViewStocks reloadData];
    
    [super viewWillAppear:YES];

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelDayHLCaption setTextAlignment:NSTextAlignmentLeft];
        [self.labelChangeCaption setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelDayHLCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelChangeCaption setTextAlignment:NSTextAlignmentRight];
    }
    
    if(![[GlobalShare sharedInstance] isTimerFavoritesRun])
        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];

    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }

    [self getSecurityList];
    
    globalShare.dictValues = [DataManager select_SecurityListAsSectors];
    self.allResults = [DataManager select_SecurityList];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:NO];
    if ([globalShare.timerFavorites isValid]) {
        [globalShare.timerFavorites invalidate];
        globalShare.timerFavorites = nil;
    }
    
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionPhoneCall:(id)sender {
//    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"44498818"];
//    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSearch:(id)sender {
//    self.tabBarController.tabBar.hidden = YES;
//    [self.tableResults setHidden:NO];
//    [self.labelTitle setText:@""];
//    if(![self.viewOptionMenu isHidden])
//        [self.viewOptionMenu setHidden:YES];
//    [self.view bringSubviewToFront:self.tableResults];
//    [self.view sendSubviewToBack:self.labelTitle];
//    [self.view sendSubviewToBack:self.buttonCall];
//    [self.view sendSubviewToBack:self.buttonSearch];
//    [self.view sendSubviewToBack:self.buttonAlert];
//    [self.view sendSubviewToBack:self.buttonOptionMenu];
//    
//    // Create the search controller and make it perform the results updating.
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.delegate = self;
//    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    
//    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.searchController.searchBar.placeholder = NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name");
//    self.definesPresentationContext = YES;
//    
//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"icon_greysearch"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    NSDictionary *placeholderAttributes = @{
//                                            NSForegroundColorAttributeName: [UIColor darkGrayColor],
//                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],
//                                            };
//    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchController.searchBar.placeholder attributes:placeholderAttributes];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:placeholderAttributes];
//    self.searchController.searchBar.tintColor = [UIColor darkGrayColor];
//
//    [self presentViewController:self.searchController animated:YES completion:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.searchResults becomeFirstResponder];
    [self.tableResults setHidden:NO];
    [self.searchResults setHidden:NO];
    [self.labelTitle setText:@""];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.view bringSubviewToFront:self.searchResults];
    [self.view bringSubviewToFront:self.tableResults];
    [self.view sendSubviewToBack:self.labelTitle];
    [self.view sendSubviewToBack:self.buttonCall];
    [self.view sendSubviewToBack:self.buttonSearch];
    [self.view sendSubviewToBack:self.buttonAlert];
    [self.view sendSubviewToBack:self.buttonOptionMenu];
}

- (IBAction)actionAlertsView:(id)sender {
    AlertsViewController *alertsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
    [[self navigationController] pushViewController:alertsViewController animated:YES];
}

- (IBAction)actionOptionMenu:(id)sender {
    if ([self.viewOptionMenu isHidden]) {
        [self.viewOptionMenu setHidden:NO];
        [self.view bringSubviewToFront:self.viewOptionMenu];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.viewOptionMenu.layer addAnimation:animation forKey:@""];
        
        self.viewOptionMenu.layer.borderWidth = 1.0;
        self.viewOptionMenu.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
        
        _transparencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transparencyButton.frame = self.view.bounds;
        //        self.transparencyButton.backgroundColor = [UIColor lightGrayColor];
        [_transparencyButton addTarget:self action:@selector(backgroundTappedMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:self.transparencyButton belowSubview:self.viewOptionMenu];
    }
    else {
        [self.viewOptionMenu setHidden:YES];
        [self.view sendSubviewToBack:self.viewOptionMenu];
        [_transparencyButton setAlpha:1.0];
        [self.transparencyButton removeFromSuperview];
        self.transparencyButton = nil;
    }
}

- (void)backgroundTappedMenu:(id)sender {
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
}

#pragma mark - Common actions

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:YES];
    globalShare.timerFavorites = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getSecurityList) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerFavorites forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void)getSecurityList {
    NSMutableArray *arrayParams = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"select ticker from tbl_SecurityList where is_checked = '%@'", @"YES"];
    globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:strQuery];
    while ([globalShare.fmRSObject next]) {
        [arrayParams addObject:[globalShare.fmRSObject stringForColumn:@"ticker"]];
    }
    [globalShare.fmRSObject close];
    
    if(arrayParams.count > 0) {
        NSString *strTickerParams;
        if(arrayParams.count > 0)
            strTickerParams = [NSString stringWithFormat:@"%@", arrayParams[0]];
        for (int i=1; i<arrayParams.count; i++) {
            strTickerParams = [NSString stringWithFormat:@"%@,%@", strTickerParams, arrayParams[i]];
        }
        self.securityList = strTickerParams;
        [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrayFavoriteStocks = nil;
            [self.tableViewStocks reloadData];
        });
    }
}

-(void) getMarketWatch {
    @try {
        if([self.securityList length] == 0) return;
        
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetMarketWatch?tickers=", self.securityList];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       self.arrayFavoriteStocks = returnedDict[@"result"];
                                                                       [self.tableViewStocks reloadData];
                                                                   });
                                                               }
                                                           }
                                                           else {
                                                               if(![[GlobalShare sharedInstance] isErrorPupup]) {
                                                                   [[GlobalShare sharedInstance] setIsErrorPupup:YES];
                                                                   [GlobalShare showBasicAlertView:self :[error localizedDescription]];
                                                               }
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

- (void)callBackResults:(NSMutableArray*)array {
    [self dismissMenu];
    
//    if(array.count > 0) {
//        NSString *strTickerParams;
//        if(array.count > 0)
//            strTickerParams = [NSString stringWithFormat:@"%@", array[0][@"ticker"]];
//        for (int i=1; i<array.count; i++) {
//            NSMutableDictionary *dictVal = array[i];
//            strTickerParams = [NSString stringWithFormat:@"%@,%@", strTickerParams, dictVal[@"ticker"]];
//        }
//        self.securityList = strTickerParams;
//        [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];
//    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!searchController.active) {
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.labelTitle setText:NSLocalizedString(@"My Favorites", @"My Favorites")];
        [self.view sendSubviewToBack:self.tableResults];
        [self.view bringSubviewToFront:self.labelTitle];
        [self.view bringSubviewToFront:self.buttonCall];
        [self.view bringSubviewToFront:self.buttonSearch];
        [self.view bringSubviewToFront:self.buttonAlert];
        [self.view bringSubviewToFront:self.buttonOptionMenu];
        return;
    }
    
    NSString *filterString = searchController.searchBar.text;
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.security_name_e contains [c] %@ OR self.security_name_a contains [c] %@ OR self.ticker contains [c] %@", filterString, filterString, filterString];
    self.visibleResults = [self.allResults filteredArrayUsingPredicate:filterPredicate];
    
    [self.tableResults reloadData];
}

- (void)callBackSuperviewFromCash {
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.tableViewOptionMenu])
        return [self.arrayMenu count];
    else if([tableView isEqual:self.tableResults])
        return [self.visibleResults count];
        else
    return [self.arrayFavoriteStocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableViewOptionMenu]) {
//        static NSString *CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        
////        cell.textLabel.text = self.arrayMenu[indexPath.row];
//        cell.textLabel.text = self.arrayMenu[indexPath.row][@"menu_title"];
//        cell.imageView.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        
        OptionsViewCell *cell = (OptionsViewCell *) [tableView dequeueReusableCellWithIdentifier:kFavoriteOptionsViewCellIdentifier forIndexPath:indexPath];
        
        cell.labelOption.text = self.arrayMenu[indexPath.row][@"menu_title"];
        cell.imageOption.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if([tableView isEqual:self.tableResults]) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = self.visibleResults[indexPath.row][@"ticker"];
        cell.detailTextLabel.text = self.visibleResults[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        FavoriteStocksCell *cell = (FavoriteStocksCell *) [tableView dequeueReusableCellWithIdentifier:kFavoriteStocksCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayFavoriteStocks[indexPath.row];

        cell.labelSymbol.text = def[@"ticker"];
        cell.labelCompanyName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
        cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"comp_current_price"]];
        cell.labelChange.text = [GlobalShare formatStringToTwoDigits:def[@"change"]];
        cell.labelPercentageChange.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
        cell.labelDayHigh.text = [GlobalShare formatStringToTwoDigits:def[@"high"]];
        cell.labelDayLow.text = [GlobalShare formatStringToTwoDigits:def[@"low"]];

//        if([def[@"change"] hasPrefix:@"-"] || [def[@"change"] hasPrefix:@"+"]) {
//            if([def[@"change"] hasPrefix:@"+"]) {
//                cell.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//            }
//            else {
//                cell.labelChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                cell.labelPercentageChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//            }
//        }
//        else {
//            cell.labelChange.textColor = [UIColor darkGrayColor];
//            cell.labelPercentageChange.textColor = [UIColor darkGrayColor];
//        }

        if([def[@"change"] hasPrefix:@"-"]) {
            cell.labelChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
            cell.labelPercentageChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
        }
        else if([def[@"change"] hasPrefix:@"+"]) {
            cell.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
            cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            if([GlobalShare returnIfGreaterThanZero:[def[@"change"] doubleValue]]) {
                cell.labelChange.text = [NSString stringWithFormat:@"+%@", [GlobalShare formatStringToTwoDigits:def[@"change"]]];
                cell.labelPercentageChange.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
                cell.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
            }
            else {
                cell.labelChange.textColor = [UIColor darkGrayColor];
                cell.labelPercentageChange.textColor = [UIColor darkGrayColor];
            }
        }
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelPrice setTextAlignment:NSTextAlignmentLeft];
            [cell.labelDayHigh setTextAlignment:NSTextAlignmentLeft];
            [cell.labelDayLow setTextAlignment:NSTextAlignmentLeft];
            [cell.labelChange setTextAlignment:NSTextAlignmentLeft];
            [cell.labelPercentageChange setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelPrice setTextAlignment:NSTextAlignmentRight];
            [cell.labelDayHigh setTextAlignment:NSTextAlignmentRight];
            [cell.labelDayLow setTextAlignment:NSTextAlignmentRight];
            [cell.labelChange setTextAlignment:NSTextAlignmentRight];
            [cell.labelPercentageChange setTextAlignment:NSTextAlignmentRight];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;

        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];

        cell.delegate = self;
        
        //#if !TEST_USE_MG_DELEGATE
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            cell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
            cell.leftSwipeSettings.onlySwipeButtons = NO;
            cell.leftButtons = [self createLeftButtons:2];
        }
        else {
            cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
            cell.rightSwipeSettings.onlySwipeButtons = NO;
            cell.rightButtons = [self createRightButtons:2];
        }
        //#endif

        return cell;
    }
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
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
    
    if([tableView isEqual:self.tableViewOptionMenu]) {
        if(indexPath.row == 0) {
            self.cashContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"CashPositionViewController"];
            self.cashContentView.view.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            self.cashContentView.delegate = self;
            
            [self.view addSubview:self.cashContentView.view];
            [UIView animateWithDuration:.3 animations:^{
                [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
                [self.cashContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            } completion:^(BOOL finished) {
                self.tabBarController.tabBar.hidden = YES;
            }];
        }
        else if(indexPath.row == 1) {
            OrderHistoryViewController *orderHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
            [[self navigationController] pushViewController:orderHistoryViewController animated:YES];
        }
        else if(indexPath.row == 2) {
            ContactUsViewController *contactUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [[self navigationController] pushViewController:contactUsViewController animated:YES];
        }
        else if(indexPath.row == 3) {
            SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            [[self navigationController] pushViewController:settingsViewController animated:YES];
        }
        else {
//            [[self navigationController] popToRootViewControllerAnimated:YES];
            [GlobalShare showSignOutAlertView:self :SIGNOUT_CONFIRMATION];
        }
    }
    else if([tableView isEqual:self.tableResults]) {
        [self.searchResults resignFirstResponder];
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.searchResults setHidden:YES];
        [self.view sendSubviewToBack:self.searchResults];
        [self.view sendSubviewToBack:self.tableResults];
        [self.view bringSubviewToFront:self.labelTitle];
        [self.view bringSubviewToFront:self.buttonCall];
        [self.view bringSubviewToFront:self.buttonSearch];
        [self.view bringSubviewToFront:self.buttonAlert];
        [self.view bringSubviewToFront:self.buttonOptionMenu];
        
        [self.labelTitle setText:NSLocalizedString(@"My Favorites", @"My Favorites")];
        
        CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
        companyStocksViewController.securityId = self.visibleResults[indexPath.row][@"ticker"];
        companyStocksViewController.securityName = self.visibleResults[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
        [[self navigationController] pushViewController:companyStocksViewController animated:YES];
//        [self.searchController setActive:NO];
        
        self.searchResults.text = @"";
        NSString *searchString = self.searchResults.text;
        [self updateFilteredContentForProductName:searchString];
    }
    else {
        
    }
}

#pragma mark - MGSwipeTableCellDelegate

//#if TEST_USE_MG_DELEGATE
//-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
//             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
//{
//    if (direction == MGSwipeDirectionLeftToRight) {
//        return nil;
//    }
//    else {
//        return [self createRightButtons:2];
//    }
//}
//#endif

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if(index == 0) {
        NSString *strUpdateParams = [NSString stringWithFormat:@"update tbl_SecurityList set is_checked = '%@' where ticker = '%@'", @"NO", self.arrayFavoriteStocks[cell.tag][@"ticker"]];
        [globalShare.fmDBObject executeUpdate:strUpdateParams];

        [self getSecurityList];
    }
    else {
        CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
        companyStocksViewController.securityId = self.arrayFavoriteStocks[cell.tag][@"ticker"];
        companyStocksViewController.securityName = self.arrayFavoriteStocks[cell.tag][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
        [[self navigationController] pushViewController:companyStocksViewController animated:YES];
    }

    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {NSLocalizedString(@"Remove", @"Remove"), NSLocalizedString(@"Details", @"Details")};
    
    UIColor * colors[2] = {[UIColor colorWithRed:220/255.f green:0/255.f blue:2/255.f alpha:1.f], [UIColor colorWithRed:18/255.f green:180/255.f blue:2/255.f alpha:1.f]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
}

-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {NSLocalizedString(@"Remove", @"Remove"), NSLocalizedString(@"Details", @"Details")};
    
    UIColor * colors[2] = {[UIColor colorWithRed:220/255.f green:0/255.f blue:2/255.f alpha:1.f], [UIColor colorWithRed:18/255.f green:180/255.f blue:2/255.f alpha:1.f]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    [self updateFilteredContentForProductName:searchString];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    NSString *searchString = searchBar.text;
    
    [self updateFilteredContentForProductName:searchString];
    
    [searchBar resignFirstResponder];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.tableResults setHidden:YES];
    [self.searchResults setHidden:YES];
    [self.view sendSubviewToBack:self.searchResults];
    [self.view sendSubviewToBack:self.tableResults];
    [self.view bringSubviewToFront:self.labelTitle];
    [self.view bringSubviewToFront:self.buttonCall];
    [self.view bringSubviewToFront:self.buttonSearch];
    [self.view bringSubviewToFront:self.buttonAlert];
    [self.view bringSubviewToFront:self.buttonOptionMenu];
    
    [self.labelTitle setText:NSLocalizedString(@"My Favorites", @"My Favorites")];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)filterString {
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.security_name_e contains [c] %@ OR self.ticker contains [c] %@", filterString, filterString];
    self.visibleResults = [self.allResults filteredArrayUsingPredicate:filterPredicate];
    
    [self.tableResults reloadData];
}

@end
