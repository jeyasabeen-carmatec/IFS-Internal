//
//  StockListCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelSecurityName;
@property (nonatomic, weak) IBOutlet UILabel *labelPrice;
@property (nonatomic, weak) IBOutlet UILabel *labelHighLow;
@property (nonatomic, weak) IBOutlet UILabel *labelChange;
@property (nonatomic, weak) IBOutlet UILabel *labelPercentChange;
@property (nonatomic, weak) IBOutlet UIImageView *imageUpDown;
@property (nonatomic, weak) IBOutlet UILabel *labelColor;
@property (nonatomic, weak) IBOutlet UILabel *labelAsk;
@property (nonatomic, weak) IBOutlet UILabel *labelBid;

@end
