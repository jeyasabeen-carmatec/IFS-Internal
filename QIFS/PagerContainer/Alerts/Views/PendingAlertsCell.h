//
//  PendingAlertsCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface PendingAlertsCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelCompanyName;
@property (nonatomic, weak) IBOutlet UILabel *labelLastPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelCompare;
@property (nonatomic, weak) IBOutlet UILabel *labelAlertPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelAlertDate;
@property (nonatomic, weak) IBOutlet UILabel *labelNotes;

@end
