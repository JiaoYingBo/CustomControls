//
//  Custom.m
//  转盘
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "Custom.h"

#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define VioletColor ZFColor(180, 100, 251)
#define OrangeColor ZFColor(255, 115, 100)
#define BlueColor ZFColor(26, 158, 198)
#define Circle_Width   80

// 极坐标
typedef struct{
    double radius;
    double angle;
} PolarCoordinate;

/**
 * 直角坐标转极坐标
 * r = √（x² + y²）
 * θ = atan(y/x)  atan:反正切(主值), 结果介于[-PI/2, PI/2]
 * acos反余弦 结果介于[0, PI]
 */
static PolarCoordinate decartToPolar(CGPoint center, CGPoint point){
    double x = point.x - center.x;
    double y = point.y - center.y;
    
    PolarCoordinate polar;
    polar.radius = sqrt(pow(x, 2.0) + pow(y, 2.0));
    polar.angle = acos(x/polar.radius);
    if(y < 0) polar.angle = 2 * M_PI - polar.angle;
    return polar;
}

/**
 * 极坐标转直角坐标
 * x = rcos（θ）
 * y = rsin（θ）
 */
static CGPoint polarToDecart(CGPoint startPoint, CGFloat radius, CGFloat angle){
    CGFloat x = radius * cos(angle) + startPoint.x;
    CGFloat y = radius * sin(angle) + startPoint.y;
    return CGPointMake(x, y);
}

@interface Custom () {
    Sector *_currentSector;
}

@end

@implementation Custom

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _sectors = [[NSMutableArray alloc] initWithCapacity:3];
        
        CGPoint centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        Sector *sector1 = [[Sector alloc] initWithStartAngle:0 color:BlueColor centerPoint:centerPoint];
        sector1.tag = 1;
        
        Sector *sector2 = [[Sector alloc] initWithStartAngle:0.6*M_PI+M_PI/15 color:OrangeColor centerPoint:centerPoint];
        sector2.tag = 2;
        
        Sector *sector3 = [[Sector alloc] initWithStartAngle:(0.6*M_PI+M_PI/15)*2 color:VioletColor centerPoint:centerPoint];
        sector3.tag = 3;
        
        [_sectors addObject:sector1];
        [_sectors addObject:sector2];
        [_sectors addObject:sector3];
        
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    for (Sector *sector in _sectors) {
        CGPoint touchPoint = [touch locationInView:self];
        
        UIBezierPath *beginPath = [self bezierPathWithCenter:sector start:YES];
        if ([beginPath containsPoint:touchPoint]) {
            sector.isStart = YES;
            _currentSector = sector;
            return YES;
        }
        
        UIBezierPath *endPath = [self bezierPathWithCenter:sector start:NO];
        if ([endPath containsPoint:touchPoint]) {
            sector.isStart = NO;
            _currentSector = sector;
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    PolarCoordinate polar = decartToPolar(_currentSector.centerPoint, touchPoint);
    
    _currentSector.currentAngle = polar.angle;
    
    if (_currentSector.isStart) {
        if (polar.angle>=_currentSector.minAngle && polar.angle<=_currentSector.maxAngle) {
            _currentSector.startAngle = MIN(polar.angle, _currentSector.endAngle);
        } else {
            _currentSector.startAngle = _currentSector.minAngle;
        }
    } else {
        if (polar.angle>=_currentSector.minAngle && polar.angle<=_currentSector.maxAngle) {
            _currentSector.endAngle = MAX(polar.angle, _currentSector.startAngle);
        } else {
            _currentSector.endAngle = _currentSector.maxAngle;
        }
    }
    
    _currentSector.startPoint = polarToDecart(_currentSector.centerPoint, Circle_Width, _currentSector.startAngle);
    _currentSector.endPoint = polarToDecart(_currentSector.centerPoint, Circle_Width, _currentSector.endAngle);
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _currentSector = nil;
}

- (void)drawRect:(CGRect)rect {
    
    for (NSInteger i = 0; i < _sectors.count; i ++) {
        
        Sector *sector = [_sectors objectAtIndex:i];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 圆弧
        CGContextSetLineWidth(context, 25);
        
        UIColor *bottomColor = [UIColor colorWithWhite:1 alpha:0.5];
        UIColor *topColor = [UIColor colorWithWhite:1 alpha:1];
        
        [bottomColor setStroke];
        CGContextAddArc(context, sector.centerPoint.x, sector.centerPoint.y, Circle_Width, sector.minAngle, sector.minAngle+0.6*M_PI, 0);
        CGContextStrokePath(context);
        
        [topColor setStroke];
        CGContextAddArc(context, sector.centerPoint.x, sector.centerPoint.y, Circle_Width, sector.startAngle, sector.endAngle, 0);
        CGContextStrokePath(context);
        
        
        // 直线
        [sector.color setStroke];
        CGContextSetLineWidth(context, 2.0);
        
        CGPoint beginSmallPoint = polarToDecart(sector.centerPoint, Circle_Width-15, sector.startAngle);
        CGPoint beginBigPoint = polarToDecart(sector.centerPoint, Circle_Width+15, sector.startAngle);
        
        CGContextMoveToPoint(context, beginSmallPoint.x, beginSmallPoint.y);
        CGContextAddLineToPoint(context, beginBigPoint.x, beginBigPoint.y);
        CGContextStrokePath(context);
        
        
        CGPoint endSmallPoint = polarToDecart(sector.centerPoint, Circle_Width-15, sector.endAngle);
        CGPoint endBigPoint = polarToDecart(sector.centerPoint, Circle_Width+15, sector.endAngle);
        
        CGContextMoveToPoint(context, endSmallPoint.x, endSmallPoint.y);
        CGContextAddLineToPoint(context, endBigPoint.x, endBigPoint.y);
        CGContextStrokePath(context);
        
        // 扇形
        CGContextSetLineWidth(context, 2.0);
        [sector.color setStroke];
        [sector.color setFill];
        CGContextMoveToPoint(context, beginBigPoint.x, beginBigPoint.y);
        CGContextAddArc(context, beginBigPoint.x, beginBigPoint.y, 10, sector.startAngle-0.2*M_PI, sector.startAngle+0.2*M_PI, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextMoveToPoint(context, endBigPoint.x, endBigPoint.y);
        CGContextAddArc(context, endBigPoint.x, endBigPoint.y, 10, sector.endAngle-0.2*M_PI, sector.endAngle+0.2*M_PI, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        NSString *startString = @"end";
        NSString *endString   = @"start";
        
        PolarCoordinate strBeginPolar = decartToPolar(sector.centerPoint, sector.startPoint);
        CGPoint strstartPoint = polarToDecart(sector.centerPoint, strBeginPolar.radius+50, strBeginPolar.angle);
        
        PolarCoordinate strEndPolar = decartToPolar(sector.centerPoint, sector.endPoint);
        CGPoint strEndPoint = polarToDecart(sector.centerPoint, strEndPolar.radius+50, strEndPolar.angle);
        
        [self drawString:startString
                withFont:[UIFont systemFontOfSize:17]
                andColor:[UIColor whiteColor]
               andCenter:strstartPoint
                  andTag:sector.tag
                  radius:strBeginPolar.radius+50];
        
        [self drawString:endString
                withFont:[UIFont systemFontOfSize:17]
                andColor:[UIColor whiteColor]
               andCenter:strEndPoint
                  andTag:sector.tag
                  radius:strEndPolar.radius+50];
        
        
        // 画触摸区域
        [self drawBezier:sector];
    }
    
}

- (void)drawString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color andCenter:(CGPoint)center andTag:(NSInteger)tag radius:(CGFloat)radius {
    CGPoint point = CGPointMake(center.x -13, center.y -13);
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [attr setValue:font forKey:NSFontAttributeName];
    [attr setValue:color forKey:NSForegroundColorAttributeName];
    
    [string drawAtPoint:point withAttributes:attr];
}

- (void)drawBezier:(Sector *)sector {
    [[UIColor redColor] set];
    UIBezierPath *beginPath = [self bezierPathWithCenter:sector start:YES];
    [beginPath stroke];
    
    [[UIColor greenColor] set];
    UIBezierPath *endPath = [self bezierPathWithCenter:sector start:NO];
    [endPath stroke];
}

// 创建滑竿的触摸区域
- (UIBezierPath *)bezierPathWithCenter:(Sector *)sector start:(BOOL)isStart {
    CGPoint point = isStart ? sector.startPoint : sector.endPoint;
    PolarCoordinate beginPolar = decartToPolar(sector.centerPoint, point);
    CGPoint beginSmallPoint1 = polarToDecart(sector.centerPoint, beginPolar.radius-10, beginPolar.angle-6*M_PI/180);
    CGPoint beginSmallPoint2 = polarToDecart(sector.centerPoint, beginPolar.radius-10, beginPolar.angle+6*M_PI/180);
    CGPoint beginBigPoint1 = polarToDecart(sector.centerPoint, beginPolar.radius+80, beginPolar.angle-6*M_PI/180);
    CGPoint beginBigPoint2 = polarToDecart(sector.centerPoint, beginPolar.radius+80, beginPolar.angle+6*M_PI/180);
    
    UIBezierPath *beginPath = [[UIBezierPath alloc] init];
    [beginPath moveToPoint:CGPointMake(beginSmallPoint1.x, beginSmallPoint1.y)];
    [beginPath addLineToPoint:CGPointMake(beginSmallPoint2.x, beginSmallPoint2.y)];
    [beginPath addLineToPoint:CGPointMake(beginBigPoint2.x, beginBigPoint2.y)];
    [beginPath addLineToPoint:CGPointMake(beginBigPoint1.x, beginBigPoint1.y)];
    [beginPath addLineToPoint:CGPointMake(beginSmallPoint1.x, beginSmallPoint1.y)];
    
    return beginPath;
}

@end


@implementation Sector

- (instancetype)initWithStartAngle:(double)angle color:(UIColor *)color centerPoint:(CGPoint)point {
    if (self = [super init]) {
        self.color = color;
        self.minValue = 0.0;      // 最小值
        self.maxValue = 100.0;    // 最大值
        self.startValue = 0.0;    // 起始值
        self.endValue = 100.0;    // 结束值
        self.centerPoint = point; // 中心点
        self.minAngle = angle;    // 最小弧度
        self.maxAngle = self.minAngle+0.6*M_PI;  // 最大弧度
        self.startAngle = self.minAngle;         // 起始弧度
        self.endAngle = self.startAngle+0.6*M_PI;// 结束弧度
        self.startPoint = polarToDecart(self.centerPoint, Circle_Width, self.startAngle); // 起始坐标
        self.endPoint = polarToDecart(self.centerPoint, Circle_Width, self.endAngle);     // 结束坐标
    }
    return self;
}

- (double)startValue {
    double start = (self.startAngle - self.minAngle)/(0.6*M_PI);
    return start;
}

- (double)endValue {
    double end = (self.endAngle - self.minAngle)/(0.6*M_PI);
    return end;
}

@end































