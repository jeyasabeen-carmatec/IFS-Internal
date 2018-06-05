//
//  NewOrderViewController.h
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "DataManager.h"

@interface NewOrderViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) NSString *securityId;
@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) NSString *strPortQty;
@property (strong, nonatomic) NSString *strPortOnSellQty;

@end
