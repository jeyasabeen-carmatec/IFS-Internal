//
//  SectorsGraphCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "SectorsGraphCell.h"

@implementation SectorsGraphCell

@synthesize labelCompany;
@synthesize labelPercent;
@synthesize labelValue;
@synthesize imageLegend;
@synthesize imageBg;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
