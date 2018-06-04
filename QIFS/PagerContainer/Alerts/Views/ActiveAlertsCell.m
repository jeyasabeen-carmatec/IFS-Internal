//
//  ActiveAlertsCell.m
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ActiveAlertsCell.h"

@implementation ActiveAlertsCell

@synthesize labelCompanyName;
@synthesize labelSymbol;
@synthesize labelNotes;
@synthesize labelDescription;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
