//
//  ViewController.m
//  转盘
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "ViewController.h"
#import "Custom.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beij"]];
    img.frame = self.view.bounds;
    [self.view addSubview:img];
    
    Custom *custom = [[Custom alloc] initWithFrame:CGRectMake(0, 90, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width)];
    custom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:custom];
    [custom addTarget:self action:@selector(sectorValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)sectorValueChanged:(Custom *)sender
{
    Sector *sector1 = [sender.sectors objectAtIndex:0];
    NSLog(@"%f  %f",sector1.startValue,sector1.endValue);
}


@end
