//
//  StockListViewController.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "XLPagerTabStripViewController.h"

@interface StockListViewController : UIViewController <XLPagerTabStripChildItem> {
    GlobalShare *globalShare;
}

- (void)dismissPopup;

@end
