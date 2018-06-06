//
//  MyNewOrdersCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface MyNewOrdersCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelOrder;
@property (nonatomic, weak) IBOutlet UILabel *labelCompanyName;
@property (nonatomic, weak) IBOutlet UILabel *labelDate;
@property (nonatomic, weak) IBOutlet UILabel *labelOrgQty;
@property (nonatomic, weak) IBOutlet UILabel *labelExecQty;
@property (nonatomic, weak) IBOutlet UIButton *buttonExecQty;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelValidity;
@property (nonatomic, weak) IBOutlet UILabel *labelStatus;

@end
