//
//  Custom.h
//  转盘
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Custom : UIControl

@property (nonatomic, strong) NSMutableArray *sectors;

@end


@interface Sector : NSObject

@property (nonatomic, readwrite) double minValue;
@property (nonatomic, readwrite) double maxValue;

@property (nonatomic, readwrite) double startValue;
@property (nonatomic, readwrite) double endValue;

@property (nonatomic, readwrite) double minAngle;
@property (nonatomic, readwrite) double maxAngle;

@property (nonatomic, readwrite) CGPoint startPoint;
@property (nonatomic, readwrite) CGPoint endPoint;

@property (nonatomic, readwrite) double startAngle;
@property (nonatomic, readwrite) double endAngle;

@property (nonatomic, readwrite) UIColor *color;
@property (nonatomic, readwrite) CGPoint centerPoint;
@property (nonatomic, readwrite) double currentAngle;

@property (nonatomic, assign)    BOOL   isStart;
@property (nonatomic, assign)    NSInteger tag;

- (instancetype)initWithStartAngle:(double)angle color:(UIColor *)color centerPoint:(CGPoint)point;

@end
