//
//  TIMERUIApplication.h
//  Tabbar
//
//  Created by Carmatec on 15/06/18.
//  Copyright © 2018 Carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 30

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"


@interface TIMERUIApplication : UIApplication{
    NSTimer     *myidleTimer;
}
-(void)resetIdleTimer;


@end
