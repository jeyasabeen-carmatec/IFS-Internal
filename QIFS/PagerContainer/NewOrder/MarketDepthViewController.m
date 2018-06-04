//
//  MarketDepthViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "MarketDepthViewController.h"
#import "MDPriceBidCell.h"
#import "MDPriceAskCell.h"
#import "MDOrderBidCell.h"
#import "MDOrderAskCell.h"
#import "MDBarView.h"

NSString *const kMDPriceBidCellIdentifier = @"MDPriceBidCell";
NSString *const kMDPriceAskCellIdentifier = @"MDPriceAskCell";
NSString *const kMDOrderBidCellIdentifier = @"MDOrderBidCell";
NSString *const kMDOrderAskCellIdentifier = @"MDOrderAskCell";

@interface MarketDepthViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableViewPriceBid;
@property (nonatomic, weak) IBOutlet UITableView *tableViewPriceAsk;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOrderBid;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOrderAsk;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;

@property (nonatomic, weak) IBOutlet UILabel *labelBidTotal;
@property (nonatomic, weak) IBOutlet UILabel *labelBidTotalQty;
@property (nonatomic, weak) IBOutlet UILabel *labelAskTotal;
@property (nonatomic, weak) IBOutlet UILabel *labelAskTotalQty;
@property (nonatomic, weak) IBOutlet UILabel *labelBidTotalOrderQty;
@property (nonatomic, weak) IBOutlet UILabel *labelAskTotalOrderQty;

@property (strong, nonatomic) NSArray *arrayMarketPriceBid;
@property (strong, nonatomic) NSArray *arrayMarketPriceAsk;
@property (strong, nonatomic) NSArray *arrayMarketOrderBid;
@property (strong, nonatomic) NSArray *arrayMarketOrderAsk;
@property (assign, nonatomic) double maxPriceBidValue;
@property (assign, nonatomic) double maxPriceAskValue;

@property (weak, nonatomic) IBOutlet UILabel *labelOrderBidQtyCaption;

@end

@implementation MarketDepthViewController

//@synthesize tableViewPriceBid;
//@synthesize tableViewPriceAsk;
//@synthesize tableViewOrderBid;
//@synthesize tableViewOrderAsk;

@synthesize securityId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Market Depth", @"Market Depth")];
    [[GlobalShare sharedInstance] setIsConfirmOrder:YES];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:NO];
//    self.tableViewPriceBid.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableViewPriceAsk.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableViewOrderBid.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableViewOrderAsk.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableViewPriceBid setSeparatorInset:UIEdgeInsetsZero];
    [self.tableViewPriceBid setLayoutMargins:UIEdgeInsetsZero];

    [self.tableViewPriceAsk setSeparatorInset:UIEdgeInsetsZero];
    [self.tableViewPriceAsk setLayoutMargins:UIEdgeInsetsZero];

    [self.tableViewOrderBid setSeparatorInset:UIEdgeInsetsZero];
    [self.tableViewOrderBid setLayoutMargins:UIEdgeInsetsZero];

    [self.tableViewOrderAsk setSeparatorInset:UIEdgeInsetsZero];
    [self.tableViewOrderAsk setLayoutMargins:UIEdgeInsetsZero];

//    tableViewOrder.estimatedRowHeight = 2.0;
//    tableViewOrder.rowHeight = UITableViewAutomaticDimension;

    self.tableViewPriceBid.scrollEnabled = NO;
    self.tableViewPriceAsk.scrollEnabled = NO;
    self.tableViewOrderBid.scrollEnabled = NO;
    self.tableViewOrderAsk.scrollEnabled = NO;
    
//    self.tableViewPriceBid.layer.borderWidth = 1.0;
//    self.tableViewPriceBid.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.tableViewPriceAsk.layer.borderWidth = 1.0;
//    self.tableViewPriceAsk.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.tableViewOrderBid.layer.borderWidth = 1.0;
//    self.tableViewOrderBid.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.tableViewOrderAsk.layer.borderWidth = 1.0;
//    self.tableViewOrderAsk.layer.borderColor = [UIColor darkGrayColor].CGColor;

    [self clearMarketOrderPrice];
//    self.labelSymbol.text = self.securityId;
    
//    self.arrayMarketPrice = @[
//                        @{
//                            @"NoOfSharesBuy": @"2",
//                            @"SharesBuy": @"2,000",
//                            @"PriceBuy": @"M.P",
//                            @"PriceSell": @"M.P",
//                            @"SharesSell": @"1,000",
//                            @"NoOfSharesSell": @"1"
//                            },
//                        @{
//                            @"NoOfSharesBuy": @"2",
//                            @"SharesBuy": @"1,000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2,000",
//                            @"NoOfSharesSell": @"1"
//                            },
//                        @{
//                            @"NoOfSharesBuy": @"2",
//                            @"SharesBuy": @"3,000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"200",
//                            @"NoOfSharesSell": @"1"
//                            },
//                        @{
//                            @"NoOfSharesBuy": @"2",
//                            @"SharesBuy": @"500",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"3,000",
//                            @"NoOfSharesSell": @"1"
//                            },
//                        //                         @{
//                        //                             @"NoOfSharesBuy": @"2",
//                        //                             @"SharesBuy": @"300",
//                        //                             @"PriceBuy": @"23.11",
//                        //                             @"PriceSell": @"23.45",
//                        //                             @"SharesSell": @"2000",
//                        //                             @"NoOfSharesSell": @"1"
//                        //                             },
//                        @{
//                            @"NoOfSharesBuy": @"2",
//                            @"SharesBuy": @"4,000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2,500",
//                            @"NoOfSharesSell": @"1"
//                            }
//                        ];
//    self.arrayMarketOrder = @[
//                        @{
//                            @"SharesBuy": @"2000",
//                            @"PriceBuy": @"M.P",
//                            @"PriceSell": @"M.P",
//                            @"SharesSell": @"1000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            },
//                        @{
//                            @"SharesBuy": @"3000",
//                            @"PriceBuy": @"23.11",
//                            @"PriceSell": @"23.45",
//                            @"SharesSell": @"2000"
//                            }
//                        ];
//    
//    self.maxBuyValue = self.maxSellValue = 0;
//    for (NSDictionary *dict in self.arrayPrice) {
//        double valueB = [GlobalShare returnDoubleFromString:dict[@"SharesBuy"]];
//        double valueS = [GlobalShare returnDoubleFromString:dict[@"SharesSell"]];
//        if (valueB > self.maxBuyValue) {
//            self.maxBuyValue = valueB;
//        }
//        if (valueS > self.maxSellValue) {
//            self.maxSellValue = valueS;
//        }
//    }
//    
//    [self.tableViewPrice reloadData];
//    [self.tableViewOrder reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelOrderBidQtyCaption setTextAlignment:NSTextAlignmentLeft];
        
        [self.labelBidTotalOrderQty setTextAlignment:NSTextAlignmentLeft];
        [self.labelAskTotalOrderQty setTextAlignment:NSTextAlignmentRight];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelOrderBidQtyCaption setTextAlignment:NSTextAlignmentRight];
        
        [self.labelBidTotalOrderQty setTextAlignment:NSTextAlignmentRight];
        [self.labelAskTotalOrderQty setTextAlignment:NSTextAlignmentLeft];
    }
    
    if(![[GlobalShare sharedInstance] isTimerMarketDepthRun])
        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];

    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
//    [self performSelector:@selector(getMarketByPrice) withObject:nil afterDelay:0.01f];
//    [self performSelector:@selector(getMarketByOrder) withObject:nil afterDelay:0.01f];

    [self performSelector:@selector(getMarketDepthValues) withObject:nil afterDelay:0.01f];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:NO];
    if ([globalShare.timerMarketDepth isValid]) {
        [globalShare.timerMarketDepth invalidate];
        globalShare.timerMarketDepth = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common actions

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:YES];
    globalShare.timerMarketDepth = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getMarketDepthValues) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerMarketDepth forMode:NSRunLoopCommonModes];
    [runLoop run];
}

- (void)getMarketDepthValues {
    [self performSelector:@selector(getMarketByPrice) withObject:nil afterDelay:0.01f];
    [self performSelector:@selector(getMarketByOrder) withObject:nil afterDelay:0.01f];
}

- (void)showMarketByPriceValue {
    double bidTotal = 0, bidTotalQty = 0, askTotal = 0, askTotalQty = 0;
    self.maxPriceBidValue = self.maxPriceAskValue = 0;
    for (NSDictionary *dict in self.arrayMarketPriceBid) {
        double valueBid = [GlobalShare returnDoubleFromString:dict[@"Qty"]];
        if (valueBid > self.maxPriceBidValue) {
            self.maxPriceBidValue = valueBid;
        }
        bidTotal = bidTotal + [GlobalShare returnDoubleFromString:dict[@"no_of_orders"]];
        bidTotalQty = bidTotalQty + [GlobalShare returnDoubleFromString:dict[@"Qty"]];
    }
    
    for (NSDictionary *dict in self.arrayMarketPriceAsk) {
        double valueAsk = [GlobalShare returnDoubleFromString:dict[@"Qty"]];
        if (valueAsk > self.maxPriceAskValue) {
            self.maxPriceAskValue = valueAsk;
        }
        askTotal = askTotal + [GlobalShare returnDoubleFromString:dict[@"no_of_orders"]];
        askTotalQty = askTotalQty + [GlobalShare returnDoubleFromString:dict[@"Qty"]];
    }

    self.labelBidTotal.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", bidTotal]];
    self.labelBidTotalQty.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", bidTotalQty]];
    self.labelAskTotal.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", askTotal]];
    self.labelAskTotalQty.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", askTotalQty]];
    
    [self.tableViewPriceBid reloadData];
    [self.tableViewPriceAsk reloadData];
}

- (void)showMarketByOrderValue {
    double bidTotalQty = 0, askTotalQty = 0;
    for (NSDictionary *dict in self.arrayMarketOrderBid) {
        bidTotalQty = bidTotalQty + [GlobalShare returnDoubleFromString:dict[@"qty"]];
    }
    
    for (NSDictionary *dict in self.arrayMarketOrderAsk) {
        askTotalQty = askTotalQty + [GlobalShare returnDoubleFromString:dict[@"qty"]];
    }

    self.labelBidTotalOrderQty.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", bidTotalQty]];
    self.labelAskTotalOrderQty.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.f", askTotalQty]];

    [self.tableViewOrderBid reloadData];
    [self.tableViewOrderAsk reloadData];
}

-(void) getMarketByPrice {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"MarketByPrice?ticker=", self.securityId];
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
                                                                       if([dictVal[@"marketDataBid"] isKindOfClass:[NSArray class]] || [dictVal[@"marketDataBid"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketPriceBid = dictVal[@"marketDataBid"];  // update model objects on main thread
                                                                       }
                                                                       else {
                                                                           self.arrayMarketPriceBid = nil;
                                                                       }

                                                                       if([dictVal[@"marketDataAsk"] isKindOfClass:[NSArray class]] || [dictVal[@"marketDataAsk"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketPriceAsk = dictVal[@"marketDataAsk"];  // update model objects on main thread
                                                                       }
                                                                       else {
                                                                           self.arrayMarketPriceAsk = nil;
                                                                       }

                                                                       [self showMarketByPriceValue];
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

-(void) getMarketByOrder {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"MarketByOrder?ticker=", self.securityId];
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
                                                                       if([dictVal[@"marketDataBid"] isKindOfClass:[NSArray class]] || [dictVal[@"marketDataBid"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketOrderBid = dictVal[@"marketDataBid"];  // update model objects on main thread
                                                                       }
                                                                       else {
                                                                           self.arrayMarketOrderBid = nil;
                                                                       }

                                                                       if([dictVal[@"marketDataAsk"] isKindOfClass:[NSArray class]] || [dictVal[@"marketDataAsk"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketOrderAsk = dictVal[@"marketDataAsk"];  // update model objects on main thread
                                                                       }
                                                                       else {
                                                                           self.arrayMarketOrderAsk = nil;
                                                                       }

//                                                                       [self showMarketByOrderValue];
                                                                       
                                                                       self.labelBidTotalOrderQty.text = [GlobalShare createCommaSeparatedString:dictVal[@"BidVol"]];
                                                                       self.labelAskTotalOrderQty.text = [GlobalShare createCommaSeparatedString:dictVal[@"AskVol"]];

                                                                       [self.tableViewOrderBid reloadData];
                                                                       [self.tableViewOrderAsk reloadData];
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

-(void) clearMarketOrderPrice {
    self.labelBidTotal.text = @"";
    self.labelBidTotalQty.text = @"";
    self.labelAskTotal.text = @"";
    self.labelAskTotalQty.text = @"";
    self.labelBidTotalOrderQty.text = @"";
    self.labelAskTotalOrderQty.text = @"";
}

#pragma mark - Button actions

- (IBAction)actionPhoneCall:(id)sender {
//    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"44498818"];
//    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSearch:(id)sender {

}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableViewPriceBid])         return [self.arrayMarketPriceBid count];
    if ([tableView isEqual:self.tableViewPriceAsk])         return [self.arrayMarketPriceAsk count];
    if ([tableView isEqual:self.tableViewOrderBid])         return [self.arrayMarketOrderBid count];
    else                                            return [self.arrayMarketOrderAsk count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView isEqual:tableViewPrice]) {
//        MDPriceCell *cell = (MDPriceCell *) [tableView dequeueReusableCellWithIdentifier:kMDPriceCellIdentifier forIndexPath:indexPath];
//
//        NSDictionary *def = self.arrayMarketPrice[indexPath.row];
//        
//        cell.labelBuyNoofShares.text = def[@"NoOfSharesBuy"];
//        cell.labelBuyShares.text = def[@"SharesBuy"];
//        cell.labelBuyPrice.text = def[@"PriceBuy"];
//        cell.labelSellPrice.text = def[@"PriceSell"];
//        cell.labelSellShares.text = def[@"SharesSell"];
//        cell.labelSellNoofShares.text = def[@"NoOfSharesSell"];
//        
//        [cell.labelBuyShares layoutIfNeeded];
//        [cell.labelSellShares layoutIfNeeded];
//
//        double percentVal = 0;
//        percentVal = ([GlobalShare returnDoubleFromString:def[@"SharesBuy"]]/self.maxBuyValue) * 100;
//        
//        MDBarView *barViewBuyShares = [[MDBarView alloc] initWithValues:[NSString stringWithFormat:@"%f", percentVal]];
//        barViewBuyShares.frame = CGRectMake(cell.labelBuyShares.frame.origin.x, cell.labelBuyShares.frame.origin.y, cell.labelBuyShares.frame.size.width, cell.labelBuyShares.frame.size.height);
//        barViewBuyShares.tag = 101;
//        [cell.contentView addSubview:barViewBuyShares];
//        [cell.contentView bringSubviewToFront:cell.labelBuyShares];
//        
//        percentVal = 0;
//        percentVal = ([GlobalShare returnDoubleFromString:def[@"SharesSell"]]/self.maxSellValue) * 100;
//        
//        MDBarView *barViewSellShares = [[MDBarView alloc] initWithValues:[NSString stringWithFormat:@"%f", percentVal]];
//        barViewSellShares.frame = CGRectMake(cell.labelSellShares.frame.origin.x, cell.labelSellShares.frame.origin.y, cell.labelSellShares.frame.size.width, cell.labelSellShares.frame.size.height);
//        barViewSellShares.tag = 102;
//        [cell.contentView addSubview:barViewSellShares];
//        [cell.contentView bringSubviewToFront:cell.labelSellShares];
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//    }
//    else {
//        MDOrderCell *cell = (MDOrderCell *) [tableView dequeueReusableCellWithIdentifier:kMDOrderCellIdentifier forIndexPath:indexPath];
//
//        NSDictionary *def = self.arrayMarketOrder[indexPath.row];
//        
//        cell.labelBuyShares.text = def[@"SharesBuy"];
//        cell.labelBuyPrice.text = def[@"PriceBuy"];
//        cell.labelSellPrice.text = def[@"PriceSell"];
//        cell.labelSellShares.text = def[@"SharesSell"];
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//    }
    
    if ([tableView isEqual:self.tableViewPriceBid]) {
        MDPriceBidCell *cell = (MDPriceBidCell *) [tableView dequeueReusableCellWithIdentifier:kMDPriceBidCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *def = self.arrayMarketPriceBid[indexPath.row];
        
        cell.labelBidNoofShares.text = def[@"no_of_orders"];
        cell.labelBidQty.text = [GlobalShare createCommaSeparatedString:def[@"Qty"]];
        if([def[@"price"] hasPrefix:@"-"])
            cell.labelBidPrice.text = @"M.P";
        else
            cell.labelBidPrice.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"price"]];
        
        [cell.labelBidQty layoutIfNeeded];
        
        double percentVal = 0;
        percentVal = ([GlobalShare returnDoubleFromString:def[@"Qty"]]/self.maxPriceBidValue) * 100;
        
        MDBarView *barViewBidShares = [[MDBarView alloc] initWithValues:[NSString stringWithFormat:@"%f", percentVal]];
//        barViewBidShares.frame = CGRectMake(cell.labelBidQty.frame.origin.x+1, cell.labelBidQty.frame.origin.y, cell.labelBidQty.frame.size.width-2, cell.labelBidQty.frame.size.height);
        
        CGRect myFrame;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            myFrame = CGRectMake(cell.labelBidQty.frame.origin.x+cell.labelBidQty.frame.size.width-1, cell.labelBidQty.frame.origin.y, cell.labelBidQty.frame.size.width-2, cell.labelBidQty.frame.size.height);
//            [cell.labelBidQty setTextAlignment:NSTextAlignmentLeft];
//        }
//        else {
            myFrame = CGRectMake(cell.labelBidQty.frame.origin.x+1, cell.labelBidQty.frame.origin.y, cell.labelBidQty.frame.size.width-2, cell.labelBidQty.frame.size.height);
            [cell.labelBidQty setTextAlignment:NSTextAlignmentRight];
//        }
        
        barViewBidShares.frame = myFrame;
        barViewBidShares.tag = 101;
        [cell.contentView addSubview:barViewBidShares];
        [cell.contentView bringSubviewToFront:cell.labelBidQty];
        
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            [cell.labelBidQty setTextAlignment:NSTextAlignmentLeft];
//        }
//        else {
//            [cell.labelBidQty setTextAlignment:NSTextAlignmentRight];
//        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if ([tableView isEqual:self.tableViewPriceAsk]) {
        MDPriceAskCell *cell = (MDPriceAskCell *) [tableView dequeueReusableCellWithIdentifier:kMDPriceAskCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *def = self.arrayMarketPriceAsk[indexPath.row];
        
        if([def[@"price"] hasPrefix:@"-"])
            cell.labelAskPrice.text = @"M.P";
        else
            cell.labelAskPrice.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"price"]];
        cell.labelAskQty.text = [GlobalShare createCommaSeparatedString:def[@"Qty"]];
        cell.labelAskNoofShares.text = def[@"no_of_orders"];
        
        [cell.labelAskQty layoutIfNeeded];
        
        double percentVal = 0;
        percentVal = ([GlobalShare returnDoubleFromString:def[@"Qty"]]/self.maxPriceAskValue) * 100;
        
        MDBarView *barViewSellShares = [[MDBarView alloc] initWithValues:[NSString stringWithFormat:@"%f", percentVal]];
//        barViewSellShares.frame = CGRectMake(cell.labelAskQty.frame.origin.x+1, cell.labelAskQty.frame.origin.y, cell.labelAskQty.frame.size.width-2, cell.labelAskQty.frame.size.height);
        
        CGRect myFrame;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            myFrame = CGRectMake(cell.labelAskQty.frame.origin.x+cell.labelAskQty.frame.size.width-1, cell.labelAskQty.frame.origin.y, cell.labelAskQty.frame.size.width-2, cell.labelAskQty.frame.size.height);
//            [cell.labelAskQty setTextAlignment:NSTextAlignmentLeft];
//        }
//        else {
            myFrame = CGRectMake(cell.labelAskQty.frame.origin.x+1, cell.labelAskQty.frame.origin.y, cell.labelAskQty.frame.size.width-2, cell.labelAskQty.frame.size.height);
            [cell.labelAskQty setTextAlignment:NSTextAlignmentRight];
//        }
        
        barViewSellShares.frame = myFrame;
        barViewSellShares.tag = 102;
        [cell.contentView addSubview:barViewSellShares];
        [cell.contentView bringSubviewToFront:cell.labelAskQty];
        
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            [cell.labelAskQty setTextAlignment:NSTextAlignmentLeft];
//        }
//        else {
//            [cell.labelAskQty setTextAlignment:NSTextAlignmentRight];
//        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if ([tableView isEqual:self.tableViewOrderBid]) {
        MDOrderBidCell *cell = (MDOrderBidCell *) [tableView dequeueReusableCellWithIdentifier:kMDOrderBidCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *def = self.arrayMarketOrderBid[indexPath.row];
        
        cell.labelBidQty.text = [GlobalShare createCommaSeparatedString:def[@"qty"]];
        if([def[@"price"] hasPrefix:@"-"])
            cell.labelBidPrice.text = @"M.P";
        else
            cell.labelBidPrice.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"price"]];
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelBidQty setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelBidQty setTextAlignment:NSTextAlignmentRight];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        MDOrderAskCell *cell = (MDOrderAskCell *) [tableView dequeueReusableCellWithIdentifier:kMDOrderAskCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *def = self.arrayMarketOrderAsk[indexPath.row];
        
        if([def[@"price"] hasPrefix:@"-"])
            cell.labelAskPrice.text = @"M.P";
        else
            cell.labelAskPrice.text = [GlobalShare createCommaSeparatedTwoDigitString:def[@"price"]];
        cell.labelAskQty.text = [GlobalShare createCommaSeparatedString:def[@"qty"]];
        
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

@end
