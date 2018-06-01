//
//  SearchControllerBaseTableViewController.h
//  QIFS
//
//  Created by zylog on 07/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const SearchControllerBaseTableViewCellIdentifier = @"searchResultsCell";

@interface SearchControllerBaseTableViewController : UITableViewController

@property (nonatomic, copy) NSString *filterString;
@property (readonly, copy) NSArray *visibleResults;

@end
