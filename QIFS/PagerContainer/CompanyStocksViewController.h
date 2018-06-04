//
//  CompanyStocksViewController.h
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

//@protocol chartCompanyTapDelegate <NSObject>
//@required
//- (void)handleTapOnCompanyChartView;
//@end


@interface CompanyStocksViewController : UIViewController {
    GlobalShare *globalShare;
}

//@property id<chartCompanyTapDelegate> delegate;
@property (strong, nonatomic) NSString *securityId;
@property (strong, nonatomic) NSString *securityName;

@end
