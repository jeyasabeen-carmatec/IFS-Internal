//
//  EnterOTPViewController.m
//  QIFS
//
//  Created by zylog on 05/04/17.
//  Copyright © 2017 zsl. All rights reserved.
//

#import "EnterOTPViewController.h"
#import "ChangePasswordViewController.h"

@interface EnterOTPViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelSubTitle1;
@property (nonatomic, weak) IBOutlet UILabel *labelSubTitle2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldOTP;

@property (nonatomic, weak) IBOutlet UIButton *buttonBack;
@property (nonatomic, weak) IBOutlet UIButton *buttonSubmit;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation EnterOTPViewController

@synthesize strUserName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Verification", @"Verification")];
    
    for (id control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)control;
            if(globalShare.myLanguage == ARABIC_LANGUAGE)
                [textField setTextAlignment:NSTextAlignmentRight];
            else
                [textField setTextAlignment:NSTextAlignmentLeft];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionSubmit:(id)sender {
    @try {
        [self.buttonBack setEnabled:NO];
        [self.buttonSubmit setEnabled:NO];
        
        [self.textFieldOTP resignFirstResponder];
        
        NSString *stringOTP = [self.textFieldOTP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *strVals = [NSString stringWithFormat:@"?cust_id=%@&otp=%@", self.strUserName, stringOTP];
        [self verifyOTP:strVals];
        
        return;
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        [self.buttonBack setEnabled:YES];
        [self.buttonSubmit setEnabled:YES];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Common actions

-(void) verifyOTP:(NSString *)strParams {
    //WebAPI/VerifyOTP?cust_id=1000015535&otp=10375
    @try {
        [self.indicatorView setHidden:NO];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"VerifyOTP", strParams];
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
                                                                       ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
                                                                       NSString *strToken = [returnedDict objectForKey:@"result"];
                                                                       changePasswordViewController.strOTPToken = strToken;
                                                                       [[self navigationController] pushViewController:changePasswordViewController animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
