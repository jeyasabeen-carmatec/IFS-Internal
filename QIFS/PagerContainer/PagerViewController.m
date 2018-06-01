//
//  PagerViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "PagerViewController.h"
#import "ChildExampleViewController.h"
#import "XLButtonBarViewCell.h"

@interface PagerViewController ()

@end

@implementation PagerViewController
{
    BOOL _isReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = NO;
    // Do any additional setup after loading the view.
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor orangeColor]];
//    [self.buttonBarView registerNib:[UINib nibWithNibName:@"XLButtonBarViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    ChildExampleViewController * child_1 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
    ChildExampleViewController * child_2 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
    ChildExampleViewController * child_3 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
    ChildExampleViewController * child_4 = [[ChildExampleViewController alloc] initWithNibName:@"ChildExampleViewController" bundle:nil];
    if (!_isReload){
        return @[child_1, child_2, child_3, child_4];
    }
    
    NSMutableArray * childViewControllers = [NSMutableArray arrayWithObjects:child_1, child_2, child_3, child_4, nil];
//    NSUInteger count = [childViewControllers count];
//    for (NSUInteger i = 0; i < count; ++i) {
//        // Select a random element between i and end of array to swap with.
//        NSUInteger nElements = count - i;
//        NSUInteger n = (arc4random() % nElements) + i;
//        [childViewControllers exchangeObjectAtIndex:i withObjectAtIndex:n];
//    }
//    NSUInteger nItems = 1 + (rand() % 8);
    
    NSUInteger nItems = [childViewControllers count];
    return [childViewControllers subarrayWithRange:NSMakeRange(0, nItems)];
}

-(void)reloadPagerTabStripView
{
    _isReload = YES;
    self.isProgressiveIndicator = (rand() % 2 == 0);
    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 4;
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (XLButtonBarViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    XLButtonBarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.label.text = [NSString stringWithFormat:@"cell %ld",(long)indexPath.row];
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//}

@end
