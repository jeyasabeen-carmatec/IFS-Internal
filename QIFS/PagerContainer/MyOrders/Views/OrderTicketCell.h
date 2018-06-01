//
//  OrderTicketCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTicketCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelTickedID;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelQty;
@property (nonatomic, weak) IBOutlet UILabel *labelDate;

@end
