//
//  AddAlertViewController.h
//  QIFS
//
//  Created by zylog on 13/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol alertAddViewDelegate <NSObject>
@required
- (void)callBackAlerts:(NSMutableDictionary*)dict;
@end

@interface AddAlertViewController : UIViewController {
    GlobalShare *globalShare;
}

@property id<alertAddViewDelegate> delegate;

@end
