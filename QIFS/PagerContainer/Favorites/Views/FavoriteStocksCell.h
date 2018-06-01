//
//  FavoriteStocksCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface FavoriteStocksCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelCompanyName;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelChange;
@property (nonatomic, weak) IBOutlet UILabel *labelPercentageChange;
@property (nonatomic, weak) IBOutlet UILabel *labelDayHigh;
@property (nonatomic, weak) IBOutlet UILabel *labelDayLow;

@end
