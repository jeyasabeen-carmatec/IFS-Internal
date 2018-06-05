//
//  SearchStocksViewController.h
//  QIFS
//
//  Created by zylog on 13/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol searchResultsDelegate <NSObject>
@required
- (void)callBackResults:(NSMutableArray*)array;
@end

@interface SearchStocksViewController : UIViewController {
    GlobalShare *globalShare;
}

@property id<searchResultsDelegate> delegate;

@end
