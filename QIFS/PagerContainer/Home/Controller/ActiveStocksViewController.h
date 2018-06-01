//
//  ActiveStocksViewController.h
//  QIFS
//
//  Created by zylog on 06/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "XLPagerTabStripViewController.h"

@interface ActiveStocksViewController : UIViewController <XLPagerTabStripChildItem> {
    GlobalShare *globalShare;
}

@end
