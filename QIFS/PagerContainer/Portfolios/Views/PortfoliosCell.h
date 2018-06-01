//
//  PortfoliosCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface PortfoliosCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *label_AR_Symbol;

@property (nonatomic, weak) IBOutlet UILabel *labelQty;
@property (nonatomic, weak) IBOutlet UILabel *labelAvgPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelMktValue;
@property (nonatomic, weak) IBOutlet UILabel *labelGainLoss;
@property (nonatomic, weak) IBOutlet UILabel *labelGainLossVal;

@end
