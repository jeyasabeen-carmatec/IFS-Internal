//
//  MyNewOrdersCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "MyNewOrdersCell.h"

@interface MyNewOrdersCell()

@end

@implementation MyNewOrdersCell

@synthesize labelSymbol;
@synthesize labelOrder;
@synthesize labelCompanyName;
@synthesize labelDate;
@synthesize labelOrgQty;
@synthesize labelExecQty;
@synthesize buttonExecQty;
@synthesize labelPrice;
@synthesize labelValidity;
@synthesize labelStatus;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
