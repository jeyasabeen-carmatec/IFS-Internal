//
//  OrderConfirmViewController.h
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol orderConfirmDelegate <NSObject>
@required
- (void)callBackFromConfirmOrder;
- (void)callBackFromConfirmOrderStocks;
@end

@interface OrderConfirmViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (nonatomic, strong) NSDictionary *passOrderValues;
@property id<orderConfirmDelegate> delegate;

@end
