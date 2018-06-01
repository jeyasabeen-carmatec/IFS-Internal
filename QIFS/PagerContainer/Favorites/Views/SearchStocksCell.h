//
//  SearchStocksCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchStocksCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelSymbol;
@property (nonatomic, weak) IBOutlet UILabel *labelCompanyName;
@property (nonatomic, weak) IBOutlet UIButton *buttonTick;
@property (nonatomic, weak) IBOutlet UIView *viewTick;

@end
