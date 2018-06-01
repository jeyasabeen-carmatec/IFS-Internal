//
//  ActiveStocksViewController.m
//  QIFS
//
//  Created by zylog on 06/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ActiveStocksViewController.h"
#import "BarView.h"

@interface ActiveStocksViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTurnOver;
@property (nonatomic, weak) IBOutlet UILabel *labelVolume;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) BarView *barViewTurnOver;
@property (nonatomic, strong) BarView *barViewVolume;
@property (nonatomic, strong) NSArray *arrayValueStocks;
@property (nonatomic, strong) NSArray *arrayVolumeStocks;
//@property (nonatomic, strong) CircleView *circleViewAlert;

@end

@implementation ActiveStocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalShare = [GlobalShare sharedInstance];

    _labelVolume.layer.cornerRadius = 3;
    _labelVolume.layer.masksToBounds = YES;
    _labelTurnOver.layer.cornerRadius = 3;
    _labelTurnOver.layer.masksToBounds = YES;

//    self.arrayActiveStocks = @[
//                          @{
//                              @"Symbol": @"GOOGL",
//                              @"Name": @"Google",
//                              @"Value": @"237,956,841.96",
//                              @"Price": @"59.47"
//                              },
//                          @{
//                              @"Symbol": @"CMCSA",
//                              @"Name": @"Comcast Corp",
//                              @"Value": @"137,956,841.96",
//                              @"Price": @"566.24"
//                              },
//                          @{
//                              @"Symbol": @"FB",
//                              @"Name": @"Facebook",
//                              @"Value": @"127,956,841.96",
//                              @"Price": @"83.38"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"107,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"97,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"92,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"87,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"79,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"65,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"50,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"40,956,841.96",
//                              @"Price": @"93.59"
//                              },
//                          @{
//                              @"Symbol": @"AAPL",
//                              @"Name": @"APPLE",
//                              @"Value": @"30,956,841.96",
//                              @"Price": @"93.59"
//                              }
//                          ];
//    
//    double firstVal, percentVal = 0;
//    NSMutableArray *arrVal = [[NSMutableArray alloc] init];
//    
//    firstVal = [GlobalShare returnDoubleFromStringActive:self.arrayActiveStocks[0][@"Value"]];
//    
//    for(int i = 0; i<[self.arrayActiveStocks count]; i++) {
//        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
//        percentVal = ([GlobalShare returnDoubleFromStringActive:self.arrayActiveStocks[i][@"Value"]]/firstVal) * 100;
//        [newDict setValue:self.arrayActiveStocks[i][@"Value"] forKey:@"Value"];
//        [newDict setValue:self.arrayActiveStocks[i][@"Symbol"] forKey:@"Symbol"];
//        [newDict setValue:self.arrayActiveStocks[i][@"Price"] forKey:@"Price"];
//        [newDict setValue:[NSString stringWithFormat:@"%.2f", percentVal] forKey:@"Percent"];
//        [arrVal addObject:newDict];
//    }
//
////    self.circleViewAlert = [[CircleView alloc] init];
//
//    [self.labelTurnOver layoutIfNeeded];
//    [self.labelVolume layoutIfNeeded];
//
//    self.barViewTurnOver = [[BarView alloc] initWithValues:arrVal];
//    self.barViewVolume = [[BarView alloc] initWithValues:arrVal];
//
////    CGRect screenRect = [[UIScreen mainScreen] bounds];
////    CGFloat myYPos = 30;
////    CGFloat screenHeight = screenRect.size.height;
////
////    CGRect rectTurnOver = CGRectMake(self.labelTurnOver.frame.origin.x, myYPos, self.labelTurnOver.frame.size.width, screenHeight-myYPos);
////    CGRect rectVolume = CGRectMake(self.labelVolume.frame.origin.x, myYPos, self.labelVolume.frame.size.width, screenHeight-myYPos);
////
////    if(self.barViewTurnOver != nil) {
////        [self.barViewTurnOver removeFromSuperview];
////        self.barViewTurnOver = nil;
////    }
////    if(self.barViewVolume != nil) {
////        [self.barViewVolume removeFromSuperview];
////        self.barViewVolume = nil;
////    }
////    self.barViewTurnOver = [[BarView alloc] initWithFrame:rectTurnOver];
////    self.barViewVolume = [[BarView alloc] initWithFrame:rectVolume];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[GlobalShare sharedInstance] setCanAutoRotateL:NO];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getTickerTopVolume) withObject:nil afterDelay:0.01f];
    [self performSelector:@selector(getTickerTopValue) withObject:nil afterDelay:0.01f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common actions

- (void)showActiveBarViewVolume {
    double firstVal, percentVal = 0;
    NSMutableArray *arrVal = [[NSMutableArray alloc] init];
    
    firstVal = [GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arrayVolumeStocks[0][@"volume_all"]]];
    
    for(int i = 0; i<[self.arrayVolumeStocks count]; i++) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        percentVal = ([GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arrayVolumeStocks[i][@"volume_all"]]]/firstVal) * 100;
        [newDict setValue:[GlobalShare createCommaSeparatedString:self.arrayVolumeStocks[i][@"volume_all"]] forKey:@"Value"];
        [newDict setValue:self.arrayVolumeStocks[i][@"ticker"] forKey:@"Symbol"];
        [newDict setValue:[NSString stringWithFormat:@"%.2f", percentVal] forKey:@"Percent"];
        [arrVal addObject:newDict];
    }
    
    [self.labelVolume layoutIfNeeded];
    
    if(self.barViewVolume != nil) [self.barViewVolume removeFromSuperview];
    self.barViewVolume = [[BarView alloc] initWithValues:arrVal];

    
    CGRect screenRect = self.view.bounds;
    CGFloat myYPos = self.labelVolume.frame.origin.y+self.labelVolume.frame.size.height;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rectVolumeZero = CGRectMake(self.labelVolume.frame.origin.x, myYPos, 0, screenHeight-myYPos);
    CGRect rectVolume = CGRectMake(self.labelVolume.frame.origin.x, myYPos, self.labelVolume.frame.size.width, screenHeight-myYPos);
    
//    CGRect rectVolumeZero, rectVolume;
//    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//        rectVolumeZero = CGRectMake(self.labelVolume.frame.origin.x+self.labelVolume.frame.size.width, myYPos, 0, screenHeight-myYPos);
//        rectVolume = CGRectMake(self.labelVolume.frame.origin.x+self.labelVolume.frame.size.width, myYPos, self.labelVolume.frame.size.width, screenHeight-myYPos);
//    }
//    else {
//        rectVolumeZero = CGRectMake(self.labelVolume.frame.origin.x, myYPos, 0, screenHeight-myYPos);
//        rectVolume = CGRectMake(self.labelVolume.frame.origin.x, myYPos, self.labelVolume.frame.size.width, screenHeight-myYPos);
//    }
    
    self.barViewVolume.frame = rectVolumeZero;[self.view addSubview:self.barViewVolume];
    
    [UIView animateWithDuration:1//Amount of time the animation takes.
                          delay:0//Amount of time after which animation starts.
                        options: UIViewAnimationOptionCurveEaseInOut//How the animation will behave.
                     animations:^{
                         //here you can either set a CGAffineTransform, or change your view's frame.
                         self.barViewVolume.frame = rectVolume;
                     }
                     completion:^(BOOL finished){//This block is called when the animation completes.
                     }];
}

- (void)showActiveBarViewValue {
    double firstVal, percentVal = 0;
    NSMutableArray *arrVal = [[NSMutableArray alloc] init];
    
    firstVal = [GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arrayValueStocks[0][@"value_all"]]];
    
    for(int i = 0; i<[self.arrayValueStocks count]; i++) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        percentVal = ([GlobalShare returnDoubleFromString:[GlobalShare formatStringToTwoDigits:self.arrayValueStocks[i][@"value_all"]]]/firstVal) * 100;
        [newDict setValue:[GlobalShare createCommaSeparatedTwoDigitString:self.arrayValueStocks[i][@"value_all"]] forKey:@"Value"];
        [newDict setValue:self.arrayValueStocks[i][@"ticker"] forKey:@"Symbol"];
        [newDict setValue:[NSString stringWithFormat:@"%.2f", percentVal] forKey:@"Percent"];
        [arrVal addObject:newDict];
    }
    
    [self.labelTurnOver layoutIfNeeded];
    
    if(self.barViewTurnOver != nil) [self.barViewTurnOver removeFromSuperview];
    self.barViewTurnOver = [[BarView alloc] initWithValues:arrVal];
    
    
    CGRect screenRect = self.view.bounds;
    CGFloat myYPos = self.labelTurnOver.frame.origin.y+self.labelTurnOver.frame.size.height;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rectTurnOverZero = CGRectMake(self.labelTurnOver.frame.origin.x, myYPos, 0, screenHeight-myYPos);
    CGRect rectTurnOver = CGRectMake(self.labelTurnOver.frame.origin.x, myYPos, self.labelTurnOver.frame.size.width, screenHeight-myYPos);
    
//    CGRect rectTurnOverZero, rectTurnOver;
//    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//        rectTurnOverZero = CGRectMake(self.labelTurnOver.frame.origin.x+self.labelTurnOver.frame.size.width, myYPos, 0, screenHeight-myYPos);
//        rectTurnOver = CGRectMake(self.labelTurnOver.frame.origin.x+self.labelTurnOver.frame.size.width, myYPos, self.labelTurnOver.frame.size.width, screenHeight-myYPos);
//    }
//    else {
//        rectTurnOverZero = CGRectMake(self.labelTurnOver.frame.origin.x, myYPos, 0, screenHeight-myYPos);
//        rectTurnOver = CGRectMake(self.labelTurnOver.frame.origin.x, myYPos, self.labelTurnOver.frame.size.width, screenHeight-myYPos);
//    }

    self.barViewTurnOver.frame = rectTurnOverZero;[self.view addSubview:self.barViewTurnOver];
    
    [UIView animateWithDuration:1//Amount of time the animation takes.
                          delay:0//Amount of time after which animation starts.
                        options: UIViewAnimationOptionCurveEaseInOut//How the animation will behave.
                     animations:^{
                         //here you can either set a CGAffineTransform, or change your view's frame.
                         self.barViewTurnOver.frame = rectTurnOver;
                     }
                     completion:^(BOOL finished){//This block is called when the animation completes.
                     }];
}

-(void) getTickerTopVolume {
    @try {
    [self.indicatorView setHidden:NO];
    [self.view bringSubviewToFront:self.indicatorView];
    
    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetTickerTopVolume?isVolume=true"];
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
                                                                   if([returnedDict[@"result"] isKindOfClass:[NSArray class]] || [returnedDict[@"result"] isKindOfClass:[NSMutableArray class]]) {
                                                                       self.arrayVolumeStocks = returnedDict[@"result"];  // update model objects on main thread
                                                                   }
                                                                   else {
                                                                       self.arrayVolumeStocks = nil;
                                                                   }
                                                                   
                                                                   self.arrayVolumeStocks = [self.arrayVolumeStocks sortedArrayUsingDescriptors:
                                                                                            @[[NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"%@.doubleValue", @"volume_all"]
                                                                                                                            ascending:NO]]];
                                                                   
                                                                   [self showActiveBarViewVolume];
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

-(void) getTickerTopValue {
    @try {
    [self.indicatorView setHidden:NO];
    [self.view bringSubviewToFront:self.indicatorView];

    NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetTickerTopVolume?isVolume=false"];
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
                                                                   if([returnedDict[@"result"] isKindOfClass:[NSArray class]] || [returnedDict[@"result"] isKindOfClass:[NSMutableArray class]]) {
                                                                       self.arrayValueStocks = returnedDict[@"result"];  // update model objects on main thread
                                                                   }
                                                                   else {
                                                                       self.arrayValueStocks = nil;
                                                                   }
                                                                   
                                                                   self.arrayValueStocks = [self.arrayValueStocks sortedArrayUsingDescriptors:
                                                                              @[[NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"%@.doubleValue", @"value_all"]
                                                                                                              ascending:NO]]];

                                                                   [self showActiveBarViewValue];
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

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Active";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
