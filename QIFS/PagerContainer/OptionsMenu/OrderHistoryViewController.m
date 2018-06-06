//
//  OrderHistoryViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryCell.h"

NSString *const kOrderHistoryCellIdentifier = @"OrderHistoryCell";

@interface OrderHistoryViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOrders;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSArray *arrayOrdersHistory;
@property (nonatomic, weak) IBOutlet UIButton *buttonFilter;
@property (nonatomic, weak) IBOutlet UIView *viewFilterMenu;
@property (nonatomic, weak) IBOutlet UITableView *tableViewFilter;
@property (nonatomic, strong) NSArray *arrayFilter;
@property (nonatomic, strong) UIButton *transparencyButton;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) BOOL hasMoreData;

@property (weak, nonatomic) IBOutlet UILabel *labelPriceCaption;

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Order History", @"Order History")];
    self.tableViewOrders.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.arrayFilter = [NSArray arrayWithObjects:NSLocalizedString(@"Last Week", @"Last Week"), NSLocalizedString(@"Last Month", @"Last Month"), NSLocalizedString(@"Last 3 Months", @"Last 3 Months"), nil];

    [self.tableViewFilter setSeparatorInset:UIEdgeInsetsZero];
    [self.tableViewFilter setLayoutMargins:UIEdgeInsetsZero];

//    self.arrayOrdersHistory = @[
//                         @{
//                             @"Symbol": @"CMCSA",
//                             @"Name": @"Comcast Corp",
//                             @"Order": @"Buy",
//                             @"Price": @"59.47",
//                             @"OrgQty": @"12,234",
//                             @"Duration": @"17/07/2016"
//                             },
//                         @{
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Order": @"Buy",
//                             @"Price": @"566.24",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Week"
//                             },
//                         @{
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Order": @"Sell",
//                             @"Price": @"83.38",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Month"
//                             },
//                         @{
//                             @"Symbol": @"AAPL",
//                             @"Name": @"Apple",
//                             @"Order": @"Sell",
//                             @"Price": @"93.38",
//                             @"OrgQty": @"12",
//                             @"Duration": @"Day"
//                             }
//                         ];

    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [_footerView addSubview:actInd];
    
    actInd = nil;
    self.hasMoreData = YES;
//    [self.tableViewOrders reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelPriceCaption setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelPriceCaption setTextAlignment:NSTextAlignmentRight];
    }
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    
    NSDate *fromDate = [GlobalShare returnHistoryDate:0];
    [self performSelector:@selector(getSubmittedOrders:) withObject:fromDate afterDelay:0.01f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionOptionMenu:(id)sender {
    if ([_viewFilterMenu isHidden]) {
        [_viewFilterMenu setHidden:NO];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_viewFilterMenu.layer addAnimation:animation forKey:@""];
        
        _viewFilterMenu.layer.borderWidth = 1.0;
        _viewFilterMenu.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
        
        _transparencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transparencyButton.frame = self.view.bounds;
//        self.transparencyButton.backgroundColor = [UIColor lightGrayColor];
        [_transparencyButton addTarget:self action:@selector(backgroundTappedMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:self.transparencyButton belowSubview:_viewFilterMenu];
    }
    else {
        [_viewFilterMenu setHidden:YES];
        [_transparencyButton setAlpha:1.0];
        [self.transparencyButton removeFromSuperview];
        self.transparencyButton = nil;
    }
}

- (void)backgroundTappedMenu:(id)sender {
    [_transparencyButton setAlpha:1.0];
    if(![self.viewFilterMenu isHidden])
        [self.viewFilterMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGPoint val = scrollView.contentOffset;
//    BOOL endOfTable = (scrollView.contentOffset.y >= ((self.arrayOrdersHistory.count * 68) - scrollView.frame.size.height)); // Here 40 is row height
//    
//    if (self.hasMoreData && endOfTable && !scrollView.dragging && !scrollView.decelerating)
//    {
//        self.tableViewOrders.tableFooterView = _footerView;
//        
//        [(UIActivityIndicatorView *)[_footerView viewWithTag:10] startAnimating];
//    }}

#pragma mark - Common actions

-(void) getSubmittedOrders:(NSDate *)fromDate {
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strFromDate = [GlobalShare returnUSDate:fromDate];
        NSString *strToDate = [GlobalShare returnUSDate:[NSDate date]];
        NSString *strParams = [NSString stringWithFormat:@"?fromDate=%@&toDate=%@", strFromDate, strToDate];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
//        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetSubmittedOrders?fromDate=01/01/2015&toDate=12/31/2016"];
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetSubmittedOrders", strParams];
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
//                                                                       self.arrayOrdersHistory = returnedDict[@"result"];
                                                                       
                                                                       NSPredicate *applePred = [NSPredicate predicateWithFormat:@"executed_qty.intValue > %d", 0];
                                                                       NSArray *arrFiltered = [returnedDict[@"result"] filteredArrayUsingPredicate:applePred];

//                                                                       NSMutableArray *newArray = [[NSMutableArray alloc] init];
//                                                                       [newArray addObjectsFromArray:arrFiltered];
                                                                       
                                                                       self.arrayOrdersHistory = [NSArray arrayWithArray:arrFiltered];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tableViewFilter])         return [self.arrayFilter count];
    else    return [self.arrayOrdersHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableViewOrders]) {
        OrderHistoryCell *cell = (OrderHistoryCell *) [tableView dequeueReusableCellWithIdentifier:kOrderHistoryCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayOrdersHistory[indexPath.row];
        
//        cell.labelSymbol.text = def[@"Symbol"];
//        cell.labelCompanyName.text = def[@"Name"];
//        cell.labelOrder.text = def[@"Order"];
//        cell.labelPrice.text = def[@"Price"];
//        cell.labelQty.text = def[@"OrgQty"];
//
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        if([def[@"Order"] isEqualToString:@"Buy"])
//            cell.labelOrder.textColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.f];
//        else
//            cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];

        cell.labelSymbol.text = def[@"symbol"];
        cell.labelCompanyName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
        cell.labelOrder.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"order_type_desc_e"] : def[@"order_type_desc_a"];
        cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"price"]];
        cell.labelQty.text = [GlobalShare createCommaSeparatedString:def[@"qty"]];
        cell.labelExpCanDate.text = def[@"expiry_date"];
        cell.labelDate.text = [NSString stringWithFormat:@"%@", [def[@"order_date"] componentsSeparatedByString:@" "][0]];
        
//        if([[def[@"order_type_desc_e"] uppercaseString] isEqualToString:@"BUY"])
        if([def[@"order_type_id"] integerValue] == 1)
            cell.labelOrder.textColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.f];
        else
            cell.labelOrder.textColor = [UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f];
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelPrice setTextAlignment:NSTextAlignmentLeft];
            [cell.labelExpCanDate setTextAlignment:NSTextAlignmentLeft];
            [cell.labelValidity setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelPrice setTextAlignment:NSTextAlignmentRight];
            [cell.labelExpCanDate setTextAlignment:NSTextAlignmentRight];
            [cell.labelValidity setTextAlignment:NSTextAlignmentRight];
        }

        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = self.arrayFilter[indexPath.row];
        
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
    [_transparencyButton setAlpha:1.0];
    if(![self.viewFilterMenu isHidden])
        [self.viewFilterMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
    
    if ([tableView isEqual:self.tableViewFilter]) {
        NSDate *fromDate = [GlobalShare returnHistoryDate:indexPath.row];
        [self performSelector:@selector(getSubmittedOrders:) withObject:fromDate afterDelay:0.01f];
    }
}

@end
