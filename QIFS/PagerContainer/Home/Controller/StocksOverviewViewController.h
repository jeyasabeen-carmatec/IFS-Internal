//
//  StocksOverviewViewController.h
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "XLPagerTabStripViewController.h"

//@protocol chartTapDelegate <NSObject>
//@required
//- (void)handleTapOnChartView;
//@end

@interface StocksOverviewViewController : UIViewController <XLPagerTabStripChildItem> {
    GlobalShare *globalShare;
}
//@property id<chartTapDelegate> delegate;

@end
