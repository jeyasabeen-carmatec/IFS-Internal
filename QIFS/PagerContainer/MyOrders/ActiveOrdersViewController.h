//
//  ActiveOrdersViewController.h
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol tapNewOrderDelegate <NSObject>
@required
- (void)callBackSuperviewFromNewOrder;
@end

@interface ActiveOrdersViewController : UIViewController {
    GlobalShare *globalShare;
}

@property id<tapNewOrderDelegate> delegate;
@property (nonatomic, strong) NSString *strOrderId;
@property (nonatomic, strong) NSString *securityId;
@property (nonatomic, strong) NSString *strOrderDetails;

@end
