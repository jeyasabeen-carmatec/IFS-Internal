//
//  GlobalShare.h
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "PropertyList.h"

@interface GlobalShare : NSObject

@property (nonatomic, assign) BOOL ismodifyOrder;
@property (nonatomic, assign) BOOL isBuytheorder;

@property (nonatomic, assign) BOOL isDayChart;
@property (nonatomic, strong) NSArray *search_results;

@property (nonatomic, strong) NSArray *stockSectors;
@property (nonatomic, strong) id topNavController;
@property (nonatomic, strong) id topViewController;
@property (nonatomic, strong) NSMutableArray *sectorValues;
@property (nonatomic, strong) NSMutableDictionary *dictValues;
@property (nonatomic, assign) BOOL isDirectOrder;
@property (nonatomic, assign) BOOL isPortfolioOrder;
@property (nonatomic, assign) BOOL isBuyOrder;
@property (nonatomic, assign) BOOL isConfirmOrder;
@property (nonatomic, assign) BOOL isDirectViewOrder;
@property (nonatomic, assign) BOOL canAutoRotate;
@property (nonatomic, assign) BOOL canAutoRotateL;
@property (nonatomic, assign) BOOL canRotateOnClick;
@property (nonatomic, assign) NSInteger isBuyOrSell;
@property (nonatomic, assign) NSInteger myLanguage;

@property (nonatomic, strong) NSTimer *timerStockList;
@property (nonatomic, strong) NSTimer *timerPortfolio;
@property (nonatomic, strong) NSTimer *timerNewOrder;
@property (nonatomic, strong) NSTimer *timerGainLoss;
@property (nonatomic, strong) NSTimer *timerActive;
@property (nonatomic, strong) NSTimer *timerFavorites;
@property (nonatomic, strong) NSTimer *timerMarketDepth;

@property (nonatomic, assign) BOOL isTimerStockListRun;
@property (nonatomic, assign) BOOL isTimerPortfolioRun;
@property (nonatomic, assign) BOOL isTimerNewOrderRun;
@property (nonatomic, assign) BOOL isTimerGainLossRun;
@property (nonatomic, assign) BOOL isTimerActiveRun;
@property (nonatomic, assign) BOOL isTimerFavoritesRun;
@property (nonatomic, assign) BOOL isTimerMarketDepthRun;

@property (nonatomic, strong) NSString *strCommission;
@property (nonatomic, strong) NSString *strNewOrderFlow;
//@property (nonatomic, strong) NSString *chartType;



@property (nonatomic, strong) NSArray *pickerData1;
@property (nonatomic, strong) NSArray *pickerData2;
@property (nonatomic, strong) NSArray *pickerData3;
@property (nonatomic, strong) NSMutableArray *arraySectors;

@property(nonatomic, strong)UIAlertAction *submit_action;
#pragma CashpositionStatus
@property (nonatomic, strong) NSString *strcashpositionName;
@property (nonatomic, assign) BOOL iscashpostionStatus;

#pragma favourites array
@property (nonatomic, strong) NSArray *favouritesArray;



@property (nonatomic, strong) FMDatabase *fmDBObject;
@property (nonatomic, strong) FMResultSet *fmRSObject;

//@property (nonatomic, strong) NSString *strOrderType;
@property (nonatomic, assign) BOOL isErrorPupup;

+ (GlobalShare *)sharedInstance;
+ (NSString *)documentFilePath:(NSString *)fileName;
+ (void)insertDocumentIntoPath:(NSString *)stringFileName;
+ (CGRect)setViewMovedUp:(BOOL)movedUp :(UIView *)view :(CGFloat)kOFFSET_FOR_KEYBOARD;
+ (void)generalAlertView:(NSString *)stringTitle :(NSString *)stringMessage;
+ (BOOL)isConnectedInternet;
+ (BOOL)isNumeric:(NSString *)stringVal;
+ (BOOL)isValidEmailAddress:(NSString *)strEmail;
+ (NSString *)replaceSpecialCharsFromMobileNumber:(NSString *)stringToPass;
+ (void)loadViewControllerIndex:(NSInteger)btnIndex :(id)navController;
+ (void)loadViewController:(id)viewController :(id)navController;
+ (void)loadViewController:(id)navController;
+ (NSString *)returnDateTime:(NSDate *)theDate;
+ (NSString *)returnDate:(NSDate *)theDate;
+ (NSDate *)returnDateAsDateanother_form:(NSString *)theDate;
+ (NSDate *)returnDateAsDate:(NSString *)theDate;
+ (NSString *)returnUSDate:(NSDate *)theDate;
+ (NSString *)returnTime:(NSDate *)theDate;
+ (NSDate *)returnTimeAsDate:(NSString *)theDate;
+ (double)returnDoubleFromString:(NSString *)strValue;
+ (double)returnDoubleFromStringActive:(NSString *)strValue;
+ (double)roundoff:(double)doubleVal :(NSInteger)noOfDigits;
+ (NSString *)formatStringToTwoDigits:(NSString *)strValue;
+ (NSString *)createCommaSeparatedString:(NSString *)strValue;
+ (NSString *)createCommaSeparatedTwoDigitString:(NSString *)strValue;
+ (NSString *)returnOrderType:(NSString *)strIndex;
+ (BOOL)returnIfExistsBetween:(double)strCurrent :(double)strMin :(double)strMax;
+ (NSDate *)returnHistoryDate:(NSInteger)passVal;
+ (NSDate *)returnCalendarDate:(NSInteger)passVal;
+ (BOOL)returnIfGreaterThanZero:(double)strCurrent;
+ (NSDate *)convertToLocalTime:(NSDate *)datePass;
+ (NSDate *)convertToGlobalTime:(NSDate *)datePass;
+ (void)showBasicAlertView:(id)viewController :(NSString *)strMessage;
+ (void)showBasicAlertViewTitle:(id)viewController :(NSString *)strTitle :(NSString *)strMessage;
+ (void)showSessionExpiredAlertView:(id)viewController :(NSString *)strMessage;
+ (void)showSignOutAlertView:(id)viewController :(NSString *)strMessage;
+ (void)checkIfRateApp:(id)viewController;
+ (void)rateApp:(id)viewController;
+ (void)setSelectedLanguage:(NSInteger)currentLanguage;
+ (NSInteger)getSelectedLanguage;
+ (NSString *)languageSelectedStringForKey:(NSString *)passKey;
+(BOOL)isUserLogedIn;
+ (NSString *)checkingNullValues:(NSString *)strValue;


//+(void)login_alert_view_creating:(UIViewController *)viewcontroller;//Praash_code

@end
