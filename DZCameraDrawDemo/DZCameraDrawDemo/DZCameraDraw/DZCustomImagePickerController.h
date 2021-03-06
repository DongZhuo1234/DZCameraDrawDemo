//
//  DZCustomImagePickerController.h
//  DZCameraDrawDemo
//
//  Created by 董棁 on 16/10/30.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@protocol CustomImagePickerControllerDelegate;

@interface DZCustomImagePickerController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
}

@property (nonatomic,unsafe_unretained)id<CustomImagePickerControllerDelegate>customDelegate;

@end



@protocol CustomImagePickerControllerDelegate <NSObject>

- (void)cameraPhoto:(UIImage *)image;

- (void)cancelCamera;

@end
