//
//  SearchResultsViewController.h
//  QIFS
//
//  Created by zylog on 07/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchControllerBaseTableViewController.h"

extern NSString *const SearchResultsControllerStoryboardIdentifier;

@interface SearchResultsViewController : SearchControllerBaseTableViewController <UISearchResultsUpdating>

@end
