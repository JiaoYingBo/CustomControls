//
//  SectorLayer.m
//  转盘
//
//  Created by 焦英博 on 2017/3/14.
//  Copyright © 2017年 jyb. All rights reserved.
//

#import "SectorLayer.h"
#import "CustomSector.h"
#import "SectorMath.h"

@interface SectorLayer ()

@property (nonatomic, assign, readwrite) CGPoint center;

@end

@implementation SectorLayer

- (void)drawInContext:(CGContextRef)ctx {
    if (_customSector) {
        // 圆弧
        CGContextSetLineWidth(ctx, 25);
        
        UIColor *bottomColor = [UIColor colorWithWhite:1 alpha:0.5];
        UIColor *topColor = [UIColor colorWithWhite:1 alpha:1];
        
        CGContextSetStrokeColorWithColor(ctx, bottomColor.CGColor);
        CGContextAddArc(ctx, self.center.x, self.center.y, _customSector.radius, _minAngle, _maxAngle, 0);
        CGContextStrokePath(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, topColor.CGColor);
        CGContextAddArc(ctx, self.center.x, self.center.y, _customSector.radius, _endAngle, _startAngle, 0);
        CGContextStrokePath(ctx);
        
        // 直线
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
        
        CGPoint endInsidePoint = polarToDecart(self.center, _customSector.radius - 15, _endAngle);
        CGPoint endOutsidePoint = polarToDecart(self.center, _customSector.radius + 15, _endAngle);
        
        CGContextMoveToPoint(ctx, endInsidePoint.x, endInsidePoint.y);
        CGContextAddLineToPoint(ctx, endOutsidePoint.x, endOutsidePoint.y);
        CGContextStrokePath(ctx);
        
        CGPoint startInsidePoint = polarToDecart(self.center, _customSector.radius - 15, _startAngle);
        CGPoint startOutsidePoint = polarToDecart(self.center, _customSector.radius + 15, _startAngle);
        
        CGContextMoveToPoint(ctx, startInsidePoint.x, startInsidePoint.y);
        CGContextAddLineToPoint(ctx, startOutsidePoint.x, startOutsidePoint.y);
        CGContextStrokePath(ctx);
        
        // 扇形
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
        CGContextSetFillColorWithColor(ctx, _color.CGColor);
        
        CGContextMoveToPoint(ctx, endOutsidePoint.x, endOutsidePoint.y);
        CGContextAddArc(ctx, endOutsidePoint.x, endOutsidePoint.y, 10, _endAngle - 0.2*M_PI, _endAngle + 0.2*M_PI, 0);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGContextMoveToPoint(ctx, startOutsidePoint.x, startOutsidePoint.y);
        CGContextAddArc(ctx, startOutsidePoint.x, startOutsidePoint.y, 10, _startAngle - 0.2*M_PI, _startAngle + 0.2*M_PI, 0);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        
        UIBezierPath *beginPath = [_customSector bezierPathWithSector:self start:YES];
        CGContextAddPath(ctx, beginPath.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
        UIBezierPath *endPath = [_customSector bezierPathWithSector:self start:NO];
        CGContextAddPath(ctx, endPath.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
        
    }
}

#pragma mark - getter

-(CGPoint)center {
    return CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}

- (CGPoint)endPoint {
    return polarToDecart(self.center, _customSector.radius, self.endAngle);
}

- (CGPoint)startPoint {
    return polarToDecart(self.center, _customSector.radius, self.startAngle);
}

@end
