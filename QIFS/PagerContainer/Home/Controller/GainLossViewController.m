//
//  GainLossViewController.m
//  QIFS
//
//  Created by zylog on 06/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "GainLossViewController.h"
#import "GainLossCell.h"
#import "CompanyStocksViewController.h"

NSString *const kGainLossCellIdentifier = @"GainLossCell";

@interface GainLossViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentGainLoss;
@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSArray *arrayGainLossStocks;
@property (nonatomic, strong) NSArray *arrayLossStocks;
@property (nonatomic, strong) NSString *isGainLoss;

@end

@implementation GainLossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalShare = [GlobalShare sharedInstance];
    self.isGainLoss = @"true";
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    if(![[GlobalShare sharedInstance] isTimerGainLossRun])
//        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
    
    [[GlobalShare sharedInstance] setCanAutoRotateL:NO];
    
//    self.arrayGainLossStocks = @[
////                         @{
////                             @"Symbol": @"CMCSA",
////                             @"Name": @"Comcast Corp",
////                             @"Value": @"59.47",
////                             //                          @"Volume": @"1.23M",
////                             @"Volume": @"H:60.12 L:58.44",
////                             @"Change": @"-0.72",
////                             @"PerChange": @"-1.23%",
////                             @"UpDown": @"Down"
////                             },
//                         @{
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Value": @"83.38",
//                             //                          @"Volume": @"1.13M",
//                             @"Volume": @"H:84.89 L:82.74",
//                             @"Change": @"+1.15",
//                             @"PerChange": @"+0.38%",
//                             @"UpDown": @"Up"
//                             },
////                         @{
////                             @"Symbol": @"AAPL",
////                             @"Name": @"Apple",
////                             @"Value": @"93.59",
////                             //                          @"Volume": @"2.43M",
////                             @"Volume": @"H:93.59 L:93.59",
////                             @"Change": @"0.00",
////                             @"PerChange": @"0.00%",
////                             @"UpDown": @"UpDown"
////                             },
//                         @{
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Value": @"566.24",
//                             //                          @"Volume": @"2.43M",
//                             @"Volume": @"H:570.78 L:563.44",
//                             @"Change": @"+2.57",
//                             @"PerChange": @"+0.46%",
//                             @"UpDown": @"Up"
//                             }
//                         ];
    
    //    [_tableViewStocks reloadData];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getTickerByChange) withObject:nil afterDelay:0.01f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)segmentedControlIndexChanged:(id)sender {
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }

    switch (self.segmentGainLoss.selectedSegmentIndex) {
        case 0:
            self.isGainLoss = @"true";
            break;
        case 1:
            self.isGainLoss = @"false";
            break;
        default:
            break;
   }
    [self performSelector:@selector(getTickerByChange) withObject:nil afterDelay:0.01f];
}

#pragma mark - Common actions

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerGainLossRun:YES];
    globalShare.timerGainLoss = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getTickerByChange) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerGainLoss forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void) getTickerByChange {
    @try {
    [self.indicatorView setHidden:NO];
    
    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetTickerByChange?isGainer=", self.isGainLoss];
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
//                                                                   if([returnedDict[@"result"] isKindOfClass:[NSDictionary class]] || [returnedDict[@"result"] isKindOfClass:[NSMutableDictionary class]]) {
                                                                   if([returnedDict[@"result"] isKindOfClass:[NSArray class]] || [returnedDict[@"result"] isKindOfClass:[NSMutableArray class]]) {
                                                                       self.arrayGainLossStocks = returnedDict[@"result"];  // update model objects on main thread
                                                                   }
                                                                   else {
                                                                       self.arrayGainLossStocks = nil;
                                                                   }

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([self.arrayGainLossStocks count] > 0)
        return 1;
//    else {
//        // Display a message when the table is empty
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"No data is currently available.";
//        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        
//        tableView.backgroundView = messageLabel;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    
//    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayGainLossStocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GainLossCell *cell = (GainLossCell *) [tableView dequeueReusableCellWithIdentifier:kGainLossCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *def = self.arrayGainLossStocks[indexPath.row];
    
//    cell.labelSymbol.text = def[@"Symbol"];
//    cell.labelSecurityName.text = def[@"Name"];
//    cell.labelPrice.text = def[@"Value"];
//    cell.labelHighLow.text = def[@"Volume"];
//    cell.labelChange.text = def[@"Change"];
//    cell.labelPercentChange.text = def[@"PerChange"];
//    
//    if([def[@"UpDown"] isEqualToString:@"UpDown"]) {
//        [cell.imageUpDown setImage:nil];
//        cell.labelColor.backgroundColor = [UIColor darkGrayColor];
//    }
//    else {
//        [cell.imageUpDown setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Arrow.png",def[@"UpDown"]]]];
//        ([def[@"UpDown"] isEqualToString:@"Up"]) ? cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f] : (cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f]);
//    }

    cell.labelSymbol.text = def[@"ticker"];
    cell.labelSecurityName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
    cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"comp_current_price"]];
    cell.labelHighLow.text = [NSString stringWithFormat:@"H:%@  L:%@", [GlobalShare formatStringToTwoDigits:def[@"high"]], [GlobalShare formatStringToTwoDigits:def[@"low"]]];
    cell.labelChange.text = [GlobalShare formatStringToTwoDigits:def[@"change"]];
    cell.labelPercentChange.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
    
//    if([def[@"change"] hasPrefix:@"-"] || [def[@"change"] hasPrefix:@"+"]) {
//        if([def[@"change"] hasPrefix:@"+"]) {
//            [cell.imageUpDown setImage:[UIImage imageNamed:@"Up_Arrow.png"]];
//            cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//        }
//        else {
//            [cell.imageUpDown setImage:[UIImage imageNamed:@"Down_Arrow.png"]];
//            cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//        }
//    }
//    else {
//        [cell.imageUpDown setImage:nil];
//        cell.labelColor.backgroundColor = [UIColor darkGrayColor];
//    }

    if([def[@"change"] hasPrefix:@"-"]) {
        [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_down_arrow"]];
        cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
    }
    else if([def[@"change"] hasPrefix:@"+"]) {
        [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
        cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
    }
    else {
        if([GlobalShare returnIfGreaterThanZero:[def[@"change"] doubleValue]]) {
            cell.labelChange.text = [NSString stringWithFormat:@"+%@", [GlobalShare formatStringToTwoDigits:def[@"change"]]];
            cell.labelPercentChange.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
            [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
            cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            [cell.imageUpDown setImage:nil];
            cell.labelColor.backgroundColor = [UIColor darkGrayColor];
        }
    }
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        cell.labelChange.textAlignment = NSTextAlignmentLeft;
        cell.labelPercentChange.textAlignment = NSTextAlignmentLeft;
    }
    else {
        cell.labelChange.textAlignment = NSTextAlignmentRight;
        cell.labelPercentChange.textAlignment = NSTextAlignmentRight;
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    cell.labelColor.layer.cornerRadius = 3;
    cell.labelColor.layer.masksToBounds = YES;
    
    return cell;
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
    CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
    companyStocksViewController.securityId = self.arrayGainLossStocks[indexPath.row][@"ticker"];
    companyStocksViewController.securityName = self.arrayGainLossStocks[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
    [globalShare.topNavController pushViewController:companyStocksViewController animated:YES];
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Gain/Loss";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
