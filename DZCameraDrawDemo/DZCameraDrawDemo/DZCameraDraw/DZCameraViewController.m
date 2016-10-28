//
//  DZCameraViewController.m
//  DZCameraDrawDemo
//
//  Created by Chris on 16/10/26.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "DZCameraViewController.h"
#import "BHBDrawBoarderView.h"
#import "BHBMyDrawer.h"
#import "DZCustomImagePickerController.h"

@interface DZCameraViewController () <UINavigationControllerDelegate,CustomImagePickerControllerDelegate>

///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///拍照
@property (nonatomic, strong) UIButton *cameraBtn;
///相册
@property (nonatomic, strong) UIButton *albumBtn;
///tag提示
@property (nonatomic, strong) UIButton *tagTipBtn;
///画板
@property (nonatomic,strong) BHBDrawBoarderView * drawBoarderView;

///图片
@property (nonatomic, strong) UIImage *photoImage;

@end

@implementation DZCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self jumpCustomImagePickerSourceType:UIImagePickerControllerSourceTypeCamera];
    });
    
    
    [self creatUI];
    
}

- (void)jumpCustomImagePickerSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        DZCustomImagePickerController *imagepickerCtrl = [[DZCustomImagePickerController alloc] init];

        imagepickerCtrl.sourceType = sourceType;
        imagepickerCtrl.customDelegate = self;
        
        [self presentViewController:imagepickerCtrl animated:NO completion:NULL];
        
    }else{
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
}

- (void)creatUI{
    
    //画板
    [self.view addSubview:self.drawBoarderView];
    
    //拍照
    self.cameraBtn = [[UIButton alloc] init];
    [self.cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    self.cameraBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cameraBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_blue"] forState:UIControlStateNormal];
    [self.view addSubview:self.cameraBtn];
    [self.cameraBtn addTarget:self action:@selector(cemareBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.cameraBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cemareBtnCenterx = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *cemareBtnBottom = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];
    NSLayoutConstraint *cemareBtnWidth = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
    NSLayoutConstraint *cemareBtnHeight = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
    [self.view addConstraints:@[cemareBtnCenterx,cemareBtnBottom,cemareBtnWidth,cemareBtnHeight]];
    
    //取消
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_green"] forState:UIControlStateNormal];
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClink) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cancelBtnLeft = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
    NSLayoutConstraint *cancelBtnCentery = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cameraBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraints:@[cancelBtnLeft,cancelBtnCentery]];
    
    //相册
    self.albumBtn = [[UIButton alloc] init];
    self.albumBtn = [[UIButton alloc] init];
    [self.albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.albumBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.albumBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_orange"] forState:UIControlStateNormal];
    [self.view addSubview:self.albumBtn];
    [self.albumBtn addTarget:self action:@selector(albumBtnClink:) forControlEvents:UIControlEventTouchUpInside];
    self.albumBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *albumBtnRight = [NSLayoutConstraint constraintWithItem:self.albumBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
    NSLayoutConstraint *albumBtnCentery = [NSLayoutConstraint constraintWithItem:self.albumBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cameraBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraints:@[albumBtnRight,albumBtnCentery]];
    
    //tag提示
    self.tagTipBtn = [[UIButton alloc] init];
    self.tagTipBtn.hidden = YES;
    self.tagTipBtn.userInteractionEnabled = NO;
    [self.tagTipBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_tag"] forState:UIControlStateNormal];
    [self.tagTipBtn setTitle:@"    随意画~    " forState:UIControlStateNormal];
    self.tagTipBtn.titleLabel.numberOfLines = 0;
    self.tagTipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.tagTipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tagTipBtn];
    self.tagTipBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *tagTipBtnCenterx = [NSLayoutConstraint constraintWithItem:self.tagTipBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *tagTipBtnTop = [NSLayoutConstraint constraintWithItem:self.tagTipBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:150];
    [self.view addConstraints:@[tagTipBtnCenterx,tagTipBtnTop]];
    
}

#pragma mark - action
- (void)cancelBtnClink{
    
    if (self.drawBoarderView.myDrawer.lines.count > 0) {
        [self.drawBoarderView.myDrawer clearScreen];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cemareBtnDidTouchUpInside:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"重新拍照"]) {
        
        if (self.drawBoarderView.myDrawer.lines.count > 0) {
            [self.drawBoarderView.myDrawer clearScreen];
        }
        [btn setTitle:@"拍照" forState:UIControlStateNormal];
        [self.albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [self jumpCustomImagePickerSourceType:UIImagePickerControllerSourceTypeCamera];
        return;
    }
}

- (void)albumBtnClink:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"完成"]) {
        
        if (self.completeImage) {
            
            UIImage *image = [self.drawBoarderView getDrawImage];
            self.completeImage(image);
            [self cancelCamera];
        }
        
        return;
    }
    
    [self jumpCustomImagePickerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

#pragma mark - CustomImagePickerControllerDelegate
- (void)cameraPhoto:(UIImage *)image{
    
    self.photoImage = image;
    self.drawBoarderView.hidden = NO;
    [self.drawBoarderView setBjImage:image];
    [self.cameraBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
    [self.albumBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.tagTipBtn.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.0 animations:^{
            self.tagTipBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.tagTipBtn.hidden = YES;
            self.tagTipBtn.alpha = 1;
        }];
    });
    
}

- (void)cancelCamera{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - set,get
- (BHBDrawBoarderView *)drawBoarderView{
    
    if (!_drawBoarderView) {
        
        _drawBoarderView = [[BHBDrawBoarderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _drawBoarderView.hidden = YES;
        if (self.lineColor) {
            _drawBoarderView.myDrawer.lineColor = self.lineColor;
        }
        if (self.lineWidth > 0) {
            _drawBoarderView.myDrawer.width = self.lineWidth;
        }
    }
    return _drawBoarderView;
}


@end
