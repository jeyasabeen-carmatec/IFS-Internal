//
//  OrderTicketViewController.h
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol tabBarManageOrderDelegate <NSObject>
@required
- (void)callBackSuperviewFromOrder;
@end

@interface OrderTicketViewController : UIViewController {
    GlobalShare *globalShare;
}

@property id<tabBarManageOrderDelegate> delegate;
@property (nonatomic, strong) NSString *strOrderId;

@end
