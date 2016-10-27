//
//  DGDrawImageViewController.h
//  DingGuangRobots
//
//  Created by Chris on 16/7/11.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCustomImagePickerController.h"

@interface DGDrawImageViewController : UIViewController<UINavigationControllerDelegate,CustomImagePickerControllerDelegate>

@property (nonatomic, copy) void(^sendImageBlock)(UIImage *image);

@property (nonatomic, copy) void(^sendVoiceBlock)(NSString *localPath,NSInteger duration);

///从首页图片轮播中进去的
@property (nonatomic, strong) UINavigationController *navigationController;

@end
