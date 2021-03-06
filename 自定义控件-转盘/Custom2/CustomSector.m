//
//  CustomSector.m
//  转盘
//
//  Created by 焦英博 on 2017/3/14.
//  Copyright © 2017年 jyb. All rights reserved.
//

#import "CustomSector.h"
#import "SectorLayer.h"
#import "SectorMath.h"

@interface CustomSector ()

@property (nonatomic, strong) SectorLayer *firstLayer;
@property (nonatomic, strong) SectorLayer *secondLayer;
@property (nonatomic, strong) SectorLayer *thirdLayer;
@property (nonatomic, strong) SectorLayer *currentSector;

@property (nonatomic, assign) double startAngle;

@end

@implementation CustomSector

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _width = 25;
        _radius = 80;
        _startAngle = 1;
        [self initSubLayers];
    }
    return self;
}

#pragma mark - initUI

- (void)initSubLayers {
    _firstLayer = [SectorLayer layer];
    _firstLayer.contentsScale = [UIScreen mainScreen].scale;
    _firstLayer.customSector = self;
    _firstLayer.minAngle = _startAngle;
    _firstLayer.maxAngle = _firstLayer.minAngle + 0.6*M_PI;
    _firstLayer.endAngle = _firstLayer.minAngle;
    _firstLayer.startAngle = _firstLayer.maxAngle;
    _firstLayer.color = [UIColor colorWithRed:(26)/255.0 green:(158)/255.0 blue:(198)/255.0 alpha:1.0];
    [self.layer addSublayer:_firstLayer];
    
    _secondLayer = [SectorLayer layer];
    _secondLayer.contentsScale = [UIScreen mainScreen].scale;
    _secondLayer.customSector = self;
    _secondLayer.minAngle = _startAngle + 0.6*M_PI + M_PI/15;
    _secondLayer.maxAngle = _secondLayer.minAngle + 0.6*M_PI;
    _secondLayer.endAngle = _secondLayer.minAngle;
    _secondLayer.startAngle = _secondLayer.maxAngle;
    _secondLayer.color = [UIColor colorWithRed:(255)/255.0 green:(115)/255.0 blue:(100)/255.0 alpha:1.0];
    [self.layer addSublayer:_secondLayer];
    
    _thirdLayer = [SectorLayer layer];
    _thirdLayer.contentsScale = [UIScreen mainScreen].scale;
    _thirdLayer.customSector = self;
    _thirdLayer.minAngle = _startAngle + (0.6*M_PI + M_PI/15)*2;
    _thirdLayer.maxAngle = _thirdLayer.minAngle + 0.6*M_PI;
    _thirdLayer.endAngle = _thirdLayer.minAngle;
    _thirdLayer.startAngle = _thirdLayer.maxAngle;
    _thirdLayer.color = [UIColor colorWithRed:(180)/255.0 green:(100)/255.0 blue:(251)/255.0 alpha:1.0];
    [self.layer addSublayer:_thirdLayer];
    
    [self updateLayers];
}

- (void)updateLayers {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _firstLayer.frame = self.bounds;
    [_firstLayer setNeedsDisplay];
    
    _secondLayer.frame = self.bounds;
    [_secondLayer setNeedsDisplay];
    
    _thirdLayer.frame = self.bounds;
    [_thirdLayer setNeedsDisplay];
    
    [CATransaction setDisableActions:NO];
    [CATransaction commit];
}

#pragma mark - setter

- (void)setWidth:(CGFloat)width {
    _width = width;
    [self updateLayers];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self updateLayers];
}

#pragma mark - actions

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    for (SectorLayer *sector in self.layer.sublayers) {
        CGPoint touchPoint = [touch locationInView:self];
        
        UIBezierPath *startPath = [self bezierPathWithSector:sector start:YES];
        if ([startPath containsPoint:touchPoint]) {
            sector.moveStart = YES;
            _currentSector = sector;
            return YES;
        }
        
        UIBezierPath *endPath = [self bezierPathWithSector:sector start:NO];
        if ([endPath containsPoint:touchPoint]) {
            sector.moveStart = NO;
            _currentSector = sector;
            return YES;
        }
    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    PolarCoordinate polar = decartToPolar(_currentSector.center, touchPoint);
    
    if (_currentSector.moveStart) {
        if (_currentSector.maxAngle >= 2*M_PI) {
            // 超出2π的区间
            if (polar.angle > 0 && polar.angle <= _currentSector.maxAngle - 2*M_PI) {
                _currentSector.startAngle = MAX(polar.angle + 2*M_PI, _currentSector.endAngle);
                NSLog(@"==>%f",MAX(polar.angle + 2*M_PI, _currentSector.endAngle));
            }
            // 临界点
            else if (polar.angle == 0 || polar.angle == 2*M_PI) {
                _currentSector.startAngle = 2*M_PI;
            }
            // 超出最大范围
//            else if (polar.angle > _currentSector.maxAngle - 2*M_PI) {
//                _currentSector.startAngle = _currentSector.maxAngle;
//            }
            // 未超出的区间
            else {
                _currentSector.startAngle = MAX(polar.angle, _currentSector.endAngle);
                NSLog(@"-->%f",MAX(polar.angle, _currentSector.endAngle));
            }
        } else {
            if (polar.angle >= _currentSector.endAngle && polar.angle <= _currentSector.maxAngle) {
                _currentSector.startAngle = MAX(polar.angle, _currentSector.endAngle);
            } else {
                _currentSector.startAngle = _currentSector.maxAngle;
            }
        }
        
    } else {
        if (_currentSector.maxAngle >= 2*M_PI) {
            if (polar.angle) {
                
            }
        } else {
            if (polar.angle >= _currentSector.minAngle && polar.angle <= _currentSector.startAngle) {
                _currentSector.endAngle = MIN(polar.angle, _currentSector.startAngle);
            } else {
                _currentSector.endAngle = _currentSector.minAngle;
            }
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [_currentSector setNeedsDisplay];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _currentSector = nil;
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    _currentSector = nil;
}

#pragma mark - public method

- (UIBezierPath *)bezierPathWithSector:(SectorLayer *)layer start:(BOOL)isStart {
    CGPoint point = isStart ? layer.startPoint : layer.endPoint;
    
    PolarCoordinate polar = decartToPolar(layer.center, point);
    CGPoint insidePoint1 = polarToDecart(layer.center, polar.radius - 10, polar.angle - 6*M_PI/180);
    CGPoint insidePoint2 = polarToDecart(layer.center, polar.radius - 10, polar.angle + 6*M_PI/180);
    CGPoint outsidePoint1 = polarToDecart(layer.center, polar.radius + 80, polar.angle - 6*M_PI/180);
    CGPoint outsidePoint2 = polarToDecart(layer.center, polar.radius + 80, polar.angle + 6*M_PI/180);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(insidePoint1.x, insidePoint1.y)];
    [path addLineToPoint:CGPointMake(insidePoint2.x, insidePoint2.y)];
    [path addLineToPoint:CGPointMake(outsidePoint2.x, outsidePoint2.y)];
    [path addLineToPoint:CGPointMake(outsidePoint1.x, outsidePoint1.y)];
    [path addLineToPoint:CGPointMake(insidePoint1.x, insidePoint1.y)];
    
    return path;
}

@end
