//
//  FavoriteStocksCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "FavoriteStocksCell.h"

@implementation FavoriteStocksCell

@synthesize labelSymbol;
@synthesize labelCompanyName;
@synthesize labelPrice;
@synthesize labelChange;
@synthesize labelPercentageChange;
@synthesize labelDayHigh;
@synthesize labelDayLow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
