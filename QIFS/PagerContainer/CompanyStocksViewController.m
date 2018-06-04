//
//  CompanyStocksViewController.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "CompanyStocksViewController.h"
//#import <Charts/Charts.h>
#import "MarketDepthViewController.h"
#import "NewOrderViewController.h"
#import "CompanyGraphViewController.h"

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface CompanyStocksViewController () < NSURLSessionDelegate> //ChartViewDelegate

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIView *chartView; //LineChartView
@property (nonatomic, weak) IBOutlet UIView *summaryView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentMenu;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayTimes;
@property (nonatomic, strong) NSArray *arrayMarketWatch;
@property (nonatomic, strong) CompanyGraphViewController *graphContentView;

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelSecurityName;
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
@property (nonatomic, weak) IBOutlet UILabel *labelLimitUp;
@property (nonatomic, weak) IBOutlet UILabel *labelLimitDown;

@property (weak, nonatomic) IBOutlet UILabel *labelVolumeCaption;
@property (weak, nonatomic) IBOutlet UIView *viewChart;

@end

@implementation CompanyStocksViewController

//@synthesize delegate;
@synthesize securityId;
@synthesize securityName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    globalShare = [GlobalShare sharedInstance];
//    [self clearMarketWatch];

    self.labelSymbol.text = self.labelTitle.text = self.securityId;
    self.labelSecurityName.text = self.securityName;
    self.arrayTimes = @[
                        @"09:30", @"09:30", @"10:00", @"10:30", @"11:00",
                        @"11:30", @"12:00", @"12:30", @"13:00", @"13:15"
                        ];

   /* _chartView.backgroundColor = [UIColor colorWithRed:252/255.f green:252/255.f blue:252/255.f alpha:0.7f];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
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
    _chartView.rightAxis.drawTopYLabelEntryEnabled = YES;
//    _chartView._defaultValueFormatter.minimumFractionDigits = 2;
//    _chartView._defaultValueFormatter.maximumFractionDigits = 2;
    _chartView._defaultValueFormatter.maximumSignificantDigits = 4;
    _chartView._defaultValueFormatter.minimumSignificantDigits = 4;

    _chartView.legend.enabled = NO;
//    _chartView.rightAxis.axisMaxValue = 10500.0;
//    _chartView.rightAxis.axisMinValue = 9500.0;
    
//    [_chartView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
      */
}
  

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.viewChart setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
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
    
    [self.segmentMenu setSelectedSegmentIndex:0];
    [[GlobalShare sharedInstance] setCanAutoRotateL:YES];

    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
<<<<<<< HEAD
    */
=======
    
>>>>>>> aa17e637865ecd6b3d2e6f2e1a595be305573f4e
    [self performSelector:@selector(getMarketWatch) withObject:nil afterDelay:0.01f];
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

- (IBAction)actionChartClick:(id)sender {
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[GlobalShare sharedInstance] setCanRotateOnClick:YES];
    self.graphContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyGraphViewController"];
    self.graphContentView.securityId = self.securityId;
    [self presentViewController:self.graphContentView animated:NO completion:nil];
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

- (IBAction)actionNewOrder:(id)sender {
    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
    newOrderViewController.securityId = self.securityId;
    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
    [[self navigationController] pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    switch (self.segmentMenu.selectedSegmentIndex) {
        case 0:
//            [newsView removeFromSuperview];
//            [self.view addSubview:summaryView];
//            [newsView setHidden:YES];
//            [summaryView setHidden:NO];
//            [self.segmentMenu setSelectedSegmentIndex:0];
            break;
        case 1: {
//            [summaryView removeFromSuperview];
//            [self.view addSubview:newsView];
//            [newsView setHidden:NO];
//            [summaryView setHidden:YES];
//            [self.segmentMenu setSelectedSegmentIndex:1];
            MarketDepthViewController *marketDepthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MarketDepthViewController"];
            marketDepthViewController.securityId = self.securityId;
           [[self navigationController] pushViewController:marketDepthViewController animated:YES];

            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Common actions

-(void) getMarketWatch {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetSecurity_Stock?ticker=", self.securityId];
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
                                                                       NSDictionary *dictVal = returnedDict[@"result"][0];
                                                                       self.labelCurrentIndex.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"comp_current_price"]];
                                                                       self.labelTodayChanges.text = [NSString stringWithFormat:@"%@(%@%%)", [GlobalShare formatStringToTwoDigits:dictVal[@"change"]], [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]]];
                                                                       
//                                                                       if([dictVal[@"change"] hasPrefix:@"-"] || [dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                           if([dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                               self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                                                                           }
//                                                                           else {
//                                                                               self.labelTodayChanges.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                                                                           }
//                                                                       }
//                                                                       else {
//                                                                           self.labelTodayChanges.textColor = [UIColor darkGrayColor];
//                                                                       }
                                                                       
                                                                       if([dictVal[@"change"] hasPrefix:@"-"]) {
                                                                           self.labelTodayChanges.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                       }
                                                                       else if([dictVal[@"change"] hasPrefix:@"+"]) {
                                                                           self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                       }
                                                                       else {
                                                                           if([GlobalShare returnIfGreaterThanZero:[dictVal[@"change"] doubleValue]]) {
                                                                               self.labelTodayChanges.text = [NSString stringWithFormat:@"+%@(+%@%%)", [GlobalShare formatStringToTwoDigits:dictVal[@"change"]], [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]]];
                                                                               self.labelTodayChanges.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                           }
                                                                           else {
                                                                               self.labelTodayChanges.textColor = [UIColor darkGrayColor];
                                                                           }
                                                                       }

//                                                                       self.arrayMarketWatch = dictVal[@"lstIntra_day"];
                                                                       
                                                                       if([dictVal[@"lstIntra_day"] isKindOfClass:[NSArray class]] || [dictVal[@"lstIntra_day"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketWatch = dictVal[@"lstIntra_day"];
                                                                       }
                                                                       else {
                                                                           self.arrayMarketWatch = nil;
                                                                       }

                                                                       self.labelVolume.text = [GlobalShare createCommaSeparatedString:dictVal[@"volume"]];
                                                                       self.labelUpdatedTime.text = dictVal[@"update_date"];
                                                                       self.labelMarketStatus.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? dictVal[@"market_status_en"] : dictVal[@"market_status_ar"];
                                                                       self.labelTodayOpen.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"open_price"]]];
                                                                       self.labelPreviousClose.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"close_price"]]];
                                                                       self.labelNoOfTrades.text = [GlobalShare createCommaSeparatedString:dictVal[@"tot_trade"]];
                                                                       self.labelValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"value_all"]]];
                                                                       self.labelDayHigh.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"high_rate"]]];
                                                                       self.labelDayLow.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"low_rate"]]];
                                                                       self.label52wkHigh.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"wk52HighPrice"]]];
                                                                       self.label52wkLow.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"wk52LowPrice"]]];
                                                                       self.labelLimitUp.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"max_price"]]];
                                                                       self.labelLimitDown.text = [GlobalShare createCommaSeparatedTwoDigitString:[GlobalShare formatStringToTwoDigits:dictVal[@"min_price"]]];
                                                                       
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

- (void)updateChartData
{
//    [_chartView animateWithYAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
    [self setDataCount:30 range:100];
}

- (void)setDataCount:(int)count range:(double)range
{
    if([self.arrayMarketWatch count] == 0) {
//        _chartView.data = nil;
        return;
    }
    
    [_indicatorView setHidden:NO];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];

//    for (int i = 0; i < self.arrayTimes.count; i++)
//    {
//        [xVals addObject:self.arrayTimes[i]];
//    }
    
    NSString *strVal;
    for (int i = 0; i < self.arrayMarketWatch.count; i++)
    {
        strVal = [self.arrayMarketWatch[i][@"update_date"] componentsSeparatedByString:@" "][1];
        strVal = [NSString stringWithFormat:@"%@:%@", [strVal componentsSeparatedByString:@":"][0], [strVal componentsSeparatedByString:@":"][1]];
        [xVals addObject:strVal];
    }

//    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < 7; i++)
//    {
//        double val = (double) RAND_FROM_TO(0, 100);
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
//    }
    
    for (int i = 0; i < self.arrayMarketWatch.count; i++)
    {
//        double val = [self.arrayMarketWatch[i][@"comp_current_price"] doubleValue];
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }

   /* LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.yVals = yVals;
        _chartView.data.xValsObjc = xVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
        [_indicatorView setHidden:YES];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
        
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
        
        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
        
        _chartView.data = data;
        [_indicatorView setHidden:YES];
    }*/
}

-(void) clearMarketWatch {
    self.labelSymbol.text = @"";
    self.labelSecurityName.text = @"";
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
    self.labelLimitUp.text = @"";
    self.labelLimitDown.text = @"";
}

#pragma mark - ChartViewDelegate

//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
//{
//    NSLog(@"chartValueSelected %ld", (long)dataSetIndex);
//}

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

@end
