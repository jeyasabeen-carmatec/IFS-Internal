//
//  ChangePasswordViewController.m
//  QIFS
//
//  Created by zylog on 25/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldNewPassword;
@property (nonatomic, weak) IBOutlet UITextField *textFieldConfirmPassword;

@property (nonatomic, weak) IBOutlet UIButton *buttonSubmit;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation ChangePasswordViewController

@synthesize strOTPToken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Change Password", @"Change Password")];
    
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
        [self.buttonSubmit setEnabled:NO];
        
        [self.textFieldNewPassword resignFirstResponder];
        [self.textFieldConfirmPassword resignFirstResponder];
        
        NSString *stringNewPassword     = [self.textFieldNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringConfirmPassword = [self.textFieldConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringNewPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :CHANGE_NEW_PASSWORD];
            return;
        } else if([stringNewPassword length] < 6) {
            [GlobalShare showBasicAlertView:self :PASSWORD_VALID];
            return;
        } else if([stringConfirmPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :CHANGE_CONFIRM_PASSWORD];
            return;
        } else if(![stringNewPassword isEqualToString:stringConfirmPassword]) {
            [GlobalShare showBasicAlertView:self :CHANGE_PASSWORD_MISMATCH];
            return;
        }
        
        NSString *strVals = [NSString stringWithFormat:@"?newPassword=%@", stringNewPassword];
        
        [self changePassword:strVals];
        return;
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        [self.buttonSubmit setEnabled:YES];
    }
}

#pragma mark - Common actions

-(void) changePassword:(NSString *)strParams {
    //ChangePassword?newPassword=<New password here>
    @try {
        [self.indicatorView setHidden:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", strOTPToken];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"ChangePassword", strParams];
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
                                                                       [self showAlertViewAction:CHANGE_PASSWORD_SUCCESS];
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
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
