//
//  MDPriceBidCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDBarView.h"

@interface MDPriceBidCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelBidNoofShares;
@property (nonatomic, weak) IBOutlet UIView *viewBidQty;
@property (nonatomic, weak) IBOutlet UILabel *labelBidQty;
@property (nonatomic, weak) IBOutlet UILabel *labelBidPrice;
@property (weak, nonatomic) IBOutlet UIView *baview;
@property (weak, nonatomic) IBOutlet UILabel *labelLine1;
@property (weak, nonatomic) IBOutlet UILabel *labelLine2;
@property (weak, nonatomic) IBOutlet UIView *testWidth;
@property (weak, nonatomic) IBOutlet UIView *bidnoofshareview;
@property (weak, nonatomic) IBOutlet UIView *outerView;



@end
