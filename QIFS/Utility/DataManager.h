//
//  DataManager.h
//  QIFS
//
//  Created by zylog on 25/11/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalShare.h"

@interface DataManager : NSObject

+ (void)insertSecurityList:(NSArray *)theArray;
+ (NSMutableDictionary *)select_SecurityListAsSectors;
+ (NSMutableArray *)select_SecurityList;
+ (void)insertSystemCodes:(NSDictionary *)dictVal;
+ (NSMutableArray *)select_SystemCodes:(NSString *)strType;

@end
