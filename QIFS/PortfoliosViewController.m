//
//  PortfoliosViewController.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "PortfoliosViewController.h"
#import "PortfoliosCell.h"
#import "NewOrderViewController.h"

#import "AlertsViewController.h"
#import "CashPositionViewController.h"
#import "OrderHistoryViewController.h"
#import "ContactUsViewController.h"
#import "SettingsViewController.h"
#import "CompanyStocksViewController.h"
#import "OptionsViewCell.h"
#import "LoginView.h"
NSString *const kPortfoliosCellIdentifier = @"PortfoliosCell";
NSString *const kPortfoliosOptionsViewCellIdentifier = @"OptionsViewCell";

@interface PortfoliosViewController () <tabBarManageCashDelegate, NSURLSessionDelegate,UITextFieldDelegate>{
    LoginView *loginVw;
    UIView *overLayView;
}

@property (nonatomic, weak) IBOutlet UILabel *labelPortfolioValue;
@property (nonatomic, weak) IBOutlet UILabel *labelGainLoss;
@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayPortfolios;

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

@property (weak, nonatomic) IBOutlet UILabel *labelGainLossCaption;

@end

@implementation PortfoliosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"My Portfolio", @"My Portfolio")];
    [self.searchResults setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableResults setHidden:YES];
    
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
    
    overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    overLayView.clipsToBounds = YES;
    overLayView.hidden = YES;
    [self.view addSubview:overLayView];

    [self clearPortfolio];

//    self.arrayPortfolios = @[
//                      @{
//                          @"Symbol": @"CMCSA",
//                          @"Name": @"Comcast Corp",
//                          @"Qty": @"10,000",
//                          @"AvgPrice": @"60.58",
//                          @"Price": @"59.47",
//                          @"PerChange": @"-0.72(1.23%)",
//                          @"MktValue": @"11,233,459.47",
//                          @"GainLossVal": @"1,332,912.00",
//                          @"GainLoss": @"+2.43%"
//                          },
//                      @{
//                          @"Symbol": @"GOOGL",
//                          @"Name": @"Google Class A",
//                          @"Qty": @"50,000",
//                          @"AvgPrice": @"536.24",
//                          @"Price": @"566.24",
//                          @"PerChange": @"+2.57(+0.46%)",
//                          @"MktValue": @"323,459.47",
//                          @"GainLossVal": @"232,912.00",
//                          @"GainLoss": @"+1.24%"
//                          },
//                      @{
//                          @"Symbol": @"AAPL",
//                          @"Name": @"Apple",
//                          @"Qty": @"12,345",
//                          @"AvgPrice": @"95.59",
//                          @"Price": @"93.59",
//                          @"PerChange": @"+1.15(+0.42%)",
//                          @"MktValue": @"1,213,459.47",
//                          @"GainLossVal": @"121,912.00",
//                          @"GainLoss": @"-0.43%"
//                          }
//                      ];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.tableViewStocks reloadData];
    
//    if(![[GlobalShare sharedInstance] isTimerPortfolioRun])
//        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelGainLossCaption setTextAlignment:NSTextAlignmentLeft];

        [self.labelPortfolioValue setTextAlignment:NSTextAlignmentLeft];
        [self.labelGainLoss setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelGainLossCaption setTextAlignment:NSTextAlignmentRight];
        
        [self.labelPortfolioValue setTextAlignment:NSTextAlignmentRight];
        [self.labelGainLoss setTextAlignment:NSTextAlignmentRight];
    }

    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"]) {
        [self showsLoginPopUp];
    }
    else{
        
        [self performSelector:@selector(getPortfolio) withObject:nil afterDelay:0.01f];
        
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
    // [loginVw removeFromSuperview];
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

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerPortfolioRun:YES];
    globalShare.timerPortfolio = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getPortfolio) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerPortfolio forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void) getPortfolio {
    @try {
    [self.indicatorView setHidden:NO];
    
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"Get_Portfolio"];
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
                                                                   NSDictionary *dictVal = returnedDict[@"result"];
//                                                                   self.labelPortfolioValue.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"total_portfolio_value"]];
                                                                
                                                                   self.labelPortfolioValue.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"total_market_value"]];
                                                                   
                                                                   self.labelPortfolioValue.text = [GlobalShare checkingNullValues:self.labelPortfolioValue.text];
                                                                   self.labelGainLoss.text = [NSString stringWithFormat:@"%@(%@%%)", [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"total_gain_loss_value"]], [GlobalShare formatStringToTwoDigits:dictVal[@"total_gain_loss_perc"]]];
                                                                   
                                                                   self.labelGainLoss.text = [GlobalShare checkingNullValues:self.labelGainLoss.text];
                                                                   
//                                                                   if([[dictVal[@"total_gain_loss_value"] stringValue] hasPrefix:@"-"] || [[dictVal[@"total_gain_loss_value"] stringValue] hasPrefix:@"+"]) {
//                                                                       if([[dictVal[@"total_gain_loss_value"] stringValue] hasPrefix:@"+"]) {
//                                                                           self.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                                                                       }
//                                                                       else {
//                                                                           self.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                                                                       }
//                                                                   }
//                                                                   else {
//                                                                       self.labelGainLoss.textColor = [UIColor darkGrayColor];
//                                                                   }
                                                                   
                                                                   if([[dictVal[@"total_gain_loss_value"] stringValue] hasPrefix:@"-"]) {
                                                                       self.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                   }
                                                                   else if([[dictVal[@"total_gain_loss_value"] stringValue] hasPrefix:@"+"]) {
                                                                       self.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                   }
                                                                   else {
                                                                       if([GlobalShare returnIfGreaterThanZero:[dictVal[@"total_gain_loss_value"] doubleValue]]) {
                                                                           self.labelGainLoss.text = [NSString stringWithFormat:@"+%@(+%@%%)", [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"total_gain_loss_value"]], [GlobalShare formatStringToTwoDigits:dictVal[@"total_gain_loss_perc"]]];
                                                                           
                                                                            self.labelGainLoss.text = [GlobalShare checkingNullValues:self.labelGainLoss.text];
                                                                           self.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                       }
                                                                       else {
                                                                           self.labelGainLoss.textColor = [UIColor darkGrayColor];
                                                                       }
                                                                   }

                                                                   self.arrayPortfolios = dictVal[@"portfolio"];  // update model objects on main thread
                                                                   [self.tableViewStocks reloadData];              // also update UI on main thread

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

-(void) clearPortfolio {
    self.labelPortfolioValue.text = @"";
    self.labelGainLoss.text = @"";
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!searchController.active) {
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.labelTitle setText:NSLocalizedString(@"My Portfolio", @"My Portfolio")];
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
        return [self.arrayPortfolios count];
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
        
        OptionsViewCell *cell = (OptionsViewCell *) [tableView dequeueReusableCellWithIdentifier:kPortfoliosOptionsViewCellIdentifier forIndexPath:indexPath];
        
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
        @try
        {
        cell.textLabel.text = self.visibleResults[indexPath.row][@"ticker"];
        cell.detailTextLabel.text = self.visibleResults[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @catch(NSException *exception)
        {
            
        }
        
        return cell;
    }
    else {
        PortfoliosCell *cell = (PortfoliosCell *) [tableView dequeueReusableCellWithIdentifier:kPortfoliosCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayPortfolios[indexPath.row];

    //    cell.labelSymbol.text = def[@"Symbol"];
    //    cell.labelQty.text = def[@"Qty"];
    //    cell.labelAvgPrice.text = def[@"AvgPrice"];
    //    cell.labelMktValue.text = def[@"MktValue"];
    //    cell.labelGainLoss.text = def[@"GainLoss"];
    //    cell.labelGainLossVal.text = def[@"GainLossVal"];
    //    
    //    ([def[@"GainLoss"] hasPrefix:@"-"]) ? cell.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f] : (cell.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:111/255.f blue:46/255.f alpha:1.f]);
    //    ([def[@"GainLoss"] hasPrefix:@"-"]) ? cell.labelGainLossVal.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f] : (cell.labelGainLossVal.textColor = [UIColor colorWithRed:0/255.f green:111/255.f blue:46/255.f alpha:1.f]);
        
        @try
        {

        cell.labelSymbol.text = def[@"ticker"];
        cell.labelSymbol.text = [GlobalShare checkingNullValues:cell.labelSymbol.text];
        cell.label_AR_Symbol.text = def[@"security_name_a"];
        cell.label_AR_Symbol.text = [GlobalShare checkingNullValues:cell.label_AR_Symbol.text];

        cell.labelQty.text = [GlobalShare createCommaSeparatedString:def[@"qty"]];
        cell.labelQty.text = [GlobalShare checkingNullValues:cell.labelQty.text];

        cell.labelAvgPrice.text = [GlobalShare formatStringToTwoDigits:def[@"cost_price"]];
        cell.labelAvgPrice.text = [GlobalShare checkingNullValues:cell.labelAvgPrice.text];
        cell.labelMktValue.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"market_value"]];
        cell.labelMktValue.text = [GlobalShare checkingNullValues:cell.labelMktValue.text];

        cell.labelGainLoss.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:def[@"gain_loss_percentage"]]];

        cell.labelGainLossVal.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"gain_loss_value"]];
            cell.labelGainLoss.text = [GlobalShare checkingNullValues:cell.labelGainLoss.text];

    //    ([def[@"gain_loss_percentage"] hasPrefix:@"-"]) ? cell.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f] : (cell.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:111/255.f blue:46/255.f alpha:1.f]);
    //    ([def[@"gain_loss_value"] hasPrefix:@"-"]) ? cell.labelGainLossVal.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f] : (cell.labelGainLossVal.textColor = [UIColor colorWithRed:0/255.f green:111/255.f blue:46/255.f alpha:1.f]);

//        if([def[@"gain_loss_percentage"] hasPrefix:@"-"] || [def[@"gain_loss_percentage"] hasPrefix:@"+"]) {
//            if([def[@"gain_loss_percentage"] hasPrefix:@"+"]) {
//                cell.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                cell.labelGainLossVal.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//            }
//            else {
//                cell.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                cell.labelGainLossVal.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//            }
//        }
//        else {
//            cell.labelGainLoss.textColor = [UIColor darkGrayColor];
//            cell.labelGainLossVal.textColor = [UIColor darkGrayColor];
//        }

        if([def[@"gain_loss_percentage"] hasPrefix:@"-"]) {
            cell.labelGainLoss.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
            cell.labelGainLossVal.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
        }
        else if([def[@"gain_loss_percentage"] hasPrefix:@"+"]) {
            cell.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
            cell.labelGainLossVal.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            if([GlobalShare returnIfGreaterThanZero:[def[@"gain_loss_percentage"] doubleValue]]) {
                cell.labelGainLoss.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:def[@"gain_loss_percentage"]]];

                cell.labelGainLossVal.text = [NSString stringWithFormat:@"+%@", [GlobalShare createCommaSeparatedTwoDigitString:def[@"gain_loss_value"]]];
                cell.labelGainLoss.text = [GlobalShare checkingNullValues:cell.labelGainLoss.text];

                cell.labelGainLoss.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                cell.labelGainLossVal.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
            }
            else {
                cell.labelGainLoss.textColor = [UIColor darkGrayColor];
                cell.labelGainLossVal.textColor = [UIColor darkGrayColor];
            }
        }
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelMktValue setTextAlignment:NSTextAlignmentLeft];
            [cell.labelGainLossVal setTextAlignment:NSTextAlignmentLeft];
            [cell.labelGainLoss setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelMktValue setTextAlignment:NSTextAlignmentRight];
            [cell.labelGainLossVal setTextAlignment:NSTextAlignmentRight];
            [cell.labelGainLoss setTextAlignment:NSTextAlignmentRight];
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
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            [cell.contentView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        }
//        else {
//            [cell.contentView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//        }

        //#endif
        }
        @catch(NSException *exception)
        {
            
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
        
        [self.labelTitle setText:NSLocalizedString(@"My Portfolio", @"My Portfolio")];
        
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
        [[GlobalShare sharedInstance] setIsBuyOrSell:2];
    }
    else {
        [[GlobalShare sharedInstance] setIsBuyOrSell:1];
    }
    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
    newOrderViewController.securityId = self.arrayPortfolios[cell.tag][@"ticker"];
    newOrderViewController.strPortQty = self.arrayPortfolios[cell.tag][@"qty"];
    newOrderViewController.strPortOnSellQty = self.arrayPortfolios[cell.tag][@"on_sell"];
    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
    [[GlobalShare sharedInstance] setIsPortfolioOrder:YES];
    [[self navigationController] pushViewController:newOrderViewController animated:YES];
    
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
    NSString* titles[2] = {NSLocalizedString(@"Sell", @"Sell"), NSLocalizedString(@"Buy", @"Buy")};
    
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
    NSString* titles[2] = {NSLocalizedString(@"Sell", @"Sell"), NSLocalizedString(@"Buy", @"Buy")};
    
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
    
    [self.labelTitle setText:NSLocalizedString(@"My Portfolio", @"My Portfolio")];
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
