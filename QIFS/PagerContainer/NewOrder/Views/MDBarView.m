//
//  MDBarView.m
//  QIFS
//
//  Created by zylog on 03/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "MDBarView.h"

@interface MDBarView()

@property (nonatomic, strong) NSString *strValue;

@end

@implementation MDBarView

- (id)init {
    if (self == [super init]) {
    }
    
    return self;
}

- (id)initWithValues:(NSString *)stringVal {
    if (self == [super init]) {
        self.strValue = stringVal;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    double range = 100;
//    for (int i = 0; i < 6; i++)
//    {
//        double mult = (range + 1);
//        double val = (double) (arc4random_uniform(mult)) + 3;
//
//        [xVals addObject:[@(val) stringValue]];
//    }

    double mult = (rect.size.width * [self.strValue doubleValue]/100);
    double xVals = (double) mult;

    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake((CGFloat)xVals, 0)];

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *gradientColors;
    if(self.tag == 102) {
        gradientColors = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithRed:255/255.f green:60/255.f blue:26/255.f alpha:1.f].CGColor,
                          (id)[UIColor colorWithRed:255/255.f green:233/255.f blue:230/255.f alpha:1.f].CGColor, nil];
    }
    else {
        gradientColors = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithRed:0/255.f green:109/255.f blue:51/255.f alpha:1.f].CGColor,
                          (id)[UIColor colorWithRed:204/255.f green:255/255.f blue:221/255.f alpha:1.f].CGColor, nil];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, NULL);
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, xVals, rect.size.height) cornerRadius:1];
    CGContextSaveGState(context);
    [roundedRectanglePath fill];
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(xVals, 0), 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
}


@end
