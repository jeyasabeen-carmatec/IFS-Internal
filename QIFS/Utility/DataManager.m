//
//  DataManager.m
//  QIFS
//
//  Created by zylog on 25/11/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (void)insertSecurityList:(NSArray *)theArray {
    @try {
        GlobalShare *globalShare = [GlobalShare sharedInstance];

        NSMutableString *strSymbol = [[NSMutableString alloc] init];
//        NSMutableArray *arrayParams = [[NSMutableArray alloc] init];
        NSString *strQuery = [NSString stringWithFormat:@"select ticker from tbl_SecurityList where is_checked = '%@'", @"YES"];
        globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:strQuery];
        while ([globalShare.fmRSObject next]) {
//            [arrayParams addObject:[globalShare.fmRSObject stringForColumn:@"ticker"]];
            
            NSString *sqlQueryPart = nil;
            sqlQueryPart = [NSString stringWithFormat:@" '%@',", [globalShare.fmRSObject stringForColumn:@"ticker"]];
            [strSymbol appendString:sqlQueryPart];
        }
        [globalShare.fmRSObject close];
        
        
        [globalShare.fmDBObject executeUpdate:@"DELETE FROM tbl_SecurityList"];
        NSMutableString *queryPart = [[NSMutableString alloc] init];
        for (int i = 0; i < theArray.count; i++) {
            NSDictionary *def = theArray[i];
            NSArray *newArray = def[@"securities"];
            
            [newArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dict = [(NSMutableDictionary *)obj mutableCopy];
                
                NSString *sqlQueryPart = nil;
                sqlQueryPart = [NSString stringWithFormat:@" (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\"),", dict[@"ticker"], dict[@"security_name_a"], dict[@"security_name_e"], def[@"security_sector_name_en"], def[@"security_sector_name_ar"], @"NO"];
                [queryPart appendString:sqlQueryPart];
            }];
        }
        
        if([queryPart length] > 0) {
            [queryPart deleteCharactersInRange:NSMakeRange([queryPart length]-1, 1)];
            queryPart = [[queryPart stringByReplacingOccurrencesOfString:@"(null)" withString:@""] mutableCopy];
            queryPart = [[NSString stringWithFormat:@"insert into tbl_SecurityList (ticker, security_name_a, security_name_e, security_sector_name_en, security_sector_name_ar, is_checked) Values%@", queryPart] mutableCopy];
            [globalShare.fmDBObject executeUpdate:queryPart];
        }
        
        
        //update tbl_SecurityList set is_checked = 'YES' WHERE ticker  in ('ABQK','AHCS')
        if(strSymbol.length > 0) {
            [strSymbol deleteCharactersInRange:NSMakeRange([strSymbol length]-1, 1)];

            NSString *strUpdateParams = [NSString stringWithFormat:@"update tbl_SecurityList set is_checked = '%@' where ticker in (%@)", @"YES", strSymbol];
            [globalShare.fmDBObject executeUpdate:strUpdateParams];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@" , [exception description]);
    }
}

+ (NSMutableDictionary *)select_SecurityListAsSectors {
    @try {
        GlobalShare *globalShare = [GlobalShare sharedInstance];
        NSMutableArray *mySectors = [[NSMutableArray alloc] init];
        globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:@"select * from tbl_SecurityList"];
        while ([globalShare.fmRSObject next]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

            [dict setObject:[globalShare.fmRSObject stringForColumn:@"ticker"] forKey:@"ticker"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_name_a"] forKey:@"security_name_a"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_name_e"] forKey:@"security_name_e"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_sector_name_en"] forKey:@"security_sector_name_en"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_sector_name_ar"] forKey:@"security_sector_name_ar"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"is_checked"] forKey:@"is_checked"];
            
            [mySectors addObject:dict];
        }
        [globalShare.fmRSObject close];

        NSMutableDictionary *contactDirectory = [NSMutableDictionary new];
        
        for (NSInteger i = 0; i < mySectors.count; i++) {
            NSMutableDictionary *tmp = mySectors[i];
            NSString *firstLetter = [tmp objectForKey:(globalShare.myLanguage != ARABIC_LANGUAGE) ? @"security_sector_name_en" : @"security_sector_name_ar"];
            if (![contactDirectory objectForKey:firstLetter]) {
                [contactDirectory setObject:[NSMutableArray new] forKey:firstLetter];
            }
            [[contactDirectory objectForKey:firstLetter] addObject:tmp];
        }
        
//        NSMutableDictionary *contactDirectoryFinal = [NSMutableDictionary new];
//        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Vendor_Name" ascending:YES];
//        for (NSString *key in contactDirectory.allKeys) {
//            [contactDirectoryFinal setObject:[[contactDirectory objectForKey:key] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] forKey:key];
//        }
        return contactDirectory;
    }
    @catch (NSException *exception) {
        NSLog(@"%@" , [exception description]);
    }
}

+ (NSMutableArray *)select_SecurityList {
    @try {
        GlobalShare *globalShare = [GlobalShare sharedInstance];
        NSMutableArray *mySectors = [[NSMutableArray alloc] init];
        globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:@"select * from tbl_SecurityList"];
        while ([globalShare.fmRSObject next]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"ticker"] forKey:@"ticker"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_name_a"] forKey:@"security_name_a"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_name_e"] forKey:@"security_name_e"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_sector_name_en"] forKey:@"security_sector_name_en"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"security_sector_name_ar"] forKey:@"security_sector_name_ar"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"is_checked"] forKey:@"is_checked"];
            
            [mySectors addObject:dict];
        }
        [globalShare.fmRSObject close];
        
        return mySectors;
    }
    @catch (NSException *exception) {
        NSLog(@"%@" , [exception description]);
    }
}

+ (void)insertSystemCodes:(NSDictionary *)dictVal {
    @try {
        GlobalShare *globalShare = [GlobalShare sharedInstance];
        [globalShare.fmDBObject executeUpdate:@"DELETE FROM tbl_TransactionOrderType"];
        NSArray *transactionOrderArray = dictVal[@"TransactionOrderSide"];
        NSMutableString *queryTrans = [[NSMutableString alloc] init];
        for (int i = 0; i < transactionOrderArray.count; i++) {
            NSDictionary *dict = transactionOrderArray[i];
            
            NSString *sqlQueryTrans = nil;
            sqlQueryTrans = [NSString stringWithFormat:@" (\"%@\", \"%@\", \"%@\"),", dict[@"description_a"], dict[@"description_e"], dict[@"minor_code"]];
            [queryTrans appendString:sqlQueryTrans];
        }
        
        if([queryTrans length] > 0) {
            [queryTrans deleteCharactersInRange:NSMakeRange([queryTrans length]-1, 1)];
            queryTrans = [[queryTrans stringByReplacingOccurrencesOfString:@"(null)" withString:@""] mutableCopy];
            queryTrans = [[NSString stringWithFormat:@"insert into tbl_TransactionOrderType (description_a, description_e, minor_code) Values%@", queryTrans] mutableCopy];
            [globalShare.fmDBObject executeUpdate:queryTrans];
        }
        
        [globalShare.fmDBObject executeUpdate:@"DELETE FROM tbl_PriceOrderType"];
        NSArray *priceOrderArray = dictVal[@"priceType"];
        NSMutableString *queryPrice = [[NSMutableString alloc] init];
        for (int i = 0; i < priceOrderArray.count; i++) {
            NSDictionary *dict = priceOrderArray[i];
            
            NSString *sqlQueryPrice = nil;
            sqlQueryPrice = [NSString stringWithFormat:@" (\"%@\", \"%@\", \"%@\"),", dict[@"description_a"], dict[@"description_e"], dict[@"minor_code"]];
            [queryPrice appendString:sqlQueryPrice];
        }
        
        if([queryPrice length] > 0) {
            [queryPrice deleteCharactersInRange:NSMakeRange([queryPrice length]-1, 1)];
            queryPrice = [[queryPrice stringByReplacingOccurrencesOfString:@"(null)" withString:@""] mutableCopy];
            queryPrice = [[NSString stringWithFormat:@"insert into tbl_PriceOrderType (description_a, description_e, minor_code) Values%@", queryPrice] mutableCopy];
            [globalShare.fmDBObject executeUpdate:queryPrice];
        }
        
        [globalShare.fmDBObject executeUpdate:@"DELETE FROM tbl_DurationOrderType"];
        NSArray *durationOrderArray = dictVal[@"duration"];
        NSMutableString *queryDuration = [[NSMutableString alloc] init];
        for (int i = 0; i < durationOrderArray.count; i++) {
            NSDictionary *dict = durationOrderArray[i];
            
            NSString *sqlQueryDuration = nil;
            sqlQueryDuration = [NSString stringWithFormat:@" (\"%@\", \"%@\", \"%@\"),", dict[@"description_a"], dict[@"description_e"], dict[@"minor_code"]];
            [queryDuration appendString:sqlQueryDuration];
        }
        
        if([queryDuration length] > 0) {
            [queryDuration deleteCharactersInRange:NSMakeRange([queryDuration length]-1, 1)];
            queryDuration = [[queryDuration stringByReplacingOccurrencesOfString:@"(null)" withString:@""] mutableCopy];
            queryDuration = [[NSString stringWithFormat:@"insert into tbl_DurationOrderType (description_a, description_e, minor_code) Values%@", queryDuration] mutableCopy];
            [globalShare.fmDBObject executeUpdate:queryDuration];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@" , [exception description]);
    }
}

+ (NSMutableArray *)select_SystemCodes:(NSString *)strType {
    @try {
        GlobalShare *globalShare = [GlobalShare sharedInstance];
        NSMutableArray *systemCodes = [[NSMutableArray alloc] init];
        NSString *strQuery = [NSString stringWithFormat:@"select * from %@", strType];
        globalShare.fmRSObject = [globalShare.fmDBObject executeQuery:strQuery];
        while ([globalShare.fmRSObject next]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"description_a"] forKey:@"description_a"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"description_e"] forKey:@"description_e"];
            [dict setObject:[globalShare.fmRSObject stringForColumn:@"minor_code"] forKey:@"minor_code"];
            
            [systemCodes addObject:dict];
        }
        [globalShare.fmRSObject close];
        
        return systemCodes;
    }
    @catch (NSException *exception) {
        NSLog(@"%@" , [exception description]);
    }
}

@end
