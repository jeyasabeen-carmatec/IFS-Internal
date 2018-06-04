//
//  StocksPagerViewController.h
//  QIFS
//
//  Created by zylog on 15/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "DataManager.h"

@interface StocksPagerViewController : UIViewController <UISearchResultsUpdating, UISearchControllerDelegate> {
    GlobalShare *globalShare;
}

@end
