//
//  PendingAlertsCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "PendingAlertsCell.h"

@implementation PendingAlertsCell

@synthesize labelSymbol;
@synthesize labelCompanyName;
@synthesize labelLastPrice;
@synthesize labelCompare;
@synthesize labelAlertPrice;
@synthesize labelAlertDate;
@synthesize labelNotes;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
