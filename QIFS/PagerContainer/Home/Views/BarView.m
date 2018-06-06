//
//  BarView.m
//  QIFS
//
//  Created by zylog on 03/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "BarView.h"

@interface BarView()

@property (nonatomic, assign) CGRect myRect;
@property (nonatomic, strong) NSArray *arrayValues;

@end

@implementation BarView


- (id)initWithFrame:(CGRect)frame :(NSArray *)arrValues {
    if (self == [super initWithFrame:frame]) {
        self.myRect = frame;
        self.arrayValues = arrValues;
    }

    return self;
}


- (id)initWithValues:(NSArray *)arrValues {
    globalShare = [GlobalShare sharedInstance];
    if (self == [super init]) {
        self.arrayValues = arrValues;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [[UIColor whiteColor] setFill];  // changes are here
//    UIRectFill(rect);               // and here
//    CGContextRef g = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(g, (242.0 / 255.0), (242.0 / 255.0), (242.0 / 255.0), 1.0);
//
//    CGContextSetShouldAntialias(g, NO);
//    const CGFloat solidPattern[2] = {0.0, 1.0};
//    CGContextSetRGBStrokeColor(g, 0.0, 0.0, 0.0, .3);
//    CGContextSetLineDash(g, 0, solidPattern, 2);
//    CGFloat yVal = 5;
//    for (NSInteger i = 0; i < 3; i++) {
//        yVal = yVal +10;
//        CGContextMoveToPoint(g, 5, yVal);
//        CGContextAddLineToPoint(g, self.frame.size.width, yVal);
//    }
//    CGContextStrokePath(g);

//    CGRect myRect = myRect;
    CGFloat myWidth = rect.size.width/2;
    CGFloat myHeight = 20.f;
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.arrayValues count]; i++)
    {
        double mult = (rect.size.width * [self.arrayValues[i][@"Percent"] doubleValue]/100);
        double val = (double) mult;
        
        [xVals addObject:[@(val) stringValue]];
    }

    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat yVal = 0;
    for (NSInteger i = 0; i < [self.arrayValues count]; i++) {
//        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
//        [xVals[i] drawInRect:CGRectMake(self.frame.origin.x,
//                                        yVal,
//                                        [xVals[i] intValue],
//                                        10) withAttributes:attributes];

//        if(globalShare.myLanguage == ARABIC_LANGUAGE) {
//            [path moveToPoint:CGPointMake((CGFloat)[xVals[i] floatValue], yVal)];
//            [path addLineToPoint:CGPointMake(0, yVal)];
//        }
//        else {
//            [path moveToPoint:CGPointMake(0, yVal)];
//            [path addLineToPoint:CGPointMake((CGFloat)[xVals[i] floatValue], yVal)];
//        }

        [path moveToPoint:CGPointMake(0, yVal)];
        [path addLineToPoint:CGPointMake((CGFloat)[xVals[i] floatValue], yVal)];
//        path.lineWidth = 20;
        yVal = yVal + 30;
        
        UILabel *labelSymbol = [[UILabel alloc] initWithFrame:CGRectMake(0, yVal, myWidth, myHeight)];
//        UILabel *labelSymbol = [[UILabel alloc] init];
//        CGRect myFrame1;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            myFrame1 = CGRectMake(myWidth, yVal, myWidth, myHeight);
//        else
//            myFrame1 = CGRectMake(0, yVal, myWidth, myHeight);
//        labelSymbol.frame = myFrame1;
        labelSymbol.textColor = [UIColor blackColor];
        labelSymbol.font = [UIFont systemFontOfSize:10.0f];
        labelSymbol.text = self.arrayValues[i][@"Symbol"];
        labelSymbol.textAlignment = NSTextAlignmentLeft;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            labelSymbol.textAlignment = NSTextAlignmentRight;
//        else
//            labelSymbol.textAlignment = NSTextAlignmentLeft;
        [self addSubview:labelSymbol];

        UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(myWidth, yVal, myWidth, myHeight)];
        labelPrice.textColor = [UIColor blackColor];
        labelPrice.font = [UIFont systemFontOfSize:11.0f];
        labelPrice.text = self.arrayValues[i][@"Value"];
        labelPrice.textAlignment = NSTextAlignmentRight;
//        [self addSubview:labelPrice];

        UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(myWidth, yVal, myWidth, myHeight)];
//        UILabel *labelValue = [[UILabel alloc] init];
//        CGRect myFrame2;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            myFrame2 = CGRectMake(0, yVal, myWidth, myHeight);
//        else
//            myFrame2 = CGRectMake(myWidth, yVal, myWidth, myHeight);
//        labelValue.frame = myFrame2;
        labelValue.textColor = [UIColor blackColor];
        labelValue.font = [UIFont systemFontOfSize:10.0f];
        labelValue.text = self.arrayValues[i][@"Value"];
        labelValue.textAlignment = NSTextAlignmentRight;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            labelValue.textAlignment = NSTextAlignmentLeft;
//        else
//            labelValue.textAlignment = NSTextAlignmentRight;
        [self addSubview:labelValue];

//        CGFloat colors [] = {
//            1.0, 1.0, 1.0, 1.0,
//            1.0, 0.0, 0.0, 1.0
//        };
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
//        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
//        
//        CGContextSaveGState(context);
//        CGContextClip(context);
//        
//        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
//        
//        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//        CGGradientRelease(gradient), gradient = NULL;
//        
//        CGContextRestoreGState(context);
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        NSArray *gradientColors;
        if(self.frame.origin.x == 5) {
            if(globalShare.myLanguage == ARABIC_LANGUAGE) {
                gradientColors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithRed:153/255.f green:119/255.f blue:63/255.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithRed:232/255.f green:220/255.f blue:201/255.f alpha:1.f].CGColor, nil];
            }
            else {
                gradientColors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithRed:113/255.f green:155/255.f blue:182/255.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithRed:221/255.f green:231/255.f blue:238/255.f alpha:1.f].CGColor, nil];
            }
        }
        else {
            if(globalShare.myLanguage == ARABIC_LANGUAGE) {
                gradientColors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithRed:113/255.f green:155/255.f blue:182/255.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithRed:221/255.f green:231/255.f blue:238/255.f alpha:1.f].CGColor, nil];
            }
            else {
                gradientColors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithRed:153/255.f green:119/255.f blue:63/255.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithRed:232/255.f green:220/255.f blue:201/255.f alpha:1.f].CGColor, nil];
            }
        }
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, NULL);
        
//        CGRect myFrame3;
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            myFrame3 = CGRectMake((CGFloat)[xVals[i] floatValue], yVal, 0, myHeight);
//        else
//            myFrame3 = CGRectMake(0, yVal, (CGFloat)[xVals[i] floatValue], myHeight);

        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, yVal, (CGFloat)[xVals[i] floatValue], myHeight) cornerRadius:1];
//        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:myFrame3 cornerRadius:1];
        CGContextSaveGState(context);
        [roundedRectanglePath fill];
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, yVal), CGPointMake((CGFloat)[xVals[i] floatValue], yVal), 0);
//        if(globalShare.myLanguage == ARABIC_LANGUAGE)
//            CGContextDrawLinearGradient(context, gradient, CGPointMake((CGFloat)[xVals[i] floatValue], yVal), CGPointMake(0, yVal), 0);
//        else
//            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, yVal), CGPointMake((CGFloat)[xVals[i] floatValue], yVal), 0);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
    }

//    [[UIColor redColor] setStroke];
//    [path stroke];
    
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.frame;
//    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor ];
//    gradientLayer.startPoint = CGPointMake(0,0);
//    gradientLayer.endPoint = CGPointMake(1,0);
//    
//    [self.layer addSublayer:gradientLayer];
    
    
//    CGAffineTransform t = CGAffineTransformMakeScale(1, -1);
//    self.transform = t;
//    CGFloat baseline = 50;
//    CGFloat inset = 40;
//    CGFloat barWidth = 20;
//    CGFloat barHeight = 80;
//    
//    CGRect r = CGRectMake(inset + barWidth, baseline, barWidth, barHeight);
//    UIBezierPath *p = [UIBezierPath bezierPathWithRect:r];
//    [[UIColor lightGrayColor] set];
//    [p fill];
//    p = [UIBezierPath bezierPath];
//    
//    [p moveToPoint:CGPointMake(inset, baseline)];
//    [p addLineToPoint:CGPointMake(inset + 3 * barWidth, baseline)];
//    [[UIColor lightGrayColor] set];
//    [p stroke];
    
    
//    //// General Declarations
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //// Color Declarations
//    UIColor* main_color_1 = [UIColor colorWithRed: 0.29 green: 0.357 blue: 0.133 alpha: 1];
//    UIColor* main_color_2 = [UIColor colorWithRed: 0.341 green: 0.412 blue: 0.153 alpha: 1];
//    UIColor* main_color_3 = [UIColor colorWithRed: 0.424 green: 0.498 blue: 0.243 alpha: 1];
//    UIColor* main_color_4 = [UIColor colorWithRed: 0.514 green: 0.592 blue: 0.337 alpha: 1];
//    UIColor* main_color_5 = [UIColor colorWithRed: 0.482 green: 0.561 blue: 0.306 alpha: 1];
//    UIColor* back_rect_1 = [UIColor colorWithRed: 0.145 green: 0.141 blue: 0.141 alpha: 1];
//    UIColor* back_rect_2 = [UIColor colorWithRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
//    UIColor* back_rect_3 = [UIColor colorWithRed: 0.416 green: 0.416 blue: 0.416 alpha: 1];
//    UIColor* back_rect_4 = [UIColor colorWithRed: 0.439 green: 0.439 blue: 0.439 alpha: 1];
//    UIColor* bacK_rect_shadow = [UIColor colorWithRed: 0.145 green: 0.145 blue: 0.145 alpha: 1];
//    
//    //// Gradient Declarations
//    NSArray* main_gradientColors = [NSArray arrayWithObjects:
//                                    (id)main_color_1.CGColor,
//                                    (id)main_color_2.CGColor,
//                                    (id)main_color_3.CGColor,
//                                    (id)main_color_4.CGColor,
//                                    (id)main_color_5.CGColor, nil];
//    CGFloat main_gradientLocations[] = {0, 0.15, 0.43, 0.78, 1};
//    CGGradientRef main_gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)main_gradientColors, main_gradientLocations);
//    NSArray* back_rect_gradientColors = [NSArray arrayWithObjects:
//                                         (id)back_rect_1.CGColor,
//                                         (id)back_rect_2.CGColor,
//                                         (id)back_rect_3.CGColor,
//                                         (id)back_rect_4.CGColor, nil];
//    CGFloat back_rect_gradientLocations[] = {0, 0.35, 0.91, 1};
//    CGGradientRef back_rect_gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)back_rect_gradientColors, back_rect_gradientLocations);
//    
//    //// Shadow Declarations
//    UIColor* shadow = bacK_rect_shadow;
//    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
//    CGFloat shadowBlurRadius = 12;
//    
//    //// back_rect Drawing
//    UIBezierPath* back_rectPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.frame.size.width, 26.5)];
//    CGContextSaveGState(context);
//    [back_rectPath addClip];
//    CGContextDrawLinearGradient(context, back_rect_gradient, CGPointMake(148.5, 0), CGPointMake(148.5, 26.5), 0);
//    CGContextRestoreGState(context);
//    
//    ////// back_rect Inner Shadow
//    CGRect back_rectBorderRect = CGRectInset([back_rectPath bounds], -shadowBlurRadius, -shadowBlurRadius);
//    back_rectBorderRect = CGRectOffset(back_rectBorderRect, -shadowOffset.width, -shadowOffset.height);
//    back_rectBorderRect = CGRectInset(CGRectUnion(back_rectBorderRect, [back_rectPath bounds]), -1, -1);
//    
//    UIBezierPath* back_rectNegativePath = [UIBezierPath bezierPathWithRect: back_rectBorderRect];
//    [back_rectNegativePath appendPath: back_rectPath];
//    back_rectNegativePath.usesEvenOddFillRule = YES;
//    
//    CGContextSaveGState(context);
//    {
//        CGFloat xOffset = shadowOffset.width + round(back_rectBorderRect.size.width);
//        CGFloat yOffset = shadowOffset.height;
//        CGContextSetShadowWithColor(context,
//                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
//                                    shadowBlurRadius,
//                                    shadow.CGColor);
//        
//        [back_rectPath addClip];
//        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(back_rectBorderRect.size.width), 0);
//        [back_rectNegativePath applyTransform: transform];
//        [[UIColor grayColor] setFill];
//        [back_rectNegativePath fill];
//    }
//    CGContextRestoreGState(context);
//    
//    //// main_rect Drawing
//    UIBezierPath* main_rectPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0.1, 10, 26.5)];
//    CGContextSaveGState(context);
//    [main_rectPath addClip];
//    CGContextDrawLinearGradient(context, main_gradient, CGPointMake(116, 0), CGPointMake(116, 26.5), 0);
//    CGContextRestoreGState(context);
//    
//    
//    //// Cleanup
//    CGGradientRelease(main_gradient);
//    CGGradientRelease(back_rect_gradient);
//    CGColorSpaceRelease(colorSpace);
}


@end
