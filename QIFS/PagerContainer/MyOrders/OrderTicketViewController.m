//
//  OrderTicketViewController.m
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "OrderTicketViewController.h"
#import "OrderTicketCell.h"
#import "OrderTicketStaticCell.h"

@interface OrderTicketViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewTicket;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *arrayTicket;
@property (nonatomic, strong) NSDictionary *dictTicket;

@property (nonatomic, weak) IBOutlet UILabel *labelOrderTitle;
//@property (nonatomic, weak) IBOutlet UILabel *labelOrderId;
//@property (nonatomic, weak) IBOutlet UILabel *labelAvgPrice;
//@property (nonatomic, weak) IBOutlet UILabel *labelTotalQty;
@property (nonatomic, weak) IBOutlet UILabel *labelOrderValue;

@end

@implementation OrderTicketViewController

@synthesize delegate;
@synthesize strOrderId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    self.tableViewTicket.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    self.arrayTicket = @[
//                         @{
//                             @"TicketID": @"5646446",
//                             @"Price": @"566.67",
//                             @"Qty": @"54,340",
//                             @"Date": @"20-07-2016 10:32:54"
//                             },
//                         @{
//                             @"TicketID": @"2786996",
//                             @"Price": @"566.67",
//                             @"Qty": @"25,340",
//                             @"Date": @"21-07-2016 09:87:54"
//                             },
//                         @{
//                             @"TicketID": @"2786996",
//                             @"Price": @"566.67",
//                             @"Qty": @"25,340",
//                             @"Date": @"21-07-2016 09:87:54"
//                             },
//                         @{
//                             @"TicketID": @"2786996",
//                             @"Price": @"566.67",
//                             @"Qty": @"25,340",
//                             @"Date": @"21-07-2016 09:87:54"
//                             },
//                         @{
//                             @"TicketID": @"2786996",
//                             @"Price": @"566.67",
//                             @"Qty": @"25,340",
//                             @"Date": @"21-07-2016 09:87:54"
//                             }
//                         ];
    
    if (![GlobalShare isConnectedInternet]) {
        [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
        return;
    }
    [self performSelector:@selector(getOrderTicketDetails) withObject:nil afterDelay:0.01f];
    [self clearOrderTicketDetails];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.labelOrderValue setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.labelOrderValue setTextAlignment:NSTextAlignmentRight];
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
    [self.delegate callBackSuperviewFromOrder];
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    } completion:^(BOOL finished) {
        if([self.view superview])
            [self.view removeFromSuperview];
    }];
}

#pragma mark - Common actions

-(void) getOrderTicketDetails {
    @try {
        [self.indicatorView setHidden:NO];
        [self.view bringSubviewToFront:self.indicatorView];
        
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
//        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetOrderTicketDetails?order_id=", @"20150921-614351"];
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@", REQUEST_URL, @"GetOrderTicketDetails?order_id=", self.strOrderId];
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
                                                                       self.dictTicket = returnedDict[@"result"];
                                                                       
//                                                                       self.arrayTicket = self.dictTicket[@"Tickets"];
                                                                       
                                                                       self.labelOrderTitle.text = [NSString stringWithFormat:@"%@ %@", (globalShare.myLanguage != ARABIC_LANGUAGE) ? self.dictTicket[@"order_type_en"] : self.dictTicket[@"order_type_ar"], [self.dictTicket[@"security_id"] componentsSeparatedByString:@"."][1]];
                                                                       self.labelOrderValue.text = [NSString stringWithFormat:@"%@ QR", [GlobalShare createCommaSeparatedTwoDigitString:self.dictTicket[@"total_order_value"]]];
                                                                       
                                                                       [self.tableViewTicket reloadData];
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

-(void) clearOrderTicketDetails {
    self.labelOrderTitle.text = @"";
    self.labelOrderValue.text = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    else     return [self.dictTicket[@"Tickets"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) return 138;
    else     return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        static NSString *CellIdentifier = @"OrderTicketStaticCell";
        OrderTicketStaticCell *cell = (OrderTicketStaticCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderTicketStaticCell" owner:nil options:nil];
            cell = [nibObjects objectAtIndex:0];
        }
        
        cell.labelOrderID.text = self.dictTicket[@"orderId"];
        cell.labelAvgPrice.text = [GlobalShare formatStringToTwoDigits:self.dictTicket[@"avg_price"]];
        cell.labelTotalQty.text = [GlobalShare createCommaSeparatedString:self.dictTicket[@"total_qty"]];
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelPriceCaption setTextAlignment:NSTextAlignmentLeft];
            
            [cell.labelOrderID setTextAlignment:NSTextAlignmentLeft];
            [cell.labelAvgPrice setTextAlignment:NSTextAlignmentLeft];
            [cell.labelTotalQty setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelPriceCaption setTextAlignment:NSTextAlignmentRight];
            
            [cell.labelOrderID setTextAlignment:NSTextAlignmentRight];
            [cell.labelAvgPrice setTextAlignment:NSTextAlignmentRight];
            [cell.labelTotalQty setTextAlignment:NSTextAlignmentRight];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"OrderTicketCell";
        OrderTicketCell *cell = (OrderTicketCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderTicketCell" owner:nil options:nil];
            cell = [nibObjects objectAtIndex:0];
        }
        
        NSDictionary *def = self.dictTicket[@"Tickets"][indexPath.row];
        
        cell.labelTickedID.text = def[@"ticket_id"];
        cell.labelPrice.text = [GlobalShare formatStringToTwoDigits:def[@"ticket_price"]];
        cell.labelQty.text = [GlobalShare createCommaSeparatedString:def[@"ticket_qty"]];
        cell.labelDate.text = def[@"ticket_date"];
        
        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
            [cell.labelPrice setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.labelPrice setTextAlignment:NSTextAlignmentRight];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //    if(indexPath.row % 2 == 0)
        //        cell.backgroundColor = [UIColor whiteColor];
        //    else
        //        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        
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

@end
