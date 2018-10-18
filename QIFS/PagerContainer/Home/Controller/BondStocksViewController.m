//
//  BondStocksViewController.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "BondStocksViewController.h"
#import "AppDelegate.h"
#import "BondStocksCell.h"
#import <QuartzCore/QuartzCore.h>

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height

@interface BondStocksViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayBondStocks;

@property (weak, nonatomic) IBOutlet UILabel *labelChangeCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelVolumeCaption;

@end

@implementation BondStocksViewController

@synthesize tableViewStocks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

//    self.arrayBondStocks = @[
//                         @{
//                             @"Symbol": @"GA09",
//                             @"Name": @"GA10 2.75% 150619",
//                             @"Price": @"59.47",
//                             @"PercentageChange": @"-0.72%",
//                             @"Volume": @"237,891,346"
//                             },
//                         @{
//                             @"Symbol": @"GA10",
//                             @"Name": @"GA11 2.75% 150619",
//                             @"Price": @"566.24",
//                             @"PercentageChange": @"+2.57%",
//                             @"Volume": @"647,891,346"
//                             },
//                         @{
//                             @"Symbol": @"GA11",
//                             @"Name": @"Tbill 9m 05086678",
//                             @"Price": @"8,693.59",
//                             @"PercentageChange": @"+1.15%",
//                             @"Volume": @"787,891,346"
//                             },
//                         @{
//                             @"Symbol": @"TB04",
//                             @"Name": @"Tbill 9m 045495566",
//                             @"Price": @"12,793.59",
//                             @"PercentageChange": @"+1.15%",
//                             @"Volume": @"289,891,346"
//                             }
//                         ];
//    
//    [tableViewStocks reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelChangeCaption setTextAlignment:NSTextAlignmentLeft];
        [self.labelVolumeCaption setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelChangeCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelVolumeCaption setTextAlignment:NSTextAlignmentRight];
    }
    
    [[GlobalShare sharedInstance] setCanAutoRotateL:NO];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getBondsList) withObject:nil afterDelay:0.01f];
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
    
}

#pragma mark - Common actions

-(void) getBondsList {
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetBondsList"];
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
                                                                       self.arrayBondStocks = returnedDict[@"result"];  // update model objects on main thread
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayBondStocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BondStocksCell";
    BondStocksCell *cell = (BondStocksCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"BondStocksCell" owner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    
    NSDictionary *def = self.arrayBondStocks[indexPath.row];

//    cell.labelSymbol.text = def[@"Symbol"];
//    cell.labelCompanyName.text = def[@"Name"];
//    cell.labelPrice.text = def[@"Price"];
//    cell.labelPercentageChange.text = def[@"PercentageChange"];
//    cell.labelVolume.text = def[@"Volume"];

//    ([def[@"PercentageChange"] hasPrefix:@"-"]) ? cell.labelPercentageChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f] : (cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:111/255.f blue:46/255.f alpha:1.f]);

    cell.labelSymbol.text = def[@"ticker"];
    cell.labelSecurityName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
    cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"comp_current_price"]];
    cell.labelPercentageChange.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
    cell.labelVolume.text = [GlobalShare createCommaSeparatedString:def[@"volume"]];

//    if([def[@"change"] hasPrefix:@"-"] || [def[@"change"] hasPrefix:@"+"]) {
//        if([def[@"change"] hasPrefix:@"+"]) {
//            cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//        }
//        else {
//            cell.labelPercentageChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//        }
//    }
//    else {
//        cell.labelPercentageChange.textColor = [UIColor darkGrayColor];
//    }
    
    if([def[@"change"] hasPrefix:@"-"]) {
        cell.labelPercentageChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
    }
    else if([def[@"change"] hasPrefix:@"+"]) {
        cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
    }
    else {
        if([GlobalShare returnIfGreaterThanZero:[def[@"change"] doubleValue]]) {
            cell.labelPercentageChange.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
            cell.labelPercentageChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            cell.labelPercentageChange.textColor = [UIColor darkGrayColor];
        }
    }

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [cell.labelPrice setTextAlignment:NSTextAlignmentLeft];
        [cell.labelPercentageChange setTextAlignment:NSTextAlignmentLeft];
        [cell.labelVolume setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [cell.labelPrice setTextAlignment:NSTextAlignmentRight];
        [cell.labelPercentageChange setTextAlignment:NSTextAlignmentRight];
        [cell.labelVolume setTextAlignment:NSTextAlignmentRight];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];

    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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


#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Bonds";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
