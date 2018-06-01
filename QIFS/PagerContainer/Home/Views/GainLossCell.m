//
//  GainLossCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "GainLossCell.h"

@implementation GainLossCell

@synthesize labelSymbol;
@synthesize labelSecurityName;
@synthesize labelPrice;
@synthesize labelHighLow;
@synthesize labelChange;
@synthesize labelPercentChange;
@synthesize imageUpDown;
@synthesize labelColor;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
