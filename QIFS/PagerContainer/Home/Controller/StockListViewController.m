//
//  StockListViewController.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "StockListViewController.h"
#import "StockListCell.h"
#import "PopoverViewController.h"
#import "StockList.h"

NSString *const kStockListCellIdentifier = @"StockListCell";

@interface UIView (Animation)
- (void)addSubviewWithBounce:(UIView*)theView;
@end

@implementation UIView (Animation)
-(void)addSubviewWithBounce:(UIView*)theView
{
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self addSubview:theView];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                theView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}
@end

@interface StockListViewController () <NSURLSessionDelegate, popupDelegate>

@property (nonatomic, weak) IBOutlet UIView *viewSector;
@property (nonatomic, weak) IBOutlet UIView *viewBasicFilter;
@property (nonatomic, weak) IBOutlet UITableView *tableViewStocks;
@property (nonatomic, weak) IBOutlet UITableView *tableViewSector;
@property (nonatomic, weak) IBOutlet UITableView *tableViewBasic;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *basics;
@property (nonatomic, strong) NSArray *arrayStockList;
@property (nonatomic, assign) BOOL isAscend;
@property (nonatomic, assign) NSInteger selFilterIndex;
@property (nonatomic, strong) PopoverViewController *contentVC;
@property (nonatomic, strong) UIButton *transparencyButton;

@end

@implementation StockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //globalShare = [GlobalShare sharedInstance];
//    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//
////    self.contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
//
//    self.transparencyButton = [[UIButton alloc] initWithFrame:self.view.bounds];
//    self.transparencyButton.backgroundColor = [UIColor clearColor];
//    self.transparencyButton.tag = 2000;
//    
//    _viewSector.layer.borderWidth = 1.0;
//    _viewSector.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
//    _viewBasicFilter.layer.borderWidth = 1.0;
//    _viewBasicFilter.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    globalShare = [GlobalShare sharedInstance];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    self.tableViewStocks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //    self.contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
    
    self.transparencyButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.transparencyButton.backgroundColor = [UIColor clearColor];
    self.transparencyButton.tag = 2000;
    
    _viewSector.layer.borderWidth = 1.0;
    _viewSector.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
    _viewBasicFilter.layer.borderWidth = 1.0;
    _viewBasicFilter.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;

    if(![[GlobalShare sharedInstance] isTimerStockListRun])
        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
    
    [[GlobalShare sharedInstance] setCanAutoRotateL:NO];
    self.isAscend = YES;
    self.selFilterIndex = 1000;
    
    self.basics = [NSArray arrayWithObjects:@"by Symbol", @"by Name", @"by Value", @"by % Change", nil];
    
//    self.arrayStockList = @[
//                         @{
//                             @"Symbol": @"CMCSA",
//                             @"Name": @"Comcast Corp",
//                             @"Value": @"59.47",
//                             @"Volume": @"H:60.12 L:58.44",
//                             @"Change": @"-0.72",
//                             @"PerChange": @"-1.23%",
//                             @"UpDown": @"Down",
//                             @"Ask": @"60.58 x 500",
//                             @"Bid": @"57.68 x 600"
//                             },
//                         @{
//                             @"Symbol": @"GOOGL",
//                             @"Name": @"Google Class A",
//                             @"Value": @"566.24",
//                             @"Volume": @"H:570.78 L:563.44",
//                             @"Change": @"+2.57",
//                             @"PerChange": @"+0.46%",
//                             @"UpDown": @"Up",
//                             @"Ask": @"570.58 x 500",
//                             @"Bid": @"560.68 x 600"
//                             },
//                         @{
//                             @"Symbol": @"AAPL",
//                             @"Name": @"Apple",
//                             @"Value": @"93.59",
//                             @"Volume": @"H:93.59 L:93.59",
//                             @"Change": @"0.00",
//                             @"PerChange": @"0.00%",
//                             @"UpDown": @"UpDown",
//                             @"Ask": @"94.59 x 500",
//                             @"Bid": @"95.59 x 600"
//                             },
//                         @{
//                             @"Symbol": @"FB",
//                             @"Name": @"Facebook",
//                             @"Value": @"83.38",
//                             @"Volume": @"H:84.89 L:82.74",
//                             @"Change": @"+1.15",
//                             @"PerChange": @"+1.38%",
//                             @"UpDown": @"Up",
//                             @"Ask": @"85.58 x 500",
//                             @"Bid": @"84.68 x 600"
//                             }
//                         ];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];

    [_tableViewBasic reloadData];
    [_tableViewSector reloadData];
//    [_tableViewStocks reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self dismissPopup];
    [[GlobalShare sharedInstance] setIsTimerStockListRun:NO];
    if ([globalShare.timerStockList isValid]) {
        [globalShare.timerStockList invalidate];
        globalShare.timerStockList = nil;
    }
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

- (IBAction)actionSector:(id)sender {
    [_viewBasicFilter setHidden:YES];
    if ([_viewSector isHidden]) {
        [_viewSector setHidden:NO];
////        [self.view bringSubviewToFront:viewChecklist];
//        
////        [UIView animateWithDuration:0.5
////                              delay:0.1
////                            options: UIViewAnimationOptionCurveEaseIn
////                         animations:^{
////                             viewSector.frame = CGRectMake(7, 103, 150, 160);
////                             [viewSector setHidden:NO];
////                             
////                             [self setAnchorPoint:CGPointMake(1.5, 1.0) forView:viewSector];
////                             viewSector.transform = CGAffineTransformMakeScale(1, 0.001);
////                         }
////                         completion:^(BOOL finished){
////                             viewSector.transform = CGAffineTransformIdentity;
////                         }];
//        
//        CATransition *transition = nil;
//        transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype =kCATransitionFromBottom ;
//        transition.delegate = self;
//        [viewSector.layer addAnimation:transition forKey:nil];
    }
    else
        [_viewSector setHidden:YES];
}

- (void) setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (IBAction)actionBasic:(id)sender {
    [_viewSector setHidden:YES];
    if ([_viewBasicFilter isHidden]) {
        [_viewBasicFilter setHidden:NO];
    }
    else
        [_viewBasicFilter setHidden:YES];
}

#pragma mark - Common actions

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerStockListRun:YES];
    globalShare.timerStockList = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getMarketWatch) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerStockList forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void) getMarketWatch {
    @try {
    [self.indicatorView setHidden:NO];
//    [self dismissPopup];

    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
     strToken = [GlobalShare checkingNullValues:strToken];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetMarketWatch"];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        [self.indicatorView setHidden:YES];
                                                        if(error == nil)
                                                        {
//                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
////                                                            NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
////                                                            NSLog(@"Data = %@",text);
////                                                            
////                                                            NSLog(@"%@", [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] class]);
//                                                            if (((httpResponse.statusCode/100) == 2) && [response.MIMEType isEqual:@"application/json"]) {
//                                                                NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                                NSLog(@"Data = %@",text);
//                                                            }
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
                                                                    self.arrayStockList = returnedDict[@"result"];
                                                                    globalShare.search_results = returnedDict[@"result"];
                                                                    
                                                                    

                                                                    // update model objects on main thread
                                                                    
//                                                                    NSArray *arrValues = jsonResponse[@"result"];
//                                                                    for(NSDictionary *dict in arrValues) {
//                                                                        StockList *stockList = [[StockList alloc] init];
//                                                                        stockList.security_id = @"";
//                                                                    }
                                                                    [self.tableViewStocks reloadData];              // also update UI on main thread
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return globalShare.stockSectors.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tableViewBasic])         return [self.basics count];
//    else if ([tableView isEqual:tableViewSector])   return [globalShare.stockSectors count];
    else                                            return [self.arrayStockList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableViewStocks]) {
        StockListCell *cell = (StockListCell *) [tableView dequeueReusableCellWithIdentifier:kStockListCellIdentifier forIndexPath:indexPath];
    @try
        {
        NSDictionary *def = self.arrayStockList[indexPath.row];
        
//        cell.labelSymbol.text = def[@"Symbol"];
//        cell.labelCompanyName.text = def[@"Name"];
//        cell.labelValue.text = def[@"Value"];
//        cell.labelVolume.text = def[@"Volume"];
//        cell.labelChange.text = def[@"Change"];
//        cell.labelPercentChange.text = def[@"PerChange"];
//        
//        if([def[@"UpDown"] isEqualToString:@"UpDown"]) {
//            [cell.imageUpDown setImage:nil];
//            cell.labelColor.backgroundColor = [UIColor darkGrayColor];
//        }
//        else {
//            [cell.imageUpDown setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Arrow.png",def[@"UpDown"]]]];
//            ([def[@"UpDown"] isEqualToString:@"Up"]) ? cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f] : (cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f]);
//        }
//        cell.labelAsk.text = [NSString stringWithFormat:@"Ask: %@",def[@"Ask"]];
//        cell.labelBid.text = [NSString stringWithFormat:@"Bid: %@",def[@"Bid"]];

        cell.labelSymbol.text = def[@"ticker"];
         
        cell.labelSymbol.text = [GlobalShare checkingNullValues:cell.labelSymbol.text];

        cell.labelSecurityName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? def[@"security_name_e"] : def[@"security_name_a"];
            
            cell.labelSecurityName.text = [GlobalShare checkingNullValues:cell.labelSecurityName.text];

//        cell.labelSecurityName.text = @"Al Khalij Commercial Bank";
        cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"comp_current_price"]];
            
            cell.labelPrice.text = [GlobalShare checkingNullValues:cell.labelPrice.text];

        cell.labelHighLow.text = [NSString stringWithFormat:@"H:%@  L:%@", [GlobalShare formatStringToTwoDigits:def[@"high"]], [GlobalShare formatStringToTwoDigits:def[@"low"]]];
            
            cell.labelHighLow.text = [GlobalShare checkingNullValues:cell.labelHighLow.text];

        cell.labelChange.text = [GlobalShare formatStringToTwoDigits:def[@"change"]];
            
            cell.labelChange.text = [GlobalShare checkingNullValues:cell.labelChange.text];

            
        cell.labelPercentChange.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
            
            cell.labelPercentChange.text = [GlobalShare checkingNullValues:cell.labelPercentChange.text];

        
//        if([def[@"change"] hasPrefix:@"-"] || [def[@"change"] hasPrefix:@"+"]) {
//            if([def[@"change"] hasPrefix:@"+"]) {
//                [cell.imageUpDown setImage:[UIImage imageNamed:@"Up_Arrow.png"]];
//                cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//            }
//            else {
//                [cell.imageUpDown setImage:[UIImage imageNamed:@"Down_Arrow.png"]];
//                cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//            }
//        }
//        else {
//            [cell.imageUpDown setImage:nil];
//            cell.labelColor.backgroundColor = [UIColor darkGrayColor];
//        }
        
        if([def[@"change"] hasPrefix:@"-"]) {
            [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_down_arrow"]];
//            cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
            cell.labelColor.backgroundColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
        }
        else if([def[@"change"] hasPrefix:@"+"]) {
            [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
//            cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:130/255.f blue:2/255.f alpha:1.f];
            cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
        }
        else {
            if([GlobalShare returnIfGreaterThanZero:[def[@"change"] doubleValue]]) {
                cell.labelChange.text = [NSString stringWithFormat:@"+%@", [GlobalShare formatStringToTwoDigits:def[@"change"]]];
                
                cell.labelChange.text = [GlobalShare checkingNullValues:cell.labelChange.text];

                cell.labelPercentChange.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:def[@"change_perc"]]];
                [cell.imageUpDown setImage:[UIImage imageNamed:@"icon_up_arrow"]];
//                cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:130/255.f blue:2/255.f alpha:1.f];
                cell.labelColor.backgroundColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
            }
            else {
                [cell.imageUpDown setImage:nil];
                cell.labelColor.backgroundColor = [UIColor darkGrayColor];
            }
        }

        if(globalShare.myLanguage != ARABIC_LANGUAGE) {
            [cell.labelChange setTextAlignment:NSTextAlignmentRight];
            [cell.labelPercentChange setTextAlignment:NSTextAlignmentRight];
            [cell.labelAsk setTextAlignment:NSTextAlignmentRight];
            
            cell.labelAsk.text = [NSString stringWithFormat:@"%@: %@ x %@", NSLocalizedString(@"Ask", @"Ask"), ([def[@"ASK"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:def[@"ASK"]], [GlobalShare createCommaSeparatedString:def[@"ASK_VOL"]]];
            
            
            cell.labelBid.text = [NSString stringWithFormat:@"%@: %@ x %@", NSLocalizedString(@"Bid", @"Bid"), ([def[@"BID"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:def[@"BID"]], [GlobalShare createCommaSeparatedString:def[@"BID_VOL"]]];
        }
        else {
            [cell.labelChange setTextAlignment:NSTextAlignmentLeft];
            [cell.labelPercentChange setTextAlignment:NSTextAlignmentLeft];
            [cell.labelAsk setTextAlignment:NSTextAlignmentLeft];
            
            cell.labelAsk.text = [NSString stringWithFormat:@"%@ x %@ :%@", [GlobalShare createCommaSeparatedString:def[@"ASK_VOL"]], ([def[@"ASK"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:def[@"ASK"]], NSLocalizedString(@"Ask", @"Ask")];
            cell.labelBid.text = [NSString stringWithFormat:@"%@ x %@ :%@", [GlobalShare createCommaSeparatedString:def[@"BID_VOL"]], ([def[@"BID"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:def[@"BID"]], NSLocalizedString(@"Bid", @"Bid")];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        
        cell.labelColor.layer.cornerRadius = 3;
        cell.labelColor.layer.masksToBounds = YES;
        
//        if(indexPath.row == 5) {
//            [UIView transitionWithView:cell.contentView
//                              duration:0.8f
//             //                           options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                               options:UIViewAnimationOptionCurveEaseInOut
//                            animations:^{
//                                //                            cell.contentView.layer.opacity = 0.4f;
//                                cell.backgroundColor = [UIColor redColor];
//                            }
//                            completion:^(BOOL animated){
//                                //                            cell.contentView.layer.opacity = 1.0f;
//                                cell.backgroundColor = [UIColor whiteColor];
//                            }];
//        }
        }
        @catch(NSException *exception)
        {
            
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
//        if ([tableView isEqual:tableViewBasic]) {
            cell.textLabel.text = self.basics[indexPath.row];;
//        }
//        else {
//            cell.textLabel.text = globalShare.stockSectors[indexPath.row];;
//        }
        
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return globalShare.stockSectors[section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 25;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 7;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
//    sectionHeader.backgroundColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.f];
//    sectionHeader.textAlignment = NSTextAlignmentLeft;
//    sectionHeader.font = [UIFont boldSystemFontOfSize:15];
//    sectionHeader.textColor = [UIColor whiteColor];
//    sectionHeader.text = globalShare.stockSectors[section];
//
//    return sectionHeader;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
//    sectionHeader.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1.f];
//    sectionHeader.textAlignment = NSTextAlignmentLeft;
//    sectionHeader.font = [UIFont boldSystemFontOfSize:15];
//    sectionHeader.textColor = [UIColor whiteColor];
////    sectionHeader.text = globalShare.stockSectors[section];
//    
//    return sectionHeader;
//}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableViewBasic]) {
        if(self.selFilterIndex == indexPath.row)
            self.isAscend = !self.isAscend;
        else
            self.isAscend = YES;
        
        self.selFilterIndex = indexPath.row;
        
        [_viewBasicFilter setHidden:YES];
        NSString *strFilter = nil;
        NSArray *myArray = nil;
        
        if(indexPath.row == 0) strFilter = @"Symbol";
        else if(indexPath.row == 1) strFilter = @"Name";
        else if(indexPath.row == 2) strFilter = @"Change";
        else strFilter = @"PerChange";

        if(indexPath.row == 2 || indexPath.row == 3) {
            myArray = [self.arrayStockList sortedArrayUsingDescriptors:
                            @[[NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"%@.doubleValue", strFilter]
                                                            ascending:self.isAscend]]];
        }
        if(indexPath.row == 0 || indexPath.row == 1) {
            NSSortDescriptor *valueDescriptor = [NSSortDescriptor sortDescriptorWithKey:strFilter ascending:self.isAscend];
            myArray = [self.arrayStockList sortedArrayUsingDescriptors:@[valueDescriptor]];
        
        }
        self.arrayStockList = myArray;
        [_tableViewStocks reloadData];
    }
//    
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//
//    CGRect rectInTableView = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];

//    PopoverViewController *contentVC = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
//    contentVC.modalPresentationStyle = UIModalPresentationPopover;
//    UIPopoverPresentationController *popPC = contentVC.popoverPresentationController;
//    contentVC.preferredContentSize = CGSizeMake(266, 57);
//    contentVC.popoverPresentationController.sourceRect = rectInTableView;
//    int64_t delta = (int64_t)(1.0e9 * 0.1);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), ^{
//        contentVC.popoverPresentationController.passthroughViews = nil;
//    });
//    contentVC.popoverPresentationController.sourceView = self.view;
//    popPC.permittedArrowDirections = UIPopoverArrowDirectionUp;// | UIPopoverArrowDirectionDown;
//    popPC.delegate = self;
//    popPC.backgroundColor = contentVC.view.backgroundColor;
//    globalShare.topViewController = contentVC;
//    [self presentViewController:contentVC animated:YES completion:nil];
    
    
//    [UIView animateWithDuration:2
//                     animations:^ {
////                         [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//                         [tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//                     }
//                     completion:^(BOOL finished) {
//                         CGRect rectInTableView = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];
//                         
//                         CGSize contentSize = CGSizeMake(300, 88);
//                         
//                         [self.transparencyButton setHidden:!self.transparencyButton];
//                         
//                         self.contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
//                         self.contentVC.delegate = self;
//                         self.contentVC.view.frame = CGRectMake((self.view.frame.size.width - contentSize.width)/2, rectInTableView.origin.y+rectInTableView.size.height-18, contentSize.width, contentSize.height);
//                         self.contentVC.view.tag = 1000;
//                         self.contentVC.securityId = self.arrayStockList[indexPath.row][@"ticker"];
//                         [self.view addSubview:self.contentVC.view];
//                         
//                         [self.view addSubviewWithBounce:self.contentVC.view];
//                         
//                         [self.view insertSubview:self.transparencyButton belowSubview:self.contentVC.view];
//                         [self.transparencyButton addTarget:self action:@selector(dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
//                     }];
    
    
    
    CGRect rectInTableView = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];

    CGSize contentSize = CGSizeMake(300, 88);
    
    [self.transparencyButton setHidden:!self.transparencyButton];
    
    self.contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
    self.contentVC.delegate = self;
    self.contentVC.view.frame = CGRectMake((self.view.frame.size.width - contentSize.width)/2, rectInTableView.origin.y+rectInTableView.size.height-18, contentSize.width, contentSize.height);
    self.contentVC.view.tag = 1000;
    self.contentVC.securityId = self.arrayStockList[indexPath.row][@"ticker"];
    self.contentVC.securityName = self.arrayStockList[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
    [self.view addSubview:self.contentVC.view];
    
    [self.view addSubviewWithBounce:self.contentVC.view];
    
    [self.view insertSubview:self.transparencyButton belowSubview:self.contentVC.view];
    [self.transparencyButton addTarget:self action:@selector(dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissHelper:(UIButton *)sender
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    sender.hidden = YES;
}

- (void)dismissPopup
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        if([[self.view viewWithTag:1000] superview]) {
            [[self.view viewWithTag:1000] removeFromSuperview];
            [self.transparencyButton setHidden:YES];
//        }
    });
}

#pragma mark - UIAlertController

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
//                                   
//                               }];
//    
//    [alertController addAction:okAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Prices";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
