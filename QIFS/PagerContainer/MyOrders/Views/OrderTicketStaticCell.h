//
//  OrderTicketStaticCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTicketStaticCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelOrderID;
@property (nonatomic, weak) IBOutlet UILabel *labelAvgPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalQty;

@property (weak, nonatomic) IBOutlet UILabel *labelPriceCaption;

@end
