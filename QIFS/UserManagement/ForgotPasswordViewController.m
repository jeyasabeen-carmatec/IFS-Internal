//
//  ForgotPasswordViewController.m
//  QIFS
//
//  Created by zylog on 25/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ChangePasswordViewController.h"
#import "EnterOTPViewController.h"

@interface ForgotPasswordViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUserName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldAccountNo;
@property (nonatomic, weak) IBOutlet UITextField *textFieldMobileNo;
@property (nonatomic, weak) IBOutlet UITextField *textFieldEmail;

@property (nonatomic, weak) IBOutlet UIButton *buttonBack;
@property (nonatomic, weak) IBOutlet UIButton *buttonForgotPassword;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UITextField *textFieldCurrent;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Forgot Password", @"Forgot Password")];
    
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

- (IBAction)actionForgotPassword:(id)sender {
    @try {
        [self.buttonBack setEnabled:NO];
        [self.buttonForgotPassword setEnabled:NO];
        
        [self.textFieldCurrent resignFirstResponder];
        
        NSString *stringUserName    = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringAccountNo   = [self.textFieldAccountNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringMobileNo    = [self.textFieldMobileNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringEmail       = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringUserName length] == 0) {
            [GlobalShare showBasicAlertView:self :USERNAME];
            return;
        } else if([stringAccountNo length] == 0) {
            [GlobalShare showBasicAlertView:self :ACCOUNT_NUMBER];
            return;
        }/* else if([stringAccountNo length] < 10) {
            [GlobalShare showBasicAlertView:self :ACCOUNT_NUMBER_VALID];
            return;
        }*/ else if([stringMobileNo length] == 0) {
            [GlobalShare showBasicAlertView:self :MOBILE_NUMBER];
            return;
        } else if([stringEmail length] == 0) {
            [GlobalShare showBasicAlertView:self :EMAIL];
            return;
        } else if([stringEmail length] == 0) {
            [GlobalShare showBasicAlertView:self :EMAIL_VALID];
            return;
        }
        
        NSString *strVals = [NSString stringWithFormat:@"?cust_id=%@&cust_nin=%@", stringUserName, stringAccountNo];

        [self forgetPassword:strVals];
        return;
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        [self.buttonBack setEnabled:YES];
        [self.buttonForgotPassword setEnabled:YES];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Common actions

-(void) forgetPassword:(NSString *)strParams {
    //ChangePassword?username=<username>&cust_id=<c# number>&cust_nin=<Nin number>&mobile_no=<Regestered Mobile no>
    //WebAPI/ForgetPassword?cust_id=1000015535&cust_nin=47428
    @try {
        [self.indicatorView setHidden:NO];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"ForgetPassword", strParams];
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
//                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       [self showAlertViewAction:FORGOT_PASSWORD_SUCCESS];
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

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textFieldCurrent = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.textFieldAccountNo] || [textField isEqual:self.textFieldMobileNo]) {
        if ([GlobalShare isNumeric:string] || [string isEqualToString:@""]) {
//            if (range.location < 10)
                return YES;
//            else
//                return NO;
        }
        else
            return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - UIAlertController

//- (void)showBasicAlertView:(NSString *)strMessage {
//    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
//    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
//                                                                             message:alertMessage
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction *action)
//                               {
////                                   NSLog(@"OK action");
//                               }];
//    
//    [alertController addAction:okAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}

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
//                                   [self showAlertViewInput:FORGOT_PASSWORD_OTP];
                                   
                                   EnterOTPViewController *enterOTPViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterOTPViewController"];
                                   NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                   enterOTPViewController.strUserName = stringUserName;
                                   [[self navigationController] pushViewController:enterOTPViewController animated:YES];
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertViewInput:(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Text Input Alert");
    NSString *alertMessage = NSLocalizedString(strMessage, @"Plain and secure text input");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter OTP", @"Enter OTP");
         
         if(globalShare.myLanguage == ARABIC_LANGUAGE)
             [textField setTextAlignment:NSTextAlignmentRight];
         else
             [textField setTextAlignment:NSTextAlignmentLeft];

         textField.secureTextEntry = YES;
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {

                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                   UITextField *textOTP     = alertController.textFields.firstObject;
                                   NSString *stringOTP      = [textOTP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                                   NSString *strVals = [NSString stringWithFormat:@"?cust_id=%@&otp=%@", stringUserName, stringOTP];
                                   [self verifyOTP:strVals];

//                                   ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
//                                   [[self navigationController] pushViewController:changePasswordViewController animated:YES];
                               }];
    
    okAction.enabled = NO;
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
    else {
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(UITextField *)sender {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *textOTP = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = textOTP.text.length > 4;
    }
}

@end
