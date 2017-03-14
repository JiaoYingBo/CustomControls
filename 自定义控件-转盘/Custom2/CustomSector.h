//
//  CustomSector.h
//  转盘
//
//  Created by 焦英博 on 2017/3/14.
//  Copyright © 2017年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectorLayer;
@interface CustomSector : UIControl

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) double startAngle;
- (UIBezierPath *)bezierPathWithSector:(SectorLayer *)layer start:(BOOL)isStart;
@end
