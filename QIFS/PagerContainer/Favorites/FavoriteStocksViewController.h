//
//  FavoriteStocksViewController.h
//  QIFS
//
//  Created by zylog on 27/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "DataManager.h"
#import "MGSwipeTableCell.h"
#import "SearchStocksViewController.h"

@interface FavoriteStocksViewController : UIViewController <searchResultsDelegate, MGSwipeTableCellDelegate, UISearchResultsUpdating, UISearchControllerDelegate> {
    GlobalShare *globalShare;
}

@end
