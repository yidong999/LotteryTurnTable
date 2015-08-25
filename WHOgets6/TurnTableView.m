//
//  TurnTableView.m
//  WHOgets6
//
//  Created by 王雪利 on 15/8/24.
//  Copyright (c) 2015年 王雪利. All rights reserved.
//

#import "TurnTableView.h"

@implementation TurnTableView

static inline float radians(double degrees) {
    return degrees * M_PI / 180;
}

static inline void drawArc(CGContextRef ctx, CGPoint point, float radius,float angle_start, float angle_end, UIColor* color)
{
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);

    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGPoint point1 = CGPointMake(point.x + radius*cos(angle_start), point.y + radius*sin(angle_start));
    CGContextAddLineToPoint(ctx, point1.x, point1.y);
    CGContextStrokePath(ctx);
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataDic
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderWidth = 10;
        self.layer.borderColor = [UIColor colorWithRed:243/255.0 green:88/255.0 blue:31/255.0 alpha:1].CGColor;
        [self setData:dataDic];
    }
    return self;
}

- (void)setData:(NSDictionary*)dataDic
{
    self.cornerDic = [[NSMutableDictionary alloc]init];
    int totalCount = 0;
    for (NSString *key in dataDic) {
        totalCount += [(NSNumber*)dataDic[key] intValue];
    }
    
    for (NSString *key in dataDic) {
        double corner = [(NSNumber*)dataDic[key] doubleValue]/(double)totalCount * 360;
        [self.cornerDic setObject:@(corner) forKey:key];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

    srand((unsigned)time(0));
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    
    float angle_start = 0;
    float angle_end = 0;
    int i = 0;
    
    
    UIColor *yelloColor = [UIColor colorWithRed:249/255.0 green:226/255.0 blue:55/255.0 alpha:1];
    UIColor *redColor = [UIColor colorWithRed:247/255.0 green:148/255.0 blue:53/255.0 alpha:1];
    for (NSString *key in self.cornerDic) {
//        if ([key isEqualToString:@"Imp"]) {
        
        angle_start = angle_end;
        angle_end = angle_start+ radians([(NSNumber*)self.cornerDic[key] doubleValue]);
        
        UIColor *color = nil;
        if (i%2 == 0) {
            color = yelloColor;
        }
        else
        {
            color = redColor;
        }
        drawArc(ctx, center, self.frame.size.width/2-self.layer.borderWidth, angle_start, angle_end, color);
        i++;

        CATextLayer *txtLayer = [CATextLayer layer];
        txtLayer.frame = CGRectMake(0, 0, self.frame.size.width-self.layer.borderWidth*2-2, 25);
        txtLayer.anchorPoint = CGPointMake(0.5, 0.5);
        txtLayer.string = (NSString*)key;
        txtLayer.alignmentMode = [NSString stringWithFormat:@"right"];
        txtLayer.fontSize = 18;
//        txtLayer.font = [UIFont fontWithName:<#(NSString *)#> size:(CGFloat)]
        [txtLayer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.width/2)];
        txtLayer.transform = CATransform3DMakeRotation(angle_start + (angle_end-angle_start)/2,0,0,1);
        [self.layer addSublayer:txtLayer];
//        }
    }
}

@end
