//
//  SectorsGraphCell.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectorsGraphCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelCompany;
@property (nonatomic, weak) IBOutlet UILabel *labelPercent;
@property (nonatomic, weak) IBOutlet UILabel *labelValue;
@property (nonatomic, weak) IBOutlet UIImageView *imageLegend;
@property (nonatomic, weak) IBOutlet UIImageView *imageBg;

@end
