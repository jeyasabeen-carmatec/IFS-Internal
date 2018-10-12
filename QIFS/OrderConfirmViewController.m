//
//  OrderConfirmViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "OrderConfirmViewController.h"

@interface OrderConfirmViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UILabel *labelTransaction;
@property (nonatomic, weak) IBOutlet UILabel *labelAccount;
@property (nonatomic, weak) IBOutlet UILabel *labelValidity;
@property (nonatomic, weak) IBOutlet UILabel *labelCostOfTrade;
@property (nonatomic, weak) IBOutlet UILabel *labelOrderValue;
@property (nonatomic, weak) IBOutlet UILabel *labelNewBuyPower;
@property (nonatomic, weak) IBOutlet UIButton *BTN_send_order;
@property (nonatomic, weak) IBOutlet UIButton *BTN_cancel;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation OrderConfirmViewController

@synthesize passOrderValues;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Order Confirmation", @"Order Confirmation")];
   
    [[GlobalShare sharedInstance] setIsConfirmOrder:YES];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:NO];

    _viewBg.layer.borderWidth = 1.0;
    _viewBg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewBg.layer.cornerRadius = 3;
    _viewBg.layer.masksToBounds = YES;
    @try
    {
    self.labelTransaction.text = passOrderValues[@"Transaction"];
    //self.labelAccount.text = passOrderValues[@"Account"];
    self.labelValidity.text = passOrderValues[@"Validity"];
    self.labelCostOfTrade.text = passOrderValues[@"CostOfTrade"];
    self.labelOrderValue.text = passOrderValues[@"OrderValue"];
    self.labelNewBuyPower.text = passOrderValues[@"NewBuyPower"];
    }
    @catch(NSException *exception)
    {
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSString *str_send = NSLocalizedString(@"Send Order", @"Send Order");
    NSString *str_do_not_send = NSLocalizedString(@"Do Not Send", @"Do Not Send");

    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelAccount setTextAlignment:NSTextAlignmentLeft];
        [self.labelValidity setTextAlignment:NSTextAlignmentLeft];
        [self.labelCostOfTrade setTextAlignment:NSTextAlignmentLeft];
        [self.labelOrderValue setTextAlignment:NSTextAlignmentLeft];
        [self.labelNewBuyPower setTextAlignment:NSTextAlignmentLeft];
        
        [_BTN_cancel setBackgroundImage:[UIImage imageNamed:@"button_dark_bg"] forState:UIControlStateNormal];
        [_BTN_send_order setBackgroundImage:[UIImage imageNamed:@"button_light_bg"] forState:UIControlStateNormal];
        [_BTN_cancel addTarget:self action:@selector(actionSendOrder) forControlEvents:UIControlEventTouchUpInside];
        [_BTN_send_order addTarget:self action:@selector(action_back) forControlEvents:UIControlEventTouchUpInside];
        
        [_BTN_cancel setTitle:str_send forState:UIControlStateNormal];
        [_BTN_send_order setTitle:str_do_not_send forState:UIControlStateNormal];


    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelAccount setTextAlignment:NSTextAlignmentRight];
        [self.labelValidity setTextAlignment:NSTextAlignmentRight];
        [self.labelCostOfTrade setTextAlignment:NSTextAlignmentRight];
        [self.labelOrderValue setTextAlignment:NSTextAlignmentRight];
        [self.labelNewBuyPower setTextAlignment:NSTextAlignmentRight];
        
        
        [_BTN_send_order setBackgroundImage:[UIImage imageNamed:@"button_dark_bg"] forState:UIControlStateNormal];
        [_BTN_cancel setBackgroundImage:[UIImage imageNamed:@"button_light_bg"] forState:UIControlStateNormal];
        [_BTN_send_order addTarget:self action:@selector(actionSendOrder) forControlEvents:UIControlEventTouchUpInside];
        [_BTN_cancel addTarget:self action:@selector(action_back) forControlEvents:UIControlEventTouchUpInside];
        
        [_BTN_send_order setTitle:str_send forState:UIControlStateNormal];
        [_BTN_cancel setTitle:str_do_not_send forState:UIControlStateNormal];
    }
    [self getCashPosition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)action_back
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)actionSendOrder
{
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }

    [self performSelector:@selector(submitNewOrder:) withObject:passOrderValues[@"SubmitNewOrder"] afterDelay:0.01f];
}

#pragma mark - Common actions

-(void) submitNewOrder:(NSString *)strParams {
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, ([[GlobalShare sharedInstance] isBuyOrder]) ? @"ModifyOrder" : @"SubmitNewOrder", strParams];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            //   NSLog(@"The order confirm data :%@",returnedDict);
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
                                                                       [self showAlertViewAction:([[GlobalShare sharedInstance] isBuyOrder]) ? ORDERCONFIRM_MODIFY_SUCCESS : ORDERCONFIRM_CREATE_SUCCESS];
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

- (void)showAlertViewAction:(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   if([[GlobalShare sharedInstance] isDirectOrder])
                                       [self.delegate callBackFromConfirmOrder];
                                   else
                                       [self.delegate callBackFromConfirmOrderStocks];
                                   
                                   [[GlobalShare sharedInstance] setIsConfirmOrder:NO];
                                   if([[GlobalShare sharedInstance] isPortfolioOrder] || [[GlobalShare sharedInstance] isBuyOrder]) {
                                       [[GlobalShare sharedInstance] setIsDirectViewOrder:YES];
                                       [[GlobalShare sharedInstance] setIsDirectOrder:YES];

                                       [[GlobalShare sharedInstance] setIsPortfolioOrder:NO];
                                       [[GlobalShare sharedInstance] setIsBuyOrder:NO];

                                       [GlobalShare loadViewController:globalShare.topNavController];
                                   }
                                   else {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                               }];

    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Common actions

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
                                                                       
                                                                       self.labelAccount.text = dictVal[@"cust_id"];
                                                                       
                                                                      
                                                                       
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

@end
