//
//  DZCameraViewController.h
//  DZCameraDrawDemo
//
//  Created by Chris on 16/10/26.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZCameraViewController : UIViewController

///线条颜色,默认红色
@property (nonatomic, strong) UIColor *lineColor;
///线条宽度,默认3
@property (nonatomic, assign) CGFloat lineWidth;

///完成图片
@property (nonatomic, copy) void(^completeImage)(UIImage *image);

@end
