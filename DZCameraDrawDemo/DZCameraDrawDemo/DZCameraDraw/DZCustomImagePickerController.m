//
//  CustomImagePickerController.m
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import "DZCustomImagePickerController.h"
#import <QuartzCore/QuartzCore.h>
@interface DZCustomImagePickerController ()

@end

@implementation DZCustomImagePickerController

@synthesize customDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
}


//切换前、后置摄像头
- (void)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

#pragma mark /////////////
- (UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc]) {
        return aView;
    }
    
    for (int i = 0; i < [aView subviews].count; i++) {
        UIView *subview = [aView.subviews objectAtIndex:i];
        subview = [self findView:subview withName:name];
        
        if(subview){
            return subview;
        }
    }
    
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        [self setShowsCameraControls:NO];
        
        //overlyView
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0,  KHeight-75-20-20, KWidth, 75+20+20)];
        
        overlyView.backgroundColor = [UIColor clearColor];
        
        //拍照
        UIButton *cemareBtn = [[UIButton alloc] init];
        [cemareBtn setTitle:@"拍照" forState:UIControlStateNormal];
        cemareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cemareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cemareBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_blue"] forState:UIControlStateNormal];
        [overlyView addSubview:cemareBtn];
        [cemareBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        cemareBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *cemareBtnCenterx = [NSLayoutConstraint constraintWithItem:cemareBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:overlyView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *cemareBtnBottom = [NSLayoutConstraint constraintWithItem:cemareBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:overlyView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];
        NSLayoutConstraint *cemareBtnWidth = [NSLayoutConstraint constraintWithItem:cemareBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
        NSLayoutConstraint *cemareBtnHeight = [NSLayoutConstraint constraintWithItem:cemareBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
        [overlyView addConstraints:@[cemareBtnCenterx,cemareBtnBottom,cemareBtnWidth,cemareBtnHeight]];
        
        //取消
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_green"] forState:UIControlStateNormal];
        [overlyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *cancelBtnLeft = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:overlyView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
        NSLayoutConstraint *cancelBtnCentery = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cemareBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [overlyView addConstraints:@[cancelBtnLeft,cancelBtnCentery]];
        
        //相册
        UIButton *albumBtn = [[UIButton alloc] init];
        albumBtn = [[UIButton alloc] init];
        [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        albumBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [albumBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_orange"] forState:UIControlStateNormal];
        [overlyView addSubview:albumBtn];
        [albumBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        albumBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *albumBtnRight = [NSLayoutConstraint constraintWithItem:albumBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:overlyView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
        NSLayoutConstraint *albumBtnCentery = [NSLayoutConstraint constraintWithItem:albumBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cemareBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [overlyView addConstraints:@[albumBtnRight,albumBtnCentery]];
        
        self.cameraOverlayView = overlyView;
        
    }
}

- (void)showPhoto
{
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)closeView{
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePicture{
    [super takePicture];
}


#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([customDelegate respondsToSelector:@selector(cameraPhoto:)]) {
        [customDelegate cameraPhoto:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self setSourceType:UIImagePickerControllerSourceTypeCamera];
}

@end
