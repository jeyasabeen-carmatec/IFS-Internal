//
//  OptionsViewCell.m
//  QIFS
//
//  Created by zylog on 11/06/17.
//  Copyright © 2017 zsl. All rights reserved.
//

#import "OptionsViewCell.h"

@implementation OptionsViewCell

@synthesize imageOption;
@synthesize labelOption;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
