//
//  AppDelegate.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "AppDelegate.h"
#import "QIFS-Swift.h"
#import "TIMERUIApplication.h"
#import "UIAlertController+Orientation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after applic ation launch.
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    
    
    globalShare = [GlobalShare sharedInstance];
    [GlobalShare insertDocumentIntoPath:@"QIFS_Trade.sqlite"];
    
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_system_codes"] length] == 0)
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_system_codes"])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_system_codes"];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"is_securities_avail"])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_securities_avail"];

    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"offline_securities_time_stamp"])
        [[NSUserDefaults standardUserDefaults] setObject:[GlobalShare convertToGlobalTime:[NSDate date]] forKey:@"offline_securities_time_stamp"];
    
    NSDate *sesDate = [GlobalShare convertToLocalTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"offline_securities_time_stamp"]];
    if([[NSDate date] timeIntervalSinceDate:sesDate] > (1*24*60*60)) {
        [[NSUserDefaults standardUserDefaults] setObject:[GlobalShare convertToGlobalTime:[NSDate date]] forKey:@"offline_securities_time_stamp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_system_codes"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_securities_avail"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *dbPath = [GlobalShare documentFilePath:@"QIFS_Trade.sqlite"];
    NSLog(@"DB PATH:%@",dbPath);
    
    globalShare.fmDBObject = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"The dbPath is - %@",dbPath);
    
    if (![globalShare.fmDBObject open]) {
        globalShare.fmDBObject = nil;
        NSLog(@"Could not open db.");
    }

//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = navController;
//    [navController setNavigationBarHidden:YES];
    
    
    
    [self.window makeKeyAndVisible];
    self.window.clipsToBounds = YES;
    
//    NSLog(@"%f", [GlobalShare returnDoubleFromString:@"2,339,232,422.34"]);
//    NSLog(@"%@", [GlobalShare createCommaSeparatedString:@"2339232422.34"]);
//    BOOL isYes = [GlobalShare returnIfExistsBetween:10.55 :10.51 :10.54];
    
    [[GlobalShare sharedInstance] setIsDirectOrder:YES];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:YES];
    [[GlobalShare sharedInstance] setIsBuyOrSell:1];
    
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage hasPrefix:@"en-"] || [strSelectedLanguage hasPrefix:@"ar-"])
        [GlobalShare setSelectedLanguage:ENGLSIH_LANGUAGE];
//        [GlobalShare setSelectedLanguage:ARABIC_LANGUAGE];
    else
        globalShare.myLanguage = [GlobalShare getSelectedLanguage];
    
    [[GlobalShare sharedInstance] setIsTimerStockListRun:NO];
    [[GlobalShare sharedInstance] setIsTimerPortfolioRun:NO];
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:NO];
    [[GlobalShare sharedInstance] setIsTimerGainLossRun:NO];
    [[GlobalShare sharedInstance] setIsTimerActiveRun:NO];
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:NO];
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:NO];

    [[NSUserDefaults standardUserDefaults] setObject:@"0.00275" forKey:@"IFS_Commission"];
    [[NSUserDefaults standardUserDefaults] synchronize];

//    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"ar"] forKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSArray *sfloats = @[ @"192.5235", @"235.4362", @"3.235", @"500.235", @"219.72", @"219.79", @"219.62"];
//    NSArray *myArray = [sfloats sortedArrayUsingDescriptors:
//                        @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
//                                                        ascending:YES]]];
//    
//    NSLog(@"Sorted: %@", myArray);
    
//    application.statusBarHidden = NO;
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];

//    [IQKeyboardManager.sharedManager setEnable:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function methodRunAfterBackground
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[GlobalShare sharedInstance] setIsTimerStockListRun:NO];
    [[GlobalShare sharedInstance] setIsTimerPortfolioRun:NO];
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:NO];
    [[GlobalShare sharedInstance] setIsTimerGainLossRun:NO];
    [[GlobalShare sharedInstance] setIsTimerActiveRun:NO];
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:NO];
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:NO];

    if ([globalShare.timerStockList isValid]) {
        [globalShare.timerStockList invalidate];
        globalShare.timerStockList = nil;
    }
    if ([globalShare.timerPortfolio isValid]) {
        [globalShare.timerPortfolio invalidate];
        globalShare.timerPortfolio = nil;
    }
    if ([globalShare.timerNewOrder isValid]) {
        [globalShare.timerNewOrder invalidate];
        globalShare.timerNewOrder = nil;
    }
    if ([globalShare.timerGainLoss isValid]) {
        [globalShare.timerGainLoss invalidate];
        globalShare.timerGainLoss = nil;
    }
    if ([globalShare.timerActive isValid]) {
        [globalShare.timerActive invalidate];
        globalShare.timerActive = nil;
    }
    if ([globalShare.timerFavorites isValid]) {
        [globalShare.timerFavorites invalidate];
        globalShare.timerFavorites = nil;
    }
    if ([globalShare.timerMarketDepth isValid]) {
        [globalShare.timerMarketDepth invalidate];
        globalShare.timerMarketDepth = nil;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *strURL = [url resourceSpecifier];
    NSLog(@"%@", strURL);
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *currentViewController = [self topViewController];
    
    if ([currentViewController respondsToSelector:@selector(canAutoRotate)]) {
        NSMethodSignature *signature = [currentViewController methodSignatureForSelector:@selector(canAutoRotate)];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setSelector:@selector(canAutoRotate)];
        [invocation setTarget:currentViewController];
        
        [invocation invoke];
        
        BOOL canAutorotate = NO;
        [invocation getReturnValue:&canAutorotate];
        
        if (canAutorotate && [[GlobalShare sharedInstance] canAutoRotateL]) {
//            if([[GlobalShare sharedInstance] canRotateOnClick])
//                return UIInterfaceOrientationMaskLandscape;
//            else
                return UIInterfaceOrientationMaskAll;
        }
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog (@"time exceeded!!");
    

    //This is where storyboarding vs xib files comes in. Whichever view controller you want to revert back to, on your storyboard, make sure it is given the identifier that matches the following code. In my case, "mainView". My storyboard file is called MainStoryboard.storyboard, so make sure your file name matches the storyboardWithName property.
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Session Expired Please Login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    [self presentAlertController];
}
/*
+ (void)showSignOutAlertView:(NSString *)strMessage {
    GlobalShare *globalShare = [GlobalShare sharedInstance];
    
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
//                                                           style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction *action)
//                                   {
//
//                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                                   
                                   
                                   UIStoryboard *storyboard = keyWindow.rootViewController.storyboard;
                                   UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                                   keyWindow.rootViewController = rootViewController;
                                   [keyWindow makeKeyAndVisible];
                                   
                               }];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
       // [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }
    else {
        [alertController addAction:okAction];
        //[alertController addAction:cancelAction];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alertController animated:YES completion:nil];

       
        
    });
}
*/

-(void)presentAlertController{
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(@"EXpired Session", @"EXpired Session");


    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Login",@"Login") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // continue your work
        
        // important to hide the window after work completed.
        // this also keeps a reference to the window until the action is invoked.
        topWindow.hidden = YES; // if you want to hide the topwindow then use this
       // if you want to remove the topwindow then use this
        
        
        
        //UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//        UIStoryboard *storyboard = keyWindow.rootViewController.storyboard;
//        ViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        keyWindow.rootViewController = rootViewController;
//        [keyWindow makeKeyAndVisible];
        
        
        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//        self.window.rootViewController = navController;
//        [navController setNavigationBarHidden:YES];
        
         UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
         UIStoryboard *storyboard = keyWindow.rootViewController.storyboard;
        ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        self.window.rootViewController = navigationController;
        navigationController.navigationBar.hidden = YES;
        
        
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


@end
