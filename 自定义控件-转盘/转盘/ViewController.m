//
//  ViewController.m
//  转盘
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "ViewController.h"
#import "CustomSector.h"
#import "Custom.h"

@interface ViewController ()

@property (nonatomic, strong) Custom *custom1;
@property (nonatomic, strong) CustomSector *custom2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beij"]];
    img.frame = self.view.bounds;
    [self.view insertSubview:img atIndex:0];
    
    [self.view addSubview:self.custom1];
}

- (IBAction)segmentedClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.custom2 removeFromSuperview];
        [self.view addSubview:self.custom1];
    } else {
        [self.custom1 removeFromSuperview];
        [self.view addSubview:self.custom2];
    }
}

#pragma mark - 写法一
- (Custom *)custom1 {
    if (!_custom1) {
        _custom1 = [[Custom alloc] initWithFrame:CGRectMake(0, 90, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width)];
        _custom1.backgroundColor = [UIColor clearColor];
        [_custom1 addTarget:self action:@selector(sectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _custom1;
}

- (void)sectorValueChanged:(Custom *)sender {
//    Sector *sector1 = [sender.sectors objectAtIndex:0];
//    NSLog(@"%f  %f",sector1.startValue,sector1.endValue);
//    Sector *sector2 = [sender.sectors objectAtIndex:1];
//    NSLog(@"%f  %f",sector2.startValue,sector2.endValue);
//    Sector *sector3 = [sender.sectors objectAtIndex:2];
//    NSLog(@"%f  %f",sector3.startValue,sector3.endValue);
}

#pragma mark - 写法二
- (CustomSector *)custom2 {
    if (!_custom2) {
        _custom2 = [[CustomSector alloc] initWithFrame:CGRectMake(0, 90, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width)];
        _custom2.backgroundColor = [UIColor clearColor];
    }
    return _custom2;
}

@end
