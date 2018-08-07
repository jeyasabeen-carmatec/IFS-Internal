//
//  MDPriceAskCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPriceAskCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelAskPrice;
@property (nonatomic, weak) IBOutlet UIView *viewAskQty;
@property (nonatomic, weak) IBOutlet UILabel *labelAskQty;
@property (nonatomic, weak) IBOutlet UILabel *labelAskNoofShares;
@property (weak, nonatomic) IBOutlet UILabel *labelLine1;
@property (weak, nonatomic) IBOutlet UILabel *labelLine2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *AskQtyview;
@property (weak, nonatomic) IBOutlet UIView *Asknoofshares;

@end
