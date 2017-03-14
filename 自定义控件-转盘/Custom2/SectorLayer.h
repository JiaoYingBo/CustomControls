//
//  SectorLayer.h
//  转盘
//
//  Created by 焦英博 on 2017/3/14.
//  Copyright © 2017年 jyb. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class CustomSector;
@interface SectorLayer : CALayer

@property (nonatomic, weak) CustomSector *customSector;
@property (nonatomic, assign) double minAngle;   // 最小角度
@property (nonatomic, assign) double maxAngle;   // 最大角度
@property (nonatomic, assign) double endAngle;   // 尾角度，默认值为minAngle
@property (nonatomic, assign) double startAngle; // 始角度，默认值为maxAngle
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign, readonly) CGPoint center; // 中点
@property (nonatomic, assign) CGPoint endPoint;  // 尾中点
@property (nonatomic, assign) CGPoint startPoint;// 始中点
@property (nonatomic, assign) BOOL moveStart;    // YES移动start滑竿，NO移动end滑竿

@end
