//
//  SectorMath.h
//  转盘
//
//  Created by 焦英博 on 2017/3/14.
//  Copyright © 2017年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct{
    double radius;
    double angle;
} PolarCoordinate;

PolarCoordinate decartToPolar(CGPoint center, CGPoint point);

CGPoint polarToDecart(CGPoint startPoint, CGFloat radius, CGFloat angle);
