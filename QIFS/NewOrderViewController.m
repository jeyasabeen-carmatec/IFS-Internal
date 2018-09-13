//
//  NewOrderViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "NewOrderViewController.h"
#import "CalculatorViewController.h"
#import "OrderConfirmViewController.h"
#import "MarketDepthViewController.h"

#import "AlertsViewController.h"
#import "CashPositionViewController.h"
#import "OrderHistoryViewController.h"
#import "ContactUsViewController.h"
#import "SettingsViewController.h"
#import "CompanyStocksViewController.h"
#import "OptionsViewCell.h"
#import "LoginView.h"

NSString *const kNewOrderOptionsViewCellIdentifier = @"OptionsViewCell";

@interface NewOrderViewController () <UIPickerViewDelegate, UIPickerViewDataSource, NSURLSessionDelegate, orderConfirmDelegate, tabBarManageCashDelegate,UITextFieldDelegate,UITabBarDelegate>{
    LoginView *loginVw;
    UIView *overLayView;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *limitUPLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitDowmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@property (nonatomic, weak) IBOutlet UIButton *buttonTransaction;
@property (nonatomic, weak) IBOutlet UIButton *buttonOrderType;
@property (nonatomic, weak) IBOutlet UIButton *buttonDuration;
@property (nonatomic, weak) IBOutlet UITextField *textFieldLimit;
@property (nonatomic, weak) IBOutlet UITextField *textFieldQty;
@property (nonatomic, weak) IBOutlet UITextField *textFieldDisclose;
@property (nonatomic, weak) IBOutlet UIView *viewBuyPower;
@property (nonatomic, weak) IBOutlet UIView *viewOrderValue;
@property (nonatomic, weak) IBOutlet UILabel *labelBuyPower;
@property (nonatomic, weak) IBOutlet UILabel *labelOrderValue;
@property (nonatomic, weak) IBOutlet UIView *viewDisclose;
@property (nonatomic, weak) IBOutlet UIButton *buttonDisclose;
@property (nonatomic, strong) UITextField *textFieldCurrent;
@property (nonatomic, weak) IBOutlet UILabel *labelDuration;
@property (nonatomic, weak) IBOutlet UIButton *buttonBack;
@property (nonatomic, weak) IBOutlet UIButton *buttonPhoneCall;
@property (nonatomic, weak) IBOutlet UIButton *buttonSmallLogo;
@property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
@property (nonatomic, weak) IBOutlet UIButton *buttonCreate;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSMutableArray *arrayMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeight;
@property (nonatomic, weak) IBOutlet UIView *viewOptionMenu;
@property (nonatomic, weak) IBOutlet UITableView *tableViewOptionMenu;
@property (nonatomic, strong) UIButton *transparencyButton;

@property (nonatomic, weak) IBOutlet UIButton *buttonCall;
//@property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
@property (nonatomic, weak) IBOutlet UIButton *buttonAlert;
@property (nonatomic, weak) IBOutlet UIButton *buttonOptionMenu;
//@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

//@property (nonatomic, weak) IBOutlet UITableView *tableResults;
@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) NSMutableArray *allResults;
//@property (readwrite, copy) NSArray *visibleResults;
@property (nonatomic, strong) CashPositionViewController *cashContentView;

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableResults;
@property (nonatomic, weak) IBOutlet UISearchBar *searchResults;

//@property (copy) NSArray *allResults;
@property (nonatomic, strong) NSMutableArray *allResults;
@property (readwrite, copy) NSArray *visibleResults;

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelSecurityName;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelChange;
@property (nonatomic, weak) IBOutlet UILabel *labelPercentChange;
@property (nonatomic, weak) IBOutlet UILabel *labelAskPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelAskCount;
@property (nonatomic, weak) IBOutlet UILabel *labelBidPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelBidCount;

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) UIButton *backgroundTapButton;

//@property (strong, nonatomic) NSArray *pickerData1;
//@property (strong, nonatomic) NSArray *pickerData2;
//@property (strong, nonatomic) NSArray *pickerData3;
@property (nonatomic, assign) NSInteger selectVal;

@property (nonatomic, assign) NSInteger selectValTrans;
@property (nonatomic, assign) NSInteger selectValOrder;
@property (nonatomic, assign) NSInteger selectValDuration;

//@property (nonatomic, assign) NSInteger transactionId;
//@property (nonatomic, assign) NSInteger orderTypeId;
//@property (nonatomic, assign) NSInteger durationId;
@property (strong, nonatomic) NSString *str_limit;
@property (strong, nonatomic) NSString *str_shares_QTY;
@property (strong, nonatomic) NSString *strOrderValue;

@property (strong, nonatomic) NSString *strQty;
@property (strong, nonatomic) NSString *strBuyPower;
@property (strong, nonatomic) NSString *strPrevOrderValue;
@property (strong, nonatomic) NSString *strLimitUpPrice;
@property (strong, nonatomic) NSString *strLimitDownPrice;
@property (strong, nonatomic) NSDate *pickerDateVal;
@property (strong, nonatomic) NSDate *pickerTimeVal;
@property (strong, nonatomic) NSString *strLimitPrice;
@property (strong, nonatomic) NSString *strValidPortOnSellQty;
/*prakash*/
@property (strong,nonatomic) NSString *str_confirm_order;


@property (weak, nonatomic) IBOutlet UILabel *labelTransactionCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelLimitCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantityCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelDisclosedCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelDurationCaption;

@end

@implementation NewOrderViewController

@synthesize securityId;
@synthesize strOrderId;
@synthesize strPortQty;
@synthesize strPortOnSellQty;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    overLayView.clipsToBounds = YES;
    overLayView.hidden = YES;
    [self.view addSubview:overLayView];
    
    
    _scrollView.translatesAutoresizingMaskIntoConstraints = YES;
    
//    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
//        
//        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
//            case 2436:
//                self.imageHeight.constant = 150;
//                printf("iPhone X");
//                break;
//            default:
//                
//                printf("unknown");
//        }
//    }
//    [self viewDidLayoutSubviews];

    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [[GlobalShare sharedInstance] setIsConfirmOrder:NO];
    [self.labelTitle setText:NSLocalizedString(@"New Order", @"New Order")];
    [self.searchResults setPlaceholder:NSLocalizedString(@"Symbol/Company Name", @"Symbol/Company Name")];
    self.tableResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableResults setHidden:YES];
    self.arrayMenu = [[NSMutableArray alloc]init];
    [self menuDataSetUp];

//    NSString *loginStatus;
//    if ([GlobalShare isUserLogedIn]) {
//
//    loginStatus = NSLocalizedString(@"Sign In", @"Sign In");
//
//    }
//    else{
//        loginStatus = NSLocalizedString(@"Sign Out", @"Sign Out");
//    }
//
//    self.arrayMenu = @[
//                       @{
//                           @"menu_title": NSLocalizedString(@"Cash Position", @"Cash Position"),
//                           @"menu_image": @"icon_cash_position"
//                           },
////                       @{
////                           @"menu_title": NSLocalizedString(@"My Orders History", @"My Orders History"),
////                           @"menu_image": @"icon_my_order_history"
////                           },
//                       @{
//                           @"menu_title": NSLocalizedString(@"Contact Us", @"Contact Us"),
//                           @"menu_image": @"icon_contact_us"
//                           },
//                       @{
//                           @"menu_title": NSLocalizedString(@"Settings", @"Settings"),
//                           @"menu_image": @"icon_settings"
//                           },
//                       @{
//                           @"menu_title": loginStatus,
//                           @"menu_image": @"icon_signout"
//                           }
//                       ];

    self.tableViewOptionMenu.scrollEnabled = NO;

    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
    self.datePicker.date = [NSDate date];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(actionDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
//    self.timePicker.date = [NSDate date];
    self.timePicker.backgroundColor = [UIColor whiteColor];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    [self.timePicker addTarget:self action:@selector(actionTimeChanged:) forControlEvents:UIControlEventValueChanged];

    int startHour = 9;
    int endHour = 13;
    
    NSDate *date1 = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate:date1];
    [components setHour:startHour];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:components];
    
    [components setHour:endHour];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *endDate = [gregorian dateFromComponents:components];
    
    [self.timePicker setMinimumDate:startDate];
    [self.timePicker setMaximumDate:endDate];
    [self.timePicker setDate:startDate animated:YES];
    [self.timePicker reloadInputViews];
    
    _viewBuyPower.layer.cornerRadius = 3;
    _viewBuyPower.layer.masksToBounds = YES;
    _viewOrderValue.layer.cornerRadius = 3;
    _viewOrderValue.layer.masksToBounds = YES;
    
    _viewDisclose.layer.cornerRadius = 3;
    _viewDisclose.layer.masksToBounds = YES;
    _viewDisclose.layer.borderWidth = 2.0;
    _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewDisclose.backgroundColor = [UIColor clearColor];
    
    _limitUPLabel.layer.cornerRadius = 3;
    _limitUPLabel.layer.masksToBounds = YES;
    _limitUPLabel.layer.borderColor=[[UIColor grayColor]CGColor];
    _limitUPLabel.layer.borderWidth= 1.0f;

    _limitDowmLabel.layer.cornerRadius = 3;
    _limitDowmLabel.layer.masksToBounds = YES;
    _limitDowmLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    _limitDowmLabel.layer.borderWidth= 1.0f;
    
    
    [self.textFieldLimit setTextAlignment:NSTextAlignmentNatural];
    [self.textFieldQty setTextAlignment:NSTextAlignmentNatural];
    [self.textFieldDisclose setTextAlignment:NSTextAlignmentNatural];
    
    [self.textFieldLimit addTarget:self action:@selector(QTY_changed) forControlEvents:UIControlEventEditingChanged];
    
    _strQty = _textFieldQty.text;
}
-(void)viewDidLayoutSubviews{
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.contentView.frame.size.height+self.contentView.frame.origin.y);
    NSLog(@"%f",self.contentView.frame.size.height+self.contentView.frame.origin.y);
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    CGRect frameset = _contentView.frame;
    frameset.size.width = self.view.frame.size.width;
     frameset.size.height = self.view.frame.size.height;
   _contentView.frame = frameset;
    
     frameset =_scrollView.frame;
    //frameset.origin.y = self.tableResults.frame.origin.y;
    frameset.size.width = self.view.frame.size.width;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height <= 480)
    {
    }
    else if(result.height <= 568)
    {
    }
    else
    {
        frameset.size.height = self.view.frame.size.height;

     }
    _scrollView.frame  = frameset;
    
    if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")])
    {
        
        _limitDowmLabel.hidden =NO;
        _limitUPLabel.hidden = NO;
    }
//    else if(_labelSymbol.text.length > 0)
//    {
//        _limitDowmLabel.hidden =NO;
//        _limitUPLabel.hidden = NO;
//    }
    else{
        _limitDowmLabel.hidden =YES;
        _limitUPLabel.hidden = YES;
    }
    
    if(self.tabBarController.selectedIndex == 1)
    {
        [globalShare setIsmodifyOrder:false];
    }
    for (id control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)control;
            if(globalShare.myLanguage == ARABIC_LANGUAGE)
                [textField setTextAlignment:NSTextAlignmentRight];
            else
                [textField setTextAlignment:NSTextAlignmentLeft];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelTransactionCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelOrderCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelLimitCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelQuantityCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelDisclosedCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelDurationCaption setTextAlignment:NSTextAlignmentRight];
        [self.buttonTransaction setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.buttonOrderType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.buttonDuration setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.buttonTransaction setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 5)];
        [self.buttonOrderType setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 5)];
        [self.buttonDuration setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 5)];

        [self.buttonTransaction setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_ar"] forState:UIControlStateNormal];
        [self.buttonOrderType setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_ar"] forState:UIControlStateNormal];
        [self.buttonDuration setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_ar"] forState:UIControlStateNormal];
    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tableViewOptionMenu setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelTransactionCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelOrderCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelLimitCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelQuantityCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelDisclosedCaption setTextAlignment:NSTextAlignmentRight];
        [self.labelDurationCaption setTextAlignment:NSTextAlignmentRight];
        [self.buttonTransaction setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.buttonOrderType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.buttonDuration setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.buttonTransaction setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 20)];
        [self.buttonOrderType setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 20)];
        [self.buttonDuration setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 20)];

        [self.buttonTransaction setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_en"] forState:UIControlStateNormal];
        [self.buttonOrderType setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_en"] forState:UIControlStateNormal];
        [self.buttonDuration setBackgroundImage:[UIImage imageNamed:@"btn_dropdown_en"] forState:UIControlStateNormal];
    }
    
    self.selectVal = 0;
    self.strLimitPrice = @"";
    
//    if(![[GlobalShare sharedInstance] isConfirmOrder]) {
//        self.selectValTrans = 0;
//        self.selectValOrder = 0;
//        self.selectValDuration = 0;
//    }
    
    if(![[GlobalShare sharedInstance] isConfirmOrder]) {
        self.selectValTrans = 0;
        self.selectValOrder = 0;
        self.selectValDuration = 0;
        
        [self clearSecurityOrderValue];
        
        [self.textFieldLimit setAlpha:1.0];
        [self.textFieldLimit setEnabled:YES];

        if(![[GlobalShare sharedInstance] isDirectOrder]) {
            [self.buttonBack setHidden:NO];
            [self.buttonPhoneCall setHidden:YES];
            [self.buttonSmallLogo setHidden:NO];

            if([[GlobalShare sharedInstance] isPortfolioOrder]) {
                self.selectValTrans = [[GlobalShare sharedInstance] isBuyOrSell]-1;
//                [self.picker selectRow:self.selectValTrans inComponent:0 animated:YES];
                [self.buttonTransaction setTitle:globalShare.pickerData1[self.selectValTrans][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];

                if([self.strPortQty integerValue] > 0 && [self.strPortQty integerValue] > [self.strPortOnSellQty integerValue])
                    self.strValidPortOnSellQty = [NSString stringWithFormat:@"%ld", (long)([self.strPortQty integerValue] - [self.strPortOnSellQty integerValue])];
                else
                    self.strValidPortOnSellQty = self.strPortQty;
                
//                if([self.buttonTransaction.currentTitle isEqualToString:@"Buy"]) {
                if(self.selectValTrans == 0) {
                    [self.contentView setBackgroundColor:[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f]];
                    self.scrollView.backgroundColor = self.contentView.backgroundColor;
                }
                else {
                    [self.contentView setBackgroundColor:[UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f]];
                    self.scrollView.backgroundColor = self.contentView.backgroundColor;
                    
                    [self.textFieldQty setText:self.strValidPortOnSellQty];
                }
            }
            if([[GlobalShare sharedInstance] isBuyOrder])
            {
                [self.buttonOrderType setTitle:@"" forState:UIControlStateNormal];
                [self.buttonDuration setTitle:@"" forState:UIControlStateNormal];

                [self.buttonSearch setHidden:YES];
                [self.labelTitle setText:NSLocalizedString(@"Modify Order", @"Modify Order")];
                [self.buttonTransaction setEnabled:NO];
                [self.buttonCreate setTitle:NSLocalizedString(@"Modify", @"Modify") forState:UIControlStateNormal];
                [self performSelector:@selector(getOrderDetails) withObject:nil afterDelay:0.01f];
            }
            else {
               
             
                
                [self.buttonSearch setHidden:NO];
                [self.labelTitle setText:NSLocalizedString(@"New Order", @"New Order")];
                [self.buttonTransaction setEnabled:YES];
                [self.buttonCreate setTitle:NSLocalizedString(@"Create Order", @"Create Order") forState:UIControlStateNormal];
                
                self.selectValOrder = 0;
                [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];

                self.selectValDuration = 0;
                [self.buttonDuration setTitle:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
            }
        }
        else {
            [self.buttonBack setHidden:YES];
            [self.buttonPhoneCall setHidden:NO];
            [self.buttonSmallLogo setHidden:YES];

            if([[GlobalShare sharedInstance] isDirectViewOrder]) {
                self.securityId = @"";
                
//                self.selectValOrder = 0;
//                [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//                
//                self.selectValDuration = 0;
//                [self.buttonDuration setTitle:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
                [self clearSecurityOrderValue];
            }
//            [[GlobalShare sharedInstance] setIsDirectViewOrder:NO];
        }
    }
    
    if(![[GlobalShare sharedInstance] isTimerNewOrderRun])
        [self performSelectorInBackground:@selector(callHeartBeatUpdate) withObject:nil];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
      NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"]) {
        [self showsLoginPopUp];
    }else{
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_system_codes"])
            [self performSelector:@selector(getSystemCodes) withObject:nil afterDelay:0.01f];
        else {
            globalShare.pickerData1 = [DataManager select_SystemCodes:@"tbl_TransactionOrderType"];
            globalShare.pickerData2 = [DataManager select_SystemCodes:@"tbl_PriceOrderType"];
            globalShare.pickerData3 = [DataManager select_SystemCodes:@"tbl_DurationOrderType"];
        }
        
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_securities_avail"])
            [self performSelector:@selector(getSecurityBySector) withObject:nil afterDelay:0.01f];
        else {
            self.allResults = [DataManager select_SecurityList];
        }
        
        
        [self performSelector:@selector(getMarketWatchNew) withObject:nil afterDelay:0.01f];
        //    [self performSelector:@selector(getSystemCodes) withObject:nil afterDelay:0.01f];
        //    [self performSelector:@selector(getSecurityBySector) withObject:nil afterDelay:0.01f];
        [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
        //    [[GlobalShare sharedInstance] setIsConfirmOrder:NO];
        
    }

  //  [self performSelector:@selector(getLimitUpLimitDown) withObject:nil afterDelay:0.01f];
  
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.textFieldCurrent resignFirstResponder];
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:NO];
    if ([globalShare.timerNewOrder isValid]) {
        [globalShare.timerNewOrder invalidate];
        globalShare.timerNewOrder = nil;
    }
    
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    //[globalShare setIsmodifyOrder:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Menu Data SetUp...
-(void)menuDataSetUp{
    NSString *loginStatus;
    NSString *userId;
    if ([GlobalShare isUserLogedIn]) {
        
        loginStatus = NSLocalizedString(@"Sign In", @"Sign In");
        
    }
    else{
        loginStatus = NSLocalizedString(@"Sign Out", @"Sign Out");
        userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UserName"];
    }
    
    [self.arrayMenu removeAllObjects];
    [_arrayMenu addObject:@{ @"menu_title": NSLocalizedString(@"Cash Position", @"Cash Position"),
                             @"menu_image": @"icon_cash_position"
                             }];
    [_arrayMenu addObject:@{ @"menu_title": NSLocalizedString(@"Contact Us", @"Contact Us"),
                             @"menu_image": @"icon_contact_us"
                             }];
    [_arrayMenu addObject:@{ @"menu_title": NSLocalizedString(@"Settings", @"Settings"),
                             @"menu_image": @"icon_settings"
                             }];
    [_arrayMenu addObject:@{ @"menu_title": loginStatus,
                             @"menu_image": @"icon_signout"
                             }];
    
    if (![GlobalShare isUserLogedIn]) {
        [self.arrayMenu insertObject:@{ @"menu_title": userId,
                                        @"menu_image": @"icon_user"
                                        } atIndex:0];
        _menuHeight.constant = 200.0;
    }
    else{
        _menuHeight.constant = 160.0;
    }
    
    
   
    [self.tableViewOptionMenu reloadData];
}



#pragma mark Loading Login PopUp when guest User
/*
 Demo User Login(Custom View)
 */
-(void)showsLoginPopUp{
    
    overLayView.hidden = NO;
    loginVw  = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:loginVw];
    loginVw.frame = CGRectMake(0, 0, self.view.frame.size.width-70, loginVw.frame.size.height);
    loginVw.center = self.view.center;
    
    [loginVw.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [loginVw.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    loginVw.userNameTF.delegate =self;
    loginVw.passwordTF.delegate = self;
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        // [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [loginVw setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        loginVw.userNameTF.textAlignment = NSTextAlignmentRight;
        loginVw.passwordTF.textAlignment = NSTextAlignmentRight;
        
    }
    else {
        //[[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [loginVw setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        loginVw.userNameTF.textAlignment = NSTextAlignmentLeft;
        loginVw.passwordTF.textAlignment = NSTextAlignmentLeft;

    }
    
}

#pragma mark - Button actions
/*
 Custom Login Screen Cancel Button Actions
 */
-(void)cancelButtonAction{
    overLayView.hidden = YES;
    [loginVw removeFromSuperview];
  
    
    if ([globalShare.strNewOrderFlow isEqualToString:@"CompanyStocksViewController"]) {
        [globalShare.topNavController popViewControllerAnimated:YES];
    }
    
  else if([globalShare.strNewOrderFlow isEqualToString:@"PopoverViewController"])//PopoverViewController
    {
        
        UITabBarController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockTabBarController"];
        tabController.delegate = self;
        [[self navigationController] pushViewController:tabController animated:YES];
        
    }
    else {
        [self.tabBarController setSelectedIndex:0];

    }
   
}
/*
 Custom Login Screen Login Button Actions
 */
-(void)loginButtonAction{
    
    @try {
        
        [loginVw.userNameTF resignFirstResponder];
        [loginVw.passwordTF resignFirstResponder];
        
        NSString *stringUserName = [loginVw.userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringPassword = [loginVw.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringUserName length] == 0) {
            [GlobalShare showBasicAlertView:self :USERNAME];
            return;
        } else if([stringPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :PASSWORD];
            return;
        }
        
        if (![GlobalShare isConnectedInternet]) {
            [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
            return;
        }
        [self verifyUserLogin:stringUserName andPassword:stringPassword];
        
        
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        //        [self toEnableControls];
    }
    
}

- (IBAction)actionBack:(id)sender {
    if([[GlobalShare sharedInstance] isPortfolioOrder])
        [[GlobalShare sharedInstance] setIsPortfolioOrder:NO];
    if([[GlobalShare sharedInstance] isBuyOrder])
        [[GlobalShare sharedInstance] setIsBuyOrder:NO];
    
    [[GlobalShare sharedInstance] setIsDirectOrder:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionPhoneCall:(id)sender {
//    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"44498818"];
//    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSearch:(id)sender {
    self.tabBarController.tabBar.hidden = YES;
    [self.searchResults becomeFirstResponder];
    [self.tableResults setHidden:NO];
    [self.searchResults setHidden:NO];
    [self.labelTitle setText:@""];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.view bringSubviewToFront:self.searchResults];
    [self.view bringSubviewToFront:self.tableResults];
    [self.view sendSubviewToBack:self.labelTitle];
    [self.view sendSubviewToBack:self.buttonBack];
    [self.view sendSubviewToBack:self.buttonPhoneCall];
    [self.view sendSubviewToBack:self.buttonSmallLogo];
    [self.view sendSubviewToBack:self.buttonSearch];
    [self.view sendSubviewToBack:self.buttonAlert];
    [self.view sendSubviewToBack:self.buttonOptionMenu];

//    [self.buttonBack setHidden:YES];
//    [self.buttonPhoneCall setHidden:YES];
//    [self.buttonSearch setHidden:YES];
//    [self.view sendSubviewToBack:self.buttonAlert];
//    [self.view sendSubviewToBack:self.buttonOptionMenu];

//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    NSDictionary *placeholderAttributes = @{
//                                            NSForegroundColorAttributeName: [UIColor darkGrayColor],
//                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],
//                                            };
//    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchResults.placeholder attributes:placeholderAttributes];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:placeholderAttributes];
//    
//    self.searchResults.tintColor = [UIColor darkGrayColor];
    
//    [self.searchResults setImage:[UIImage imageNamed:@"icon_greysearch"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    self.searchResults.tintColor = [UIColor darkGrayColor];
}

- (IBAction)actionAlertsView:(id)sender {
    AlertsViewController *alertsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
    [[self navigationController] pushViewController:alertsViewController animated:YES];
}

- (IBAction)actionOptionMenu:(id)sender
{
    if ([self.viewOptionMenu isHidden]) {
        [self.viewOptionMenu setHidden:NO];
        [self.view bringSubviewToFront:self.viewOptionMenu];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.viewOptionMenu.layer addAnimation:animation forKey:@""];
        
        self.viewOptionMenu.layer.borderWidth = 1.0;
        self.viewOptionMenu.layer.borderColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:1.f].CGColor;
        
        _transparencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transparencyButton.frame = self.view.bounds;
        //        self.transparencyButton.backgroundColor = [UIColor lightGrayColor];
        [_transparencyButton addTarget:self action:@selector(backgroundTappedMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:self.transparencyButton belowSubview:self.viewOptionMenu];
    }
    else {
        [self.viewOptionMenu setHidden:YES];
        [self.view sendSubviewToBack:self.viewOptionMenu];
        [_transparencyButton setAlpha:1.0];
        [self.transparencyButton removeFromSuperview];
        self.transparencyButton = nil;
    }
}

- (void)backgroundTappedMenu:(id)sender {
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
}

- (IBAction)actionRefresh:(id)sender {
    
}

- (IBAction)actionTransaction:(id)sender {
    [self.buttonTransaction setEnabled:NO];
    [self.textFieldCurrent resignFirstResponder];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIButton *btn = (UIButton *)sender;
    self.selectVal = btn.tag;
    
    if(![self.picker superview])
        [self.view addSubview:self.picker];
    [self.picker reloadAllComponents];
    [self.picker selectRow:self.selectValTrans inComponent:0 animated:YES];
    
//    if(self.selectValTrans == 0) {
        [self.buttonTransaction setTitle:globalShare.pickerData1[self.selectValTrans][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
        
//        if([self.buttonTransaction.currentTitle isEqualToString:@"Buy"]) {
        if(self.selectValTrans == 0) {
           [self.contentView setBackgroundColor:[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f]];
            self.scrollView.backgroundColor = self.contentView.backgroundColor;
        }
        else {
            [self.contentView setBackgroundColor:[UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f]];
            self.scrollView.backgroundColor = self.contentView.backgroundColor;
        }
//    }
    
    [UIView animateWithDuration:.5 animations:^{
        [self.picker setFrame:CGRectMake(0, screenHeight-162, [[UIScreen mainScreen] bounds].size.width, 162)];
        self.tabBarController.tabBar.hidden = YES;
    } completion:^(BOOL finished) {
        self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.backgroundTapButton.backgroundColor = [UIColor lightGrayColor];
        _backgroundTapButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-162);
        [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backgroundTapButton];
        [self.buttonTransaction setEnabled:YES];
    }];
}

- (void)backgroundTapped:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [UIView animateWithDuration:.5 animations:^{
        self.tabBarController.tabBar.hidden = NO;
        [self.picker setFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
        [self.datePicker setFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
        [self.timePicker setFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
    } completion:^(BOOL finished) {
        if([self.picker superview])
            [self.picker removeFromSuperview];
        if([self.datePicker superview]) {
            self.pickerDateVal = self.datePicker.date;
            [self.labelDuration setText:[GlobalShare returnDate:self.datePicker.date]];
            [self.datePicker removeFromSuperview];
        }
        if([self.timePicker superview]) {
            self.pickerTimeVal = self.timePicker.date;
            [self.labelDuration setText:[GlobalShare returnTime:self.timePicker.date]];
            [self.timePicker removeFromSuperview];
        }
        [self.backgroundTapButton removeFromSuperview];
        self.backgroundTapButton = nil;
    }];
}

- (IBAction)actionOrderType:(id)sender
{
    [self.buttonOrderType setEnabled:NO];
    [self.textFieldCurrent resignFirstResponder];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIButton *btn = (UIButton *)sender;
    self.selectVal = btn.tag;
    
    if(![self.picker superview])
        [self.view addSubview:self.picker];
    [self.picker reloadAllComponents];
    
    [self.picker selectRow:self.selectValOrder inComponent:0 animated:YES];
    
//    if(self.selectValOrder == 0) {
        [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//    }
    
//    if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) {
    if(self.selectValOrder != 0) {
        [self.textFieldLimit setAlpha:0.5];
        [self.textFieldLimit setEnabled:NO];
    }
    else {
        [self.textFieldLimit setAlpha:1.0];
        [self.textFieldLimit setEnabled:YES];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        [self.picker setFrame:CGRectMake(0, screenHeight-162, [[UIScreen mainScreen] bounds].size.width, 162)];
        self.tabBarController.tabBar.hidden = YES;
    } completion:^(BOOL finished) {
        self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundTapButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-162);
        [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backgroundTapButton];
        [self.buttonOrderType setEnabled:YES];
    }];
}

- (IBAction)actionDuration:(id)sender {
    [self.buttonDuration setEnabled:NO];
    [self.textFieldCurrent resignFirstResponder];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIButton *btn = (UIButton *)sender;
    self.selectVal = btn.tag;
    
    if(![self.picker superview])
        [self.view addSubview:self.picker];
    [self.picker reloadAllComponents];
    
    [self.picker selectRow:self.selectValDuration inComponent:0 animated:YES];
    
//    if(self.selectValDuration == 0) {
        [self.buttonDuration setTitle:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//    }
    
    [UIView animateWithDuration:.5 animations:^{
        //        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :150];
        [self.picker setFrame:CGRectMake(0, screenHeight-162, [[UIScreen mainScreen] bounds].size.width, 162)];
        self.tabBarController.tabBar.hidden = YES;
    } completion:^(BOOL finished) {
        self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundTapButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-162);
        [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backgroundTapButton];
        [self.buttonDuration setEnabled:YES];
    }];
}

- (IBAction)actionCheckDisclose:(id)sender {
    UIButton *buttonReceive = (UIButton *)sender;
    
    if ([buttonReceive.currentImage isEqual:[UIImage imageNamed:@"icon_tickmark"]]) {
        [buttonReceive setImage:nil forState:UIControlStateNormal];
//        [_viewDisclose setBackgroundColor:[UIColor clearColor]];
        _viewDisclose.layer.borderWidth = 1.0;
        _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        [self.textFieldDisclose setText:@""];
        [self.textFieldDisclose setAlpha:0.5];
        [self.textFieldDisclose setEnabled:NO];
    }
    else {
        [buttonReceive setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
//        [_viewDisclose setBackgroundColor:[UIColor orangeColor]];
        _viewDisclose.layer.borderWidth = 1.0;
        _viewDisclose.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [self.textFieldDisclose setAlpha:1.0];
        [self.textFieldDisclose setEnabled:YES];
    }
}

- (IBAction)actionDateChanged:(id)sender {
    self.pickerDateVal = self.datePicker.date;
    [self.labelDuration setText:[GlobalShare returnDate:self.datePicker.date]];
}

- (IBAction)actionTimeChanged:(id)sender {
    self.pickerTimeVal = self.timePicker.date;
    [self.labelDuration setText:[GlobalShare returnTime:self.timePicker.date]];
}

//- (IBAction)actionCreateOrder:(id)sender {
//    [self.textFieldCurrent resignFirstResponder];
//    [self.backgroundTapButton removeFromSuperview];
//    self.backgroundTapButton = nil;
//
//    NSString *strOrderSide = globalShare.pickerData1[self.selectValTrans][@"minor_code"];
//    NSString *strTransactionType = globalShare.pickerData1[self.selectValTrans][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
//    NSString *strSymbol = self.labelSymbol.text;
//    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strDisclose = [self.textFieldDisclose.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
////    NSString *strIsMarketPriceOrder = globalShare.pickerData2[self.selectValOrder][@"minor_code"];
//    NSString *strValidity = globalShare.pickerData3[self.selectValDuration][@"minor_code"];
//
//    if([self.labelSymbol.text length] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_SECURITY];
//        return;
//    } else if([self.buttonTransaction.currentTitle length] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_TRANSACTION];
//        return;
//    } else if([self.buttonOrderType.currentTitle length] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_ORDERTYPE];
//        return;
//    } else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"] && [strPrice integerValue] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_PRICE];
//        return;
//    } else if([strQty integerValue] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_QTY];
//        return;
//    } else if([self.buttonDuration.currentTitle length] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_DURATION];
//        return;
//    } else if([self.buttonDisclose.currentImage isEqual:[UIImage imageNamed:@"tickmark.png"]] && [strDisclose integerValue] == 0) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTY];
//        return;
//    } else if([strDisclose integerValue] > [strQty integerValue]) {
//        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTYVAL];
//        return;
//    }
//    
//    if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"])
//        strPrice = self.labelPrice.text;
//    
//    double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0, newBuyPower = 0;
//    if([strQty integerValue] > 0) {
//        priceVal = [strPrice doubleValue];
//        qtyVal = [strQty doubleValue];
//        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
//        OrderVal = qtyVal * priceVal;
//        commissionVal = qtyVal * priceVal * commission;
//        if(commissionVal < 30) commissionVal = 30.0;
//        orderCommissionVal = OrderVal + commissionVal;
//    }
//    
//    NSString *strSubmitNewOrder;
//    if([self.buttonCreate.currentTitle isEqualToString:@"Modify"]) {
//        newBuyPower = [GlobalShare returnDoubleFromString:self.strBuyPower] + [self.strPrevOrderValue doubleValue] - orderCommissionVal;
//        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&order_id=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity, self.strOrderId];
//    }
//    else {
//        newBuyPower = [GlobalShare returnDoubleFromString:self.strBuyPower] - orderCommissionVal;
//        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity];
//    }
//
//    NSString *strTransaction = [NSString stringWithFormat:@"%@ %@ %@ @ %@", strTransactionType, strQty, strSymbol, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"Market" : strPrice];
//    NSString *strAccount = @"XXXX";
//    NSString *strCostOfTrade = [NSString stringWithFormat:@"%.2f QR", OrderVal];
//    NSString *strOrderValue = [NSString stringWithFormat:@"%.2f QR", orderCommissionVal];
//    NSString *strNewBuyPower = [NSString stringWithFormat:@"%.2f QR", newBuyPower];
//
//    NSMutableDictionary *dictVals = [[NSMutableDictionary alloc] init];
//    [dictVals setObject:strSubmitNewOrder forKey:@"SubmitNewOrder"];
//    [dictVals setObject:strTransaction forKey:@"Transaction"];
//    [dictVals setObject:strAccount forKey:@"Account"];
//    [dictVals setObject:[GlobalShare createCommaSeparatedTwoDigitString:strCostOfTrade] forKey:@"CostOfTrade"];
//    [dictVals setObject:[GlobalShare createCommaSeparatedTwoDigitString:strOrderValue] forKey:@"OrderValue"];
//    [dictVals setObject:[GlobalShare createCommaSeparatedTwoDigitString:strNewBuyPower] forKey:@"NewBuyPower"];
//
//    if (![GlobalShare isConnectedInternet]) {
//        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
//        return;
//    }
//    
//    OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
//    orderConfirmViewController.delegate = self;
//    orderConfirmViewController.passOrderValues = dictVals;
//    [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
//}

- (IBAction)actionCreateOrder:(id)sender
{
    [self.textFieldCurrent resignFirstResponder];
    [self.backgroundTapButton removeFromSuperview];
    self.backgroundTapButton = nil;
    
    if([self.strBuyPower doubleValue] < 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_BUYINGCASH];
        return;
    }
    
    NSString *strOrderSide = globalShare.pickerData1[self.selectValTrans][@"minor_code"];
    NSString *strTransactionType = globalShare.pickerData1[self.selectValTrans][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
    NSString *strSymbol = self.labelSymbol.text;
    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strDisclose = [self.textFieldDisclose.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSString *strIsMarketPriceOrder = globalShare.pickerData2[self.selectValOrder][@"minor_code"];
    NSString *strValidity = globalShare.pickerData3[self.selectValDuration][@"minor_code"];
    NSString *strValidityDate = @"", *strValidityTime = @"";
    if([strValidity integerValue] == 9)
        strValidityDate = self.labelDuration.text;
    else if([strValidity integerValue] == 10)
        strValidityTime = self.labelDuration.text;
    if([strValidityDate length] > 0)
        strValidityDate = [GlobalShare returnUSDate:self.datePicker.date];

    if([self.labelSymbol.text length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_SECURITY];
        return;
    } else if([self.buttonTransaction.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_TRANSACTION];
        return;
    } else if([self.buttonOrderType.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_ORDERTYPE];
        return;
//    } else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"] && [strPrice integerValue] == 0) {
    }
//    else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) {
    else if(self.selectValOrder == 0) {
        if([strPrice length] == 0) {
            [GlobalShare showBasicAlertView:self :NEWORDER_PRICE];
            return;
        } else if(([strPrice hasPrefix:@"."] && [strPrice hasSuffix:@"."]) || ([strPrice hasPrefix:@"."] || [strPrice hasSuffix:@"."])) {
            [GlobalShare showBasicAlertView:self :NEWORDER_VALIDPRICE];
            return;
        }/* else if([strPrice doubleValue] < [self.strLimitDownPrice doubleValue]) {
            [GlobalShare showBasicAlertView:self :NEWORDER_LIMITDOWNPRICE];
            return;
        } else if([strPrice doubleValue] > [self.strLimitUpPrice doubleValue]) {
            [GlobalShare showBasicAlertView:self :NEWORDER_LIMITUPPRICE];
            return;
        }*/ else if(([strPrice doubleValue] > [self.strLimitUpPrice doubleValue]) || ([strPrice doubleValue] < [self.strLimitDownPrice doubleValue])) {
            NSString *strMsg;
//            if(globalShare.myLanguage != ARABIC_LANGUAGE)
                strMsg = [NSString stringWithFormat:@"%@ %@ %@ %@", NEWORDER_LIMITLESSVALID, self.strLimitUpPrice, NEWORDER_LIMITGREATERVALID, self.strLimitDownPrice];
//            else
//                strMsg = [NSString stringWithFormat:@"%@ %@ %@ %@", self.strLimitDownPrice, NEWORDER_LIMITGREATERVALID, self.strLimitUpPrice, NEWORDER_LIMITLESSVALID];

            [GlobalShare showBasicAlertView:self :strMsg];
            return;
        }
    }
    if([strQty length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_QTY];
        return;
    } else if([strQty integerValue] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_ORG_QTY];
        return;
    } else if([self.buttonDuration.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DURATION];
        return;
    } else if([[GlobalShare sharedInstance] isPortfolioOrder] && self.selectValTrans == 1 && ([strQty integerValue] > [self.strValidPortOnSellQty integerValue])) {
        [GlobalShare showBasicAlertView:self :NEWORDER_NOTENOUGHAVAILQTY];
        return;
    } else if([self.buttonDisclose.currentImage isEqual:[UIImage imageNamed:@"icon_tickmark"]] && [strDisclose integerValue] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTY];
        return;
    } else if([strDisclose integerValue] > [strQty integerValue]) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTYVAL];
        return;
    }
    
//    if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"])
//        strPrice = self.labelPrice.text;
    
    if([strPrice length] > 0)
        strPrice = [GlobalShare formatStringToTwoDigits:strPrice];
    
    NSString *strSubmitNewOrder;
    NSString *strConfirmOrder;
    
    NSString *isMarketPrice = @"0";
    if(self.selectValOrder == 1)
        isMarketPrice = @"1";
    else if(self.selectValOrder == 4)
        isMarketPrice = @"2";

    if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")]) {
//        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@&expiry_time=%@&order_id=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity, strValidityDate, strValidityTime, self.strOrderId];
//        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"2", strOrderSide, strSymbol, strQty, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", self.strOrderId];
        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@&expiry_time=%@&order_id=%@", strOrderSide, strSymbol, strQty, strDisclose, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, strValidity, strValidityDate, strValidityTime, self.strOrderId];
       
        
        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"2", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, self.strOrderId];
        
        _str_confirm_order = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"2", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, self.strOrderId];
        
    }
    else {
//        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@&expiry_time=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity, strValidityDate, strValidityTime];
//        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"1", strOrderSide, strSymbol, strQty, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", @""];
        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@&expiry_time=%@", strOrderSide, strSymbol, strQty, strDisclose, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, strValidity, strValidityDate, strValidityTime];
        
        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"1", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, @""];
        
         _str_confirm_order = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"1", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, @""];
        [self create_order_chek_STATUS];
        
    }
    
//    NSString *strTransaction = [NSString stringWithFormat:@"%@ %@ %@ @ %@", strTransactionType, strQty, strSymbol, ([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) ? strPrice : self.buttonOrderType.currentTitle];
//    NSString *strTransaction = [NSString stringWithFormat:@"%@ %@ %@ - %@", strTransactionType, [GlobalShare createCommaSeparatedString:strQty], strSymbol, (self.selectValOrder == 0) ? strPrice : self.buttonOrderType.currentTitle];
    NSString *strTransaction;
//    if(globalShare.myLanguage != ARABIC_LANGUAGE)
        strTransaction = [NSString stringWithFormat:@"%@ %@ %@ - %@", strTransactionType, [GlobalShare createCommaSeparatedString:strQty], strSymbol, (self.selectValOrder == 0) ? strPrice : self.buttonOrderType.currentTitle];

    if(globalShare.myLanguage == ARABIC_LANGUAGE && self.selectValOrder == 0)
        strTransaction = [NSString stringWithFormat:@"%@ - %@ %@ %@", (self.selectValOrder == 0) ? strPrice : self.buttonOrderType.currentTitle, strSymbol, [GlobalShare createCommaSeparatedString:strQty], strTransactionType];

    NSString *strAccount = @"XXXX";
    
    NSMutableDictionary *dictVals = [[NSMutableDictionary alloc] init];
    [dictVals setObject:strSubmitNewOrder forKey:@"SubmitNewOrder"];
    [dictVals setObject:strConfirmOrder forKey:@"ConfirmOrder"];
    [dictVals setObject:strTransaction forKey:@"Transaction"];
    [dictVals setObject:strAccount forKey:@"Account"];
    [dictVals setObject:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forKey:@"Validity"];

    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }

//    [self confirmOrder:dictVals];
//    return;
    
    if(self.selectValTrans == 0) {
        if(self.selectValOrder == 1 || self.selectValOrder == 2 || self.selectValOrder == 4)
            strPrice = self.strLimitUpPrice;
        else if(self.selectValOrder == 3)
            strPrice = self.strLimitDownPrice;
    }
    else {
        if(self.selectValOrder == 1 || self.selectValOrder == 3 || self.selectValOrder == 4)
            strPrice = self.strLimitDownPrice;
        else if(self.selectValOrder == 2)
            strPrice = self.strLimitUpPrice;
    }
    
    double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
    if([strQty integerValue] > 0) {
        priceVal = [strPrice doubleValue];
        qtyVal = [strQty doubleValue];
        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
        OrderVal = qtyVal * priceVal;
        commissionVal = qtyVal * priceVal * commission;
        if(commissionVal < 30) commissionVal = 30.0;
        if(self.selectValTrans == 0)
            orderCommissionVal = OrderVal + commissionVal;
        else
            orderCommissionVal = OrderVal - commissionVal;
    }

    self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
    [dictVals setObject:[GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", OrderVal]] forKey:@"OrderValue"];
    [dictVals setObject:[GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]] forKey:@"CostOfTrade"];
    
    
    
    
    if([globalShare isBuyOrder] == true )
    {
     
    if([_str_shares_QTY isEqualToString:_textFieldQty.text] )
    {
        if( [_str_limit isEqualToString:_textFieldLimit.text])
        {
        OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
        orderConfirmViewController.delegate = self;
        orderConfirmViewController.passOrderValues = dictVals;
        [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
        }
        
        else
        {
//           //  [globalShare setIsmodifyOrder:false];
//
//                NSString *str_txt =NSLocalizedString(@"ORDER_MODIFIED", @"Basic Alert Style");
//                NSString *str_string = [NSString stringWithFormat:@"%@\n%@ %@ - %@",str_txt,_textFieldQty.text,_labelSymbol.text,_textFieldLimit.text];
//
//            NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
//            NSString *alertMessage = NSLocalizedString(str_string, @"BasicAlertMessage");
//
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
//                                                                                     message:alertMessage
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
//                                                                   style:UIAlertActionStyleDefault
//                                                                 handler:^(UIAlertAction *action)
//                                           {
//                                                 [self dismissViewControllerAnimated:NO completion:nil];
//                                           }];
//
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action)
//                                       {
//                                           OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
//                                           orderConfirmViewController.delegate = self;
//                                           orderConfirmViewController.passOrderValues = dictVals;
//                                           [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
//                                       }];
//
//            if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//                [alertController addAction:cancelAction];
//                [alertController addAction:okAction];
//            }
//            else {
//                [alertController addAction:okAction];
//                [alertController addAction:cancelAction];
//            }
//
//            [self presentViewController:alertController animated:YES completion:nil];
            
            [self update_ORder_API:dictVals];
            
            }
        
    }
    else{
        
        // [globalShare setIsmodifyOrder:false];
        
//        NSString *str_txt =NSLocalizedString(@"ORDER_MODIFIED", @"Basic Alert Style");
//        NSString *str_string = [NSString stringWithFormat:@"%@\n%@ %@ - %@",str_txt,_textFieldQty.text,_labelSymbol.text,_textFieldLimit.text];
//        NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
//        NSString *alertMessage = NSLocalizedString(str_string, @"BasicAlertMessage");
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
//                                                                                 message:alertMessage
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action)
//                                       {
//                                           [self dismissViewControllerAnimated:NO completion:nil];
//                                       }];
//
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
//                                                           style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction *action)
//                                   {
//                                       OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
//                                       orderConfirmViewController.delegate = self;
//                                       orderConfirmViewController.passOrderValues = dictVals;
//                                       [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
//                                   }];
//
//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            [alertController addAction:cancelAction];
//            [alertController addAction:okAction];
//        }
//        else {
//            [alertController addAction:okAction];
//            [alertController addAction:cancelAction];
//        }
//
//        [self presentViewController:alertController animated:YES completion:nil];
        [self update_ORder_API:dictVals];
     }
    }
    else
    {
        OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
        orderConfirmViewController.delegate = self;
        orderConfirmViewController.passOrderValues = dictVals;
        [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
    }
    
    
}

- (IBAction)actionMarketDepth:(id)sender {
    if([self.labelSymbol.text length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_SECURITY];
        return;
    }
    
    [self.textFieldCurrent resignFirstResponder];
    [self.backgroundTapButton removeFromSuperview];
    self.backgroundTapButton = nil;
    
    MarketDepthViewController *marketDepthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MarketDepthViewController"];
    marketDepthViewController.securityId = self.securityId;
    [[self navigationController] pushViewController:marketDepthViewController animated:YES];
}

- (IBAction)actionConfirmOrderValue:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [self.backgroundTapButton removeFromSuperview];
    self.backgroundTapButton = nil;
    
    if([self.strBuyPower doubleValue] < 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_BUYINGCASH];
        return;
    }

    NSString *strOrderSide = globalShare.pickerData1[self.selectValTrans][@"minor_code"];
//    NSString *strTransactionType = globalShare.pickerData1[self.selectValTrans][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
    NSString *strSymbol = self.labelSymbol.text;
    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strDisclose = [self.textFieldDisclose.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strValidity = globalShare.pickerData3[self.selectValDuration][@"minor_code"];
//    NSString *strValidityDate = self.labelDuration.text;
//    if([strValidityDate length] > 0)
//        strValidityDate = [GlobalShare returnUSDate:self.datePicker.date];
    
    if([self.labelSymbol.text length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_SECURITY];
        return;
    } else if([self.buttonTransaction.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_TRANSACTION];
        return;
    } else if([self.buttonOrderType.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_ORDERTYPE];
        return;
    }
//    else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) {
    else if(self.selectValOrder == 0) {
        if([strPrice length] == 0) {
            [GlobalShare showBasicAlertView:self :NEWORDER_PRICE];
            return;
        } else if(([strPrice hasPrefix:@"."] && [strPrice hasSuffix:@"."]) || ([strPrice hasPrefix:@"."] || [strPrice hasSuffix:@"."])) {
            [GlobalShare showBasicAlertView:self :NEWORDER_VALIDPRICE];
            return;
        }/* else if([strPrice doubleValue] < [self.strLimitDownPrice doubleValue]) {
            [GlobalShare showBasicAlertView:self :NEWORDER_LIMITDOWNPRICE];
            return;
        } else if([strPrice doubleValue] > [self.strLimitUpPrice doubleValue]) {
            [GlobalShare showBasicAlertView:self :NEWORDER_LIMITUPPRICE];
            return;
        }*/ else if(([strPrice doubleValue] > [self.strLimitUpPrice doubleValue]) || ([strPrice doubleValue] < [self.strLimitDownPrice doubleValue])) {
            [GlobalShare showBasicAlertView:self :[NSString stringWithFormat:@"%@ %@ %@ %@", NEWORDER_LIMITLESSVALID, self.strLimitUpPrice, NEWORDER_LIMITGREATERVALID, self.strLimitDownPrice]];
            return;
        }
    }
    if([strQty length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_QTY];
        return;
    } else if([strQty integerValue] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_ORG_QTY];
        return;
    } else if([self.buttonDuration.currentTitle length] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DURATION];
        return;
    } else if([[GlobalShare sharedInstance] isPortfolioOrder] && self.selectValTrans == 1 && ([strQty integerValue] > [self.strValidPortOnSellQty integerValue])) {
        [GlobalShare showBasicAlertView:self :NEWORDER_NOTENOUGHAVAILQTY];
        return;
    } else if([self.buttonDisclose.currentImage isEqual:[UIImage imageNamed:@"icon_tickmark"]] && [strDisclose integerValue] == 0) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTY];
        return;
    } else if([strDisclose integerValue] > [strQty integerValue]) {
        [GlobalShare showBasicAlertView:self :NEWORDER_DISCLOSEDQTYVAL];
        return;
    }
    
    if([strPrice length] > 0)
        strPrice = [GlobalShare formatStringToTwoDigits:strPrice];
    
//    NSString *strSubmitNewOrder;
    NSString *strConfirmOrder;
    
    NSString *isMarketPrice = @"0";
    if(self.selectValOrder == 1)
        isMarketPrice = @"1";
    else if(self.selectValOrder == 4)
        isMarketPrice = @"2";

    if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")]) {
////        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@&order_id=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity, strValidityDate, self.strOrderId];
//        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"2", strOrderSide, strSymbol, strQty, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", self.strOrderId];
        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"2", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, self.strOrderId];
    }
    else {
////        strSubmitNewOrder = [NSString stringWithFormat:@"?order_side=%@&symbol=%@&qty=%@&disclose=%@&price=%@&is_market_price_order=%@&validity=%@&expiry_date=%@", strOrderSide, strSymbol, strQty, strDisclose, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", strValidity, strValidityDate];
//        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"1", strOrderSide, strSymbol, strQty, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"" : strPrice, ([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"]) ? @"1" : @"0", @""];
        strConfirmOrder = [NSString stringWithFormat:@"?order_type=%@&order_side=%@&symbol=%@&qty=%@&price=%@&is_market_price_order=%@&order_id=%@", @"1", strOrderSide, strSymbol, strQty, (self.selectValOrder == 1) ? @"" : strPrice, isMarketPrice, @""];
    }
    
//    NSString *strTransaction = [NSString stringWithFormat:@"%@ %@ %@ @ %@", strTransactionType, strQty, strSymbol, ([self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) ? strPrice : self.buttonOrderType.currentTitle];
//    NSString *strAccount = @"XXXX";
    
    NSMutableDictionary *dictVals = [[NSMutableDictionary alloc] init];
//    [dictVals setObject:strSubmitNewOrder forKey:@"SubmitNewOrder"];
    [dictVals setObject:strConfirmOrder forKey:@"ConfirmOrder"];
//    [dictVals setObject:strTransaction forKey:@"Transaction"];
//    [dictVals setObject:strAccount forKey:@"Account"];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    
    [self confirmOrderValue:dictVals];
//    return;
    
    if(self.selectValTrans == 0) {
        if(self.selectValOrder == 1 || self.selectValOrder == 2 || self.selectValOrder == 4)
            strPrice = self.strLimitUpPrice;
        else if(self.selectValOrder == 3)
            strPrice = self.strLimitDownPrice;
    }
    else {
        if(self.selectValOrder == 1 || self.selectValOrder == 3 || self.selectValOrder == 4)
            strPrice = self.strLimitDownPrice;
        else if(self.selectValOrder == 2)
            strPrice = self.strLimitUpPrice;
    }
    
    double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
    if([strQty integerValue] > 0) {
        priceVal = [strPrice doubleValue];
        qtyVal = [strQty doubleValue];
        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
        OrderVal = qtyVal * priceVal;
        commissionVal = qtyVal * priceVal * commission;
        if(commissionVal < 30) commissionVal = 30.0;
        if(self.selectValTrans == 0)
            orderCommissionVal = OrderVal + commissionVal;
        else
            orderCommissionVal = OrderVal - commissionVal;
    }

    self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
}

#pragma mark - Common actions
-(BOOL)verifyUserLogin:(NSString *)stringUserName andPassword:(NSString*)stringPassword{
    @try {
        
        [loginVw removeFromSuperview];
        loginVw.hidden = YES;
        overLayView.hidden = YES;
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@SetCredentials?username=%@&password=%@", REQUEST_URL, stringUserName, stringPassword];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           
                                                           if(error == nil)
                                                           {
                                                               
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               if([[returnedDict objectForKey:@"status"] hasPrefix:@"error"]) {
                                                                   if([[returnedDict objectForKey:@"result"] hasPrefix:@"T4"])
                                                                       [GlobalShare showBasicAlertView:self :INVALID_HEADER];
                                                                   else
                                                                       [GlobalShare showBasicAlertView:self :[returnedDict objectForKey:@"result"]];
                                                                   return;
                                                               }
                                                               NSString *strToken = [returnedDict objectForKey:@"result"];
                                                               [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:@"ssckey"];
                                                               // Storing UserName in Shared Preference values..
                                                               [[NSUserDefaults standardUserDefaults] setValue:stringUserName forKey:@"UserName"];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               [self menuDataSetUp];
                                                               [self.tableViewOptionMenu reloadData];
                                                               [self viewWillAppear:YES];
                                                               
                                                               
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

- (void)callHeartBeatUpdate {
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:YES];
    globalShare.timerNewOrder = [NSTimer scheduledTimerWithTimeInterval:AUTO_SYNC_INTERVAL target:self selector:@selector(getMarketWatchNew) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:globalShare.timerNewOrder forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void) getMarketWatchNew {
    
    @try {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView setHidden:NO];
        });
        
            
            
       
        if([self.securityId length] == 0) return;
        
       // [self.indicatorView setHidden:NO];
       
            
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetMarketWatch?tickers=", self.securityId];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                              // NSLog(@"the live market_data_is:%@",returnedDict);
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
                                                                       
                                                                        if(![returnedDict[@"result"] isKindOfClass:[NSArray class]]) return;
                                                                       
                                                                       NSArray *arrVal = returnedDict[@"result"];
                                                                       NSDictionary *dictVal = arrVal[0];
                                                                       
                                                                            self.labelSymbol.text = dictVal[@"ticker"];
                                                                       
                                                                       self.labelSecurityName.text = (globalShare.myLanguage != ARABIC_LANGUAGE) ? dictVal[@"security_name_e"] : dictVal[@"security_name_a"];
                                                                       self.labelPrice.text = [GlobalShare formatStringToTwoDigits:dictVal[@"comp_current_price"]];
                                                                       self.labelChange.text = [GlobalShare formatStringToTwoDigits:dictVal[@"change"]];
                                                                       self.labelPercentChange.text = [NSString stringWithFormat:@"%@%%", [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]]];
                                                                       [self getLimitUpLimitDown];

//                                                                       self.strLimitUpPrice = [GlobalShare formatStringToTwoDigits:dictVal[@"max_price"]];
//                                                                       self.strLimitDownPrice = [GlobalShare formatStringToTwoDigits:dictVal[@"min_price"]];
                                                                       
                                                                       
//                                                                       self.limitUPLabel.hidden = NO;
//                                                                       self.limitDowmLabel.hidden = NO;
                                                                       
                                                                       
                                                                       
//                                                                       if([dictVal[@"change"] hasPrefix:@"-"] || [dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                           if([dictVal[@"change"] hasPrefix:@"+"]) {
//                                                                               self.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                                                                               self.labelPercentChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
//                                                                           }
//                                                                           else {
//                                                                               self.labelChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                                                                               self.labelPercentChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
//                                                                           }
//                                                                       }
//                                                                       else {
//                                                                           self.labelChange.textColor = [UIColor whiteColor];
//                                                                           self.labelPercentChange.textColor = [UIColor whiteColor];
//                                                                       }
                                                                       
                                                                       if(self.selectValOrder == 1 || self.selectValOrder == 4)
                                                                           [self.textFieldLimit setText:@""];
                                                                       else if(self.selectValOrder == 2)
                                                                           [self.textFieldLimit setText:self.strLimitUpPrice];
                                                                       else if(self.selectValOrder == 3)
                                                                           [self.textFieldLimit setText:self.strLimitDownPrice];

                                                                       if([dictVal[@"change"] hasPrefix:@"-"]) {
                                                                           self.labelChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                           self.labelPercentChange.textColor = [UIColor colorWithRed:171/255.f green:0/255.f blue:2/255.f alpha:1.f];
                                                                       }
                                                                       else if([dictVal[@"change"] hasPrefix:@"+"]) {
                                                                           self.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                           self.labelPercentChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                       }
                                                                       else {
                                                                           if([GlobalShare returnIfGreaterThanZero:[dictVal[@"change"] doubleValue]]) {
                                                                               self.labelChange.text = [NSString stringWithFormat:@"+%@", [GlobalShare formatStringToTwoDigits:dictVal[@"change"]]];
                                                                               self.labelPercentChange.text = [NSString stringWithFormat:@"+%@%%", [GlobalShare formatStringToTwoDigits:dictVal[@"change_perc"]]];
                                                                               self.labelChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                               self.labelPercentChange.textColor = [UIColor colorWithRed:0/255.f green:100/255.f blue:25/255.f alpha:1.f];
                                                                           }
                                                                           else {
                                                                               self.labelChange.textColor = [UIColor whiteColor];
                                                                               self.labelPercentChange.textColor = [UIColor whiteColor];
                                                                           }
                                                                       }

                                                                       self.labelAskPrice.text = ([dictVal[@"ASK"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:dictVal[@"ASK"]];
                                                                       self.labelAskCount.text = [GlobalShare createCommaSeparatedString:dictVal[@"ASK_VOL"]];
                                                                       self.labelBidPrice.text = ([dictVal[@"BID"] hasPrefix:@"-"]) ? @"M.P" : [GlobalShare formatStringToTwoDigits:dictVal[@"BID"]];
                                                                       self.labelBidCount.text = [GlobalShare createCommaSeparatedString:dictVal[@"BID_VOL"]];
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

-(void) getSystemCodes {
    @try {
        [self.indicatorView setHidden:NO];

        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetSystemCodes"];
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
                                                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_system_codes"];
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       [DataManager insertSystemCodes:returnedDict[@"result"]];
                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       globalShare.pickerData1 = dictVal[@"TransactionOrderSide"];
                                                                       globalShare.pickerData2 = dictVal[@"priceType"];
                                                                       globalShare.pickerData3 = dictVal[@"duration"];
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
                                                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_securities_avail"];
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       [self createSecurity:returnedDict[@"result"]];
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

-(void) getCashPosition {
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetCashPosition"];
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
                                                                       
                                                                       self.strBuyPower = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Current_Balance"]];
                                                                       self.labelBuyPower.text = self.strBuyPower;
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

//-(void) getOrderDetails {
//    @try {
//        if([self.strOrderId length] == 0) return;
//        
//        [self.indicatorView setHidden:NO];
//        
//        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
//        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
//        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//        
//        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetOrderDetails?order_id=", self.strOrderId];
//        NSURL *url = [NSURL URLWithString:strURL];
//        
//        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
//                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                           [self.indicatorView setHidden:YES];
//                                                           if(error == nil)
//                                                           {
//                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                                                               if([returnedDict[@"status"] hasPrefix:@"error"]) {
//                                                                   if([returnedDict[@"result"] hasPrefix:@"T5"])
//                                                                       [GlobalShare showSessionExpiredAlertView:self :SESSION_EXPIRED];
//                                                                   else if([returnedDict[@"result"] hasPrefix:@"T3"])
//                                                                       [GlobalShare showBasicAlertView:self :INVALID_HEADER];
//                                                                   else
//                                                                       [GlobalShare showBasicAlertView:self :returnedDict[@"result"]];
//                                                                   return;
//                                                               }
//                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
//                                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                                       
//                                                                       NSDictionary *dictVal = returnedDict[@"result"];
//                                                                       
//                                                                       NSPredicate *applePred1 = [NSPredicate predicateWithFormat:@"self.minor_code matches %@", dictVal[@"order_type_id"]];
//                                                                       NSArray *arrFiltered1 = [globalShare.pickerData1 filteredArrayUsingPredicate:applePred1];
//                                                                       NSMutableArray *pickData1 = [NSMutableArray arrayWithArray:arrFiltered1];
//                                                                       if(pickData1.count > 0)
//                                                                           [self.buttonTransaction setTitle:[pickData1 objectAtIndex:0][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//                                                                       
////                                                                       NSPredicate *applePred2 = [NSPredicate predicateWithFormat:@"self.minor_code matches %@", dictVal[@"order_type_id"]];
////                                                                       NSArray *arrFiltered2 = [globalShare.pickerData2 filteredArrayUsingPredicate:applePred2];
////                                                                       NSMutableArray *pickData2 = [NSMutableArray arrayWithArray:arrFiltered2];
////                                                                       if(pickData2.count > 0)
////                                                                           [self.buttonOrderType setTitle:[pickData2 objectAtIndex:0][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//
//                                                                       NSPredicate *applePred3 = [NSPredicate predicateWithFormat:@"self.minor_code matches %@", dictVal[@"validity"]];
//                                                                       NSArray *arrFiltered3 = [globalShare.pickerData3 filteredArrayUsingPredicate:applePred3];
//                                                                       NSMutableArray *pickData3 = [NSMutableArray arrayWithArray:arrFiltered3];
//                                                                       if(pickData3.count > 0)
//                                                                           [self.buttonDuration setTitle:[pickData3 objectAtIndex:0][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//
//                                                                       self.selectValTrans = [dictVal[@"order_type_id"] integerValue] - 1;
//                                                                       self.selectValDuration = [dictVal[@"validity"] integerValue] - 1;
//
//                                                                       [self.textFieldLimit setAlpha:0.5];
//                                                                       [self.textFieldLimit setEnabled:NO];
//                                                                       if([dictVal[@"is_market_price"] integerValue] == 1) {
//                                                                           self.selectValOrder = 1;
////                                                                           self.textFieldLimit.text = @"";
//                                                                       }
//                                                                       else {
//                                                                           self.selectValOrder = 0;
//                                                                           [self.textFieldLimit setAlpha:1.0];
//                                                                           [self.textFieldLimit setEnabled:YES];
////                                                                           self.textFieldLimit.text = [GlobalShare formatStringToTwoDigits:dictVal[@"limit_price"]];
//                                                                       }
//
//                                                                       [self.picker selectRow:self.selectValTrans inComponent:0 animated:YES];
//                                                                       [self.buttonOrderType setTitle:[globalShare.pickerData2 objectAtIndex:self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
//                  
//                                                                       if([self.buttonTransaction.currentTitle isEqualToString:@"Buy"]) {
//                                                                           [self.view setBackgroundColor:[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f]];
//                                                                       }
//                                                                       else {
//                                                                           [self.view setBackgroundColor:[UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f]];
//                                                                       }
//
//                                                                       self.textFieldLimit.text = [GlobalShare formatStringToTwoDigits:dictVal[@"limit_price"]];
//                                                                       self.textFieldQty.text = dictVal[@"qty"];
//                                                                       
//                                                                       if([dictVal[@"disclose_qty"] integerValue] > 0) {
//                                                                           [_buttonDisclose setImage:[UIImage imageNamed:@"tickmark.png"] forState:UIControlStateNormal];
//                                                                           [_viewDisclose setBackgroundColor:[UIColor orangeColor]];
//                                                                           _viewDisclose.layer.borderWidth = 1.0;
//                                                                           _viewDisclose.layer.borderColor = [UIColor orangeColor].CGColor;
//                                                                           
//                                                                           [self.textFieldDisclose setAlpha:1.0];
//                                                                           [self.textFieldDisclose setEnabled:YES];
//                                                                           self.textFieldDisclose.text = dictVal[@"disclose_qty"];
//                                                                       }
//                                                                       else {
//                                                                           [_buttonDisclose setImage:nil forState:UIControlStateNormal];
//                                                                           [_viewDisclose setBackgroundColor:[UIColor clearColor]];
//                                                                           _viewDisclose.layer.borderWidth = 1.0;
//                                                                           _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
//                                                                           
//                                                                           [self.textFieldDisclose setAlpha:0.5];
//                                                                           [self.textFieldDisclose setEnabled:NO];
//                                                                           self.textFieldDisclose.text = @"";
//                                                                       }
//                                                                       
//                                                                       NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//                                                                       NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//                                                                       
////                                                                       if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"])
////                                                                           strPrice = self.labelPrice.text;
//                                                                       
//                                                                       double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
//                                                                       priceVal = [strPrice doubleValue];
//                                                                       qtyVal = [strQty doubleValue];
//                                                                       commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
//                                                                       OrderVal = qtyVal * priceVal;
//                                                                       commissionVal = qtyVal * priceVal * commission;
//                                                                       if(commissionVal < 30) commissionVal = 30.0;
//                                                                       orderCommissionVal = OrderVal + commissionVal;
//                                                                       
//                                                                       self.strPrevOrderValue = [NSString stringWithFormat:@"%.2f", orderCommissionVal];
//                                                                       self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:self.strPrevOrderValue];
//
//                                                                   });
//                                                               }
//                                                           }
//                                                           else {
//                                                               [GlobalShare showBasicAlertView:self :[error localizedDescription]];
//                                                           }
//                                                       }];
//        
//        [dataTask resume];
//    }
//    @catch (NSException * e) {
//        NSLog(@"%@", [e description]);
//    }
//    @finally {
//        
//    }
//}

-(void) getOrderDetails {
    @try {
        if([self.strOrderId length] == 0) return;
        
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetOrderDetails?order_id=", self.strOrderId];
        NSLog(@"The URL for getOrderdetails:%@",strURL);
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               if([returnedDict[@"status"] hasPrefix:@"error"]) {
                                                                   if([returnedDict[@"order_type_desc_e"] isEqualToString:@"SELL"])
                                                                   {
                                                                       [globalShare setIsBuytheorder:false];
                                                                   }
                                                                   
                                                                   
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
                                                                       if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")])
                                                                       {
                                                                       self.labelOrderValue.text = [NSString stringWithFormat:@"%@",dictVal[@"OrderValue"]];
                                                                           _strOrderValue = self.labelOrderValue.text;
                                                                       }
                                                                       
                                                                      // [self getLimitUpLimitDown];
                                                                       
                                                                       NSString *strcost =[NSString stringWithFormat:@"%.2f",[dictVal[@"OrderValue"]floatValue]] ;
                                                                       [[NSUserDefaults standardUserDefaults] setValue:strcost forKey:@"modified_order_VAL"] ;
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       
                                                                       NSPredicate *applePred1 = [NSPredicate predicateWithFormat:@"self.minor_code matches %@", dictVal[@"order_type_id"]];
                                                                       NSArray *arrFiltered1 = [globalShare.pickerData1 filteredArrayUsingPredicate:applePred1];
                                                                       NSMutableArray *pickData1 = [NSMutableArray arrayWithArray:arrFiltered1];
                                                                       if(pickData1.count > 0)
                                                                           [self.buttonTransaction setTitle:[pickData1 objectAtIndex:0][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
                                                                       
                                                                       NSPredicate *applePred3 = [NSPredicate predicateWithFormat:@"self.minor_code matches %@", dictVal[@"validity"]];
                                                                       NSArray *arrFiltered3 = [globalShare.pickerData3 filteredArrayUsingPredicate:applePred3];
                                                                       NSMutableArray *pickData3 = [NSMutableArray arrayWithArray:arrFiltered3];
                                                                       if(pickData3.count > 0)
                                                                           [self.buttonDuration setTitle:[pickData3 objectAtIndex:0][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
                                                                       
                                                                       self.selectValTrans = [dictVal[@"order_type_id"] integerValue] - 1;
                                                                       self.selectValDuration = [dictVal[@"validity"] integerValue] - 1;
//                                                                       self.selectValOrder = 0;
                                                                       
                                                                       [self.textFieldLimit setAlpha:0.5];
                                                                       [self.textFieldLimit setEnabled:NO];
                                                                       if([dictVal[@"is_market_price"] integerValue] == 1) {
                                                                           self.selectValOrder = 1;
                                                                           self.textFieldLimit.text = @"";
                                                                       }
                                                                       else if([dictVal[@"is_market_price"] integerValue] == 2) {
                                                                           self.selectValOrder = 4;
                                                                           self.textFieldLimit.text = @"";
                                                                       }
                                                                       else {
                                                                           self.selectValOrder = 0;
                                                                           self.textFieldLimit.text = [GlobalShare formatStringToTwoDigits:dictVal[@"limit_price"]];
                                                                           _str_limit = self.textFieldLimit.text;
                                                                           [self.textFieldLimit setAlpha:1.0];
                                                                           [self.textFieldLimit setEnabled:YES];
                                                                       }
                                                                       
//                                                                       [self.picker selectRow:self.selectValOrder inComponent:0 animated:YES];
                                                                       [self.buttonOrderType setTitle:[globalShare.pickerData2 objectAtIndex:self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
                                                                       
//                                                                       if([self.buttonTransaction.currentTitle isEqualToString:@"Buy"]) {
                                                                       if(self.selectValTrans == 0) {
                                                                           [self.contentView setBackgroundColor:[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f]];
                                                                           self.scrollView.backgroundColor = self.contentView.backgroundColor;
                                                                       }
                                                                       else {
                                                                           [self.contentView setBackgroundColor:[UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f]];
                                                                           self.scrollView.backgroundColor = self.contentView.backgroundColor;
                                                                       }
                                                                       
                                                                       self.textFieldQty.text = dictVal[@"qty"];
                                                                       _str_shares_QTY = _textFieldQty.text;
                                                                       
                                                                       self.strLimitPrice = dictVal[@"limit_price"];
                                                                       
//                                                                       if([self.buttonDuration.currentTitle isEqualToString:@"GTD"]) {
                                                                       if(self.selectValDuration == 8) {
                                                                           [self.labelDuration setText:[NSString stringWithFormat:@"%@", [dictVal[@"expiry_date"] componentsSeparatedByString:@" "][0]]];
                                                                           NSLog(@"The label duration text is:%@",self.labelDuration.text);
                                                                        NSDate   *date = [GlobalShare returnDateAsDateanother_form:self.labelDuration.text];
                                                                           self.datePicker.date = date; /*[GlobalShare returnDateAsDate:self.labelDuration.text];*/
                                                                       }
//                                                                       else if([self.buttonDuration.currentTitle isEqualToString:@"GTT"]) {
                                                                       else if(self.selectValDuration == 9) {
                                                                           @try
                                                                           {
                                                                           NSString *strExpTime = [NSString stringWithFormat:@"%@", [dictVal[@"expiry_date"] componentsSeparatedByString:@" "][1]];
                                                                           [self.labelDuration setText:[NSString stringWithFormat:@"%@:%@", [strExpTime componentsSeparatedByString:@":"][0], [strExpTime componentsSeparatedByString:@":"][1]]];
//                                                                           self.timePicker.date = [GlobalShare returnTimeAsDate:self.labelDuration.text];
                                                                           
                                                                           NSInteger startHour = [[strExpTime componentsSeparatedByString:@":"][0] integerValue];
                                                                           NSInteger startMinute = [[strExpTime componentsSeparatedByString:@":"][1] integerValue];
                                                                           
                                                                           NSDate *date1 = [NSDate date];
                                                                           NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                                                           NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate:date1];
                                                                           [components setHour:startHour];
                                                                           [components setMinute:startMinute];
                                                                           [components setSecond:0];
                                                                           NSDate *startDate = [gregorian dateFromComponents:components];
                                                                           
                                                                           [self.timePicker setDate:startDate animated:YES];
                                                                           }
                                                                           @catch(NSException *exception)
                                                                           {
                                                                               
                                                                           }
                                                                       }
                                                                       else
                                                                           [self.labelDuration setText:@""];

                                                                       if([dictVal[@"disclose_qty"] integerValue] > 0) {
                                                                           [_buttonDisclose setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
//                                                                           [_viewDisclose setBackgroundColor:[UIColor orangeColor]];
                                                                           _viewDisclose.layer.borderWidth = 1.0;
                                                                           _viewDisclose.layer.borderColor = [UIColor orangeColor].CGColor;
                                                                           
                                                                           [self.textFieldDisclose setAlpha:1.0];
                                                                           [self.textFieldDisclose setEnabled:YES];
                                                                           self.textFieldDisclose.text = dictVal[@"disclose_qty"];
                                                                       }
                                                                       else {
                                                                           [_buttonDisclose setImage:nil forState:UIControlStateNormal];
//                                                                           [_viewDisclose setBackgroundColor:[UIColor clearColor]];
                                                                           _viewDisclose.layer.borderWidth = 1.0;
                                                                           _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
                                                                           
                                                                           [self.textFieldDisclose setAlpha:0.5];
                                                                           [self.textFieldDisclose setEnabled:NO];
                                                                           self.textFieldDisclose.text = @"";
                                                                       }
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

-(void) createSecurity:(NSArray *)strArray {
//    for (int i = 0; i < strArray.count; i++) {
//        NSMutableDictionary *def = strArray[i];
//        NSMutableArray *newArray = def[@"securities"];
//        [self.allResults addObjectsFromArray:newArray];
//    }
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    [self.allResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSMutableDictionary *dict = [(NSMutableDictionary *)obj mutableCopy];
//        dict[@"IsChecked"] = @("NO");
//        [arr addObject:dict];
//    }];
//    NSLog(@"%@", arr);
//    NSLog(@"%@", @"sd");
    
    [DataManager insertSecurityList:strArray];
//    globalShare.dictValues = [[NSMutableDictionary alloc] init];
    globalShare.dictValues = [DataManager select_SecurityListAsSectors];
    self.allResults = [DataManager select_SecurityList];
}

- (void)updateOrderValue {
    
    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
    if([strQty integerValue] > 0) {
        priceVal = [strPrice doubleValue];
        qtyVal = [strQty doubleValue];
        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
        OrderVal = qtyVal * priceVal;
        commissionVal = qtyVal * priceVal * commission;
        if(commissionVal < 30) commissionVal = 30.0;
        if(self.selectValTrans == 0)
            orderCommissionVal = OrderVal + commissionVal;
        else
            orderCommissionVal = OrderVal - commissionVal;
    }
    
    self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
//    if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")])
//    {
//    [self order_VAL_cahnged];
//    }
    
    
//    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
////    if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"])
//    if(self.selectValOrder == 0)
//        strPrice = self.labelPrice.text;
//
//    if([strQty integerValue] > 0) {
//        double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
//        priceVal = [strPrice doubleValue];
//        qtyVal = [strQty doubleValue];
//        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
//        OrderVal = qtyVal * priceVal;
//        commissionVal = qtyVal * priceVal * commission;
//        if(commissionVal < 30) commissionVal = 30.0;
//        orderCommissionVal = OrderVal + commissionVal;
//
//        self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
//    }
}

- (void)callBackFromConfirmOrderStocks {
   // [self clearSecurityOrderValue];
    [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
}

- (void)callBackFromConfirmOrder {
   // self.securityId = @"";
   // [self clearSecurityOrderValue];
    [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
}

- (void)clearSecurityOrderValue {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.buttonTransaction setTitle:@"" forState:UIControlStateNormal];
    [self.buttonOrderType setTitle:@"" forState:UIControlStateNormal];
    [self.buttonDuration setTitle:@"" forState:UIControlStateNormal];
    [self.textFieldLimit setText:@""];
    [self.textFieldQty setText:@""];
    [self.textFieldDisclose setText:@""];
    
    [self.labelBuyPower setText:@""];
    [self.labelOrderValue setText:@""];
    [self.labelSymbol setText:@""];
    [self.labelSecurityName setText:@""];
    [self.labelPrice setText:@""];
    [self.labelChange setText:@""];
    [self.labelPercentChange setText:@""];
    [self.labelAskPrice setText:@""];
    [self.labelAskCount setText:@""];
    [self.labelBidPrice setText:@""];
    [self.labelBidCount setText:@""];
    [self.labelDuration setText:@""];

    [_buttonDisclose setImage:nil forState:UIControlStateNormal];
    [_viewDisclose setBackgroundColor:[UIColor clearColor]];
    _viewDisclose.layer.borderWidth = 1.0;
    _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [self.textFieldDisclose setAlpha:0.5];
    [self.textFieldDisclose setEnabled:NO];
    [self.textFieldLimit setAlpha:1.0];
    [self.textFieldLimit setEnabled:YES];

//    self.securityId = @"";
    self.selectValTrans = 0;
    self.selectValOrder = 0;
    self.selectValDuration = 0;
    
    [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
    [self.buttonDuration setTitle:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
    
    self.strLimitUpPrice = @"";
    self.strLimitDownPrice = @"";
}

-(void) clearNewOrder {
    [self.labelOrderValue setText:@""];
    [self.labelBuyPower setText:@""];
}

- (void)clearOrderValue {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.buttonTransaction setTitle:@"" forState:UIControlStateNormal];
    [self.textFieldLimit setText:@""];
    [self.textFieldQty setText:@""];
    [self.textFieldDisclose setText:@""];
    
    [self.labelBuyPower setText:@""];
    [self.labelOrderValue setText:@""];
    [self.labelDuration setText:@""];
    
    [_buttonDisclose setImage:nil forState:UIControlStateNormal];
    [_viewDisclose setBackgroundColor:[UIColor clearColor]];
    _viewDisclose.layer.borderWidth = 1.0;
    _viewDisclose.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [self.textFieldDisclose setAlpha:0.5];
    [self.textFieldDisclose setEnabled:NO];
    [self.textFieldLimit setAlpha:1.0];
    [self.textFieldLimit setEnabled:YES];
    
    //    self.securityId = @"";
    self.selectValTrans = 0;
    self.selectValOrder = 0;
    self.selectValDuration = 0;
    
    [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
    [self.buttonDuration setTitle:globalShare.pickerData3[self.selectValDuration][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
}

-(void) confirmOrder:(NSMutableDictionary *)dictParams {
    @try {
        [self.indicatorView setHidden:NO];

        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"ConfirmOrder", dictParams[@"ConfirmOrder"]];
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
                                                                       
                                                                       double commissionVal = 0, orderVal = 0, orderCommissionVal = 0;
                                                                       commissionVal = [dictVal[@"commission_value"] doubleValue];
                                                                       orderCommissionVal = [dictVal[@"total_order_value"] doubleValue];
                                                                       
                                                                       [[NSUserDefaults standardUserDefaults] setValue:dictVal[@"total_order_value"]  forKey:@"modified_order_VAL"] ;
                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                                       if(self.selectValTrans == 0)
                                                                           orderVal = orderCommissionVal - commissionVal;
                                                                       else
                                                                           orderVal = orderCommissionVal + commissionVal;

                                                                       self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];

                                                                       [dictParams setObject:[GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderVal]] forKey:@"CostOfTrade"];
                                                                       [dictParams setObject:[GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"total_order_value"]] forKey:@"OrderValue"];
                                                                    
                                                                       
                                                                       
                                                                       [dictParams setObject:[GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"new_balance"]] forKey:@"NewBuyPower"];

                                                                       OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
                                                                       orderConfirmViewController.delegate = self;
                                                                       orderConfirmViewController.passOrderValues = dictParams;
                                                                       [[self navigationController] pushViewController:orderConfirmViewController animated:YES];

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

-(void) confirmOrderValue:(NSMutableDictionary *)dictParams {
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"ConfirmOrder", dictParams[@"ConfirmOrder"]];
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
                                                                       
                                                                       double commissionVal = 0, orderVal = 0, orderCommissionVal = 0;
                                                                       commissionVal = [dictVal[@"commission_value"] doubleValue];
                                                                       orderCommissionVal = [dictVal[@"total_order_value"] doubleValue];
                                                                       if(self.selectValTrans == 0)
                                                                           orderVal = orderCommissionVal - commissionVal;
                                                                       else
                                                                           orderVal = orderCommissionVal + commissionVal;
                                                                       
                                                                       self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
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

- (void)callBackSuperviewFromCash {
    self.tabBarController.tabBar.hidden = NO;
}
-(void) getLimitUpLimitDown {
    @try {
        NSLog(@"%@",self.securityId);
        
        if([self.securityId length] == 0) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView setHidden:NO];
        });
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@GetSymbolLimitUpDown?ticker=%@", REQUEST_URL,self.securityId];
        //NSLog(@"URL .. %@",strURL);
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
                                                                     NSDictionary *limitUpDownDict =    [returnedDict valueForKey:@"result"];
                                                                       self.limitDowmLabel.hidden = NO;
                                                                       self.limitUPLabel.hidden = NO;
                                                                       
                                                                       NSString *str = [NSString stringWithFormat:@"%@: %@",
                                                                        NSLocalizedString(@"Limit Up", @"Limit Up"),[limitUpDownDict valueForKey:@"LimitUp"]];
                                                                      
                                                                       
                                                                       self.limitUPLabel.text = str;
                                           
                                                                       str = [NSString stringWithFormat:@"%@: %@",
                                                                              NSLocalizedString(@"Limit Down", @"Limit Down"),[limitUpDownDict valueForKey:@"LimitDown"]];
                                                                       self.limitDowmLabel.text = str;
                                                                       self.strLimitUpPrice = [GlobalShare formatStringToTwoDigits:limitUpDownDict[@"LimitUp"]];
                                                                       self.strLimitDownPrice = [GlobalShare formatStringToTwoDigits:limitUpDownDict[@"LimitDown"]];
                                                                       
//                                                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_securities_avail"];
//                                                                       [[NSUserDefaults standardUserDefaults] synchronize];
//                                                                       [self createSecurity:returnedDict[@"result"]];
                                                                       
                                                                       
                                                                   });
                                                               }
                                                           }
                                                           else {
                                                            //   [GlobalShare showBasicAlertView:self :[error localizedDescription]];
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

#pragma mark - UIPickerView

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_selectVal == 0)
        return globalShare.pickerData1.count;
    else if(_selectVal == 1)
        return globalShare.pickerData2.count;
    else
        return globalShare.pickerData3.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_selectVal == 0)
        return globalShare.pickerData1[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
    else if(_selectVal == 1)
        return globalShare.pickerData2[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
    else
        return globalShare.pickerData3[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    if(_selectVal == 0) {
        self.selectValTrans = row;
        [self.buttonTransaction setTitle:globalShare.pickerData1[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
        
//        if([self.buttonTransaction.currentTitle isEqualToString:@"Buy"]) {
        if(self.selectValTrans == 0) {
            [self.contentView setBackgroundColor:[UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f]];
            self.scrollView.backgroundColor = [UIColor colorWithRed:230/255.f green:240/255.f blue:255/255.f alpha:1.f];
        }
        else {
            [self.contentView setBackgroundColor:[UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f]];
            self.scrollView.backgroundColor = [UIColor colorWithRed:255/255.f green:245/255.f blue:245/255.f alpha:1.f];
        }
    }
    else if(_selectVal == 1) {
        self.selectValOrder = row;
        [self.buttonOrderType setTitle:globalShare.pickerData2[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
        
//        if(![self.buttonOrderType.currentTitle isEqualToString:@"Limit Price"]) {
        if(self.selectValOrder != 0) {
////            [self.buttonDuration setTitle:@"" forState:UIControlStateNormal];
////            [self.textFieldLimit setText:@""];
//            if([self.buttonOrderType.currentTitle isEqualToString:@"Market Price"])
//                [self.textFieldLimit setText:@""];
//            else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Up"])
//                [self.textFieldLimit setText:self.strLimitUpPrice];
//            else if([self.buttonOrderType.currentTitle isEqualToString:@"Limit Down"])
//                [self.textFieldLimit setText:self.strLimitDownPrice];

            if(self.selectValOrder == 1 || self.selectValOrder == 4)
                [self.textFieldLimit setText:@""];
            else if(self.selectValOrder == 2)
                [self.textFieldLimit setText:self.strLimitUpPrice];
            else if(self.selectValOrder == 3)
                [self.textFieldLimit setText:self.strLimitDownPrice];

            [self.textFieldLimit setAlpha:0.5];
            [self.textFieldLimit setEnabled:NO];
        }
        else {
            if([self.strLimitPrice doubleValue] > 0)
                [self.textFieldLimit setText:[GlobalShare formatStringToTwoDigits:self.strLimitPrice]];
            else
                [self.textFieldLimit setText:@""];
            [self.textFieldLimit setAlpha:1.0];
            [self.textFieldLimit setEnabled:YES];
        }
    }
    else {
        self.selectValDuration = row;
        [self.buttonDuration setTitle:globalShare.pickerData3[row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
        
//        if([self.buttonDuration.currentTitle isEqualToString:@"GTD"]) {
        if(self.selectValDuration == 8) {
            if(![self.datePicker superview])
                [self.view addSubview:self.datePicker];
            
            [UIView animateWithDuration:.5 animations:^{
                [self.picker setFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
            } completion:^(BOOL finished) {
                if([self.picker superview])
                    [self.picker removeFromSuperview];
            }];
            
            [UIView animateWithDuration:.5 animations:^{
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenHeight = screenRect.size.height;
                [self.datePicker setFrame:CGRectMake(0, screenHeight-162, [[UIScreen mainScreen] bounds].size.width, 162)];
            } completion:^(BOOL finished) {
            }];
        }
//        else if([self.buttonDuration.currentTitle isEqualToString:@"GTT"]) {
        else if(self.selectValDuration == 9) {
            if(![self.timePicker superview])
                [self.view addSubview:self.timePicker];
            
            [UIView animateWithDuration:.5 animations:^{
                [self.picker setFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 162)];
            } completion:^(BOOL finished) {
                if([self.picker superview])
                    [self.picker removeFromSuperview];
            }];
            
            [UIView animateWithDuration:.5 animations:^{
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenHeight = screenRect.size.height;
                [self.timePicker setFrame:CGRectMake(0, screenHeight-162, [[UIScreen mainScreen] bounds].size.width, 162)];
            } completion:^(BOOL finished) {
            }];
        }
        else
            self.pickerDateVal = nil;
            self.pickerTimeVal = nil;
            [self.labelDuration setText:@""];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundTapButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-162);
    [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundTapButton];
    
    self.textFieldCurrent = textField;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    
//    if ([textField isEqual:_textFieldLimit])
//        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :75];
//    else
//        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :90];
//    
//    [UIView commitAnimations];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView setAnimationDuration:0.5];
    
    if ([textField isEqual:_textFieldLimit])
    {
        
        [self updateOrderValue];
      //  self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :75];
    }
//    else
       // self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :90];
    
  //  [UIView commitAnimations];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_textFieldQty]) {
        if ([GlobalShare isNumeric:string] || [string isEqualToString:@""]) {
            return YES;
        }
        else
            return NO;
    }
    else if ([textField isEqual:_textFieldLimit]) {
        NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        if ([string rangeOfCharacterFromSet:charSet].location != NSNotFound)
            return NO;
        else {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *sep = [newString componentsSeparatedByString:@"."];
            if([sep count] > 2)
                return NO;
            else {
                if([sep count] == 1) {
                    return YES;
                }
                if([sep count] == 2) {
                    if([[sep objectAtIndex:1] length] > 2)
                        return NO;
                }
                return YES;
            }
        }
    }
    else {
        return YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    double viewWidth = [UIScreen mainScreen].bounds.size.width;
    double viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect viewableAreaFrame = CGRectMake(0.0, 0.0, viewWidth, viewHeight - keyboardSize.height);
    CGRect activeTextFieldFrame = [self.textFieldCurrent convertRect:self.textFieldCurrent.bounds toView:self.view];
    
    if (!CGRectContainsRect(viewableAreaFrame, activeTextFieldFrame))
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -keyboardSize.height;
            self.view.frame = f;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = self.view.bounds;
    }];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.tableViewOptionMenu])
        return self.arrayMenu.count;
    else
        return self.visibleResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableViewOptionMenu]) {
//        static NSString *CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        
////        cell.textLabel.text = self.arrayMenu[indexPath.row];
//        cell.textLabel.text = self.arrayMenu[indexPath.row][@"menu_title"];
//        cell.imageView.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        
        OptionsViewCell *cell = (OptionsViewCell *) [tableView dequeueReusableCellWithIdentifier:kNewOrderOptionsViewCellIdentifier forIndexPath:indexPath];
        
        cell.labelOption.text = self.arrayMenu[indexPath.row][@"menu_title"];
        cell.imageOption.image = [UIImage imageNamed:self.arrayMenu[indexPath.row][@"menu_image"]];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = self.visibleResults[indexPath.row][@"ticker"];
        cell.detailTextLabel.text = self.visibleResults[indexPath.row][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_name_e" : @"security_name_a"];
        
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

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_transparencyButton setAlpha:1.0];
    if(![self.viewOptionMenu isHidden])
        [self.viewOptionMenu setHidden:YES];
    [self.transparencyButton removeFromSuperview];
    self.transparencyButton = nil;
    
    if([tableView isEqual:self.tableViewOptionMenu]) {
        
        if ([[[self.arrayMenu objectAtIndex:indexPath.row]valueForKey:@"menu_image"] isEqualToString:@"icon_user"]) {
            //NSLog(@"User Id selected....");
        }
        else if ([[[self.arrayMenu objectAtIndex:indexPath.row]valueForKey:@"menu_image"] isEqualToString:@"icon_cash_position"]){
            
            self.cashContentView = [self.storyboard instantiateViewControllerWithIdentifier:@"CashPositionViewController"];
            self.cashContentView.view.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            self.cashContentView.delegate = self;
            
            [self.view addSubview:self.cashContentView.view];
            [UIView animateWithDuration:.3 animations:^{
                [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
                [self.cashContentView.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            } completion:^(BOOL finished) {
                self.tabBarController.tabBar.hidden = YES;
            }];
        }
       else if ([[[self.arrayMenu objectAtIndex:indexPath.row]valueForKey:@"menu_image"] isEqualToString:@"icon_contact_us"]){
           
            ContactUsViewController *contactUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [[self navigationController] pushViewController:contactUsViewController animated:YES];
        }
       else if ([[[self.arrayMenu objectAtIndex:indexPath.row]valueForKey:@"menu_image"] isEqualToString:@"icon_settings"]){
           
            SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            [[self navigationController] pushViewController:settingsViewController animated:YES];
        }
        else {
            if ([GlobalShare isUserLogedIn]) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else{
                [GlobalShare showSignOutAlertView:self :SIGNOUT_CONFIRMATION];
            }
        }
        
        if(indexPath.row != 0) {
            [self callBackFromConfirmOrder];
        }
    }
    else {
        if(![self.securityId isEqualToString:self.visibleResults[indexPath.row][@"ticker"]]) {
            self.securityId = self.visibleResults[indexPath.row][@"ticker"];
           // [self clearSecurityOrderValue];
            
            [self.buttonOrderType setEnabled:YES];
            
            [self performSelector:@selector(getMarketWatchNew) withObject:nil afterDelay:0.01f];
           // [self performSelector:@selector(getLimitUpLimitDown) withObject:nil afterDelay:0.01f];
            
            
        }
        
////        self.selectVal = 0;
////        self.strLimitPrice = @"";
////        self.selectValOrder = 0;
////        [self.buttonOrderType setTitle:globalShare.pickerData2[self.selectValOrder][(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"description_e" : @"description_a"] forState:UIControlStateNormal];
////        [self.textFieldLimit setAlpha:1.0];
////        [self.textFieldLimit setEnabled:YES];
//        [self.buttonOrderType setEnabled:YES];
//
//        [self performSelector:@selector(getMarketWatchNew) withObject:nil afterDelay:0.01f];
        [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
     
        [self.searchResults resignFirstResponder];
        self.tabBarController.tabBar.hidden = NO;
        [self.tableResults setHidden:YES];
        [self.searchResults setHidden:YES];
        [self.view sendSubviewToBack:self.searchResults];
        [self.view sendSubviewToBack:self.tableResults];
        [self.view bringSubviewToFront:self.labelTitle];
        [self.view bringSubviewToFront:self.buttonBack];
        [self.view bringSubviewToFront:self.buttonPhoneCall];
        [self.view bringSubviewToFront:self.buttonSmallLogo];
        [self.view bringSubviewToFront:self.buttonSearch];
        [self.view bringSubviewToFront:self.buttonAlert];
        [self.view bringSubviewToFront:self.buttonOptionMenu];

        if([[GlobalShare sharedInstance] isBuyOrder])
            [self.labelTitle setText:NSLocalizedString(@"Modify Order", @"Modify Order")];
        else
            [self.labelTitle setText:NSLocalizedString(@"New Order", @"New Order")];

        self.searchResults.text = @"";
        NSString *searchString = self.searchResults.text;
        [self updateFilteredContentForProductName:searchString];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    [self updateFilteredContentForProductName:searchString];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    NSString *searchString = searchBar.text;
    
    [self updateFilteredContentForProductName:searchString];
    
    [searchBar resignFirstResponder];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.tableResults setHidden:YES];
    [self.searchResults setHidden:YES];
    [self.view sendSubviewToBack:self.searchResults];
    [self.view sendSubviewToBack:self.tableResults];
    [self.view bringSubviewToFront:self.labelTitle];
    [self.view bringSubviewToFront:self.buttonBack];
    [self.view bringSubviewToFront:self.buttonPhoneCall];
    [self.view bringSubviewToFront:self.buttonSmallLogo];
    [self.view bringSubviewToFront:self.buttonSearch];
    [self.view bringSubviewToFront:self.buttonAlert];
    [self.view bringSubviewToFront:self.buttonOptionMenu];

    if([[GlobalShare sharedInstance] isBuyOrder])
        [self.labelTitle setText:NSLocalizedString(@"Modify Order", @"Modify Order")];
    else
        [self.labelTitle setText:NSLocalizedString(@"New Order", @"New Order")];

//    [self.buttonBack setHidden:NO];
//    [self.buttonPhoneCall setHidden:NO];
//    [self.buttonSearch setHidden:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchString = [searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)filterString {
//    if (filterString.length <= 0) {
//        self.visibleResults = self.allResults;
//    }
//    else {
    
    if ([filterString isEqualToString:@""]) {
        
        self.visibleResults = globalShare.search_results;
    }
    else{
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.security_name_e contains [c] %@ OR self.security_name_a contains [c] %@ OR self.ticker contains [c] %@", filterString, filterString, filterString];
        self.visibleResults = [globalShare.search_results filteredArrayUsingPredicate:filterPredicate];
   }
    
    [self.tableResults reloadData];
}

#pragma mark modify order
-(void)update_ORder_API : (NSDictionary *)dictVals
{
   
        @try {
            if([self.strOrderId length] == 0) return;
            
            [self.indicatorView setHidden:NO];
            
            NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL,@"ConfirmOrder",_str_confirm_order];
            
//            NSString *strURL =[NSString stringWithFormat:@"%@ConfirmOrder?order_side=1&order_type=2&symbol=%@&qty=%@&price=%@&is_market_price_order=0&order_id=20171214-749037, tag=null'];
            NSLog(@"The URL for getOrderdetails:%@",strURL);
            NSURL *url = [NSURL URLWithString:strURL];
            
            NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               [self.indicatorView setHidden:YES];
    if(error == nil)
        {
       NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"the response from update order:%@",returnedDict);
            
            
            
            if([returnedDict[@"status"] isEqualToString:@"authenticated"])
            {
            NSDictionary *temp_dict = returnedDict[@"result"];
            NSString *str_VAL = [NSString stringWithFormat:@"%@",temp_dict[@"new_balance"]];
                
           
            if([str_VAL containsString:@"-"])
            {
                
                [GlobalShare showBasicAlertView:self :CHECK_AMOUNT];
                return;
            }
            else
            {
                
                
            NSString *str_txt =NSLocalizedString(@"CHANGE QUANTITY", @"Basic Alert Style");
//            NSString *str_commission_VAL = NSLocalizedString(@"COMMISSION VALUE", @"Basic Alert Style");
//            NSString *str_newbal_VAL =NSLocalizedString(@"NEW BALANCE", @"Basic Alert Style");
//            NSString *str_total_order_VAL =NSLocalizedString(@"TOTAL ORDER VALUE", @"Basic Alert Style");
//
//                NSString *strCommisionvalue = [NSString stringWithFormat:@"%@",temp_dict[@"commission_value"]];
//                NSString *strnewbalancevalue = [NSString stringWithFormat:@"%@",temp_dict[@"new_balance"]];
//                 NSString *strtotalbalancevalue = [NSString stringWithFormat:@"%@",temp_dict[@"total_order_value"]];
                
           
//                NSString *str_string = [NSString stringWithFormat:@"%@\n%@ : %@\n%@ : %@\n%@ : %@ ",str_txt,str_commission_VAL,strCommisionvalue,str_newbal_VAL,strnewbalancevalue,str_total_order_VAL,strtotalbalancevalue];
           NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
                
                NSString *str_TXT = [NSString stringWithFormat:@"%@ %@ ?",str_txt,_textFieldQty.text];
//                if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//                  str_TXT = [NSString stringWithFormat:@"? %@ %@",_textFieldQty.text,str_txt];
//                }
            NSString *alertMessage = NSLocalizedString(str_TXT, @"BasicAlertMessage");
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                     message:alertMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                           //    _textFieldQty.text = _strQty;
                                               [self dismissViewControllerAnimated:NO completion:nil];
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           OrderConfirmViewController *orderConfirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
                                           orderConfirmViewController.delegate = self;
                                           orderConfirmViewController.passOrderValues = dictVals;
                                           [[self navigationController] pushViewController:orderConfirmViewController animated:YES];
                                       }];
            
            if(globalShare.myLanguage == ARABIC_LANGUAGE) {
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
            }
            else {
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
            }
            
            [self presentViewController:alertController animated:YES completion:nil];
         }
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

-(void)create_order_chek_STATUS
{
    @try {
        if([self.strOrderId length] == 0) return;
        
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL,@"ConfirmOrder",_str_confirm_order];
        
        //            NSString *strURL =[NSString stringWithFormat:@"%@ConfirmOrder?order_side=1&order_type=2&symbol=%@&qty=%@&price=%@&is_market_price_order=0&order_id=20171214-749037, tag=null'];
        NSLog(@"The URL for getOrderdetails:%@",strURL);
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSLog(@"the response from update order:%@",returnedDict);
                                                               
                                                               
                                                               
                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"])
                                                               {
                                                                   NSDictionary *temp_dict = returnedDict[@"result"];
                                                                   NSString *str_VAL = [NSString stringWithFormat:@"%@",temp_dict[@"new_balance"]];
                                                                   
                                                                   
                                                                   if([str_VAL containsString:@"-"])
                                                                   {
                                                                       
                                                                       [GlobalShare showBasicAlertView:self :CHECK_AMOUNT];
                                                                       return;
                                                                   }
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
#pragma Text field editing chaneged


-(void)order_VAL_cahnged
{
    NSString *strPrice = [self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strQty = [self.textFieldQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    double qtyVal = 0, priceVal = 0, commission = 0, commissionVal = 0, OrderVal = 0, orderCommissionVal = 0;
    if([strQty integerValue] > 0) {
        priceVal = [strPrice doubleValue];
        qtyVal = [strQty doubleValue];
        commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
        OrderVal = qtyVal * priceVal;
        commissionVal = qtyVal * priceVal * commission;
        if(commissionVal < 30) commissionVal = 30.0;
        if(self.selectValTrans == 0)
            orderCommissionVal = OrderVal + commissionVal;
        else
            orderCommissionVal = OrderVal - commissionVal;
    }
    
    self.labelOrderValue.text = [GlobalShare createCommaSeparatedTwoDigitString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
}

-(void)QTY_changed
{
    if([self.buttonTransaction.currentTitle isEqualToString:NSLocalizedString(@"Sell", @"Sell")])
    {
        
    }
   
    else
    {
       
    if([self.textFieldLimit.text isEqualToString:@""])
    {
    self.textFieldQty.text =  @"";
    }
    double buyCash1 = 0,buyCash2 = 0, buySharePrice1 = 0, commission = 0, commissionVal = 0;
    int buyNoOfShares1 = 0;
    NSString *str = [self.labelBuyPower.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    buyCash1 = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    buyCash2 = [[_strOrderValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    if([self.buttonCreate.currentTitle isEqualToString:NSLocalizedString(@"Modify", @"Modify")])
    {
    buyCash1 = buyCash1 + buyCash2;
    }
    
    buySharePrice1 = [[self.textFieldLimit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
   
    
    if(self.selectValOrder == 0)
   // buySharePrice1 = [self.labelPrice.text doubleValue];
    
    commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
    commissionVal = buyCash1 * commission;
    if(commissionVal < 30) commissionVal = 30.0;
    buyCash1 = buyCash1 - commissionVal;
    buyNoOfShares1 = buyCash1 / buySharePrice1;
   
        if(buyNoOfShares1 < 1)
        {
            _textFieldQty.text =[NSString stringWithFormat:@""];
        }
        else{
            _textFieldQty.text =[NSString stringWithFormat:@"%d",buyNoOfShares1];

        }
    }
    [self order_VAL_cahnged];
}


@end
