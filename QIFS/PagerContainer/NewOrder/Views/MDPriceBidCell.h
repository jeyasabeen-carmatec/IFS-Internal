//
//  MDPriceBidCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPriceBidCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelBidNoofShares;
@property (nonatomic, weak) IBOutlet UIView *viewBidQty;
@property (nonatomic, weak) IBOutlet UILabel *labelBidQty;
@property (nonatomic, weak) IBOutlet UILabel *labelBidPrice;

@end
