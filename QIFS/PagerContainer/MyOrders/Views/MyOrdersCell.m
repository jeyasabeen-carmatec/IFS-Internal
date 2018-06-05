//
//  MyOrdersCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "MyOrdersCell.h"

@interface MyOrdersCell()

@end

@implementation MyOrdersCell

@synthesize labelSymbol;
@synthesize labelCompanyName;
@synthesize labelOrder;
@synthesize labelPrice;
@synthesize labelOrgQty;
@synthesize labelDate;
@synthesize labelValidity;
@synthesize labelExpCanDate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
