//
//  CustomImagePickerController.h
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@protocol CustomImagePickerControllerDelegate;

@interface DZCustomImagePickerController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
}

@property (nonatomic,unsafe_unretained)id<CustomImagePickerControllerDelegate>customDelegate;

//@property (nonatomic, strong) UINavigationController *navigationController;///图片轮播器进来

@end



@protocol CustomImagePickerControllerDelegate <NSObject>

- (void)cameraPhoto:(UIImage *)image;

- (void)cancelCamera;

@end