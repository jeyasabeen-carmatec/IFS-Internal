//
//  AppDelegate.h
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalShare.h"
#import "PropertyList.h"
#import "ViewController.h"
//#import "IQKeyboardManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    GlobalShare *globalShare;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end

