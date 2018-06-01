//
//  GlobalShare.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "GlobalShare.h"
#import "Reachability.h"

static GlobalShare *_shareInstane;

@interface GlobalShare ()

@end

@implementation GlobalShare

@synthesize stockSectors;
@synthesize topNavController;
@synthesize topViewController;
@synthesize sectorValues;
@synthesize dictValues;
@synthesize isDirectOrder;
@synthesize isPortfolioOrder;
@synthesize isBuyOrder;
@synthesize isConfirmOrder;
@synthesize isDirectViewOrder;
@synthesize canAutoRotate;
@synthesize canAutoRotateL;
@synthesize canRotateOnClick;
@synthesize isBuyOrSell;
@synthesize myLanguage;

@synthesize timerStockList;
@synthesize timerPortfolio;
@synthesize timerNewOrder;
@synthesize timerGainLoss;
@synthesize timerActive;
@synthesize timerFavorites;
@synthesize timerMarketDepth;

@synthesize isTimerStockListRun;
@synthesize isTimerPortfolioRun;
@synthesize isTimerNewOrderRun;
@synthesize isTimerGainLossRun;
@synthesize isTimerActiveRun;
@synthesize isTimerFavoritesRun;
@synthesize isTimerMarketDepthRun;

@synthesize strCommission;

@synthesize pickerData1;
@synthesize pickerData2;
@synthesize pickerData3;
@synthesize arraySectors;

@synthesize fmDBObject;
@synthesize fmRSObject;

//@synthesize strOrderType;
@synthesize isErrorPupup;

+ (GlobalShare *)sharedInstance {
    if (_shareInstane == nil) {
        _shareInstane = [[GlobalShare alloc] init];
    }
    return _shareInstane;
}

+ (NSString *)documentFilePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return([documentsDir stringByAppendingPathComponent:fileName]);
}

+ (void)insertDocumentIntoPath:(NSString *)stringFileName {
    NSString *documentsDirectory = [GlobalShare documentFilePath:stringFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[stringFileName componentsSeparatedByString:@"."][0] ofType:[stringFileName componentsSeparatedByString:@"."][1]];
        
        NSLog(@"DB Path %@",bundlePath);
        if (bundlePath == nil)
        {
            NSLog(@"Database path is nil");
        }
        else
        {
            BOOL isCopiedDB = [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentsDirectory error:nil];
            if (!isCopiedDB) NSLog(@"Copying database failed");
        }
    }
}

+ (CGRect)setViewMovedUp:(BOOL)movedUp :(UIView *)view :(CGFloat)kOFFSET_FOR_KEYBOARD {
    CGRect rect = view.frame;
    if (movedUp) {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
    }
    else {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    return rect;
}

+ (void)generalAlertView:(NSString *)stringTitle :(NSString *)stringMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:stringTitle message:stringMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

+ (BOOL)isConnectedInternet {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        return NO;
    }
    return YES;
}

+ (BOOL)isNumeric:(NSString *)stringVal {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithRange:NSMakeRange('0',10)] invertedSet];
    NSString *trimmed = [stringVal stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    BOOL isNumeric = trimmed.length > 0 && [trimmed rangeOfCharacterFromSet:nonNumberSet].location == NSNotFound;
    return isNumeric;
}

+ (BOOL)isValidEmailAddress:(NSString *)strEmail {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:[strEmail lowercaseString]];
    return myStringMatchesRegEx;
}

+ (NSString *)replaceSpecialCharsFromMobileNumber:(NSString *)stringToPass {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
    stringToPass = [[stringToPass componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    return stringToPass;
}

+ (void)navToControllerFrom:(id)navController {
    @try {
//        NSArray *arrayViews = [navController viewControllers];
//        for (id viewController in arrayViews) {
//            if ([viewController isKindOfClass:[CalendarViewController class]]) {
//                [navController popToViewController:viewController animated:YES];
//                return;
//            }
//        }
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    } @finally {

    }
}

+ (void)loadViewControllerIndex:(NSInteger)btnIndex :(id)navController {
//    NSString *strClassName = NSStringFromClass([passViewController class]);
    NSMutableArray *arrayMenu = [NSMutableArray arrayWithObjects:@"SectorGraphViewController", @"StocksListViewController", nil];
    NSString *strClassName = [arrayMenu objectAtIndex:btnIndex];
    UIViewController *viewController1 = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:[navController viewControllers]];
    
    for (id viewController in navigationArray) {
        NSString *strClassNames = NSStringFromClass([viewController class]);
        if ([strClassNames isEqualToString:strClassName]) {
            [navController popToViewController:viewController animated:YES];
            return;
        }
    }
    [navigationArray addObject:viewController1];
    [navController setViewControllers:navigationArray];
}

+ (void)loadViewController:(id)viewCon :(id)navController {
    @try {
        NSArray *arrayViews = [navController viewControllers];
        for (id viewController in arrayViews) {
            if ([viewController isKindOfClass:[viewCon class]]) {
                [navController popToViewController:viewController animated:YES];
                return;
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    } @finally {
        
    }
}

+ (void)loadViewController:(id)navController {
    @try {
        NSArray *arrayViews = [navController viewControllers];
        id viewController = [arrayViews objectAtIndex:[arrayViews count] - 3];
        
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [navController popToViewController:viewController animated:YES];
            return;
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    } @finally {
        
    }
}

+ (NSString *)returnDateTime:(NSDate *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    return [formatter stringFromDate:theDate];
}

+ (NSString *)returnDate:(NSDate *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    return [formatter stringFromDate:theDate];
}

+ (NSDate *)returnDateAsDate:(NSString *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    return [formatter dateFromString:theDate];
}

+ (NSString *)returnUSDate:(NSDate *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:theDate];
}

+ (NSString *)returnTime:(NSDate *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:theDate];
}

+ (NSDate *)returnTimeAsDate:(NSString *)theDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter dateFromString:theDate];
}

+ (double)returnDoubleFromString:(NSString *)strValue {
    NSNumberFormatter * numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setDecimalSeparator:@"."];

    NSNumber *number = [numberFormatter numberFromString:strValue];
    double priceInDouble = [number doubleValue];
    
    return priceInDouble;
}

+ (double)returnDoubleFromStringActive:(NSString *)strValue {
    NSString *number = [strValue stringByReplacingOccurrencesOfString:@"," withString:@""];
    double priceInDouble = [number doubleValue];
    
    return priceInDouble;
}

+ (double)roundoff:(double)doubleVal :(NSInteger)noOfDigits {
    double d, r;
    d = pow(10.0, (double)noOfDigits);
    r = round (doubleVal * d) / d;
    return r;
}

+ (NSString *)formatStringToTwoDigits:(NSString *)strValue {
    NSString *stringRet = [NSString stringWithFormat:@"%.2f", [strValue doubleValue]];
    return stringRet;
}

+ (NSString *)createCommaSeparatedString:(NSString *)strValue {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[strValue doubleValue]]];
    
    return theString;
}

+ (NSString *)createCommaSeparatedTwoDigitString:(NSString *)strValue {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[strValue doubleValue]]];
    
    return theString;
}

+ (NSString *)returnOrderType:(NSString *)strIndex {
    NSArray *objects = [NSArray arrayWithObjects:@"Active", @"Filled", @"P.Filled", @"Cancelled", @"Expired", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"3", @"7", @"8", @"5", @"11", nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    return ([dic objectForKey:strIndex]);
}

+ (BOOL)returnIfExistsBetween:(double)strCurrent :(double)strMin :(double)strMax {
    NSNumber *numberCurrent = [NSNumber numberWithDouble:strCurrent];
    NSNumber *numberMin = [NSNumber numberWithDouble:strMin];
    NSNumber *numberMax = [NSNumber numberWithDouble:strMax];
    if(([numberCurrent compare:numberMin] == NSOrderedSame || [numberCurrent compare:numberMin] == NSOrderedDescending) && ([numberCurrent compare:numberMax] == NSOrderedSame || [numberCurrent compare:numberMax] == NSOrderedAscending))
    {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSDate *)returnHistoryDate:(NSInteger)passVal {
    NSDate *todayDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:todayDate];
    
    if(passVal == 0)
        components.day = [components day] - 7;
    else if(passVal == 1)
        components.month = [components month] - 1;
    else
        components.month = [components month] - 3;
    
    NSDate *formattedDate = [calendar dateFromComponents:components];
    return formattedDate;
}

+ (NSDate *)returnCalendarDate:(NSInteger)passVal {
    NSDate *todayDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:todayDate];
    
    if(passVal == 0)
        components.day = [components day] - 0;
    else if(passVal == 1)
        components.month = [components month] - 1;
    else if(passVal == 2)
        components.month = [components month] - 3;
    else if(passVal == 3)
        components.month = [components month] - 6;
    else if(passVal == 4)
        components.year = [components year] - 1;
    else
        components.year = [components year] - 3;

    NSDate *formattedDate = [calendar dateFromComponents:components];
    return formattedDate;
}

+ (BOOL)returnIfGreaterThanZero:(double)strCurrent {
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

+ (NSDate *)convertToLocalTime:(NSDate *)datePass {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:datePass];
    return [NSDate dateWithTimeInterval:seconds sinceDate:datePass];
}

+ (NSDate *)convertToGlobalTime:(NSDate *)datePass {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:datePass];
    return [NSDate dateWithTimeInterval:seconds sinceDate:datePass];
}

+ (void)showBasicAlertView:(id)viewController :(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   [[GlobalShare sharedInstance] setIsErrorPupup:NO];
                               }];
    
    [alertController addAction:okAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showBasicAlertViewTitle:(id)viewController :(NSString *)strTitle :(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(strTitle, @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [alertController addAction:okAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showSessionExpiredAlertView:(id)viewController :(NSString *)strMessage {
    GlobalShare *globalShare = [GlobalShare sharedInstance];

    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   [globalShare.topNavController popToRootViewControllerAnimated:YES];
                               }];
    
    [alertController addAction:okAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showSignOutAlertView:(id)viewController :(NSString *)strMessage {
    GlobalShare *globalShare = [GlobalShare sharedInstance];
    
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                {

                                }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                                {
                                    [globalShare.topNavController popToRootViewControllerAnimated:YES];
                                }];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }
    else {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - Rate App

+ (void)checkIfRateApp:(id)viewController {
    //Ask for Rating
    BOOL neverRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"];
    
    NSInteger launchCount = 0;
    //Get the number of launches
    launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchCount"];
    launchCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"launchCount"];
    
    if (!neverRate)
    {
        if ( (launchCount == 3) || (launchCount == 9) || (launchCount == 15) || (launchCount == 21) )
        {
            [self rateApp:viewController];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)rateApp:(id)viewController {
    //    BOOL neverRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"];
    //
    //    if (!neverRate) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please rate IFS!"
    //                                                        message:@"If you like it we'd like to know."
    //                                                       delegate:self
    //                                              cancelButtonTitle:nil
    //                                              otherButtonTitles:@"Rate It Now", @"Remind Me Later", @"No, Thanks", nil];
    //        alert.delegate = self;
    //        [alert show];
    //    }
    
    NSString *alertTitle = NSLocalizedString(@"Please rate IFS!", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(@"If you liked it, we would like to know!", @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Rate It Now", @"OK")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
                              {
                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
//                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=573753324"]]];
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id\(573753324)"]]];
                              }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remind Me Later", @"OK")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
                              {
                                  
                              }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"No, Thanks", @"OK")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
                              {
                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                              }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=573753324"]]];
//    }
//
//    else if (buttonIndex == 1) {
//
//    }
//
//    else if (buttonIndex == 2) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
//    }
//}

#pragma mark - Localization

+ (void)setSelectedLanguage:(NSInteger)currentLanguage {
    GlobalShare *globalShare = [GlobalShare sharedInstance];

    if(currentLanguage == ARABIC_LANGUAGE) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSString *strLangSelect = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    globalShare.myLanguage = currentLanguage;
    
//    return strLangSelect;
}

+ (NSInteger)getSelectedLanguage {
    NSInteger myLang;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];

//    strSelectedLanguage = [strSelectedLanguage stringByReplacingOccurrencesOfString:@"en-US" withString:@"en"];
//    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat:@"ar"]]) {
    if([strSelectedLanguage hasPrefix:@"ar"]) {
        myLang = ARABIC_LANGUAGE;
    }
    else {
        myLang = ENGLSIH_LANGUAGE;
    }
    return myLang;
}

+ (NSString *)languageSelectedStringForKey:(NSString *)passKey {
    NSString *path;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];

//    strSelectedLanguage = [strSelectedLanguage stringByReplacingOccurrencesOfString:@"en-US" withString:@"en"];
//    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat:@"ar"]]) {
    if([strSelectedLanguage hasPrefix:@"ar"]) {
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    }
    else {
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    NSString *str = [languageBundle localizedStringForKey:passKey value:@"" table:@"Localization"];
    return str;
}

@end
