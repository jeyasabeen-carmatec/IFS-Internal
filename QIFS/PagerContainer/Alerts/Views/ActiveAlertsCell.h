//
//  ActiveAlertsCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface ActiveAlertsCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *labelCompanyName;
@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelNotes;
@property (nonatomic, weak) IBOutlet UILabel *labelDescription;

@end
