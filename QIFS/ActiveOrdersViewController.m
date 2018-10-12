//
//  ActiveOrdersViewController.m
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ActiveOrdersViewController.h"
#import "NewOrderViewController.h"

@interface ActiveOrdersViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UILabel *labelOrderTitle;
@property (nonatomic, weak) IBOutlet UIButton *buttonModify;
@property (nonatomic, weak) IBOutlet UIButton *buttonCancel;

@end

@implementation ActiveOrdersViewController

@synthesize delegate;
@synthesize strOrderId;
@synthesize securityId;
@synthesize strOrderDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.labelOrderTitle.text = strOrderDetails;
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

#pragma mark - Button actions

- (IBAction)backgroundTapped:(id)sender {
    [self.delegate callBackSuperviewFromNewOrder];
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    } completion:^(BOOL finished) {
        if([self.view superview])
            [self.view removeFromSuperview];
    }];
}

- (IBAction)actionModifyOrder:(id)sender
{
    if([_strOrderType isEqualToString:@"BUY"])
    {
        [globalShare setIsBuytheorder:YES];
    }
    [globalShare setIsmodifyOrder:YES];
    
    
    [self.delegate callBackSuperviewFromNewOrder];
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    } completion:^(BOOL finished) {
        if([self.view superview])
            [self.view removeFromSuperview];
    }];
    

    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
    newOrderViewController.securityId = self.securityId;
    newOrderViewController.strOrderId = self.strOrderId;
    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
    [[GlobalShare sharedInstance] setIsBuyOrder:YES];
    [globalShare.topNavController pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionCancelOrder:(id)sender {
    [self showAlertViewTwoActions:CANCEL_ORDER_CONFIRM];
}

#pragma mark - Common actions

- (void)showAlertViewTwoActions:(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   if (![GlobalShare isConnectedInternet]) {
                                       [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
                                       return;
                                   }

                                   [self cancelOrder];
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

-(void) cancelOrder {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view setUserInteractionEnabled:NO];
        [self.buttonModify setEnabled:NO];
        [self.buttonCancel setEnabled:NO];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"CancelOrder?order_id=", self.strOrderId];
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           [self.view setUserInteractionEnabled:YES];
                                                           [self.buttonModify setEnabled:YES];
                                                           [self.buttonCancel setEnabled:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                              // NSLog(@"Active orders data is:%@",returnedDict);
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
                                                                       [GlobalShare showBasicAlertView:self :CANCEL_ORDER_SUCCESS];

                                                                       [UIView animateWithDuration:.3 animations:^{
                                                                           [self.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                                                                       } completion:^(BOOL finished) {
                                                                           if([self.view superview])
                                                                               [self.view removeFromSuperview];
                                                                       }];
                                                                       [self.delegate callBackSuperviewFromNewOrder];
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
