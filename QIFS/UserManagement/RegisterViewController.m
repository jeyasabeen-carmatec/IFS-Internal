//
//  RegisterViewController.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "RegisterViewController.h"
#import "GlobalShare.h"
#import "PropertyList.h"

@interface RegisterViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldAccountNo;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUserName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, weak) IBOutlet UITextField *textFieldRePassword;
@property (nonatomic, weak) IBOutlet UITextField *textFieldFirstName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldLastName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldMobileNo;
@property (nonatomic, weak) IBOutlet UITextField *textFieldEmail;

@property (nonatomic, weak) IBOutlet UISwitch *switchEnglish;
@property (nonatomic, weak) IBOutlet UISwitch *switchArabic;

@property (nonatomic, weak) IBOutlet UIButton *buttonBack;
@property (nonatomic, weak) IBOutlet UIButton *buttonRegister;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UITextField *textFieldCurrent;

@end

@implementation RegisterViewController

@synthesize textFieldAccountNo;
@synthesize textFieldUserName;
@synthesize textFieldPassword;
@synthesize textFieldRePassword;
@synthesize textFieldFirstName;
@synthesize textFieldLastName;
@synthesize textFieldMobileNo;
@synthesize textFieldEmail;

@synthesize switchEnglish;
@synthesize switchArabic;

@synthesize buttonBack;
@synthesize buttonRegister;

@synthesize textFieldCurrent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.labelTitle setText:NSLocalizedString(@"Registration", @"Registration")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionRegister:(id)sender {
    @try {
        [buttonBack setEnabled:NO];
        [buttonRegister setEnabled:NO];
        
        [textFieldCurrent resignFirstResponder];
        
        NSString *stringAccountNo   = [textFieldAccountNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringUserName    = [textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringPassword    = [textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringRePassword  = [textFieldRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringFirstName   = [textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringLastName    = [textFieldLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringMobileNo    = [textFieldMobileNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringEmail       = [textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringAccountNo length] == 0) {
            [GlobalShare showBasicAlertView:self :ACCOUNT_NUMBER];
            return;
        } else if([stringAccountNo length] < 10) {
            [GlobalShare showBasicAlertView:self :ACCOUNT_NUMBER_VALID];
            return;
        } else if([stringUserName length] == 0) {
            [GlobalShare showBasicAlertView:self :USERNAME];
            return;
        } else if([stringPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :PASSWORD];
            return;
        } else if([stringPassword length] < 6) {
            [GlobalShare showBasicAlertView:self :PASSWORD_VALID];
            return;
        } else if([stringRePassword length] == 0) {
            [GlobalShare showBasicAlertView:self :REPASSWORD];
            return;
        } else if(![stringPassword isEqualToString:stringRePassword]) {
            [GlobalShare showBasicAlertView:self :REPASSWORD_MISMATCH];
            return;
        } else if([stringFirstName length] == 0) {
            [GlobalShare showBasicAlertView:self :FIRSTNAME];
            return;
        } else if([stringLastName length] == 0) {
            [GlobalShare showBasicAlertView:self :LASTNAME];
            return;
        } else if([stringMobileNo length] == 0) {
            [GlobalShare showBasicAlertView:self :MOBILE_NUMBER];
            return;
        } else if([stringEmail length] == 0) {
            [GlobalShare showBasicAlertView:self :EMAIL];
            return;
        } else if([stringEmail length] == 0) {
            [GlobalShare showBasicAlertView:self :EMAIL_VALID];
            return;
        }
        
        NSString *strVals = [NSString stringWithFormat:@"?username=%@&user_full_name=%@ %@&cust_id=%@&cust_nin=%@&mobile_no=%@", stringUserName, stringFirstName, stringLastName, stringAccountNo, stringAccountNo, stringMobileNo];

        [self showAlertViewTwoActions:REGISTER_TERMS :strVals];
        return;
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        [buttonBack setEnabled:YES];
        [buttonRegister setEnabled:YES];
    }
}

- (IBAction)actionBack:(id)sender {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromTop;
//    
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController popToRootViewControllerAnimated:NO];
    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [[self navigationController] popViewControllerAnimated:NO];
    
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController popToRootViewControllerAnimated:YES];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//                     }];
    
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:0.45f];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromRight];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [self.navigationController.view.layer addAnimation:animation forKey:@""];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)switchEnglishLanguage:(id)sender {
    [switchArabic setOn:!switchEnglish.on animated:YES];
}

- (IBAction)switchArabicLanguage:(id)sender {
    [switchEnglish setOn:!switchArabic.on animated:YES];
}

#pragma mark - Common actions

-(void) createNewUser:(NSString *)strParams {
    //CreateNewUser?username=<username>&user_full_name=<user full name>&cust_id=<c# number>&cust_nin=<Nin number>&mobile_no=<cust mobile no>
    @try {
        [self.indicatorView setHidden:NO];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"CreateNewUser", strParams];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               if([returnedDict[@"status"] hasPrefix:@"error"]) {
                                                                    [GlobalShare showBasicAlertView:self :returnedDict[@"result"]];
                                                                    return;
                                                               }
                                                               if([returnedDict[@"status"] isEqualToString:@"authenticated"]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                                       NSDictionary *dictVal = returnedDict[@"result"];
                                                                       [self showAlertViewAction:REGISTER_SUCCESS];
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
    if ([textField isEqual:textFieldLastName] || [textField isEqual:textFieldMobileNo] || [textField isEqual:textFieldEmail]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        if ([textField isEqual:textFieldEmail])
            self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :150];
        else
            self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :75];

        [UIView commitAnimations];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:textFieldLastName] || [textField isEqual:textFieldMobileNo] || [textField isEqual:textFieldEmail])  {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        if ([textField isEqual:textFieldEmail])
            self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :150];
        else
            self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :75];
        [UIView commitAnimations];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:textFieldAccountNo]) {
        if ([GlobalShare isNumeric:string] || [string isEqualToString:@""]) {
            if (range.location < 10)
                return YES;
            else
                return NO;
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
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertViewTwoActions:(NSString *)strMessage :(NSString *)strParams {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Disagree", @"Disagree")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {

                               }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Agree", @"Agree")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
//                                   [self showAlertViewAction:REGISTER_SUCCESS];
                                   [self createNewUser:strParams];
                               }];
    
//    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//    }
//    else {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
//    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
