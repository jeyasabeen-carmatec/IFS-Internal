//
//  DateValueFormatter.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//


#import "DateValueFormatter.h"
#import "GlobalShare.h"

@interface DateValueFormatter ()
{
    NSDateFormatter *_dateFormatter;
}
@end

@implementation DateValueFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
       
        _dateFormatter = [[NSDateFormatter alloc] init];
       
       
        
        if ([[GlobalShare sharedInstance] isDayChart]) {
       
            _dateFormatter.dateFormat = @"HH:mm";
        }
        else{
            _dateFormatter.dateFormat = @"dd/MM/YYYY";
        }
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];
}

@end
