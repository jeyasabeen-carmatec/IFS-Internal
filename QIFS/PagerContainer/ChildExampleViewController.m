//
//  ChildExampleViewController.m
//  QIFS
//
//  Created by zylog on 29/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ChildExampleViewController.h"
#import "PagerViewController.h"

@interface ChildExampleViewController ()

@property (nonatomic, strong) IBOutlet UIButton *myButton;

@end

@implementation ChildExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSelect:(id)sender {
//    PagerViewController *pagerViewController = [[PagerViewController alloc] initWithNibName:@"PagerViewController" bundle:nil];
//    [[self navigationController] pushViewController:pagerViewController animated:YES];
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"TitleView";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

@end
