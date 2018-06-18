//
//  CompanyGraphViewController.m
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "CompanyGraphViewController.h"
#import <Charts/Charts.h>
#import "QIFS-Swift.h"
#import "DateValueFormatter.h"
#import "UIAlertController+Orientation.h"

@interface CompanyGraphViewController () <ChartViewDelegate, NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet LineChartView *lineChartViewQE;
@property (nonatomic, assign) UIDeviceOrientation orientation;
//@property (nonatomic, strong) BalloonMarker *markerView;
@property (nonatomic, weak) IBOutlet UIButton *buttonPlus;
@property (nonatomic, weak) IBOutlet UIButton *buttonOneDay;
@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelClose;
@property (nonatomic, weak) IBOutlet UILabel *labelDate;
@property (nonatomic, weak) IBOutlet UILabel *labelLast;
//@property (nonatomic, strong) CircleMarker *circleMarker;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayMarketWatch;
@property (nonatomic, assign) NSInteger selectedIndexOption;
@property (nonatomic, strong) UIButton *buttonRecent;

@end

@implementation CompanyGraphViewController

@synthesize securityId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];
//    _orientation = [[UIDevice currentDevice] orientation];
//    if (_orientation == UIDeviceOrientationUnknown || _orientation == UIDeviceOrientationFaceUp || _orientation == UIDeviceOrientationFaceDown) {
//        _orientation = UIDeviceOrientationPortrait;
//    }
    
    [self clearMarketValues];

    self.labelSymbol.text = self.securityId;

    [self.buttonOneDay setBackgroundColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1]];
    self.selectedIndexOption = 1;
    self.buttonRecent = self.buttonOneDay;
    
    ChartXAxis *xAxis = _lineChartViewQE.xAxis;
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
//    xAxis.granularity = 3600.0;
    
    _lineChartViewQE.backgroundColor = [UIColor colorWithRed:252/255.f green:252/255.f blue:252/255.f alpha:0.7f];
    _lineChartViewQE.delegate = self;
//    _lineChartViewQE.descriptionText = @"";
    _lineChartViewQE.chartDescription.enabled = NO;
    _lineChartViewQE.noDataText = CHART_DATA_UNAVAILABLE;
//    _lineChartViewQE.noDataTextDescription = CHART_DATA_UNAVAILABLE;
    
    _lineChartViewQE.dragEnabled = YES;
    _lineChartViewQE.pinchZoomEnabled = YES;
    _lineChartViewQE.drawGridBackgroundEnabled = NO;
    _lineChartViewQE.scaleXEnabled = YES;
    _lineChartViewQE.scaleYEnabled = NO;
    
    //    // x-axis limit line
    //    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    //    llXAxis.lineWidth = 4.0;
    //    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    //    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    //    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];

    _lineChartViewQE.rightAxis.enabled = YES;
    _lineChartViewQE.leftAxis.enabled = NO;
    _lineChartViewQE.rightAxis.drawGridLinesEnabled = YES;
    _lineChartViewQE.xAxis.drawGridLinesEnabled = YES;
    _lineChartViewQE.rightAxis.gridLineWidth = 0.1;
    _lineChartViewQE.xAxis.gridLineWidth = 0.1;
    _lineChartViewQE.xAxis.labelPosition = XAxisLabelPositionBottom;
    _lineChartViewQE.rightAxis.drawTopYLabelEntryEnabled = YES;
//    _lineChartViewQE._defaultValueFormatter.maximumSignificantDigits = 4;
//    _lineChartViewQE._defaultValueFormatter.minimumSignificantDigits = 4;

    //    _lineChartViewQE.xAxis.drawAxisLineEnabled = YES;
    //    lineChartView.leftAxis.axisLineColor = [UIColor redColor];
    
    _lineChartViewQE.legend.enabled = NO;
//    self.markerView = [[BalloonMarker alloc] initWithColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    self.markerView.minimumSize = CGSizeMake(120.f, 40.f);
//    _lineChartViewQE.marker = _markerView;
//    _lineChartViewQE.marker.image = [UIImage imageNamed:@"icon_marker.png"];
    _lineChartViewQE.drawMarkers = NO;
    
//    self.circleMarker = [[CircleMarker alloc] initWithColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    self.circleMarker.minimumSize = CGSizeMake(10.f, 10.f);
//    _lineChartViewQE.marker = _circleMarker;
}

-(void)viewWillAppear:(BOOL)animated {
//    UIApplication* application = [UIApplication sharedApplication];
//    if (application.statusBarOrientation != UIInterfaceOrientationPortrait)
//    {
//        UIViewController *c = [[UIViewController alloc]init];
//        [self presentViewController:c animated:NO completion:nil];
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];
    _orientation = [[UIDevice currentDevice] orientation];
    if (_orientation == UIDeviceOrientationUnknown || _orientation == UIDeviceOrientationFaceUp || _orientation == UIDeviceOrientationFaceDown) {
        _orientation = UIDeviceOrientationPortrait;
    }
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    
    NSDate *fromDate = [GlobalShare returnCalendarDate:1];
    [self performSelector:@selector(getStockLandscape:) withObject:fromDate afterDelay:0.01f];

//    [self updateChartData];
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
        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
//{
//    return UIInterfaceOrientationPortrait;
//}

- (IBAction)actionAddRemoveMarker:(id)sender {
    LineChartDataSet *set1 = nil;
    if (_lineChartViewQE.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_lineChartViewQE.data.dataSets[0];
        [set1 setDrawVerticalHighlightIndicatorEnabled:!set1.drawVerticalHighlightIndicatorEnabled];
        [set1 setDrawHorizontalHighlightIndicatorEnabled:!set1.drawHorizontalHighlightIndicatorEnabled];
        [_lineChartViewQE.data notifyDataChanged];
        [_lineChartViewQE notifyDataSetChanged];
    }
    [_lineChartViewQE setDrawMarkers:!_lineChartViewQE.drawMarkers];
    
    if([_buttonPlus.backgroundColor isEqual:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]]) {
        [self.labelClose setHidden:NO];
        [self.labelDate setHidden:NO];
        [self.labelLast setHidden:YES];
        [_buttonPlus setBackgroundColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1]];
    }
    else {
        [self.labelClose setHidden:YES];
        [self.labelDate setHidden:YES];
        [self.labelLast setHidden:NO];
        [_buttonPlus setBackgroundColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]];
    }
}

- (IBAction)actionselectedStockData:(id)sender {
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    
    UIButton *buttonReceive = (UIButton *)sender;
    if(self.buttonRecent.tag == buttonReceive.tag)
        return;

    self.selectedIndexOption = buttonReceive.tag;
    [self.buttonRecent setBackgroundColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]];

//    if([buttonReceive.backgroundColor isEqual:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]]) {
        [buttonReceive setBackgroundColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1]];
//    }
//    else {
//        [buttonReceive setBackgroundColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]];
//    }
    
    self.buttonRecent = buttonReceive;
    NSDate *fromDate = [GlobalShare returnCalendarDate:buttonReceive.tag];
    [self performSelector:@selector(getStockLandscape:) withObject:fromDate afterDelay:0.01f];
}

#pragma mark - Common actions

-(void) getStockLandscape:(NSDate *)fromDate {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
        NSString *strFromDate = [GlobalShare returnUSDate:fromDate];
        NSString *strToDate = [GlobalShare returnUSDate:[NSDate date]];
        NSString *strParams = [NSString stringWithFormat:@"?ticker=%@&fromDate=%@&toDate=%@", self.securityId, strFromDate, strToDate];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"StockLandscape", strParams];
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
                                                                       self.labelLast.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last", @"Last"), [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"comp_current_price"]]];
                                                                       
                                                                       if([dictVal[@"lstIntra_day"] isKindOfClass:[NSArray class]] || [dictVal[@"lstIntra_day"] isKindOfClass:[NSMutableArray class]]) {
                                                                           self.arrayMarketWatch = dictVal[@"lstIntra_day"];
                                                                       }
                                                                       else {
                                                                           self.arrayMarketWatch = nil;
                                                                       }
                                                                       
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

- (BOOL)canAutoRotate
{
    return YES;
}

- (void)updateChartData
{
    [_lineChartViewQE animateWithYAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
    [self setDataCount:30 range:100];
}

-(void)didRotate:(NSNotification *)notification {
    _orientation = [[UIDevice currentDevice] orientation];
//    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];
//    if (newOrientation != UIDeviceOrientationUnknown && newOrientation != UIDeviceOrientationFaceUp && newOrientation != UIDeviceOrientationFaceDown) {
//        _orientation = newOrientation;
//    }
    
    // Do your orientation logic here
    if (_orientation == UIDeviceOrientationLandscapeLeft || _orientation == UIDeviceOrientationLandscapeRight) {
    } else if (_orientation == UIDeviceOrientationPortrait)
    {
        // Clear the current view and insert the orientation specific view.
//        if([[GlobalShare sharedInstance] canAutoRotateL]) {
//            [self.navigationController popViewControllerAnimated:NO];
//        [self.view removeFromSuperview];
//        }
        [[GlobalShare sharedInstance] setCanRotateOnClick:NO];
//        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    }
}
-(NSString *)convertingTimeStampToDate:(double)timeStamp{
    // double timeStamp = 1474914600000;
    NSTimeInterval timeInterval=timeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString=[dateformatter stringFromDate:date];
    return dateString;
}

// Related to Charts ......
- (void)setDataCount:(int)count range:(double)range
{
    if([self.arrayMarketWatch count] == 0) {
        _lineChartViewQE.data = nil;
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
        if(self.selectedIndexOption == 0) {
            strVal = [self.arrayMarketWatch[i][@"update_date"] componentsSeparatedByString:@" "][1];
            strVal = [NSString stringWithFormat:@"%@:%@", [strVal componentsSeparatedByString:@":"][0], [strVal componentsSeparatedByString:@":"][1]];
        }
        else {
        strVal = [self.arrayMarketWatch[i][@"update_date"] componentsSeparatedByString:@" "][0];
            
        }
      
        
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"dd-MM-YYYY"];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

       [dateFormat setDateFormat:@"dd-MM-yyyy"];


//        NSDate *to = [NSDate date];
        NSDate *from = [dateFormat dateFromString:strVal];

       // NSTimeInterval point = [to timeIntervalSinceDate:from];
       NSTimeInterval point = [from timeIntervalSince1970] ;

       // NSTimeInterval x = point;
      NSNumber *num = [NSNumber numberWithDouble:point];

       // NSNumber *num = [NSNumber numberWithDouble:point];
        [xVals addObject:num];
        
          // NSLog(@"%@ -- > %@ ----> %@",strVal,from,num);
        
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    //    for (int i = 0; i < 7; i++)
    //    {
    //        double val = (double) RAND_FROM_TO(10000, 10100);
    //        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    //    }
    
    for (int i = 0; i < self.arrayMarketWatch.count; i++)
    {
//        double val = [self.arrayMarketWatch[i][@"comp_current_price"] doubleValue];
        [yVals addObject:self.arrayMarketWatch[i][@"comp_current_price"]];
    }
    
    
    //    _chartView.xAxis._axisMaximum = [self.arrayMarketIndex count]-1;
    //    _chartView.xAxis._axisMinimum = 0;
    //    _chartView.xAxis.axisMaxValue = [self.arrayMarketIndex count]-1;
    //    _chartView.xAxis.axisMinValue = 0;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
//    NSString *strVal;
    for (int i = 0; i < self.arrayMarketWatch.count; i++)//
    {
//        if(self.selectedIndexOption == 0) {
//            strVal = [self.arrayMarketWatch[i][@"update_date"] componentsSeparatedByString:@" "][1];
//            strVal = [NSString stringWithFormat:@"%@:%@", [strVal componentsSeparatedByString:@":"][0], [strVal componentsSeparatedByString:@":"][1]];
//        }
//        else {
//            strVal = [self.arrayMarketWatch[i][@"update_date"] componentsSeparatedByString:@" "][0];
//        }
//
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"dd-MM-YYYY"];
//
//        NSTimeInterval now = [[dateFormat dateFromString:strVal] timeIntervalSince1970];
//        NSTimeInterval hourSeconds = 3600.0;
//
//        NSTimeInterval from = now - (count / 2.0) * hourSeconds;
//        //        NSTimeInterval to = now + (count / 2.0) * hourSeconds;
//
//        NSTimeInterval x = from;
//
//        NSLog(@"\nX values %f\nY values %@",x,yVals);
        
        [values addObject:[[ChartDataEntry alloc] initWithX:[[xVals objectAtIndex:i] doubleValue] y:[[yVals objectAtIndex:i] doubleValue]]];
    }
    
//    NSLog(@"Line data values \n%@\nX values = %@",values,xVals);
    
    LineChartDataSet *set1 = nil;
    if (_lineChartViewQE.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_lineChartViewQE.data.dataSets[0];
//        set1.yVals = yVals;
//        _lineChartViewQE.data.xValsObjc = xVals;
        set1.values = values;
        [_lineChartViewQE.data notifyDataChanged];
        [_lineChartViewQE notifyDataSetChanged];
        [_indicatorView setHidden:YES];
    }
    else
    {
//        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
        
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
        [set1 setColor:[UIColor colorWithRed:204/255.f green:224/255.f blue:255/255.f alpha:1.f]];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 2.0;
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
//        set1.drawCubicEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.drawCirclesEnabled = NO;
        set1.drawVerticalHighlightIndicatorEnabled = NO;
        set1.drawHorizontalHighlightIndicatorEnabled = NO;
        set1.highlightColor = [UIColor orangeColor];
        set1.highlightLineWidth = 0.2;
        set1.axisDependency = AxisDependencyRight;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
//        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _lineChartViewQE.data = data;
        [_indicatorView setHidden:YES];
    }
}

-(void) clearMarketValues {
    self.labelClose.text = @"";
    self.labelDate.text = @"";
    self.labelLast.text = @"";
}

#pragma mark - ChartViewDelegate

-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    
    self.labelClose.text = [NSString stringWithFormat:@"%@: %.2f", NSLocalizedString(@"Close", @"Close"), entry.y];
    
    NSString *dateStr = [self convertingTimeStampToDate:entry.x];
    self.labelDate.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Date", @"Date"), dateStr];
    
    NSLog(@"%@ ---- >%f",dateStr,entry.x);
}
/*
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{

      NSLog(@"entry............. %@",entry);
    
//    self.labelClose.text = [NSString stringWithFormat:@"%@: %.2f", NSLocalizedString(@"Close", @"Close"), entry.value];
//    NSString *strVal;
//    if(self.selectedIndexOption == 0) {
//        strVal = [self.arrayMarketWatch[entry.xIndex][@"update_date"] componentsSeparatedByString:@" "][1];
//        strVal = [NSString stringWithFormat:@"%@:%@", [strVal componentsSeparatedByString:@":"][0], [strVal componentsSeparatedByString:@":"][1]];
//    }
//    else {
//        strVal = [self.arrayMarketWatch[entry.xIndex][@"update_date"] componentsSeparatedByString:@" "][0];
//    }
//
//    self.labelDate.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Date", @"Date"), strVal];
//
}
*/
- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
        NSLog(@"chartValueNothingSelected");
}

-(void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
}

-(void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    
}


@end
