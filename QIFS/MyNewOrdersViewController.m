//
//  MyNewOrdersViewController.m
//  QIFS
//
//  Created by zylog on 16/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "MyNewOrdersViewController.h"
#import "MGSwipeButton.h"
#import "NewOrderViewController.h"
#import "MyNewOrdersCell.h"
#import "OrderTicketViewController.h"
#import "ActiveOrdersViewController.h"

#import "AlertsViewController.h"
#import "CashPositionViewController.h"
#import "OrderHistoryViewController.h"
#import "ContactUsViewController.h"
#import "SettingsViewController.h"
#import "CompanyStocksViewController.h"
#import "OptionsViewCell.h"
#import "LoginView.h"

NSString *const kMyNewOrdersCellIdentifier = @"MyNewOrdersCell";
NSString *const kMyNewOrdersOptionsViewCellIdentifier = @"OptionsViewCell";

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)
#define TEST_USE_MG_DELEGATE 1

@interface MyNewOrdersViewController () <tabBarManageOrderDelegate,tapNewOrderDelegate, tabBarManageCashDelegate, NSURLSessionDelegate>{
    LoginView *loginVw;
    UIView *overLayView;
}


@property (nonatomic, weak) IBOutlet UITableView *tableViewOrders;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentOrders;
@property (nonatomic, weak) IBOutlet UIView *viewOrders;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

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

@property (nonatomic, strong) NSArray *arrayMyOrders;
@property (nonatomic, strong) NSArray *arrayOrdersCount;
@property (nonatomic, strong) NSMutableArray *arrayMyOrdersCount;
@property (nonatomic, strong) NSString *strOrderType;
@property (nonatomic, strong) NSString *strOrderId;

@property (nonatomic, weak) IBOutlet UILabel *labelTitleOrgQty;
@property (nonatomic, weak) IBOutlet UILabel *labelTitleAvgPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelTitleValidity;
@property (nonatomic, weak) IBOutlet UILabel *labelMyOrderCount;
@property (nonatomic, weak) IBOutlet UILabel *labelActiveCount;
@property (nonatomic, weak) IBOutlet UILabel *labelFilledCount;
@property (nonatomic, weak) IBOutlet UILabel *labelCancelledCount;
@property (nonatomic, strong) OrderTicketViewController *ticketContentView;
@property (nonatomic, strong) ActiveOrdersViewController *activeContentView;

@end

@implementation MyNewOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"My Orders", @"My Orders")];
    [self.searchResults setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    self.strOrderType = @"3";
    self.arrayMyOrdersCount = [[NSMutableArray alloc] init];
    [self clearOrderCount];

    self.tableResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewOrders.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableResults setHidden:YES];
    
    overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    overLayView.clipsToBounds = YES;
    overLayView.hidden = YES;
    [self.view addSubview:overLayView];

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

//    self.arrayMyOrders = @[
//                         @{
//                             @"Symbol": @"CMCSA",
//                             @"Name": @"Comcast Corp",
//                             @"Order": @"Buy",
//                             @"Price": @"59.47",
//                             @"OrgQty": @"12,234",
//                             @"Duration": @"17/07/2016",
//                             @"ExpCanDate": @"17/07/2016 11:57:23"
//                             },
//                         @{
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Order": @"Buy",
//                             @"Price": @"566.24",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Week",
//                             @"ExpCanDate": @""
//                             },
//                         @{
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Order": @"Sell",
//                             @"Price": @"83.38",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Month",
//                             @"ExpCanDate": @"17/07/2016 13:15:15"
//                             },
//                         @{
//                             @"Symbol": @"AAPL",
//                             @"Name": @"Apple",
//                             @"Order": @"Sell",
//                             @"Price": @"93.38",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Day",
//                             @"ExpCanDate": @""
//                             }
//                         ];
    
//    self.arrayOrdersCount = @[
//                              @{
//                                  @"Status": @"A",
//                                  @"Value": @"2"
//                                  },
//                              @{
//                                  @"Status": @"B",
//                                  @"Value": @"1"
//                                  },
//                              @{
//                                  @"Status": @"C",
//                                  @"Value": @"1"
//                                  }
//                              ];
//
//    float angleToStart = 0, angleToEnd = 0;
//    float total = 0;
//    for(NSDictionary *dic in self.arrayOrdersCount) {
//        total = total + [dic[@"Value"] floatValue];
//    }
//    for(NSDictionary *dic in self.arrayOrdersCount) {
//        float factor = total/[dic[@"Value"] floatValue];
//        angleToStart = angleToEnd;
//        angleToEnd = (360/factor) + angleToStart;
//        
//        [self createCircleWithStartAngle:DEGREES_TO_RADIANS(angleToStart) endAngle:DEGREES_TO_RADIANS(angleToEnd) name:dic[@"Status"] view:_viewOrders];
//    }
    
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_segmentOrders setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelTitleAvgPrice setTextAlignment:NSTextAlignmentLeft];
        [self.labelTitleValidity setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelTitleAvgPrice setTextAlignment:NSTextAlignmentRight];
        [self.labelTitleValidity setTextAlignment:NSTextAlignmentRight];
    }
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"]) {
        [self showsLoginPopUp];
    }
    else{
        
        [self.tableViewOrders reloadData];
        
        if (![GlobalShare isConnectedInternet]) {
            [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
            return;
        }
        [self performSelector:@selector(getOrderCount) withObject:nil afterDelay:0.01f];
        
        
        globalShare.dictValues = [DataManager select_SecurityListAsSectors];
        self.allResults = [DataManager select_SecurityList];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
#pragma mark Loading Login PopUp when guest User
-(void)showsLoginPopUp{
    
    overLayView.hidden = NO;
    loginVw  = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:loginVw];
    loginVw.frame = CGRectMake(0, 0, self.view.frame.size.width-70, loginVw.frame.size.height);
    loginVw.center = self.view.center;
    
    [loginVw.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [loginVw.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    loginVw.userNameTF.delegate =self;
    loginVw.passwordTF.delegate = self;
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        // [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [loginVw setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
    }
    else {
        //[[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [loginVw setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }
    
}

#pragma mark - Button actions
-(void)cancelButtonAction{
    overLayView.hidden = YES;
    //[self.navigationController popViewControllerAnimated:YES];
    //[loginVw removeFromSuperview];
    [self.tabBarController setSelectedIndex:0];
}
-(void)loginButtonAction{
    
    @try {
        
        [loginVw.userNameTF resignFirstResponder];
        [loginVw.passwordTF resignFirstResponder];
        
        NSString *stringUserName = [loginVw.userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringPassword = [loginVw.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringUserName length] == 0) {
            [GlobalShare showBasicAlertView:self :USERNAME];
            return;
        } else if([stringPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :PASSWORD];
            return;
        }
        
        if (![GlobalShare isConnectedInternet]) {
            [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
            return;
        }
        [self verifyUserLogin:stringUserName andPassword:stringPassword];
        
        
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        //        [self toEnableControls];
    }
    
}

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

- (IBAction)segmentedControlIndexChanged:(id)sender {
//    if(![self.indicatorView isHidden]) return;
    switch (self.segmentOrders.selectedSegmentIndex) {
        case 0: {
            [self.labelTitleOrgQty setText:NSLocalizedString(@"Org. Qty", @"Org. Qty")];
            [self.labelTitleAvgPrice setText:NSLocalizedString(@"Price", @"Price")];
            break;
        }
        case 2:
        case 4: {
            [self.labelTitleOrgQty setText:NSLocalizedString(@"Qty", @"Qty")];
            [self.labelTitleAvgPrice setText:NSLocalizedString(@"Price", @"Price")];
            break;
        }
        case 1:
        case 3: {
            [self.labelTitleOrgQty setText:NSLocalizedString(@"Qty", @"Qty")];
            [self.labelTitleAvgPrice setText:NSLocalizedString(@"Avg. Price", @"Avg. Price")];
            break;
        }
        default:
            break;
    }
    
    self.arrayMyOrders = nil;
    [self.tableViewOrders reloadData];
    
    NSArray *orderType = [NSArray arrayWithObjects:@"3", @"7", @"8", @"5", @"11", nil];
    self.strOrderType = orderType[self.segmentOrders.selectedSegmentIndex];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getOrderCount) withObject:nil afterDelay:0.01f];
}

- (IBAction)actionOrderTicket:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
    
    NSDictionary *def = self.arrayMyOrders[btn.tag];
    
//    if(([def[@"order_status_id"] integerValue] == 3 || [def[@"order_status_id"] integerValue] == 4 || [def[@"order_status_id"] integerValue] == 12 || [def[@"order_status_id"] integerValue] == 8 || [def[@"order_status_id"] integerValue] == 5 || [def[@"order_status_id"] integerValue] == 11 || [def[@"order_status_id"] integerValue] == 6 || [def[@"order_status_id"] integerValue] == 13))
    if([def[@"executed_qty"] integerValue] == 0)
        return;
    
    self.ticketContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderTicketViewController"];
    self.ticketContentView.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.ticketContentView.delegate = self;
    self.ticketContentView.strOrderId = def[@"order_id"];
    [self.view addSubview:self.ticketContentView.view];
    [UIView animateWithDuration:.3 animations:^{
        [self.ticketContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = YES;
    }];
}

#pragma mark - Common actions
-(BOOL)verifyUserLogin:(NSString *)stringUserName andPassword:(NSString*)stringPassword{
    @try {
        
        
        [loginVw removeFromSuperview];
        overLayView.hidden = YES;
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@SetCredentials?username=%@&password=%@", REQUEST_URL, stringUserName, stringPassword];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           
                                                           if(error == nil)
                                                           {
                                                               
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               if([[returnedDict objectForKey:@"status"] hasPrefix:@"error"]) {
                                                                   if([[returnedDict objectForKey:@"result"] hasPrefix:@"T4"])
                                                                       [GlobalShare showBasicAlertView:self :INVALID_HEADER];
                                                                   else
                                                                       [GlobalShare showBasicAlertView:self :[returnedDict objectForKey:@"result"]];
                                                                   return;
                                                               }
                                                               NSString *strToken = [returnedDict objectForKey:@"result"];
                                                               [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:@"ssckey"];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               [self viewWillAppear:YES];
                                                               
                                                               
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

-(void) getSubmittedOrders {
    @try {
        NSString *strLocOrderType;
        if([self.strOrderType integerValue] == 3)
            strLocOrderType = @"3,4,12,8";
        else if([self.strOrderType integerValue] == 11)
            strLocOrderType = @"11,6,13";
//        else if([self.strOrderType integerValue] == 8)
//            strLocOrderType = @"8,5";
        else
            strLocOrderType = self.strOrderType;

        strLocOrderType = @"";

//    [self.indicatorView setHidden:NO];

//    NSString *strTodayDate = [GlobalShare returnUSDate:[NSDate date]];
//    NSString *strParams = [NSString stringWithFormat:@"GetSubmittedOrders?fromDate=%@&toDate=%@&order_status=%@", strTodayDate, strTodayDate, self.strOrderType];
    NSString *strParams = [NSString stringWithFormat:@"GetSubmittedOrders?fromDate=&toDate=&order_status=%@", strLocOrderType];

    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];

//    NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetSubmittedOrders?fromDate=02/28/2017&toDate=02/28/2016&order_status=", self.strOrderType];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, strParams];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       [self.indicatorView setHidden:YES];
                                                       [self.tableViewOrders setUserInteractionEnabled:YES];
                                                       [self.segmentOrders setEnabled:YES];
                                                       [self.buttonSearch setEnabled:YES];
                                                       [self.buttonOptionMenu setEnabled:YES];
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
//                                                           NSLog(@"%@", returnedDict);
                                                           if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   self.arrayMyOrders = returnedDict[@"result"];
                                                                   
//                                                                   if([self.strOrderType integerValue] == 8) {
//                                                                       NSPredicate *applePred1 = [NSPredicate predicateWithFormat:@"self.order_status_id matches %@", @"8"];
//                                                                       NSArray *arrFiltered1 = [returnedDict[@"result"] filteredArrayUsingPredicate:applePred1];
//
//                                                                       NSPredicate *applePred2 = [NSPredicate predicateWithFormat:@"self.order_status_id matches %@ and executed_qty.intValue > %d and remaining_qty.intValue != %d", @"5", 0, 0];
//                                                                       NSArray *arrFiltered2 = [returnedDict[@"result"] filteredArrayUsingPredicate:applePred2];
//                                                                       
//                                                                       NSMutableArray *newArray = [[NSMutableArray alloc] init];
//                                                                       [newArray addObjectsFromArray:arrFiltered1];
//                                                                       [newArray addObjectsFromArray:arrFiltered2];
//                                                                       
//                                                                       self.arrayMyOrders = [NSArray arrayWithArray:newArray];
//                                                                   }
//                                                                   else {
//                                                                       self.arrayMyOrders = returnedDict[@"result"];
//                                                                   }
                                                                   [self.tableViewOrders reloadData];              // also update UI on main thread
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

-(void) cancelOrder {
    @try {
        [self.indicatorView setHidden:NO];
        [self.tableViewOrders setUserInteractionEnabled:NO];
        [self.segmentOrders setEnabled:NO];
        [self.buttonSearch setEnabled:NO];
        [self.buttonOptionMenu setEnabled:NO];

        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"CancelOrder?order_id=", self.strOrderId];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           //                                                           [self.indicatorView setHidden:YES];
                                                           [self performSelector:@selector(getOrderCount) withObject:nil afterDelay:0.01f];
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
//                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       [GlobalShare showBasicAlertView:self :CANCEL_ORDER_SUCCESS];
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

-(void) getOrderCount {
    @try {
        [self.indicatorView setHidden:NO];
        [self.tableViewOrders setUserInteractionEnabled:NO];
        [self.segmentOrders setEnabled:NO];
        [self.buttonSearch setEnabled:NO];
        [self.buttonOptionMenu setEnabled:NO];

        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetOrderCount"];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                           [self.indicatorView setHidden:YES];
                                                           [self performSelector:@selector(getSubmittedOrders) withObject:nil afterDelay:0.01f];
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
//                                                               NSLog(@"%@", returnedDict);
                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       
                                                                       self.labelMyOrderCount.text = dictVal[@"MyOrderCount"];
                                                                       self.labelActiveCount.text = dictVal[@"ActiveOrderCount"];
                                                                       self.labelFilledCount.text = dictVal[@"FilledOrderCount"];
                                                                       self.labelCancelledCount.text = dictVal[@"CancelledOrderCount"];
                                                                       
                                                                       [self.arrayMyOrdersCount removeAllObjects];
                                                                       [self.arrayMyOrdersCount addObject:dictVal[@"ActiveOrderCount"]];
                                                                       [self.arrayMyOrdersCount addObject:dictVal[@"FilledOrderCount"]];
                                                                       [self.arrayMyOrdersCount addObject:dictVal[@"CancelledOrderCount"]];
    //                                                                   [self.arrayMyOrdersCount addObject:@"2"];
    //                                                                   [self.arrayMyOrdersCount addObject:@"1"];
    //                                                                   [self.arrayMyOrdersCount addObject:@"1"];
                                                                       [self toDrawOrderCount];
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

-(void) toDrawOrderCount {
    NSArray *array = @[ @"A", @"B", @"C" ];
    float angleToStart = 0, angleToEnd = 0;
    float total = 0;
//    for(NSString *strVal in self.arrayMyOrdersCount) {
//        total = total + [strVal floatValue];
//    }
    NSNumber *sumofValues = [self.arrayMyOrdersCount valueForKeyPath:@"@sum.self"];
    total = [sumofValues floatValue];
    for(int i = 0; i < [self.arrayMyOrdersCount count]; i++) {
        float factor = total/[self.arrayMyOrdersCount[i] floatValue];
        angleToStart = angleToEnd;
        angleToEnd = (360/factor) + angleToStart;
        
        [self createCircleWithStartAngle:DEGREES_TO_RADIANS(angleToStart) endAngle:DEGREES_TO_RADIANS(angleToEnd) name:array[i] view:_viewOrders];
    }
}

- (void)callBackSuperviewFromOrder {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)callBackSuperviewFromNewOrder {
    self.tabBarController.tabBar.hidden = NO;
    [self performSelector:@selector(getOrderCount) withObject:nil afterDelay:0.01f];
}

- (void)showAlertViewTwoActions:(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   [self cancelOrder];
                               }];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }
    else {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)showBasicAlertView:(NSString *)strMessage {
//    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
//    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
//                                                                             message:alertMessage
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction *action)
//                               {
//                                   //                                   NSLog(@"OK action");
//                               }];
//    
//    [alertController addAction:okAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}

-(void) clearOrderCount {
    self.labelMyOrderCount.text = @"";
    self.labelActiveCount.text = @"";
    self.labelFilledCount.text = @"";
    self.labelCancelledCount.text = @"";
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!searchController.active) {
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.labelTitle setText:NSLocalizedString(@"My Orders", @"My Orders")];
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
        return [self.arrayMyOrders count];
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
        
        OptionsViewCell *cell = (OptionsViewCell *) [tableView dequeueReusableCellWithIdentifier:kMyNewOrdersOptionsViewCellIdentifier forIndexPath:indexPath];
        
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
        MyNewOrdersCell *cell = (MyNewOrdersCell *) [tableView dequeueReusableCellWithIdentifier:kMyNewOrdersCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayMyOrders[indexPath.row];
        
    //    cell.labelSymbol.text = def[@"Symbol"];
    //    cell.labelCompanyName.text = def[@"Name"];
    //    cell.labelOrder.text = def[@"Order"];
    //    cell.labelPrice.text = def[@"Price"];
    //    cell.labelOrgQty.text = def[@"OrgQty"];
    //    cell.labelExpCanDate.text = def[@"ExpCanDate"];
    //
    //    if([def[@"Order"] isEqualToString:@"Buy"])
    //        cell.labelOrder.textColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.f];
    //    else
    //        cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];
    ////    
    ////    if([def[@"ExpCanDate"] length] > 0)
    ////        cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];
    ////    else
    ////        cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];

        cell.labelSymbol.text = def[@"symbol"];
        cell.labelCompanyName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
        cell.labelOrder.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"order_type_desc_e"] : def[@"order_type_desc_a"];
        cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"price"]];
        cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:def[@"qty"]];
        cell.labelExecQty.text = [GlobalShare createCommaSeparatedString:def[@"executed_qty"]];
        [cell.buttonExecQty setTitle:[GlobalShare createCommaSeparatedString:def[@"executed_qty"]] forState:UIControlStateNormal];
        cell.buttonExecQty.tag = indexPath.row;
//        cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:@"345523525"];
//        [cell.buttonExecQty setTitle:[GlobalShare createCommaSeparatedString:@"246585643"] forState:UIControlStateNormal];

//        cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:def[@"remaining_qty"]];
//        NSString *strQty = [NSString stringWithFormat:@"%ld", (long)([def[@"qty"] integerValue] - [def[@"executed_qty"] integerValue])];
//        cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:strQty];
//        if([self.strOrderType integerValue] == 3 || [self.strOrderType integerValue] == 7 || [self.strOrderType integerValue] == 8)
//            cell.labelExpCanDate.text = @"";
//        else
//            cell.labelExpCanDate.text = def[@"expiry_date"];

        cell.labelDate.text = [NSString stringWithFormat:@"%@", def[@"order_date"]];
        
        if([def[@"order_status_id"] integerValue] == 7 || [def[@"order_status_id"] integerValue] == 8)
            cell.labelValidity.text = @"";
        else
            cell.labelValidity.text = [NSString stringWithFormat:@"%@", (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"validity_en"] : def[@"validity_ar"]];

//        if([[def[@"order_type_desc_e"] uppercaseString] isEqualToString:@"BUY"])
        if([def[@"order_type_id"] integerValue] == 1)
            cell.labelOrder.textColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.f];
        else
            cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];

//        if([self.strOrderType integerValue] == 3 || [self.strOrderType integerValue] == 5 || [self.strOrderType integerValue] == 11)
//            cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:def[@"remaining_qty"]];
//        else
//            cell.labelOrgQty.text = [GlobalShare createCommaSeparatedString:def[@"executed_qty"]];

        cell.labelStatus.text = [NSString stringWithFormat:@"%@", (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"order_status_e"] : def[@"order_status_a"]];

        if([def[@"order_status_id"] integerValue] == 5 || [def[@"order_status_id"] integerValue] == 11 || [def[@"order_status_id"] integerValue] == 6 || [def[@"order_status_id"] integerValue] == 13)
            cell.labelStatus.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];
        else
            cell.labelStatus.textColor = [UIColor colorWithRed:97/255.f green:152/255.f blue:255/255.f alpha:1.f];

        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;
        
//        if([def[@"order_status_id"] integerValue] == 3 || [def[@"order_status_id"] integerValue] == 4 || [def[@"order_status_id"] integerValue] == 12 || [def[@"order_status_id"] integerValue] == 8) {
//            cell.delegate = self;
//            
//            //#if !TEST_USE_MG_DELEGATE
////            cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
////            cell.rightSwipeSettings.onlySwipeButtons = NO;
////            cell.rightExpansion.fillOnTrigger = YES;
////            cell.rightButtons = [self createRightButtons:2];
//            if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//                cell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
//                cell.leftSwipeSettings.onlySwipeButtons = NO;
//                cell.leftButtons = [self createLeftButtons:2];
//            }
//            else {
//                cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
//                cell.rightSwipeSettings.onlySwipeButtons = NO;
//                cell.rightButtons = [self createRightButtons:2];
//            }
//            //#endif
//        }
//        else {
//            cell.rightButtons = nil;
//        }
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelPrice setTextAlignment:NSTextAlignmentLeft];
//            [cell.labelExpCanDate setTextAlignment:NSTextAlignmentLeft];
            [cell.labelValidity setTextAlignment:NSTextAlignmentLeft];
            [cell.labelOrder setTextAlignment:NSTextAlignmentLeft];
            [cell.labelStatus setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelPrice setTextAlignment:NSTextAlignmentRight];
//            [cell.labelExpCanDate setTextAlignment:NSTextAlignmentRight];
            [cell.labelValidity setTextAlignment:NSTextAlignmentRight];
            [cell.labelOrder setTextAlignment:NSTextAlignmentRight];
            [cell.labelStatus setTextAlignment:NSTextAlignmentRight];
        }
        
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
//        else if(indexPath.row == 1) {
//            OrderHistoryViewController *orderHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//            [[self navigationController] pushViewController:orderHistoryViewController animated:YES];
//        }
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
        
        [self.labelTitle setText:NSLocalizedString(@"My Orders", @"My Orders")];
        
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
//        if([self.strOrderType integerValue] == 3 || [self.strOrderType integerValue] == 5 || [self.strOrderType integerValue] == 11)
//            return;
//        self.ticketContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderTicketViewController"];
//        self.ticketContentView.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//        self.ticketContentView.delegate = self;
//        self.ticketContentView.strOrderId = self.arrayMyOrders[indexPath.row][@"order_id"];
//        [self.view addSubview:self.ticketContentView.view];
//        [UIView animateWithDuration:.3 animations:^{
//            [self.ticketContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
//        } completion:^(BOOL finished) {
//            self.tabBarController.tabBar.hidden = YES;
//        }];
        
        
        NSDictionary *def = self.arrayMyOrders[indexPath.row];

        if([def[@"order_status_id"] integerValue] == 7 || [def[@"order_status_id"] integerValue] == 5 || [def[@"order_status_id"] integerValue] == 11 || [def[@"order_status_id"] integerValue] == 6 || [def[@"order_status_id"] integerValue] == 13)
            return;
        
        NSString *strTransaction;
        if(globalShare.myLanguage == ARABIC_LANGUAGE)
            strTransaction = [NSString stringWithFormat:@"%@ - %@ %@ %@", [GlobalShare formatStringToTwoDigits:def[@"price"]], def[@"symbol"], [GlobalShare createCommaSeparatedString:def[@"qty"]], (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"order_type_desc_e"] : def[@"order_type_desc_a"]];
        else
            strTransaction = [NSString stringWithFormat:@"%@ %@ %@ - %@", (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"order_type_desc_e"] : def[@"order_type_desc_a"], [GlobalShare createCommaSeparatedString:def[@"qty"]], def[@"symbol"], [GlobalShare formatStringToTwoDigits:def[@"price"]]];

        self.activeContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveOrdersViewController"];
        self.activeContentView.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.activeContentView.delegate = self;
        self.activeContentView.strOrderId = def[@"order_id"];
        self.activeContentView.securityId = def[@"symbol"];
        self.activeContentView.strOrderType =def[@"order_type_desc_e"];
        self.activeContentView.strOrderDetails = strTransaction;
        [self.view addSubview:self.activeContentView.view];
        [UIView animateWithDuration:.3 animations:^{
            [self.activeContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        } completion:^(BOOL finished) {
            self.tabBarController.tabBar.hidden = YES;
        }];
    }
}

#pragma mark - MGSwipeTableCell delegate

//#if TEST_USE_MG_DELEGATE
//-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
//             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
//{
//    if (direction == MGSwipeDirectionLeftToRight) {
//        return nil;
//    }
//    else {
//        if([self.strOrderType integerValue] == 3 || [self.strOrderType integerValue] == 8)
//            return [self createRightButtons:2];
//        else
//            return nil;
//    }
//}
//#endif

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    self.strOrderId = self.arrayMyOrders[cell.tag][@"order_id"];
    if(index == 0) {
        [self showAlertViewTwoActions:CANCEL_ORDER_CONFIRM];
    }
    else {
        NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
        newOrderViewController.securityId = self.arrayMyOrders[cell.tag][@"symbol"];
        newOrderViewController.strOrderId = self.strOrderId;
        [[GlobalShare sharedInstance] setIsDirectOrder:NO];
        [[GlobalShare sharedInstance] setIsBuyOrder:YES];
        [[self navigationController] pushViewController:newOrderViewController animated:YES];
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
    NSString* titles[2] = {NSLocalizedString(@"Cancel", @"Cancel"), NSLocalizedString(@"Modify", @"Modify")};
    
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
    NSString* titles[2] = {NSLocalizedString(@"Cancel", @"Cancel"), NSLocalizedString(@"Modify", @"Modify")};
    
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

-(void)createCircleWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle name:(NSString *)name view:(UIView *)view {
    
    UIView *subView = view;
    
    // Set up the shape of the circle
    int radius = 25;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    // Make a circular shape
    UIBezierPath *path=[UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    circle.path = [path CGPath];
    
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(subView.bounds)-radius,
                                  CGRectGetMidY(subView.bounds)-radius);
    
    circle.fillColor = [UIColor clearColor].CGColor;
    
    //making line end cap round
    //    circle.lineCap=kCALineCapRound;
    
    UIColor *strokeColor;
    
    if([name isEqualToString:@"A"])
        //        strokeColor=[UIColor redColor];
        strokeColor=[UIColor colorWithRed:106.0/255.0 green:167.0/255.0 blue:134.0/255.0 alpha:1.0];
    else if([name isEqualToString:@"B"])
        //        strokeColor=[UIColor greenColor];
        strokeColor=[UIColor colorWithRed:53.0/255.0 green:194.0/255.0 blue:209.0/255.0 alpha:1.0];
    else if([name isEqualToString:@"C"])
        //        strokeColor=[UIColor blueColor];
        strokeColor=[UIColor colorWithRed:255/255.0 green:140/255.0 blue:157/255.0 alpha:1.0];
    
    circle.strokeColor = strokeColor.CGColor;
    circle.lineWidth = 8;
    
    // Add to parent layer
    [subView.layer addSublayer:circle];
}

//- (UIRectEdge)edgesForExtendedLayout {
//    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
//}

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
    
    [self.labelTitle setText:NSLocalizedString(@"My Orders", @"My Orders")];
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
