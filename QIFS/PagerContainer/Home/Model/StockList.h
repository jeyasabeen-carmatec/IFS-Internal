//
//  StockList.h
//  QIFS
//
//  Created by zylog on 23/08/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockList : NSObject

@property (nonatomic, strong) NSString *security_id;
@property (nonatomic, strong) NSString *ticker;
@property (nonatomic, strong) NSString *security_name_e;
@property (nonatomic, strong) NSString *security_name_a;
@property (nonatomic, strong) NSString *change;
@property (nonatomic, strong) NSString *change_perc;
@property (nonatomic, strong) NSString *min_price;
@property (nonatomic, strong) NSString *max_price;
@property (nonatomic, strong) NSString *comp_current_price;
@property (nonatomic, strong) NSString *BID;
@property (nonatomic, strong) NSString *BID_VOL;
@property (nonatomic, strong) NSString *ASK;
@property (nonatomic, strong) NSString *ASK_VOL;

@end
