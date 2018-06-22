//
//  StocksOverviewViewController.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "StocksOverviewViewController.h"
#import "QEGraphViewController.h"
#import <Charts/Charts.h>
#import "StockNewsCell.h"

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))
NSString *const kStockNewsCellIdentifier = @"StockNewsCell";

@interface StocksOverviewViewController () <ChartViewDelegate, NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet LineChartView *chartView;
@property (nonatomic, weak) IBOutlet UIView *summaryView;
@property (nonatomic, weak) IBOutlet UIView *newsView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentMenu;
@property (nonatomic, weak) IBOutlet UITableView *tableViewNews;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

//@property (nonatomic, strong) NSArray *arrayTimes;
@property (nonatomic, strong) NSArray *arrayNews;
@property (nonatomic, strong) NSArray *arrayMarketIndex;

@property (nonatomic, weak) IBOutlet UILabel *labelCurrentIndex;
@property (nonatomic, weak) IBOutlet UILabel *labelTodayChanges;
@property (nonatomic, weak) IBOutlet UILabel *labelVolume;
@property (nonatomic, weak) IBOutlet UILabel *labelUpdatedTime;
@property (nonatomic, weak) IBOutlet UILabel *labelMarketStatus;
@property (nonatomic, weak) IBOutlet UILabel *labelTodayOpen;
@property (nonatomic, weak) IBOutlet UILabel *labelPreviousClose;
@property (nonatomic, weak) IBOutlet UILabel *labelNoOfTrades;
@property (nonatomic, weak) IBOutlet UILabel *labelValue;
@property (nonatomic, weak) IBOutlet UILabel *labelDayHigh;
@property (nonatomic, weak) IBOutlet UILabel *labelDayLow;
@property (nonatomic, weak) IBOutlet UILabel *label52wkHigh;
@property (nonatomic, weak) IBOutlet UILabel *label52wkLow;

@property (weak, nonatomic) IBOutlet UILabel *labelVolumeCaption;
@property (weak, nonatomic) IBOutlet UIView *viewChart;
@property(strong,nonatomic) QEGraphViewController *graphContentView;

@end

@implementation StocksOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    globalShare = [GlobalShare sharedInstance];
    [self clearMarketIndex];

//    self.arrayTimes = @[
//                        @"09:30", @"09:30", @"10:00", @"10:30", @"11:00",
//                        @"11:30", @"12:00", @"12:30", @"13:00", @"13:15"
//                        ];

    _chartView.backgroundColor = [UIColor colorWithRed:252/255.f green:252/255.f blue:252/255.f alpha:0.7f];
    _chartView.delegate = self;
//    _chartView.descriptionText = @"";
    //_chartView.chartDescription.enabled = NO;
    _chartView.noDataText = CHART_DATA_UNAVAILABLE;
//    _chartView.noDataTextDescription = CHART_DATA_UNAVAILABLE;
    
    _chartView.dragEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.scaleXEnabled = NO;
    _chartView.scaleYEnabled = NO;
    
    _chartView.rightAxis.enabled = YES;
    _chartView.leftAxis.enabled = NO;
    _chartView.rightAxis.drawGridLinesEnabled = NO;
    _chartView.xAxis.drawGridLinesEnabled = NO;
    _chartView.rightAxis.gridLineWidth = 0.1;
    _chartView.xAxis.gridLineWidth = 0.1;
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
//    _chartView.xAxis.avoidFirstLastClippingEnabled = YES;
    _chartView.rightAxis.drawTopYLabelEntryEnabled = YES;
//    _chartView._defaultValueFormatter.minimumFractionDigits = 0;
//    _chartView._defaultValueFormatter.minimumSignificantDigits = 0;// (not considered)
//    _chartView._defaultValueFormatter.minimumFractionDigits = 2;

    _chartView.legend.enabled = NO;
//    _chartView.rightAxis.axisMaxValue = 10500.0;
//    _chartView.rightAxis.axisMinValue = 9500.0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelVolumeCaption setTextAlignment:NSTextAlignmentLeft];

        [self.labelVolume setTextAlignment:NSTextAlignmentLeft];
        [self.labelMarketStatus setTextAlignment:NSTextAlignmentLeft];
        
        [self.labelTodayOpen setTextAlignment:NSTextAlignmentLeft];
        [self.labelPreviousClose setTextAlignment:NSTextAlignmentLeft];
        [self.labelNoOfTrades setTextAlignment:NSTextAlignmentLeft];
        [self.labelValue setTextAlignment:NSTextAlignmentLeft];
        [self.labelDayHigh setTextAlignment:NSTextAlignmentLeft];
        [self.labelDayLow setTextAlignment:NSTextAlignmentLeft];
        [self.label52wkHigh setTextAlignment:NSTextAlignmentLeft];
        [self.label52wkLow setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelVolumeCaption setTextAlignment:NSTextAlignmentRight];
        
        [self.labelVolume setTextAlignment:NSTextAlignmentRight];
        [self.labelMarketStatus setTextAlignment:NSTextAlignmentRight];
        
        [self.labelTodayOpen setTextAlignment:NSTextAlignmentRight];
        [self.labelPreviousClose setTextAlignment:NSTextAlignmentRight];
        [self.labelNoOfTrades setTextAlignment:NSTextAlignmentRight];
        [self.labelValue setTextAlignment:NSTextAlignmentRight];
        [self.labelDayHigh setTextAlignment:NSTextAlignmentRight];
        [self.labelDayLow setTextAlignment:NSTextAlignmentRight];
        [self.label52wkHigh setTextAlignment:NSTextAlignmentRight];
        [self.label52wkLow setTextAlignment:NSTextAlignmentRight];
    }
    [self.viewChart setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];

    [[GlobalShare sharedInstance] setCanAutoRotateL:YES];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }

//    [self performSelector:@selector(authenticateUser) withObject:nil afterDelay:0.01f];
    [self performSelector:@selector(getMarketIndex) withObject:nil afterDelay:0.01f];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
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
    @try {

    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {

    }
}

- (IBAction)actionChartClick:(id)sender {
    
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[GlobalShare sharedInstance] setCanRotateOnClick:YES];
    self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"QEGraphViewController"];
    
   // [self presentViewController:self.graphContentView animated:NO completion:nil];
    [self.view.window.rootViewController presentViewController:self.graphContentView animated:YES completion:nil];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    if (self.segmentMenu.selectedSegmentIndex == 0) {
        [_newsView setHidden:YES];
        [_summaryView setHidden:NO];
    }
    else{
        [self newsAction];
    }
}
-(void)newsAction{
    NSString *str;
    //https://www.islamicbroker.com.qa/
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
       // str = [NSString stringWithFormat:@"https://www.islamicbroker.com.qa/ar/stories/c/3/0/%D8%A3%D9%87 %D9%85-%D8%A7%D9%84%D8%A3%D8%AE%D8%A8%D8%A7%D8%B1"];
        str = [NSString stringWithFormat:@"%@%@",webSite_Url,@"ar/stories/c/3/0/%D8%A3%D9%87 %D9%85-%D8%A7%D9%84%D8%A3%D8%AE%D8%A8%D8%A7%D8%B1"];
    }
    else{
        //str= @"https://www.islamicbroker.com.qa/en/stories/c/3/0/News";
        str = [NSString stringWithFormat:@"%@en/stories/c/3/0/News",webSite_Url];
    }
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self.segmentMenu setSelectedSegmentIndex:0];
    
}
#pragma mark - Common actions

-(void) getMarketIndex {
    @try {
    [self.indicatorView setHidden:NO];
    [self.view bringSubviewToFront:self.indicatorView];

//    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        strToken = [GlobalShare checkingNullValues:strToken];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetMarketIndex"];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
//    //Configure your session with common header fields like authorization etc
//
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfiguration.HTTPAdditionalHeaders = @{@"Authorization": strToken};
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    
//    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetMarketIndex"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                                                                   self.labelCurrentIndex.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"index_1"]];
                                                                   self.labelTodayChanges.text = [NSString stringWithFormat:@"%@(%@%%)", [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]], [GlobalShare formatStringToTwoDigits:dictVal[@"change"]]];

//                                                                   if([dictVal[@"change"] hasPrefix:@"-"] || [dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                       if([dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                           self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                                                                       }
//                                                                       else {
//                                                                           self.labelTodayChanges.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                                                                       }
//                                                                   }
//                                                                   else {
//                                                                       self.labelTodayChanges.textColor = [UIColor darkGrayColor];
//                                                                   }
                                                                   
                                                                   if([dictVal[@"change"] hasPrefix:@"-"]) {
                                                                       self.labelTodayChanges.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                   }
                                                                   else if([dictVal[@"change"] hasPrefix:@"+"]) {
                                                                       self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                   }
                                                                   else {
                                                                       if([GlobalShare returnIfGreaterThanZero:[dictVal[@"change"] doubleValue]]) {
                                                                           self.labelTodayChanges.text = [NSString stringWithFormat:@"+%@(+%@%%)", [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]], [GlobalShare formatStringToTwoDigits:dictVal[@"change"]]];
                                                                           self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                       }
                                                                       else {
                                                                           self.labelTodayChanges.textColor = [UIColor darkGrayColor];
                                                                       }
                                                                   }

//                                                                   self.arrayMarketIndex = dictVal[@"lstMarketSummary_Intra_day"];
                                                                   
                                                                   if([dictVal[@"lstMarketSummary_Intra_day"] isKindOfClass:[NSArray class]] || [dictVal[@"lstMarketSummary_Intra_day"] isKindOfClass:[NSMutableArray class]]) {
                                                                       self.arrayMarketIndex = dictVal[@"lstMarketSummary_Intra_day"];
                                                                   }
                                                                   else {
                                                                       self.arrayMarketIndex = nil;
                                                                   }

                                                                   self.labelVolume.text = [GlobalShare createCommaSeparatedString:dictVal[@"tot_vol"]];
                                                                   self.labelUpdatedTime.text = dictVal[@"update_date"];
                                                                   self.labelMarketStatus.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? dictVal[@"market_status_en"] : dictVal[@"market_status_ar"];
                                                                   self.labelTodayOpen.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"yest_index"]]];
                                                                   self.labelPreviousClose.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"yest_index"]]];
                                                                   self.labelNoOfTrades.text = [GlobalShare createCommaSeparatedString:dictVal[@"tot_trade"]];
                                                                   self.labelValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"tot_val"]]];
                                                                   self.labelDayHigh.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"indexhigh"]]];
                                                                   self.labelDayLow.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"indexlow"]]];
                                                                   self.label52wkHigh.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"w52high"]]];
                                                                   self.label52wkLow.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"w52low"]]];
                                                                   
                                                                   if([[dictVal[@"market_status_en"] lowercaseString] isEqualToString:@"pre-open"])
                                                                       self.labelMarketStatus.textColor = [UIColor colorWithRed:250/255.f green:135/255.f blue:40/255.f alpha:1.f];
                                                                   if([[dictVal[@"market_status_en"] lowercaseString] isEqualToString:@"open"])
                                                                       self.labelMarketStatus.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                   if([[dictVal[@"market_status_en"] lowercaseString] isEqualToString:@"pre-close"])
                                                                       self.labelMarketStatus.textColor = [UIColor colorWithRed:250/255.f green:135/255.f blue:40/255.f alpha:1.f];
                                                                   if([[dictVal[@"market_status_en"] lowercaseString] isEqualToString:@"trading at last"])
                                                                       self.labelMarketStatus.textColor = [UIColor colorWithRed:250/255.f green:135/255.f blue:40/255.f alpha:1.f];
                                                                   if([[dictVal[@"market_status_en"] lowercaseString] isEqualToString:@"closed"])
                                                                       self.labelMarketStatus.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                   
                                                                   [self performSelector:@selector(updateChartData) withObject:nil afterDelay:0.01f];
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

-(void) authenticateUser {
    @try {
    [self.indicatorView setHidden:NO];
    
    //    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        strToken = [GlobalShare checkingNullValues:strToken];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"Authenticate"];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
//    //Configure your session with common header fields like authorization etc
//
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfiguration.HTTPAdditionalHeaders = @{@"Authorization": strToken};
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//
//    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"Authenticate"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       [self.indicatorView setHidden:YES];
                                                       if(error == nil)
                                                       {
                                                           NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                           NSLog(@"%@", returnedDict);
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

- (void)updateChartData
{
    [_chartView animateWithYAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
    [self setDataCount:30 range:100];
}

- (void)setDataCount:(int)count range:(double)range
{
    if([self.arrayMarketIndex count] == 0) {
        _chartView.data = nil;
        return;
    }
    
    _chartView.chartDescription.text = @"";
    [_indicatorView setHidden:NO];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < self.arrayTimes.count; i++)
//    {
//        [xVals addObject:self.arrayTimes[i]];
//    }

    NSString *strVal;
    for (int i = 0; i < self.arrayMarketIndex.count; i++)
    {
//        [xVals addObject:[self.arrayMarketIndex[i][@"update_date"] componentsSeparatedByString:@" "][1]];
        strVal = [self.arrayMarketIndex[i][@"update_date"] componentsSeparatedByString:@" "][1];
        strVal = [NSString stringWithFormat:@"%@:%@", [strVal componentsSeparatedByString:@":"][0], [strVal componentsSeparatedByString:@":"][1]];
        [xVals addObject:strVal];
    }

    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < 7; i++)
//    {
//        double val = (double) RAND_FROM_TO(10000, 10100);
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
//    }
    
    for (int i = 0; i < self.arrayMarketIndex.count; i++)
    {
//        double val = [self.arrayMarketIndex[i][@"index_1"] doubleValue];
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        [yVals addObject:self.arrayMarketIndex[i][@"index_1"]];
    }
    
//    _chartView.xAxis._axisMaximum = [self.arrayMarketIndex count]-1;
//    _chartView.xAxis._axisMinimum = 0;
//    _chartView.xAxis.axisMaxValue = [self.arrayMarketIndex count]-1;
//    _chartView.xAxis.axisMinValue = 0;
    
   
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrayMarketIndex.count; i++) {
        [values addObject:[[ChartDataEntry alloc] initWithX:[[xVals objectAtIndex:i] doubleValue] y:[[yVals objectAtIndex:i] doubleValue]]];
    }

    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
//        set1.yVals = yVals;
//        _chartView.data.xValsObjc = xVals;
//        set1.xMin = 10500.0;
//        set1.xMax = 9500.0;
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
        [_indicatorView setHidden:YES];
    }
    else
    {
//        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
        
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
        [set1 setColor:[UIColor colorWithRed:204/255.f green:224/255.f blue:255/255.f alpha:1.f]];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        
        NSArray *gradientColors = @[
                                    (id)[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f].CGColor,
                                    (id)[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        set1.drawValuesEnabled = NO;
        set1.drawCirclesEnabled = NO;
        set1.drawHorizontalHighlightIndicatorEnabled = NO;
        set1.drawVerticalHighlightIndicatorEnabled = NO;
        set1.highlightLineWidth = 1.0;
        set1.lineWidth = 2.0;
        set1.axisDependency = AxisDependencyRight;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
//        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _chartView.data = data;
        
        [_indicatorView setHidden:YES];
    }
}

-(void) clearMarketIndex {
    self.labelCurrentIndex.text = @"";
    self.labelTodayChanges.text = @"";
    self.labelVolume.text = @"";
    self.labelUpdatedTime.text = @"";
    self.labelMarketStatus.text = @"";
    self.labelTodayOpen.text = @"";
    self.labelPreviousClose.text = @"";
    self.labelNoOfTrades.text = @"";
    self.labelValue.text = @"";
    self.labelDayHigh.text = @"";
    self.labelDayLow.text = @"";
    self.label52wkHigh.text = @"";
    self.label52wkLow.text = @"";
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
//    NSLog(@"chartValueSelected %ld", (long)dataSetIndex);
//    [self.delegate handleTapOnChartView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockNewsCell *cell = (StockNewsCell *) [tableView dequeueReusableCellWithIdentifier:kStockNewsCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *def = self.arrayNews[indexPath.row];
    
    cell.labelDate.text = def[@"Symbol"];
    cell.labelNewsText.text = def[@"Name"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    return cell;
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
    return @"QE Index";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
