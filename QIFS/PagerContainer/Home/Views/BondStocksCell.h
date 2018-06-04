//
//  BondStocksCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BondStocksCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelSecurityName;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelPercentageChange;
@property (nonatomic, weak) IBOutlet UILabel *labelVolume;

@end
