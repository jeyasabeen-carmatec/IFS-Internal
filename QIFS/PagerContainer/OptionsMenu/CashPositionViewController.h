//
//  CashPositionViewController.h
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol tabBarManageCashDelegate <NSObject>
@required
- (void)callBackSuperviewFromCash;
@end

@interface CashPositionViewController : UIViewController {
    GlobalShare *globalShare;
}

@property id<tabBarManageCashDelegate> delegate;

@end
