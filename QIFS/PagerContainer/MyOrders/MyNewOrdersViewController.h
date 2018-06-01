//
//  MyNewOrdersViewController.h
//  QIFS
//
//  Created by zylog on 16/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "DataManager.h"
#import "MGSwipeTableCell.h"

@interface MyNewOrdersViewController : UIViewController <MGSwipeTableCellDelegate, UISearchResultsUpdating, UISearchControllerDelegate> {
    GlobalShare *globalShare;
}

@end
