//
//  MarketDepthViewController.h
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@interface MarketDepthViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) NSString *securityId;

@end
