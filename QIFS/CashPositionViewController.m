//
//  CashPositionViewController.m
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "CashPositionViewController.h"
#import "LoginView.h"

@interface CashPositionViewController () <NSURLSessionDelegate,UITextFieldDelegate>{
    LoginView *loginVw;
    UIView *overLayView;
}

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UILabel *labelLastDeposit;
@property (nonatomic, weak) IBOutlet UILabel *labelLastDepositDate;
@property (nonatomic, weak) IBOutlet UILabel *labelLastWithdrawal;
@property (nonatomic, weak) IBOutlet UILabel *labelLastWithdrawalDate;

@property (nonatomic, weak) IBOutlet UILabel *labelBalance;
@property (nonatomic, weak) IBOutlet UILabel *labelFacilities;
@property (nonatomic, weak) IBOutlet UILabel *labelBlockedCash;
@property (nonatomic, weak) IBOutlet UILabel *labelCurrentBalance;

@end

@implementation CashPositionViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self overLayCreation];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"CASH POSITION", @"CASH POSITION")];
   
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"]) {
        [self clearCashPosition];
        [self showsLoginPopUp];
    }
    else{
    [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
    [self clearCashPosition];
    }
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelBalance setTextAlignment:NSTextAlignmentLeft];
        [self.labelFacilities setTextAlignment:NSTextAlignmentLeft];
        [self.labelBlockedCash setTextAlignment:NSTextAlignmentLeft];
        [self.labelCurrentBalance setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelBalance setTextAlignment:NSTextAlignmentRight];
        [self.labelFacilities setTextAlignment:NSTextAlignmentRight];
        [self.labelBlockedCash setTextAlignment:NSTextAlignmentRight];
        [self.labelCurrentBalance setTextAlignment:NSTextAlignmentRight];
    }
}

-(void)overLayCreation{
    overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    overLayView.clipsToBounds = YES;
    overLayView.hidden = YES;
    [self.view addSubview:overLayView];
}
#pragma mark Loading Login PopUp when guest User
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
        
    }
    else {
        //[[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [loginVw setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }
    
}

#pragma mark - Button actions
-(void)cancelButtonAction{
    overLayView.hidden = YES;
    [self removeCashPositionController];
}
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

- (IBAction)backgroundTapped:(id)sender {
    [self removeCashPositionController];
}
-(void)removeCashPositionController{
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    } completion:^(BOOL finished) {
        if([self.view superview])
            [self.view removeFromSuperview];
        [self.delegate callBackSuperviewFromCash];
    }];
}

#pragma mark - Common actions

-(BOOL)verifyUserLogin:(NSString *)stringUserName andPassword:(NSString*)stringPassword{
    @try {
        
        
        [loginVw removeFromSuperview];
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
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               [self getCashPosition];
                                                               
                                                               
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
                                                                       
                                                                       self.labelLastDeposit.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Deposit_Amount"]];
                                                                       self.labelLastWithdrawal.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"withdraw_Amount"]];
                                                                       
                                                                       if([dictVal[@"Deposit_Date"] length] > 0)
                                                                           self.labelLastDepositDate.text = [NSString stringWithFormat:@"%@", [dictVal[@"Deposit_Date"] componentsSeparatedByString:@" "][0]];
                                                                       
                                                                       if([dictVal[@"withdraw_Date"] length] > 0)
                                                                           self.labelLastWithdrawalDate.text = [NSString stringWithFormat:@"%@", [dictVal[@"withdraw_Date"] componentsSeparatedByString:@" "][0]];

                                                                       self.labelBalance.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Balance"]];
                                                                       self.labelFacilities.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Facility"]];
                                                                       self.labelBlockedCash.text = [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Block_cash"]];
                                                                       self.labelCurrentBalance.text = [NSString stringWithFormat:@"%@ QR", [GlobalShare createCommaSeparatedTwoDigitString:dictVal[@"Current_Balance"]]];

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

-(void) clearCashPosition {
    self.labelLastDeposit.text = @"";
    self.labelLastDepositDate.text = @"";
    self.labelLastWithdrawal.text = @"";
    self.labelLastWithdrawalDate.text = @"";

    self.labelBalance.text = @"";
    self.labelFacilities.text = @"";
    self.labelBlockedCash.text = @"";
    self.labelCurrentBalance.text = @"";
}
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


@end
