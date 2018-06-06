//
//  ChangePasswordViewController.h
//  QIFS
//
//  Created by zylog on 25/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@interface ChangePasswordViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) NSString *strOTPToken;

@end
