//
//  PopoverViewController.m
//  QIFS
//
//  Created by zylog on 30/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "PopoverViewController.h"
#import "RegisterViewController.h"
#import "GlobalShare.h"
#import "CompanyStocksViewController.h"
#import "NewOrderViewController.h"
#import "AddAlertViewController.h"

@interface PopoverViewController ()<NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UIButton *buttonFavTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgFavorites;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation PopoverViewController

@synthesize securityId;
@synthesize securityName;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor darkGrayColor].CGColor,
                        (id)[UIColor blackColor].CGColor];
//    [self.view.layer addSublayer:gradient];
//    self.view.layer.mask = gradient;
    
    for (id control in self.view.subviews) {
        if ([control isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)control;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.view bringSubviewToFront:btn];
        }
        if ([control isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *)control;
            [self.view bringSubviewToFront:imgView];
        }
        if ([control isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)control;
            [self.view bringSubviewToFront:label];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"]) {
    }
    else
    {
    [self favouritesList];
    }
    NSLog(@"%@",globalShare.favouritesArray);
    
    
    
   /* NSString *strIsFavorite;
    NSString *strQuery = [NSString stringWithFormat:@"select is_checked from tbl_SecurityList where ticker = '%@'", self.securityId];
    globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:strQuery];
    if ([globalShare.fmRSObject next]) {
        strIsFavorite = [globalShare.fmRSObject stringForColumn:@"is_checked"];
    }
    [globalShare.fmRSObject close];
    
    if ([strIsFavorite boolValue]) {
        [self.buttonFavTitle setTitle:NSLocalizedString(@"Unfavorite", @"Unfavorite") forState:UIControlStateNormal];
        [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_unfavorite"]];
    }
    else {
        [self.buttonFavTitle setTitle:NSLocalizedString(@"Favorite", @"Favorite") forState:UIControlStateNormal];
        [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_favorite"]];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionStockDetails:(id)sender {
//    [GlobalShare loadViewContainer:0 :globalShare.topNavController];
    CompanyStocksViewController *companyStocksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyStocksViewController"];
    companyStocksViewController.securityId = self.securityId;
    companyStocksViewController.securityName = self.securityName;
    [globalShare.topNavController pushViewController:companyStocksViewController animated:YES];
}

- (IBAction)actionSetAlert:(id)sender {
    AddAlertViewController *addAlertViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAlertViewController"];
    [globalShare.topNavController presentViewController:addAlertViewController animated:YES completion:nil];
}

- (IBAction)actionLatestNews:(id)sender {
    
    NSString *str;
    //https://www.islamicbroker.com.qa/
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        // str = [NSString stringWithFormat:@"https://www.islamicbroker.com.qa/ar/stories/c/3/0/%D8%A3%D9%87 %D9%85-%D8%A7%D9%84%D8%A3%D8%AE%D8%A8%D8%A7%D8%B1"];
        str = [NSString stringWithFormat:@"%@%@",webSite_Url,@"ar/stories/c/3/0/%D8%A3%D9%87%D9%85-%D8%A7%D9%84%D8%A3%D8%AE%D8%A8%D8%A7%D8%B1"];
    }
    else{
        //str= @"https://www.islamicbroker.com.qa/en/stories/c/3/0/News";
        str = [NSString stringWithFormat:@"%@en/stories/c/3/0/News",webSite_Url];
    }
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
   // [self.segmentMenu setSelectedSegmentIndex:0];
//    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
//    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
//    [globalShare.topNavController pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionNewOrder:(id)sender {
    globalShare.strNewOrderFlow = @"PopoverViewController";
    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
    newOrderViewController.securityId = self.securityId;
    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
    [globalShare.topNavController pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionFavorites:(id)sender
{
    NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
    if (strToken == nil || [strToken isEqualToString:@"(null)"])
    {
        
    }
    else
    {
    NSString *strIsFavorite;
    if([self.buttonFavTitle.currentTitle isEqualToString:NSLocalizedString(@"Favorite", @"Favorite")]) {
        strIsFavorite = @"YES";
        [self favouritesAdd];

    }
    else {
        strIsFavorite = @"NO";
        [self favouritesRemove];
    }
    }
    
   // NSString *strUpdateParams = [NSString stringWithFormat:@"update tbl_SecurityList set is_checked = '%@' where ticker = '%@'", strIsFavorite, self.securityId];
   // [globalShare.fmDBObject executeUpdate:strUpdateParams];
}
#pragma Favourites Functionality
-(void)favouritesAdd
{
    @try {
        [self.indicatorView setHidden:NO];
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSString *strURL = [NSString stringWithFormat:@"%@SaveFavorites?Tickers=%@", REQUEST_URL, self.securityId];
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSLog(@"The favourites :%@",returnedDict);
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
                                                               if([[returnedDict valueForKey:@"status"] isEqualToString:@"authenticated"])
                                                               {
                                                                   [self.buttonFavTitle setTitle:NSLocalizedString(@"Unfavorite", @"Unfavorite") forState:UIControlStateNormal];
                                                                   [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_unfavorite"]];
                                                                   [GlobalShare showBasicAlertViewTitle:self :self.securityId :FAVORITES_ADD];
                                                                   [self favouritesList];

                                                                   [self.delegate dismissPopup];

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
-(void)favouritesRemove
{
    @try {
        [self.indicatorView setHidden:NO];
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSString *strURL = [NSString stringWithFormat:@"%@deleteFavorite?Ticker=%@", REQUEST_URL, self.securityId];
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSLog(@"The favourites :%@",returnedDict);
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
                                                               if([[returnedDict valueForKey:@"status"] isEqualToString:@"authenticated"])
                                                               {
                                                                   [self.buttonFavTitle setTitle:NSLocalizedString(@"Favorite", @"Favorite") forState:UIControlStateNormal];
                                                                   [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_favorite"]];
                                                                   [GlobalShare showBasicAlertViewTitle:self :self.securityId :FAVORITES_REMOVE];
                                                                   
                                                                   [self favouritesList];
                                                                   [self.delegate dismissPopup];
                                                                   
                                                                   
                                                                 
                                                                   
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
-(void)favouritesList
{
    @try {
        [self.indicatorView setHidden:NO];
        NSString *strToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ssckey"]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.HTTPAdditionalHeaders = @{@"Authorization": strToken};
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSString *strURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, @"GetFavorites"];
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           [self.indicatorView setHidden:YES];
                                                           if(error == nil)
                                                           {
                                                               NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSLog(@"The favourites :%@",returnedDict);
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
                                                               if([[returnedDict valueForKey:@"status"] isEqualToString:@"authenticated"])
                                                               {
                                                                if([[returnedDict valueForKey:@"result"] isKindOfClass:[NSArray class]])
                                                                {
                                                                    globalShare.favouritesArray= [returnedDict valueForKey:@"result"];
                                                                   for(int k = 0; k< globalShare.favouritesArray.count;k++)
                                                                   {
                                                                    NSDictionary *dictVal = [globalShare.favouritesArray objectAtIndex:k];
                                                                    if([[dictVal valueForKey:@"Ticker"] isEqualToString:self.securityId])
                                                                       {
                                                                [self.buttonFavTitle setTitle:NSLocalizedString(@"Unfavorite", @"Unfavorite") forState:UIControlStateNormal];
                                                                           [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_unfavorite"]];
                                                                       }
                                                                else
                                                                    {
                                                                   [self.buttonFavTitle setTitle:NSLocalizedString(@"Favorite", @"Favorite") forState:UIControlStateNormal];
                                                                           [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_favorite"]];
                                                                    }
                                                                   }
                                                                   
                                                                 
                                                               }
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
