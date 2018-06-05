//
//  SearchResultsViewController.m
//  QIFS
//
//  Created by zylog on 07/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "SearchResultsViewController.h"

NSString *const SearchResultsControllerStoryboardIdentifier = @"SearchResultsViewController";

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    if (!searchController.active) {
        return;
    }
    
    self.filterString = searchController.searchBar.text;
}

@end
