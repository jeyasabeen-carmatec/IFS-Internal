//
//  SectorsGraphViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "SectorsGraphViewController.h"
#import <Charts/Charts.h>
#import "SectorsGraphCell.h"

NSString *const kSectorsGraphCellIdentifier = @"SectorsGraphCell";

@interface SectorsGraphViewController () <ChartViewDelegate, NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet PieChartView *chartView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UITableView *tableViewComponents;
@property (nonatomic, weak) IBOutlet UILabel *labelComapany;
@property (nonatomic, weak) IBOutlet UIImageView *imageArrow;
//@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, strong) NSArray *arraySectorList;
@property (nonatomic, strong) NSArray *arrayCompanyList;
@property (nonatomic, strong) NSArray *legendColors;
@property (nonatomic, strong) NSString *companyId;


@end

@implementation SectorsGraphViewController
//{
//    NSMutableArray *yVals1;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    self.tableViewComponents.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _chartView.usePercentValuesEnabled = YES;
    _chartView.drawSlicesUnderHoleEnabled = NO;
    _chartView.holeRadiusPercent = 0.58;
    _chartView.transparentCircleRadiusPercent = 0.61;
//    _chartView.descriptionText = @"";
    [_chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    _chartView.extraTopOffset = -5.0f;
    _chartView.extraBottomOffset = 0.0f;
    _chartView.extraLeftOffset = -5.0f;
    _chartView.extraRightOffset = -5.0f;

    _chartView.drawCenterTextEnabled = YES;
    _chartView.userInteractionEnabled = YES;
    _chartView.chartDescription.text = @"";
    
//    [_labelComapany setText:@""];
//    [_labelComapany setHidden:YES];
//    [_imageArrow setHidden:YES];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//
//    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby Daniel Cohen Gindi"];
//    [centerText setAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
//                                NSParagraphStyleAttributeName: paragraphStyle
//                                } range:NSMakeRange(0, centerText.length)];
//    [centerText addAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
//                                NSForegroundColorAttributeName: UIColor.grayColor
//                                } range:NSMakeRange(10, centerText.length - 10)];
//    [centerText addAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
//                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
//                                } range:NSMakeRange(centerText.length - 19, 19)];
//    _chartView.centerAttributedText = centerText;
    
    _chartView.drawHoleEnabled = YES;
    _chartView.rotationAngle = 0.0;
    _chartView.rotationEnabled = YES;
    _chartView.highlightPerTapEnabled = YES;
    
//    ChartLegend *l = _chartView.legend;
//    l.position = ChartLegendDirectionRightToLeft;
//    l.xEntrySpace = 7.0;
//    l.yEntrySpace = 0.0;
//    l.yOffset = 0.0;
//    _chartView.legend.enabled = NO;
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;

    _chartView.legend.enabled = NO;
    _chartView.delegate = self;
}

- (void)setDataCount:(int)count range:(double)range
{
//    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
     @try{
    
    for (int i = 0; i < count; i++)
    {
        NSDictionary *def = self.arraySectorList[i];
//        cell.labelCompany.text = def[(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"];
        //    cell.labelPercent.text = @"14.53 %";e.value / yValueSum * 100.0
        //    cell.labelValue.text = def[@"Index"];

        
//        NSDictionary *def = self.arraySectorList[i];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:[GlobalShare roundoff:[def[@"sector_percentage"] doubleValue] :2] label:def[(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"] icon: [UIImage imageNamed:@"icon"]]];
       
    } // For Loop Close
        
    } @catch(NSException *exception){
          NSLog(@"%@",values);
        NSLog(@"Sectors Exception ....");
    }
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    
    dataSet.drawIconsEnabled = NO;
    
//    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[GlobalShare sharedInstance] setCanAutoRotateL:NO];
    
//    self.arrayCompanyList = @[
//                          @{
//                              @"Symbol": @"CMCSA",
//                              @"Name": @"Comcast Corp",
//                              @"Value": @"59.47",
//                              @"Color": ChartColorTemplates.vordiplom
//                              },
//                          @{
//                              @"Symbol": @"GOOGL",
//                              @"Name": @"Google",
//                              @"Value": @"566.24",
//                              @"Color": ChartColorTemplates.joyful
//                              },
//                          @{
//                              @"Symbol": @"FB",
//                              @"Name": @"Facebook",
//                              @"Value": @"83.38",
//                              @"Color": ChartColorTemplates.colorful
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"93.59",
//                              @"Color": ChartColorTemplates.liberty
//                              },
//                          @{
//                              @"Symbol": @"YHOO",
//                              @"Name": @"YAHOO",
//                              @"Value": @"36.24",
//                              @"Color": ChartColorTemplates.material
//                              }
//                          ];
//    
//    globalShare.stockSectors = @[
//                                 @{
//                                     @"Name": @"Financial Services",
//                                     @"Value": @"59.47",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.vordiplom
//                                     },
//                                 @{
//                                     @"Name": @"Consumer Services",
//                                     @"Value": @"566.24",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.joyful
//                                     },
//                                 @{
//                                     @"Name": @"Industrials",
//                                     @"Value": @"83.38",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.colorful
//                                     },
//                                 @{
//                                     @"Name": @"Insurance",
//                                     @"Value": @"93.59",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.liberty
//                                     },
//                                 @{
//                                     @"Name": @"Real Estate",
//                                     @"Value": @"46.24",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.material
//                                     },
//                                 @{
//                                     @"Name": @"Telecoms",
//                                     @"Value": @"56.24",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.pastel
//                                     },
//                                 @{
//                                     @"Name": @"Transportation",
//                                     @"Value": @"26.24",
//                                     @"Index": @"2.2M",
//                                     @"Color": ChartColorTemplates.pastel
//                                     }
//                                 ];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getSecurityBySector) withObject:nil afterDelay:0.01f];
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
    [_labelComapany setText:@""];
    [_labelComapany setHidden:YES];
    [_imageArrow setHidden:YES];
    
    self.companyId = @"100";
    [self updateChartData:self.companyId];
}

#pragma mark - Common actions

-(void) getSecurityBySector {
    @try {
    [self.indicatorView setHidden:NO];
    
    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetSecurityBySector"];
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
                                                                   self.arraySectorList = returnedDict[@"result"];  // update model objects on main thread
                                                                   self.companyId = @"100";
                                                                   [self updateChartData:self.companyId];

//                                                                   NSArray *techCount = [self.arraySectorList valueForKeyPath:@"@distinctUnionOfObjects.security_sector"];
//                                                                   NSLog(@"sdfds");
//                                                                   [self.tableViewComponents reloadData];              // also update UI on main thread
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

- (void)updateChartData:(NSString *)passCompanyId
{
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setDataCount:passCompanyId];
}

- (void)setDataCount:(NSString *)passCompanyId
{
//    self.arrayCompanyList = [self.arraySectorList valueForKeyPath:@"@distinctUnionOfObjects.security_sector"];
//    for(int i=0;i<[self.arrayCompanyList count];i++) {
//        NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.Sector matches %@", self.arrayCompanyList[i]];
//        NSArray *arrFiltered = [globalShare.sectorValues filteredArrayUsingPredicate:applePred];
//    }
//    int sum = [myDicionariesArrey valueForKeyPath:@"@sum.keyToCulc"];
    
    if(![passCompanyId isEqualToString:@"100"]) {
        passCompanyId = [NSString stringWithFormat:@"%ld", (long)([passCompanyId intValue] - 1)];
        NSDictionary *def = self.arraySectorList[[passCompanyId integerValue]];
        
        self.arrayCompanyList = def[@"securities"];
    }

    NSMutableArray *companyName = [[NSMutableArray alloc] init];
    NSInteger count = ([passCompanyId isEqualToString:@"100"]) ? (int)self.arraySectorList.count : (int)self.arrayCompanyList.count;
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [companyName addObject:([passCompanyId isEqualToString:@"100"]) ? self.arraySectorList[i][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"] : self.arrayCompanyList[i][@"ticker"]];
    }

   NSMutableArray  *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.[GlobalShare returnDoubleFromStringActive:[GlobalShare formatStringToTwoDigits:self.arrayVolumeStocks[0][@"volume_all"]]]
    for (int i = 0; i < count; i++)
    {
//        NSNumber *sumofValues;
//        if([passCompanyId isEqualToString:@"100"]) {
//            NSDictionary *def = self.arraySectorList[i];
//            self.arrayCompanyList = def[@"securities"];
//            sumofValues = [self.arrayCompanyList valueForKeyPath:@"@sum.value_all"];
//            [yVals1 addObject:sumofValues];
//        }
    
//        NSLog(@"The numbers Y val = %@",yVals1);

//        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) xIndex:i]];
//        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:([passCompanyId isEqualToString:@"100"]) ? [GlobalShare returnDoubleFromStringActive:[GlobalShare formatStringToTwoDigits:[sumofValues stringValue]]] : [GlobalShare returnDoubleFromStringActive:[GlobalShare formatStringToTwoDigits:self.arrayCompanyList[i][@"value_all"]]] xIndex:i]];
//        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:([passCompanyId isEqualToString:@"100"]) ? [GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arraySectorList[i][@"sector_value"]]] : [GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arrayCompanyList[i][@"value_all"]]] xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:companyName[i % companyName.count]];
    }
    
//    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
//    dataSet.sliceSpace = 2.0;
    
//    for (int i = 0; i < [dataSet.yVals count]; i++)
//    {
//        NSLog(@"%@", dataSet.yVals[i]);
//    }

    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.material];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
//    dataSet.colors = colors;
    self.legendColors = colors;
    
//    dataSet.valueLinePart1OffsetPercentage = 0.8;
//    dataSet.valueLinePart1Length = 0.2;
//    dataSet.valueLinePart2Length = 0.6;
//    dataSet.xValuePosition = PieChartValuePositionInsideSlice;
//    dataSet.yValuePosition = PieChartValuePositionInsideSlice;
//
//    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 2;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
//    [data setValueFormatter:pFormatter];
//    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
//    [data setValueTextColor:UIColor.blackColor];
    
//    _chartView.data = data;
    _chartView.centerText = ([passCompanyId isEqualToString:@"100"]) ? NSLocalizedString(@"Market Sectors", @"Market Sectors") : self.arraySectorList[[passCompanyId integerValue]][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"];
    [_chartView highlightValues:nil];    
    [_tableViewComponents reloadData];
    
    
    [self setDataCount:(int)count range:100];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arraySectorList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"SectorsGraphCell";
//    SectorsGraphCell *cell = (SectorsGraphCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell == nil) {
//        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SectorsGraphCell" owner:nil options:nil];
//        cell = [nibObjects objectAtIndex:0];
//    }
    SectorsGraphCell *cell = (SectorsGraphCell *) [tableView dequeueReusableCellWithIdentifier:kSectorsGraphCellIdentifier forIndexPath:indexPath];

    NSDictionary *def = self.arraySectorList[indexPath.row];

    cell.labelCompany.text = def[(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"];
//    cell.labelPercent.text = @"14.53 %";e.value / yValueSum * 100.0
//    cell.labelValue.text = def[@"Index"];
    cell.labelPercent.text = [NSString stringWithFormat:@"%.2f%%", [GlobalShare roundoff:[def[@"sector_percentage"] doubleValue] :2]];
    cell.labelValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[def[@"sector_value"] stringValue]];
    [cell.imageLegend setBackgroundColor:self.legendColors[indexPath.row]];
    [cell.imageBg setBackgroundColor:[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageLegend.layer.cornerRadius = 3;
    cell.imageLegend.layer.borderWidth = 1.5;
    cell.imageLegend.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.imageLegend.layer.masksToBounds = YES;

    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_labelComapany setText:self.arraySectorList[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"]];
    [_labelComapany setHidden:NO];
    [_imageArrow setHidden:NO];
    [self updateChartData:self.arraySectorList[indexPath.row][@"security_sector"]];
    
    NSLog(@"Did select ...%@",[self.arraySectorList objectAtIndex:indexPath.row]);
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Sectors";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
