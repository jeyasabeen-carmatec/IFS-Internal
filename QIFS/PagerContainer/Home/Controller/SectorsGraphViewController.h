//
//  SectorsGraphViewController.h
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "XLPagerTabStripViewController.h"

@interface SectorsGraphViewController : UIViewController <XLPagerTabStripChildItem> {
    GlobalShare *globalShare;
}

@end
