//
//  CustomImagePickerController.m
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import "DZCustomImagePickerController.h"
#import<QuartzCore/QuartzCore.h>
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
	// Do any additional setup after loading the view.
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    
//}


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
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0,  KHeight-75-20-20, KWidth, 75+20+20)];//CGRectMake(0,  kHeight-75-20-50, kWidth, 75+20+50)
        
        //[overlyView setBackgroundColor:DGBjGrayColor];
        overlyView.backgroundColor = [UIColor clearColor];
        
        //拍照
        UIButton *cemareBtn = [[UIButton alloc] init];
        [cemareBtn setTitle:@"拍照" forState:UIControlStateNormal];
        cemareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cemareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cemareBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_blue"] forState:UIControlStateNormal];
        [overlyView addSubview:cemareBtn];
//        [cemareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(overlyView);
//            make.bottom.mas_equalTo(overlyView).offset(-20);
//            make.width.height.mas_equalTo(75);
//        }];
        [cemareBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        
        //取消
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_green"] forState:UIControlStateNormal];
        [overlyView addSubview:cancelBtn];
//        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(overlyView).offset(20);
//            make.centerY.mas_equalTo(cemareBtn);
//            //make.width.height.mas_equalTo(50);
//        }];
        [cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        //相册
        UIButton *albumBtn = [[UIButton alloc] init];
        albumBtn = [[UIButton alloc] init];
        [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        albumBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [albumBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_orange"] forState:UIControlStateNormal];
        [overlyView addSubview:albumBtn];
//        [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(overlyView).offset(-20);
//            make.centerY.mas_equalTo(cemareBtn);
//            // make.width.height.mas_equalTo(50);
//        }];
        [albumBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        self.cameraOverlayView = overlyView;
        
    }
}

- (void)showPhoto
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)closeView{
    
    if (self.navigationController) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
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
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if ([customDelegate respondsToSelector:@selector(cameraPhoto:)]) {
        [customDelegate cameraPhoto:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self setSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
