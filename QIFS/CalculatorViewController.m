//
//  CalculatorViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIView *viewBuy1;
@property (nonatomic, weak) IBOutlet UIView *viewBuy2;
@property (nonatomic, weak) IBOutlet UIView *viewSell1;
@property (nonatomic, weak) IBOutlet UIView *viewSell2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuyCash1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuySharePrice1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuyNoOfShares1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuyNoOfShares2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuySharePrice2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBuyCash2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellCash1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellSharePrice1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellNoOfShares1;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellNoOfShares2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellSharePrice2;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSellCash2;
@property (nonatomic, strong) UITextField *textFieldCurrent;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentMenu;
@property (nonatomic, strong) UIButton *backgroundTapButton;

@property (nonatomic, weak) IBOutlet UILabel *labelBuyCash1;
@property (nonatomic, weak) IBOutlet UILabel *labelBuySharePrice1;
@property (nonatomic, weak) IBOutlet UILabel *labelBuyNoOfShares1;
@property (nonatomic, weak) IBOutlet UILabel *labelBuyNoOfShares2;
@property (nonatomic, weak) IBOutlet UILabel *labelBuySharePrice2;
@property (nonatomic, weak) IBOutlet UILabel *labelBuyCash2;
@property (nonatomic, weak) IBOutlet UILabel *labelSellCash1;
@property (nonatomic, weak) IBOutlet UILabel *labelSellSharePrice1;
@property (nonatomic, weak) IBOutlet UILabel *labelSellNoOfShares1;
@property (nonatomic, weak) IBOutlet UILabel *labelSellNoOfShares2;
@property (nonatomic, weak) IBOutlet UILabel *labelSellSharePrice2;
@property (nonatomic, weak) IBOutlet UILabel *labelSellCash2;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [[GlobalShare sharedInstance] setIsConfirmOrder:YES];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:NO];
    [self.labelTitle setText:NSLocalizedString(@"Calculator", @"Calculator")];

    _viewBuy1.layer.borderWidth = 1.0;
    _viewBuy1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewBuy1.layer.cornerRadius = 3;
    _viewBuy1.layer.masksToBounds = YES;
    _viewBuy2.layer.borderWidth = 1.0;
    _viewBuy2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewBuy2.layer.cornerRadius = 3;
    _viewBuy2.layer.masksToBounds = YES;

    _viewSell1.layer.borderWidth = 1.0;
    _viewSell1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewSell1.layer.cornerRadius = 3;
    _viewSell1.layer.masksToBounds = YES;
    _viewSell2.layer.borderWidth = 1.0;
    _viewSell2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewSell2.layer.cornerRadius = 3;
    _viewSell2.layer.masksToBounds = YES;
    
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        [self.labelBuyCash1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBuySharePrice1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBuyNoOfShares1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBuyNoOfShares2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBuySharePrice2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBuyCash2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellCash1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellSharePrice1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellNoOfShares1 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellNoOfShares2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellSharePrice2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSellCash2 setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
        [self.labelBuyCash1 setTextAlignment:NSTextAlignmentRight];
        [self.labelBuySharePrice1 setTextAlignment:NSTextAlignmentRight];
        [self.labelBuyNoOfShares1 setTextAlignment:NSTextAlignmentRight];
        [self.labelBuyNoOfShares2 setTextAlignment:NSTextAlignmentRight];
        [self.labelBuySharePrice2 setTextAlignment:NSTextAlignmentRight];
        [self.labelBuyCash2 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellCash1 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellSharePrice1 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellNoOfShares1 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellNoOfShares2 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellSharePrice2 setTextAlignment:NSTextAlignmentRight];
        [self.labelSellCash2 setTextAlignment:NSTextAlignmentRight];
    }
    
     [self performSelector:@selector(getCashPosition) withObject:nil afterDelay:0.01f];
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

- (IBAction)actionBack:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [self.backgroundTapButton removeFromSuperview];
    self.backgroundTapButton = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    switch (self.segmentMenu.selectedSegmentIndex) {
        case 0:
            [_viewBuy1 setHidden:NO];
            [_viewBuy2 setHidden:NO];
            [_viewSell1 setHidden:YES];
            [_viewSell2 setHidden:YES];
            
           // self.textFieldBuyCash1.text = @"";
            self.textFieldBuySharePrice1.text = @"";
            self.textFieldBuyNoOfShares1.text = @"";
            
            self.textFieldBuyNoOfShares2.text = @"";
            self.textFieldBuySharePrice2.text = @"";
            self.textFieldBuyCash2.text = @"";
            
            break;
        case 1:
            [_viewBuy1 setHidden:YES];
            [_viewBuy2 setHidden:YES];
            [_viewSell1 setHidden:NO];
            [_viewSell2 setHidden:NO];
            
            self.textFieldSellNoOfShares1.text = @"";
            self.textFieldSellSharePrice1.text = @"";
            self.textFieldSellCash1.text = @"";
            
          //  self.textFieldSellCash2.text = @"";
            self.textFieldSellSharePrice2.text = @"";
            self.textFieldSellNoOfShares2.text = @"";
            
            break;
        default:
            break;
    }
}

- (IBAction)actionCalculateBuyShares:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    double buyCash1 = 0, buySharePrice1 = 0, commission = 0, commissionVal = 0;
    int buyNoOfShares1 = 0;
    buyCash1 = [[self.textFieldBuyCash1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    buySharePrice1 = [[self.textFieldBuySharePrice1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    
//    NSString *strBuyCash1 = [self.textFieldBuyCash1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strBuySharePrice1 = [self.textFieldBuySharePrice1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([strBuyCash1 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_CASH];
//        return;
//    } else if(([strBuyCash1 hasPrefix:@"."] && [strBuyCash1 hasSuffix:@"."]) || ([strBuyCash1 hasPrefix:@"."] || [strBuyCash1 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDCASH];
//        return;
//    } else if([strBuySharePrice1 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARE];
//        return;
//    } else if(([strBuySharePrice1 hasPrefix:@"."] && [strBuySharePrice1 hasSuffix:@"."]) || ([strBuySharePrice1 hasPrefix:@"."] || [strBuySharePrice1 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDSHARE];
//        return;
//    }
    
    commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
    commissionVal = buyCash1 * commission;
    if(commissionVal < 30) commissionVal = 30.0;
    buyCash1 = buyCash1 - commissionVal;
    buyNoOfShares1 = buyCash1 / buySharePrice1;

    self.textFieldBuyNoOfShares1.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%d", buyNoOfShares1]];
}

- (IBAction)actionCalculateBuyCash:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    double buyNoOfShares2 = 0, buySharePrice2 = 0, buyCash2 = 0, commission = 0, commissionVal = 0, orderCommissionVal = 0;
    buyNoOfShares2 = [[self.textFieldBuyNoOfShares2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    buySharePrice2 = [[self.textFieldBuySharePrice2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    
//    NSString *strBuyNoOfShares2 = [self.textFieldBuyNoOfShares2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strBuySharePrice2 = [self.textFieldBuySharePrice2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([strBuyNoOfShares2 integerValue] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARES];
//        return;
//    } else if([strBuySharePrice2 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARE];
//        return;
//    } else if(([strBuySharePrice2 hasPrefix:@"."] && [strBuySharePrice2 hasSuffix:@"."]) || ([strBuySharePrice2 hasPrefix:@"."] || [strBuySharePrice2 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDSHARE];
//        return;
//    }

    commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
    buyCash2 = buyNoOfShares2 * buySharePrice2;
    commissionVal = buyNoOfShares2 * buySharePrice2 * commission;
    if(commissionVal < 30) commissionVal = 30.0;
    orderCommissionVal = buyCash2 + commissionVal;

    self.textFieldBuyCash2.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
}

- (IBAction)actionCalculateSellCash:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    double sellNoOfShares1 = 0, sellSharePrice1 = 0, sellCash1 = 0, commission = 0, commissionVal = 0, orderCommissionVal = 0;
    sellNoOfShares1 = [[self.textFieldSellNoOfShares1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    sellSharePrice1 = [[self.textFieldSellSharePrice1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    
//    NSString *strSellNoOfShares1 = [self.textFieldSellNoOfShares1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strSellSharePrice1 = [self.textFieldSellSharePrice1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([strSellNoOfShares1 integerValue] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARES];
//        return;
//    } else if([strSellSharePrice1 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARE];
//        return;
//    } else if(([strSellSharePrice1 hasPrefix:@"."] && [strSellSharePrice1 hasSuffix:@"."]) || ([strSellSharePrice1 hasPrefix:@"."] || [strSellSharePrice1 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDSHARE];
//        return;
//    }

    commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
    sellCash1 = sellNoOfShares1 * sellSharePrice1;
    commissionVal = sellNoOfShares1 * sellSharePrice1 * commission;
    if(commissionVal < 30) commissionVal = 30.0;
    orderCommissionVal = sellCash1 - commissionVal;
    
    self.textFieldSellCash1.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%.2f", orderCommissionVal]];
}

- (IBAction)actionCalculateSellShares:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    double sellCash2 = 0, sellSharePrice2 = 0,  commission = 0, commissionVal = 0;
    int sellNoOfShares2 = 0;
    sellCash2 = [[self.textFieldSellCash2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    sellSharePrice2 = [[self.textFieldSellSharePrice2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    
//    NSString *strSellCash2 = [self.textFieldSellCash2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *strSellSharePrice2 = [self.textFieldSellSharePrice2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([strSellCash2 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_CASH];
//        return;
//    } else if(([strSellCash2 hasPrefix:@"."] && [strSellCash2 hasSuffix:@"."]) || ([strSellCash2 hasPrefix:@"."] || [strSellCash2 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDCASH];
//        return;
//    } else if([strSellSharePrice2 length] == 0) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_SHARE];
//        return;
//    } else if(([strSellSharePrice2 hasPrefix:@"."] && [strSellSharePrice2 hasSuffix:@"."]) || ([strSellSharePrice2 hasPrefix:@"."] || [strSellSharePrice2 hasSuffix:@"."])) {
//        [GlobalShare showBasicAlertView:self :CALCULATOR_VALIDSHARE];
//        return;
//    }

    commission = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IFS_Commission"] doubleValue];
    commissionVal = sellCash2 * commission;
    if(commissionVal < 30) commissionVal = 30.0;
    sellCash2 = sellCash2 + commissionVal;
    sellNoOfShares2 = sellCash2 / sellSharePrice2;

    self.textFieldSellNoOfShares2.text = [GlobalShare createCommaSeparatedString:[NSString stringWithFormat:@"%d", sellNoOfShares2]];
}

- (void)backgroundTapped:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [self.backgroundTapButton removeFromSuperview];
    self.backgroundTapButton = nil;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textFieldCurrent = textField;
//    if ([textField isEqual:_textFieldBuyNoOfShares2] || [textField isEqual:_textFieldBuySharePrice2] || [textField isEqual:_textFieldBuyCash2] || [textField isEqual:_textFieldSellCash2] || [textField isEqual:_textFieldSellSharePrice2] || [textField isEqual:_textFieldSellNoOfShares2]) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        
//        if ([textField isEqual:_textFieldBuyNoOfShares2] || [textField isEqual:_textFieldSellCash2])
//            self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :50];
//        else if ([textField isEqual:_textFieldBuySharePrice2] || [textField isEqual:_textFieldSellSharePrice2])
//            self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :100];
//        else
//            self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :150];
//        
//        [UIView commitAnimations];
//    }
    
    self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backgroundTapButton.backgroundColor = [UIColor lightGrayColor];
    _backgroundTapButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-216);
    [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundTapButton];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if ([textField isEqual:_textFieldBuyNoOfShares2] || [textField isEqual:_textFieldBuySharePrice2] || [textField isEqual:_textFieldBuyCash2] || [textField isEqual:_textFieldSellCash2] || [textField isEqual:_textFieldSellSharePrice2] || [textField isEqual:_textFieldSellNoOfShares2]) {
//        [UIView setAnimationDuration:0.3];
//        
//        if ([textField isEqual:_textFieldBuyNoOfShares2] || [textField isEqual:_textFieldSellCash2])
//            self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :50];
//        else if ([textField isEqual:_textFieldBuySharePrice2] || [textField isEqual:_textFieldSellSharePrice2])
//            self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :100];
//        else
//            self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :150];
//        
//        [UIView commitAnimations];
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_textFieldBuyNoOfShares2] || [textField isEqual:_textFieldSellNoOfShares1]) {
        if ([GlobalShare isNumeric:string] || [string isEqualToString:@""]) {
            return YES;
        }
        else
            return NO;
    }
    else {
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
                                                               NSLog(@"%@",returnedDict);
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
                                                                       
                                                                    if([globalShare ismodifyOrder] == true )
                                                                    {
                                                                        NSString *str_order_val = [[NSUserDefaults standardUserDefaults] valueForKey:@"modified_order_VAL"];
                                                                        
                                                                        self.textFieldBuyCash1.text = [NSString stringWithFormat:@"%.2f", [str_order_val floatValue]];
                                                                        
                                                                        self.textFieldBuyCash1.text = [GlobalShare checkingNullValues:self.textFieldBuyCash1.text];
                                                                        
                                                                        self.textFieldSellCash2.text = [NSString stringWithFormat:@"%.2f", [str_order_val floatValue]];
                                                                        
                                                                         self.textFieldSellCash2.text = [GlobalShare checkingNullValues:self.textFieldSellCash2.text];
//                                                                        [globalShare setIsmodifyOrder:false];
                                                                    }
                                                                    else{
                                                                        self.textFieldBuyCash1.text = [NSString stringWithFormat:@"%.2f", [dictVal[@"Current_Balance"]floatValue]];
                                                                        
                                                                        self.textFieldBuyCash1.text = [GlobalShare checkingNullValues:self.textFieldBuyCash1.text];
                                                                        
                                                                        self.textFieldSellCash2.text = [NSString stringWithFormat:@"%.2f", [dictVal[@"Current_Balance"] floatValue]];
                                                                        
                                                                          self.textFieldSellCash2.text = [GlobalShare checkingNullValues:self.textFieldSellCash2.text];
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
@end
