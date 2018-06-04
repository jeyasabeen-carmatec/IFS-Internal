//
//  EnterOTPViewController.h
//  QIFS
//
//  Created by zylog on 05/04/17.
//  Copyright © 2017 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"

@interface EnterOTPViewController : UIViewController {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) NSString *strUserName;

@end
