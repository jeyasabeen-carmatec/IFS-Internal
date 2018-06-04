//
//  StocksContainerViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "StocksContainerViewController.h"
#import "StocksOverviewViewController.h"
#import "StockListViewController.h"
#import "SectorsGraphViewController.h"
#import "GainLossViewController.h"
#import "ActiveStocksViewController.h"
#import "BondStocksViewController.h"

@interface StocksContainerViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation StocksContainerViewController

@synthesize containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    StocksOverviewViewController * child_1 = [[StocksOverviewViewController alloc] initWithNibName:@"StocksOverviewViewController" bundle:nil];
//
//    StockListViewController * child_2 = [[StockListViewController alloc] initWithNibName:@"StockListViewController" bundle:nil];
//
//    SectorsGraphViewController * child_3 = [[SectorsGraphViewController alloc] initWithNibName:@"SectorsGraphViewController" bundle:nil];
//
//    ChildExampleViewController * child_4 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
//
//    ChildExampleViewController * child_5 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
//
//    ChildExampleViewController * child_6 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
//
//    ChildExampleViewController * child_7 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
//
//    ChildExampleViewController * child_8 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
//    
//    NSArray *childViews =  @[child_1.view, child_2.view, child_3.view, child_4.view, child_5.view, child_6.view, child_7.view, child_8.view];
//    
//    UIView *childv = [childViews objectAtIndex:0];
//    childv.frame = containerView.frame;
//    
//    [containerView addSubview:childv];

    self.isProgressiveIndicator = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor orangeColor]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    StocksOverviewViewController *child_1 = [self.storyboard instantiateViewControllerWithIdentifier:@"StocksOverviewViewController"];
    StockListViewController *child_2 = [self.storyboard instantiateViewControllerWithIdentifier:@"StockListViewController"];
    SectorsGraphViewController *child_3 = [self.storyboard instantiateViewControllerWithIdentifier:@"SectorsGraphViewController"];
    GainLossViewController *child_4 = [self.storyboard instantiateViewControllerWithIdentifier:@"GainLossViewController"];
    ActiveStocksViewController *child_5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveStocksViewController"];
    BondStocksViewController *child_6 = [self.storyboard instantiateViewControllerWithIdentifier:@"BondStocksViewController"];
    
    NSMutableArray * childViewControllers = [NSMutableArray arrayWithObjects:child_1, child_2, child_3, child_4, child_5, child_6, nil];
    NSUInteger nItems = [childViewControllers count];
    return [childViewControllers subarrayWithRange:NSMakeRange(0, nItems)];
}

#pragma mark - Common actions

@end
