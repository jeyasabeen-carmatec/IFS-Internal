//
//  ViewController.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"

@implementation UIView (ShakeAnimation)

- (void)triggerShakeAnimation {
    const int MAX_SHAKES = 6;
    const CGFloat SHAKE_DURATION = 0.05;
    const CGFloat SHAKE_TRANSFORM = 4;
    
    CGFloat direction = 1;
    
    for (int i = 0; i <= MAX_SHAKES; i++) {
        [UIView animateWithDuration:SHAKE_DURATION
                              delay:SHAKE_DURATION * i
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             if (i >= MAX_SHAKES) {
                                 self.transform = CGAffineTransformIdentity;
                             } else {
                                 self.transform = CGAffineTransformMakeTranslation(SHAKE_TRANSFORM * direction, 0);
                             }
                         } completion:nil];
        
        direction *= -1;
    }
}

@end

@interface ViewController () <NSURLSessionDelegate, UITabBarControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUserName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UIButton *buttonLogin;
@property (nonatomic, weak) IBOutlet UIButton *buttonForgotPassword;
@property (nonatomic, weak) IBOutlet UIButton *buttonNewUser;

@property (nonatomic, strong) UITextField *textFieldCurrent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Login", @"Login")];

//    [txtUserName triggerShakeAnimation];
    
    globalShare.topNavController = self.navigationController;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.textFieldUserName setText:@"1000015535"];
//    [self.textFieldPassword setText:@"123456"];
    [self.textFieldUserName setText:@"1000000321"];
    [self.textFieldPassword setText:@"ssc@123"];
    [[GlobalShare sharedInstance] setIsErrorPupup:NO];
    [[GlobalShare sharedInstance] setIsTimerStockListRun:NO];
    [[GlobalShare sharedInstance] setIsTimerPortfolioRun:NO];
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:NO];
    [[GlobalShare sharedInstance] setIsTimerGainLossRun:NO];
    [[GlobalShare sharedInstance] setIsTimerActiveRun:NO];
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:NO];
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:NO];
    
    if ([globalShare.timerStockList isValid]) {
        [globalShare.timerStockList invalidate];
        globalShare.timerStockList = nil;
    }
    if ([globalShare.timerPortfolio isValid]) {
        [globalShare.timerPortfolio invalidate];
        globalShare.timerPortfolio = nil;
    }
    if ([globalShare.timerNewOrder isValid]) {
        [globalShare.timerNewOrder invalidate];
        globalShare.timerNewOrder = nil;
    }
    if ([globalShare.timerGainLoss isValid]) {
        [globalShare.timerGainLoss invalidate];
        globalShare.timerGainLoss = nil;
    }
    if ([globalShare.timerActive isValid]) {
        [globalShare.timerActive invalidate];
        globalShare.timerActive = nil;
    }
    if ([globalShare.timerFavorites isValid]) {
        [globalShare.timerFavorites invalidate];
        globalShare.timerFavorites = nil;
    }
    if ([globalShare.timerMarketDepth isValid]) {
        [globalShare.timerMarketDepth invalidate];
        globalShare.timerMarketDepth = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if(globalShare.dictValues == nil)
        globalShare.dictValues = [[NSMutableDictionary alloc] init];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
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
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (BOOL)canAutoRotate
{
    return NO;
}

- (IBAction)actionLogin:(id)sender {
    @try {
//        [self toDisableControls];

        [self.textFieldUserName resignFirstResponder];
        [self.textFieldPassword resignFirstResponder];
        
        NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringPassword = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        [self verifyUserLogin];

//        UITabBarController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockTabBarController"];
//        [[self navigationController] pushViewController:tabController animated:YES];
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
//        [self toEnableControls];
    }
}

- (IBAction)actionForgotPassword:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [[self navigationController] pushViewController:forgotPasswordViewController animated:YES];
}

- (IBAction)actionNewUser:(id)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [[self navigationController] pushViewController:registerViewController animated:YES];
}

#pragma mark - Common actions

-(void) toEnableControls {
    [self.buttonLogin setEnabled:YES];
    [self.buttonForgotPassword setEnabled:YES];
    [self.buttonNewUser setEnabled:YES];
}

-(void) toDisableControls {
    [self.buttonLogin setEnabled:NO];
    [self.buttonForgotPassword setEnabled:NO];
    [self.buttonNewUser setEnabled:NO];
}

-(void) verifyUserLogin {
    @try {
    [self.indicatorView setHidden:NO];
    [self toDisableControls];

    NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringPassword = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@SetCredentials?username=%@&password=%@", REQUEST_URL, stringUserName, stringPassword];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        [self.indicatorView setHidden:YES];
                                                        [self toEnableControls];

                                                        if(error == nil)
                                                        {
//                                                            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                            NSLog(@"Data = %@",text);
                                                           
                                                            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            if([[returnedDict objectForKey:@"status"] hasPrefix:@"error"]) {
                                                                if([[returnedDict objectForKey:@"result"] hasPrefix:@"T4"])
                                                                    [GlobalShare showBasicAlertView:self :INVALID_HEADER];
                                                                else
                                                                    [GlobalShare showBasicAlertView:self :[returnedDict objectForKey:@"result"]];
                                                                return;
                                                            }
                                                            NSString *strToken = [returnedDict objectForKey:@"result"];
//                                                            NSString *strToken = @"1234567890";
                                                            [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:@"ssckey"];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];

                                                            UITabBarController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockTabBarController"];
                                                            tabController.delegate = self;
                                                            [[self navigationController] pushViewController:tabController animated:YES];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[GlobalShare sharedInstance] setIsConfirmOrder:NO];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:YES];
    return YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.buttonForgotPassword setEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.buttonForgotPassword setEnabled:NO];
    self.textFieldCurrent = textField;
//    if ([textField isEqual:self.textFieldPassword])  {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :75];
//        [UIView commitAnimations];
//    }
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        // move to the left side of some containing view
//        textField.center = CGPointMake(self.view.frame.origin.x + textField.frame.size.width/2, textField.center.y);
//    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self.buttonForgotPassword setEnabled:YES];
//    if ([textField isEqual:self.textFieldPassword])  {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :75];
//        [UIView commitAnimations];
//    }
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        // move to the center of containing view
//        textField.center = CGPointMake(self.view.frame.size.width/2, textField.center.y);
//    }];
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

#pragma mark - UIAlertController

//- (void)showBasicAlertView:(NSString *)strMessage {
//    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
//    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
//                                                                             message:alertMessage
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
////    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
////                                                           style:UIAlertActionStyleCancel
////                                                         handler:^(UIAlertAction *action)
////                                   {
////                                       NSLog(@"Cancel action");
////                                   }];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction *action)
//                               {
//
//                               }];
//    
//    [alertController addAction:okAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}

@end
