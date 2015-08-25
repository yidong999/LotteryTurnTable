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

static inline void drawArc(CGContextRef ctx, CGPoint point, float radius,float angle_start, float angle_end, UIColor* color) {
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataDic
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderWidth = 4;
        self.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
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
    
    
    UIColor *yelloColor = [UIColor colorWithRed:249/255.0 green:218/255.0 blue:160/255.0 alpha:1];
    UIColor *redColor = [UIColor colorWithRed:241/255.0 green:107/255.0 blue:60/255.0 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:121/255.0 green:174/255.0 blue:218/255.0 alpha:1];
    UIColor *pinkColor = [UIColor colorWithRed:222/255.0 green:127/255.0 blue:155/255.0 alpha:1];
    UIColor *purpleColor = [UIColor colorWithRed:117/255.0 green:94/255.0 blue:160/255.0 alpha:1];
    for (NSString *key in self.cornerDic) {
        angle_start = angle_end;
        angle_end = angle_start+ radians([(NSNumber*)self.cornerDic[key] doubleValue]);
        
        UIColor *color = nil;
        if (i%5 == 0) {
            color = yelloColor;
        }
        else if(i%5 == 1)
        {
            color = redColor;
        }
        else if (i%5 == 2)
        {
            color = blueColor;
        }
        else if (i%5 == 3)
        {
            color = pinkColor;
        }
        else if (i%5 == 4)
        {
            color = purpleColor;
        }
        drawArc(ctx, center, self.frame.size.width/2-self.layer.borderWidth, angle_start, angle_end, color);
        i++;

        CATextLayer *txtLayer = [CATextLayer layer];
        txtLayer.frame = CGRectMake(0, 0, self.frame.size.width-10, 20);
        txtLayer.anchorPoint = CGPointMake(0.5, 0.5);
        txtLayer.string = (NSString*)key;
        txtLayer.alignmentMode = [NSString stringWithFormat:@"right"];
        txtLayer.fontSize = 18;
        [txtLayer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.width/2)];
        txtLayer.transform = CATransform3DMakeRotation(angle_start + (angle_end-angle_start)/2,0,0,1);
        [self.layer addSublayer:txtLayer];
    }
}

@end
