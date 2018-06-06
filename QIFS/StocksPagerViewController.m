//
//  StocksPagerViewController.m
//  QIFS
//
//  Created by zylog on 15/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "StocksPagerViewController.h"
#import "CAPSPageMenu.h"
#import "StocksOverviewViewController.h"
#import "StockListViewController.h"
#import "SectorsGraphViewController.h"
#import "GainLossViewController.h"
#import "ActiveStocksViewController.h"
#import "SearchResultsTableViewController.h"
//#import "QIFS-Swift.h"
#import "QEGraphViewController.h"
#import "AlertsViewController.h"
#import "CashPositionViewController.h"
#import "OrderHistoryViewController.h"
#import "ContactUsViewController.h"
#import "BondStocksViewController.h"
#import "SettingsViewController.h"
#import "CompanyStocksViewController.h"
#import "OptionsViewCell.h"

NSString *const kStocksOptionsViewCellIdentifier = @"OptionsViewCell";

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface StocksPagerViewController () <  tabBarManageCashDelegate, NSURLSessionDelegate, CAPSPageMenuDelegate> //ChartViewDelegate chartTapDelegate

@property (nonatomic) CAPSPageMenu *pageMenu;

@property (nonatomic, weak) IBOutlet UITableView *tableResults;
@property (nonatomic, weak) IBOutlet UISearchBar *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) NSString *filterString;
//@property (copy) NSArray *allResults;
@property (nonatomic, strong) NSMutableArray *allResults;
@property (readwrite, copy) NSArray *visibleResults;

@property (nonatomic, strong) QEGraphViewController *graphContentView;
@property (nonatomic, strong) CashPositionViewController *cashContentView;

@property (nonatomic, weak) IBOutlet UIButton *buttonCall;
@property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
@property (nonatomic, weak) IBOutlet UIButton *buttonAlert;
@property (nonatomic, weak) IBOutlet UIButton *buttonOptionMenu;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

@property (nonatomic, strong) NSArray *arrayMenu;
@property (nonatomic, weak) IBOutlet UIView *viewOptionMenu;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOptionMenu;
@property (nonatomic, strong) UIButton *transparencyButton;
@property (nonatomic, assign) UIDeviceOrientation orientation;

@property (nonatomic, weak) IBOutlet UIView *viewGraphQE;
@property (nonatomic, weak) IBOutlet UIView *lineChartViewQE;  //LineChartView
//@property (nonatomic, strong) CircleMarker *circleMarker;
@property (nonatomic, strong) StockListViewController *stockListView;

@property (nonatomic, weak) IBOutlet UIButton *buttonPlus;
@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelClose;
@property (nonatomic, weak) IBOutlet UILabel *labelDate;
@property (nonatomic, weak) IBOutlet UILabel *labelLast;

@property (nonatomic, strong) NSMutableArray *arrayCompany;
@property (nonatomic, strong) NSMutableArray *arrayFilterCompany;

@end

@implementation StocksPagerViewController

@synthesize stockListView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"QE Market", @"QE Market")];
    [self.searchResults setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    self.tableResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    NSString *loginStatus;
    if ([GlobalShare isUserLogedIn]) {
        
        loginStatus = NSLocalizedString(@"Sign In", @"Sign In");
        
    }
    else{
        loginStatus = NSLocalizedString(@"Sign Out", @"Sign Out");
    }
    
    self.arrayMenu = @[
                       @{
                           @"menu_title": NSLocalizedString(@"Cash Position", @"Cash Position"),
                           @"menu_image": @"icon_cash_position"
                           },
                       //                       @{
                       //                           @"menu_title": NSLocalizedString(@"My Orders History", @"My Orders History"),
                       //                           @"menu_image": @"icon_my_order_history"
                       //                           },
                       @{
                           @"menu_title": NSLocalizedString(@"Contact Us", @"Contact Us"),
                           @"menu_image": @"icon_contact_us"
                           },
                       @{
                           @"menu_title": NSLocalizedString(@"Settings", @"Settings"),
                           @"menu_image": @"icon_settings"
                           },
                       @{
                           @"menu_title": loginStatus,
                           @"menu_image": @"icon_signout"
                           }
                       ];

//    [self.tableViewOptionMenu setSeparatorInset:UIEdgeInsetsZero];
//    [self.tableViewOptionMenu setLayoutMargins:UIEdgeInsetsZero];
    self.tableViewOptionMenu.scrollEnabled = NO;

//    self.allResults = @[@"Here's", @"to", @"the", @"crazy", @"ones.", @"The", @"misfits.", @"The", @"rebels.", @"The", @"troublemakers.", @"The", @"round", @"pegs", @"in", @"the", @"square", @"holes.", @"The", @"ones", @"who", @"see", @"things", @"differently.", @"They're", @"not", @"fond", @"of", @"rules.", @"And", @"they", @"have", @"no", @"respect", @"for", @"the", @"status", @"quo.", @"You", @"can", @"quote", @"them,", @"disagree", @"with", @"them,", @"glorify", @"or", @"vilify", @"them.", @"About", @"the", @"only", @"thing", @"you", @"can't", @"do", @"is", @"ignore", @"them.", @"Because", @"they", @"change", @"things.", @"They", @"push", @"the", @"human", @"race", @"forward.", @"And", @"while", @"some", @"may", @"see", @"them", @"as", @"the", @"crazy", @"ones,", @"we", @"see", @"genius.", @"Because", @"the", @"people", @"who", @"are", @"crazy", @"enough", @"to", @"think", @"they", @"can", @"change", @"the", @"world,", @"are", @"the", @"ones", @"who", @"do."];

//    self.allResults = @[
//                            @{
//                                @"Symbol": @"CMCSA",
//                                @"Name": @"Comcast Corp",
//                                @"Value": @"59.47"
//                                },
//                            @{
//                                @"Symbol": @"GOOGL",
//                                @"Name": @"Google Class A",
//                                @"Value": @"566.24"
//                                },
//                            @{
//                                @"Symbol": @"AAPL",
//                                @"Name": @"Apple",
//                                @"Value": @"93.59"
//                                },
//                            @{
//                                @"Symbol": @"FB",
//                                @"Name": @"Facebook",
//                                @"Value": @"83.38"
//                                }
//                            ];
//    self.visibleResults = self.allResults;

//    self.arrayCompany = [[NSMutableArray alloc] init];
//    self.arrayFilterCompany = [[NSMutableArray alloc] init];
//    
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
//    
//    [dict1 setValue:@"FB" forKey:@"Symbol"];
//    [dict1 setValue:@"Facebook" forKey:@"Name"];
//    [dict1 setValue:@"83.38" forKey:@"LastPrice"];
//    [self.arrayCompany addObject:dict1];
//    
//    [dict2 setValue:@"GOOGL" forKey:@"Symbol"];
//    [dict2 setValue:@"Google" forKey:@"Name"];
//    [dict2 setValue:@"566.24" forKey:@"LastPrice"];
//    [self.arrayCompany addObject:dict2];
//    
//    [dict3 setValue:@"AAPL" forKey:@"Symbol"];
//    [dict3 setValue:@"Apple" forKey:@"Name"];
//    [dict3 setValue:@"93.59" forKey:@"LastPrice"];
//    [self.arrayCompany addObject:dict3];
//    
//    [dict4 setValue:@"CMCSA" forKey:@"Symbol"];
//    [dict4 setValue:@"Comcast Corp" forKey:@"Name"];
//    [dict4 setValue:@"59.47" forKey:@"LastPrice"];
//    [self.arrayCompany addObject:dict4];

    [self.tableResults setHidden:YES];

    StocksOverviewViewController *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"StocksOverviewViewController"];
//    controller1.delegate = self;
    StockListViewController *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"StockListViewController"];
    GainLossViewController *controller3 = [self.storyboard instantiateViewControllerWithIdentifier:@"GainLossViewController"];
    SectorsGraphViewController *controller4 = [self.storyboard instantiateViewControllerWithIdentifier:@"SectorsGraphViewController"];
    ActiveStocksViewController *controller5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveStocksViewController"];
//    BondStocksViewController *controller6 = [self.storyboard instantiateViewControllerWithIdentifier:@"BondStocksViewController"];
    self.stockListView = controller2;
    
    controller1.title = NSLocalizedString(@"QE Index", @"QE Index");
    controller2.title = NSLocalizedString(@"Prices", @"Prices");
    controller3.title = NSLocalizedString(@"Gain/Loss", @"Gain/Loss");
    controller4.title = NSLocalizedString(@"Sectors", @"Sectors");
    controller5.title = NSLocalizedString(@"Active", @"Active");
   // controller6.title = NSLocalizedString(@"Bonds", @"Bonds");
    
    NSArray *controllerArray;
    if(globalShare.myLanguage == ARABIC_LANGUAGE)
        controllerArray = @[/*controller6,*/ controller5, controller4, controller3, controller1, controller2];
    else
        controllerArray = @[controller2, controller1, controller3, controller4, controller5/*, controller6*/];

    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor darkGrayColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor darkGrayColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(20.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(70.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
//    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height-49-64) options:parameters];
//    _pageMenu.delegate = self;
//    [self.view addSubview:_pageMenu.view];
//    [_pageMenu moveToPage:1];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];
//    _orientation = [[UIDevice currentDevice] orientation];
//    if (_orientation == UIDeviceOrientationUnknown || _orientation == UIDeviceOrientationFaceUp || _orientation == UIDeviceOrientationFaceDown) {
//        _orientation = UIDeviceOrientationPortrait;
//    }
    
//    self.cashContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"CashPositionViewController"];
//    self.cashContentView.view.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//    self.cashContentView.delegate = self;
    
//    _lineChartViewQE.backgroundColor = [UIColor colorWithRed:252/255.f green:252/255.f blue:252/255.f alpha:0.7f];
//    _lineChartViewQE.delegate = self;
//    _lineChartViewQE.descriptionText = @"";
//    _lineChartViewQE.noDataText = CHART_DATA_UNAVAILABLE;
////    _lineChartViewQE.noDataTextDescription = CHART_DATA_UNAVAILABLE;
//    
//    _lineChartViewQE.dragEnabled = YES;
//    _lineChartViewQE.pinchZoomEnabled = YES;
//    _lineChartViewQE.drawGridBackgroundEnabled = NO;
//    _lineChartViewQE.scaleXEnabled = YES;
//    _lineChartViewQE.scaleYEnabled = NO;
//    
//    _lineChartViewQE.rightAxis.enabled = YES;
//    _lineChartViewQE.leftAxis.enabled = NO;
//    _lineChartViewQE.rightAxis.drawGridLinesEnabled = YES;
//    _lineChartViewQE.xAxis.drawGridLinesEnabled = YES;
//    _lineChartViewQE.rightAxis.gridLineWidth = 0.1;
//    _lineChartViewQE.xAxis.gridLineWidth = 0.1;
//    _lineChartViewQE.xAxis.labelPosition = XAxisLabelPositionBottom;
//    
//    _lineChartViewQE.legend.enabled = NO;
//    
//    _lineChartViewQE.drawMarkers = NO;
//    self.circleMarker = [[CircleMarker alloc] initWithColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    self.circleMarker.minimumSize = CGSizeMake(10.f, 10.f);
//    _lineChartViewQE.marker = _circleMarker;

    [self.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
    
    NSInteger passIndex = 0;
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//        [self.pageMenu.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        [self.lineChartViewQE setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        [_pageMenu moveToPage:[controllerArray count] - 1 withAnimated:YES];
        passIndex = [controllerArray count] - 1;
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
//        [self.pageMenu.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//        [self.lineChartViewQE setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//        [_pageMenu moveToPage:0];
        passIndex = 0;
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
     //_pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height-49-64) options:parameters index:passIndex];
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(_labelTitle.frame.origin.y+_labelTitle.frame.size.height+20)-49) options:parameters index:passIndex];//labelTitle
    
    NSLog(@"..... %f",_labelTitle.frame.origin.y+_labelTitle.frame.size.height+10);
    NSLog(@"Height %f",self.view.frame.size.height-(_labelTitle.frame.origin.y+_labelTitle.frame.size.height+30)-49);
    //NSLog(@"y %f",_labelTitle.frame.origin.y);

    
    
    _pageMenu.delegate = self;
    [_pageMenu moveToPage:passIndex withAnimated:YES];
    [self.view addSubview:_pageMenu.view];
}

-(void)viewWillAppear:(BOOL)animated {
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];
//    _orientation = [[UIDevice currentDevice] orientation];
//    if (_orientation == UIDeviceOrientationUnknown || _orientation == UIDeviceOrientationFaceUp || _orientation == UIDeviceOrientationFaceDown) {
//        _orientation = UIDeviceOrientationPortrait;
//    }
    [super viewWillAppear:YES];
    
    if(globalShare.dictValues == nil)
        globalShare.dictValues = [[NSMutableDictionary alloc] init];

    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
//    [GlobalShare checkIfRateApp:self];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_system_codes"])
        [self performSelector:@selector(getSystemCodes) withObject:nil afterDelay:0.01f];
    else {
        globalShare.pickerData1 = [DataManager select_SystemCodes:@"tbl_TransactionOrderType"];
        globalShare.pickerData2 = [DataManager select_SystemCodes:@"tbl_PriceOrderType"];
        globalShare.pickerData3 = [DataManager select_SystemCodes:@"tbl_DurationOrderType"];
    }

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_securities_avail"])
        [self performSelector:@selector(getSecurityBySector) withObject:nil afterDelay:0.01f];
    else {
        globalShare.dictValues = [DataManager select_SecurityListAsSectors];
        self.allResults = [DataManager select_SecurityList];
    }

//    [self updateChartData];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.pageMenu.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.pageMenu.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
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
////    [self.labelTitle setHidden:YES];
////    [self.buttonCall setHidden:YES];
////    [self.buttonSearch setHidden:YES];
////    [self.buttonAlert setHidden:YES];
////    [self.buttonOptionMenu setHidden:YES];
//
////    SearchResultsTableViewController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsTableViewController"];
//
//    // Create the search controller and make it perform the results updating.
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.delegate = self;
//    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
////    [self.searchController.searchBar becomeFirstResponder];
////    [self.searchController setActive:YES];
//    
//    /*
//     Configure the search controller's search bar. For more information on how to configure
//     search bars, see the "Search Bar" group under "Search".
//     */
//    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.searchController.searchBar.placeholder = NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name");
//    self.definesPresentationContext = YES;
//
////    // Include the search bar within the navigation bar.
//////    self.navigationItem.titleView = self.searchController.searchBar;
////    
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
    
    [self.stockListView dismissPopup];
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
    
    [self.stockListView dismissPopup];
}

- (void)backgroundTappedMenu:(id)sender {
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
}

- (IBAction)actionAddRemoveMarker:(id)sender {
//    LineChartDataSet *set1 = nil;
//    if (_lineChartViewQE.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_lineChartViewQE.data.dataSets[0];
//        [set1 setDrawVerticalHighlightIndicatorEnabled:!set1.drawVerticalHighlightIndicatorEnabled];
//        [set1 setDrawHorizontalHighlightIndicatorEnabled:!set1.drawHorizontalHighlightIndicatorEnabled];
//        [_lineChartViewQE.data notifyDataChanged];
//        [_lineChartViewQE notifyDataSetChanged];
//    }
//    [_lineChartViewQE setDrawMarkers:!_lineChartViewQE.drawMarkers];
    
    if([_buttonPlus.backgroundColor isEqual:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]]) {
        [self.labelClose setHidden:NO];
        [self.labelDate setHidden:NO];
        [self.labelLast setHidden:YES];
        [_buttonPlus setBackgroundColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1]];
    }
    else {
        [self.labelClose setHidden:YES];
        [self.labelDate setHidden:YES];
        [self.labelLast setHidden:NO];
        [_buttonPlus setBackgroundColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]];
    }
}

#pragma mark - Common actions

-(void) getSystemCodes {
    @try {
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetSystemCodes"];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                                                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_system_codes"];
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       [DataManager insertSystemCodes:returnedDict[@"result"]];
                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       globalShare.pickerData1 = dictVal[@"TransactionOrderSide"];
                                                                       globalShare.pickerData2 = dictVal[@"priceType"];
                                                                       globalShare.pickerData3 = dictVal[@"duration"];
                                                                   });
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

-(void) getSecurityBySector {
    @try {
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetSecurityBySector"];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                                                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_securities_avail"];
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       [self createSecurity:returnedDict[@"result"]];
                                                                   });
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

-(void) createSecurity:(NSArray *)strArray {
//    if(globalShare.arraySectors == nil)
//        globalShare.arraySectors = [[NSMutableArray alloc] init];
//    [globalShare.arraySectors addObjectsFromArray:strArray];
//    for (int i = 0; i < strArray.count; i++) {
//        NSMutableDictionary *def = strArray[i];
//        NSMutableArray *newArray = def[@"securities"];
//        [self.allResults addObjectsFromArray:newArray];
//    }
//    
//    NSMutableDictionary *muteDict = [[NSMutableDictionary alloc] init];
//    for (int i = 0; i < strArray.count; i++) {
//        NSDictionary *def = strArray[i];
//        NSArray *newArray = def[@"securities"];
//        
//        NSMutableArray *arr = [[NSMutableArray alloc] init];
//        [newArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSMutableDictionary *dict = [(NSMutableDictionary *)obj mutableCopy];
//            dict[@"IsChecked"] = @("NO");
//            [arr addObject:dict];
//        }];
//        
//        NSString *strSector = def[@"security_sector_name"];
//        [muteDict setObject:arr forKey:strSector];
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:muteDict forKey:@"mySectors"];
//    [[NSUserDefaults standardUserDefaults] synchronize];

//    for (int i = 0; i < strArray.count; i++) {
//        NSMutableDictionary *def = strArray[i];
//        NSMutableArray *newArray = def[@"securities"];
//        [self.allResults addObjectsFromArray:newArray];
//    }
    
    [DataManager insertSecurityList:strArray];
//    globalShare.dictValues = [[NSMutableDictionary alloc] init];
    globalShare.dictValues = [DataManager select_SecurityListAsSectors];
    self.allResults = [DataManager select_SecurityList];
}

- (void)handleTapOnChartView {
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[GlobalShare sharedInstance] setCanRotateOnClick:YES];
    self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"QEGraphViewController"];
    [self presentViewController:self.graphContentView animated:NO completion:nil];
//    [self.navigationController pushViewController:self.graphContentView animated:NO];
}

//- (void)handleTapOnChartView {
////    self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"QEGraphViewController"];
////    self.graphContentView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//////    self.graphContentView.view.frame = [UIScreen mainScreen].bounds;
////
////    CATransition *animation = [CATransition animation];
////    [animation setDuration:0.45f];
////    [animation setType:kCATransitionPush];
////    [animation setSubtype:kCATransitionFromRight];
////    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
////    [self.graphContentView.view.layer addAnimation:animation forKey:@""];
////    
////    [self.view addSubview:self.graphContentView.view];
////    
//////    [UIView animateWithDuration:0.3 animations:^
//////    {
//////         self.graphContentView.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//////    }
//////                     completion:^(BOOL finished)
//////    {
//////
//////    }];
//    
//    self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"QEGraphViewController"];
//    self.graphContentView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    [self.view addSubview:self.graphContentView.view];
//    [self.graphContentView.view setCenter:self.view.center];
//    [self rotateController:self.graphContentView degrees:-90];
////    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
////    [self.view setBounds:CGRectMake(0, 0, 480, 320)];
//}

-(void) rotateController:(UIViewController *)controller degrees:(NSInteger)aDgrees
{
    UIScreen *screen = [UIScreen mainScreen];
    if(aDgrees>0)
        controller.view.bounds = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    else
    {
        controller.view.bounds = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    }
    controller.view.transform = CGAffineTransformConcat(controller.view.transform, CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(aDgrees)));
}

- (void)callBackSuperviewFromCash {
    self.tabBarController.tabBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    /*
     -updateSearchResultsForSearchController: is called when the controller is
     being dismissed to allow those who are using the controller they are search
     as the results controller a chance to reset their state. No need to update
     anything if we're being dismissed.
     */
    if (!searchController.active) {
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.labelTitle setText:NSLocalizedString(@"QE Market", @"QE Market")];
        [self.view sendSubviewToBack:self.tableResults];
        [self.view bringSubviewToFront:self.labelTitle];
        [self.view bringSubviewToFront:self.buttonCall];
        [self.view bringSubviewToFront:self.buttonSearch];
        [self.view bringSubviewToFront:self.buttonAlert];
        [self.view bringSubviewToFront:self.buttonOptionMenu];
        
//        [self.labelTitle setHidden:NO];
//        [self.buttonCall setHidden:NO];
//        [self.buttonSearch setHidden:NO];
//        [self.buttonAlert setHidden:NO];
//        [self.buttonOptionMenu setHidden:NO];

        return;
    }
    
    NSString *filterString = searchController.searchBar.text;
    
//    if (!self.filterString || self.filterString.length <= 0) {
//        self.visibleResults = self.allResults;
//    }
//    else {
//        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", self.filterString];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.security_name_e contains [c] %@ OR self.security_name_a contains [c] %@ OR self.ticker contains [c] %@", filterString, filterString, filterString];
        self.visibleResults = [self.allResults filteredArrayUsingPredicate:filterPredicate];
//    }
    
    [self.tableResults reloadData];
}

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(![[GlobalShare sharedInstance] canAutoRotateL])
        return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
    else
        return YES;
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    if(![[GlobalShare sharedInstance] canAutoRotateL])
        return NO;
    else
        return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if(![[GlobalShare sharedInstance] canAutoRotateL])
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}

- (BOOL)canAutoRotate
{
    return NO;
}

-(void)didRotate:(NSNotification *)notification {
//    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];
//    if (newOrientation != UIDeviceOrientationUnknown && newOrientation != UIDeviceOrientationFaceUp && newOrientation != UIDeviceOrientationFaceDown) {
//        _orientation = newOrientation;
//    }
//    
//    // Do your orientation logic here
//    if (_orientation == UIDeviceOrientationLandscapeLeft || _orientation == UIDeviceOrientationLandscapeRight) {
//        // Clear the current view and insert the orientation specific view.
//        if([[GlobalShare sharedInstance] canAutoRotateL]) {
////            self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"QEGraphViewController"];
////            [self.navigationController pushViewController:self.graphContentView animated:NO];
//            self.viewGraphQE.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//            if (![_viewGraphQE superview])
//                [self.view addSubview:_viewGraphQE];
//            self.tabBarController.tabBar.hidden = YES;
//            [self updateChartData];
//        }
//    } else if (_orientation == UIDeviceOrientationPortrait) {
//        // Clear the current view and insert the orientation specific view.
//        if([[GlobalShare sharedInstance] canAutoRotateL]) {
//            if ([_viewGraphQE superview]) {
//                [_viewGraphQE removeFromSuperview];
//            }
//            self.tabBarController.tabBar.hidden = NO;
//        }
//    }
}

- (void)updateChartData
{
//    [_lineChartViewQE animateWithYAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
    [self setDataCount:30 range:100];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
//    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
//        double mult = (range + 1);
//        double val = (double) (arc4random_uniform(mult)) + 3;
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
//    LineChartDataSet *set1 = nil;
//    if (_lineChartViewQE.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_lineChartViewQE.data.dataSets[0];
//        set1.yVals = yVals;
//        _lineChartViewQE.data.xValsObjc = xVals;
//        [_lineChartViewQE.data notifyDataChanged];
//        [_lineChartViewQE notifyDataSetChanged];
//    }
//    else
//    {
//        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
//        
//        [set1 setColor:[UIColor colorWithRed:204/255.f green:224/255.f blue:255/255.f alpha:1.f]];
//        [set1 setCircleColor:UIColor.blackColor];
//        set1.lineWidth = 2.0;
//        set1.circleRadius = 3.0;
//        set1.drawCircleHoleEnabled = NO;
//        set1.valueFont = [UIFont systemFontOfSize:9.f];
//
//        NSArray *gradientColors = @[
//                                    (id)[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f].CGColor,
//                                    (id)[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f].CGColor
//                                    ];
//        
//        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//        
//        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
//        set1.drawFilledEnabled = YES;
//        set1.drawCubicEnabled = NO;
//        set1.drawValuesEnabled = NO;
//        set1.drawCirclesEnabled = NO;
//        set1.drawVerticalHighlightIndicatorEnabled = NO;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//        set1.highlightColor = [UIColor orangeColor];
//        set1.highlightLineWidth = 0.2;
//        
//        CGGradientRelease(gradient);
//        
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//        
//        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
//        
//        _lineChartViewQE.data = data;
//    }
}

#pragma mark - ChartViewDelegate
//
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
//{
//    self.labelClose.text = [NSString stringWithFormat:@"%@: %.2f", NSLocalizedString(@"Close", @"Close"), entry.value];
//    self.labelDate.text = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Date", @"Date"), (long)entry.xIndex];
//}

#pragma mark - UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.visibleResults.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.textLabel.text = self.visibleResults[indexPath.row];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.tableViewOptionMenu])
        return self.arrayMenu.count;
    else
        return self.visibleResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableViewOptionMenu]) {
//        static NSString *CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
        
////        cell.textLabel.text = self.arrayMenu[indexPath.row];
//        cell.textLabel.text = self.arrayMenu[indexPath.row][@"menu_title"];
//        cell.imageView.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        
        OptionsViewCell *cell = (OptionsViewCell *) [tableView dequeueReusableCellWithIdentifier:kStocksOptionsViewCellIdentifier forIndexPath:indexPath];

        cell.labelOption.text = self.arrayMenu[indexPath.row][@"menu_title"];
        cell.imageOption.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
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
//    if([tableView isEqual:self.tableViewOptionMenu]) {
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

                self.tabBarController.tabBar.hidden = YES;
                [self.view addSubview:self.cashContentView.view];
                [UIView animateWithDuration:.3 animations:^{
                    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
                    [self.cashContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                } completion:^(BOOL finished) {
                    
                }];
            }
//            else if(indexPath.row == 1) {
//                OrderHistoryViewController *orderHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//                [[self navigationController] pushViewController:orderHistoryViewController animated:YES];
//            }
            else if(indexPath.row == 1) {
                ContactUsViewController *contactUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                [[self navigationController] pushViewController:contactUsViewController animated:YES];
            }
            else if(indexPath.row == 2) {
                SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                [[self navigationController] pushViewController:settingsViewController animated:YES];
            }
            else {
                
                if ([GlobalShare isUserLogedIn]) {
                    
                 [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                else{
                    //loginStatus = NSLocalizedString(@"Sign Out", @"Sign Out");
                     [GlobalShare showSignOutAlertView:self :SIGNOUT_CONFIRMATION];
                }
               
            }
        }
        else {
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
            
            [self.labelTitle setText:NSLocalizedString(@"QE Market", @"QE Market")];
            
            CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
            companyStocksViewController.securityId = self.visibleResults[indexPath.row][@"ticker"];
            companyStocksViewController.securityName = self.visibleResults[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
            [[self navigationController] pushViewController:companyStocksViewController animated:YES];
//            [self.searchController setActive:NO];
            
            self.searchResults.text = @"";
            NSString *searchString = self.searchResults.text;
            [self updateFilteredContentForProductName:searchString];
        }
//    }
//    else {
//        CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
//        [[self navigationController] pushViewController:companyStocksViewController animated:YES];
//        [self.searchController setActive:NO];
//    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    UIButton *cancelButton;
//    UIView *topView = searchBar.subviews[0];
//    for (UIView *subView in topView.subviews) {
//        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//            cancelButton = (UIButton*)subView;
//        }
//    }
//    if (cancelButton) {
//        //Set the new title of the cancel button
//        [cancelButton setTitle:@"Annuller" forState:UIControlStateNormal];
//    }
    
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
    
    [self.labelTitle setText:NSLocalizedString(@"QE Market", @"QE Market")];
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
