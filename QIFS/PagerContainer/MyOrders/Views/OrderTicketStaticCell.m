//
//  OrderTicketStaticCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "OrderTicketStaticCell.h"

@implementation OrderTicketStaticCell

@synthesize labelOrderID;
@synthesize labelAvgPrice;
@synthesize labelTotalQty;

@synthesize labelPriceCaption;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
