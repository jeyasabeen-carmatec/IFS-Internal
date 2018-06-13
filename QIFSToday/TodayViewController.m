//
//  TodayViewController.m
//  QIFSToday
//
//  Created by zylog on 25/08/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetListCell.h"

NSString *const kWidgetListCellIdentifier = @"WidgetListCell";

@interface TodayViewController () <NCWidgetProviding, NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UIButton *buttonOpenApp;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayWidgetStocks;
@property (nonatomic, strong) NSTimer *timerWidget;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    self.arrayWidgetStocks = @[
//                         @{
//                             @"Symbol": @"CMCSA",
//                             @"Name": @"Comcast Corp",
//                             @"Value": @"59.47",
//                             @"Volume": @"H:60.12 L:58.44",
//                             @"Change": @"-0.72",
//                             @"PerChange": @"-1.23%",
//                             @"UpDown": @"Down"
//                             },
//                         @{
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Value": @"566.24",
//                             @"Volume": @"H:570.78 L:563.44",
//                             @"Change": @"+2.57",
//                             @"PerChange": @"+0.46%",
//                             @"UpDown": @"Up"
//                             },
//                         @{
//                             @"Symbol": @"AAPL",
//                             @"Name": @"Apple",
//                             @"Value": @"93.59",
//                             @"Volume": @"H:93.59 L:93.59",
//                             @"Change": @"0.00",
//                             @"PerChange": @"0.00%",
//                             @"UpDown": @"UpDown"
//                             },
//                         @{
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Value": @"83.38",
//                             @"Volume": @"H:84.89 L:82.74",
//                             @"Change": @"+1.15",
//                             @"PerChange": @"+1.38%",
//                             @"UpDown": @"Up"
//                             }
//                         ];
    
    self.preferredContentSize = CGSizeMake(0, 212);
//    [_tableViewStocks reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
    [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

//    [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
//    [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.top = 0.0;
    margins.left = 0.0;
    margins.right = 0.0;
    margins.bottom = 0.0;
    return margins;
}

- (IBAction)actionOpenURL:(id)sender {
    NSURL *pjURL = [NSURL URLWithString:@"QIFSTodayApp://home"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}

#pragma mark - Common actions

- (void)callHeartBeatUpdate {
    self.timerWidget = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getMarketWatch) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timerWidget forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void) getMarketWatch {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
//        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetMarketWatch"];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               if([returnedDict[@"status"] hasPrefix:@"error"]) {
                                                                   return;
                                                               }
                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       self.arrayWidgetStocks = returnedDict[@"result"];  // update model objects on main thread
                                                                       [self.tableViewStocks reloadData];              // also update UI on main thread
                                                                   });
                                                               }
                                                           }
                                                           else {
                                                               return;
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

- (NSString *)formatStringToTwoDigits:(NSString *)strValue {
    NSString *stringRet = [NSString stringWithFormat:@"%.2f", [strValue doubleValue]];
    return stringRet;
}

- (BOOL)returnIfGreaterThanZero:(double)strCurrent {
    NSNumber *numberCurrent = [NSNumber numberWithDouble:strCurrent];
    NSNumber *numberMin = [NSNumber numberWithDouble:0.00];
    if([numberMin compare:numberCurrent] == NSOrderedAscending)
    {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWidgetStocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WidgetListCell *cell = (WidgetListCell *) [tableView dequeueReusableCellWithIdentifier:kWidgetListCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *def = self.arrayWidgetStocks[indexPath.row];
    
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
    @try
    {
    cell.labelSymbol.text = def[@"ticker"];
    
    cell.labelSecurityName.text = def[@"security_name_e"];
    cell.labelPrice.text = [self formatStringToTwoDigits:def[@"comp_current_price"]];
    cell.labelHighLow.text = [NSString stringWithFormat:@"H:%@  L:%@", [self formatStringToTwoDigits:def[@"high"]], [self formatStringToTwoDigits:def[@"low"]]];
    cell.labelChange.text = [self formatStringToTwoDigits:def[@"change"]];
    cell.labelPercentChange.text = [NSString stringWithFormat:@"%@%%", [self formatStringToTwoDigits:def[@"change_perc"]]];
    
    if([def[@"change"] hasPrefix:@"-"]) {
        [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_down_arrow"]];
        cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
    }
    else if([def[@"change"] hasPrefix:@"+"]) {
        [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
        cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
    }
    else {
        if([self returnIfGreaterThanZero:[def[@"change"] doubleValue]]) {
            cell.labelChange.text = [NSString stringWithFormat:@"+%@", [self formatStringToTwoDigits:def[@"change"]]];
            cell.labelPercentChange.text = [NSString stringWithFormat:@"+%@%%", [self formatStringToTwoDigits:def[@"change_perc"]]];
            [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
            cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            [cell.imageUpDown setImage:nil];
            cell.labelColor.backgroundColor = [UIColor darkGrayColor];
        }
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if(indexPath.row % 2 == 0)
//        cell.backgroundColor = [UIColor whiteColor];
//    else
//        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    cell.labelColor.layer.cornerRadius = 3;
    cell.labelColor.layer.masksToBounds = YES;
    }
    @catch(NSException *exception)
    {
        
    }
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
    NSURL *pjURL = [NSURL URLWithString:@"QIFSTodayApp://home"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}

@end
