//
//  ViewController.m
//  DZCameraDrawDemo
//
//  Created by Chris on 16/10/27.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "ViewController.h"
#import "DZCameraViewController.h"

#define KWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 100)];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(btnClink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnClink{
    
    DZCameraViewController *cemaraVC = [[DZCameraViewController alloc] init];
    [self presentViewController:cemaraVC animated:YES completion:nil];
    
}

@end
