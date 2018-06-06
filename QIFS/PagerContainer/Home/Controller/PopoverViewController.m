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

@interface PopoverViewController ()

@property (nonatomic, weak) IBOutlet UIButton *buttonFavTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgFavorites;

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSString *strIsFavorite;
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
    }
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
//    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
//    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
//    [globalShare.topNavController pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionNewOrder:(id)sender {
    NewOrderViewController *newOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewOrderViewController"];
    newOrderViewController.securityId = self.securityId;
    [[GlobalShare sharedInstance] setIsDirectOrder:NO];
    [globalShare.topNavController pushViewController:newOrderViewController animated:YES];
}

- (IBAction)actionFavorites:(id)sender {
    NSString *strIsFavorite;
    if([self.buttonFavTitle.currentTitle isEqualToString:NSLocalizedString(@"Favorite", @"Favorite")]) {
        strIsFavorite = @"YES";
        [self.buttonFavTitle setTitle:NSLocalizedString(@"Unfavorite", @"Unfavorite") forState:UIControlStateNormal];
        [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_unfavorite"]];
        [GlobalShare showBasicAlertViewTitle:self :self.securityId :FAVORITES_ADD];
    }
    else {
        strIsFavorite = @"NO";
        [self.buttonFavTitle setTitle:NSLocalizedString(@"Favorite", @"Favorite") forState:UIControlStateNormal];
        [self.imgFavorites setImage:[UIImage imageNamed:@"icon_pop_favorite"]];
        [GlobalShare showBasicAlertViewTitle:self :self.securityId :FAVORITES_REMOVE];
    }
    
    NSString *strUpdateParams = [NSString stringWithFormat:@"update tbl_SecurityList set is_checked = '%@' where ticker = '%@'", strIsFavorite, self.securityId];
    [globalShare.fmDBObject executeUpdate:strUpdateParams];
    [self.delegate dismissPopup];
}

@end
