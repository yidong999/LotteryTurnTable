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
    //设置填充颜色
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    //移动画笔
    CGContextMoveToPoint(ctx, point.x, point.y);
    //画扇形
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    //填充
    CGContextFillPath(ctx);

    //画中间的白色分割线
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    //设置线条宽度
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, point.x, point.y);
    //算出线另一端的坐标
    CGPoint point1 = CGPointMake(point.x + radius*cos(angle_start), point.y + radius*sin(angle_start));
    //画线
    CGContextAddLineToPoint(ctx, point1.x, point1.y);
    CGContextStrokePath(ctx);
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataDic
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderWidth = 9;
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
    
    //遍历字典，画饼
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
        //画扇形
        drawArc(ctx, center, self.frame.size.width/2-self.layer.borderWidth, angle_start, angle_end, color);
        i++;

        CATextLayer *txtLayer = [self textLayer:key rotate:angle_start + (angle_end-angle_start)/2];
        [self.layer addSublayer:txtLayer];
//        }
    }
}

- (CATextLayer*)textLayer:(NSString*)text rotate:(CGFloat)angel
{
    CATextLayer *txtLayer = [CATextLayer layer];
    //设置每个layer的长度都为转盘的直径
    txtLayer.frame = CGRectMake(0, 0, self.frame.size.width-self.layer.borderWidth*2-8, 25);
    
    //设置锚点，绕中心点旋转
    txtLayer.anchorPoint = CGPointMake(0.5, 0.5);
    txtLayer.string = text;
    txtLayer.alignmentMode = [NSString stringWithFormat:@"right"];
    txtLayer.fontSize = 18;
    
    //layer没有center，用Position
    [txtLayer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.width/2)];
    //旋转
    txtLayer.transform = CATransform3DMakeRotation(angel,0,0,1);
    return txtLayer;
}

@end
