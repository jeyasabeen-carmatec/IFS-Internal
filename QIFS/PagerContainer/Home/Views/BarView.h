//
//  BarView.h
//  QIFS
//
//  Created by zylog on 03/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@interface BarView : UIView {
    GlobalShare *globalShare;
}

- (id)initWithValues:(NSArray *)arrValues;

@end
