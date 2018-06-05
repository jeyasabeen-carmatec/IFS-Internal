//
//  GainLossViewController.h
//  QIFS
//
//  Created by zylog on 06/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "GlobalShare.h"
#import "PropertyList.h"

@interface GainLossViewController : UIViewController <XLPagerTabStripChildItem> {
    GlobalShare *globalShare;
}

@end
