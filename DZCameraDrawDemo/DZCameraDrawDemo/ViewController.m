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

@property (nonatomic, strong) UIImageView *imageView;

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
    
    DZCameraViewController *cameraVC = [[DZCameraViewController alloc] init];
    cameraVC.lineColor = [UIColor redColor];///线条默认红色
    cameraVC.lineWidth = 5;///线条默认宽3
    
    cameraVC.completeImage = ^(UIImage *image){
        CGSize imageSize = image.size;
        CGFloat height = imageSize.height/imageSize.width*KWidth;
        self.imageView.frame = CGRectMake(0, 100, KWidth, height);
        self.imageView.image = image;
    };
    
    [self presentViewController:cameraVC animated:YES completion:nil];
    
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
