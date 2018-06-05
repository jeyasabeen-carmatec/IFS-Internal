//
//  PopoverViewController.h
//  QIFS
//
//  Created by zylog on 30/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@protocol popupDelegate <NSObject>
@required
- (void)dismissPopup;
@end

@interface PopoverViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) NSString *securityId;
@property (strong, nonatomic) NSString *securityName;
@property id<popupDelegate> delegate;

@end
