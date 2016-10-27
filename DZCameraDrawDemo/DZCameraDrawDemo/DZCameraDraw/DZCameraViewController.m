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

@interface DZCameraViewController ()

///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///拍照
@property (nonatomic, strong) UIButton *cemareBtn;
///相册
@property (nonatomic, strong) UIButton *albumBtn;
///tag提示
@property (nonatomic, strong) UIButton *tagTipBtn;
///画板
@property (nonatomic,strong) BHBDrawBoarderView * drawBoarderView;

@end

@implementation DZCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self jumpCustomImagePicker];
    
    [self creatUI];
    
}

- (void)jumpCustomImagePicker{
    
    
}

- (void)creatUI{
    
    //画板
    [self.view addSubview:self.drawBoarderView];
    
    //拍照
    self.cemareBtn = [[UIButton alloc] init];
    [self.cemareBtn setTitle:@"拍照" forState:UIControlStateNormal];
    self.cemareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cemareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cemareBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_blue"] forState:UIControlStateNormal];
    [self.view addSubview:self.cemareBtn];
    [self.cemareBtn addTarget:self action:@selector(cemareBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.cemareBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cemareBtnCenterx = [NSLayoutConstraint constraintWithItem:self.cemareBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *cemareBtnBottom = [NSLayoutConstraint constraintWithItem:self.cemareBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];
    NSLayoutConstraint *cemareBtnWidth = [NSLayoutConstraint constraintWithItem:self.cemareBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
    NSLayoutConstraint *cemareBtnHeight = [NSLayoutConstraint constraintWithItem:self.cemareBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
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
    NSLayoutConstraint *cancelBtnCentery = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cemareBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
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
    NSLayoutConstraint *albumBtnCentery = [NSLayoutConstraint constraintWithItem:self.albumBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cemareBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraints:@[albumBtnRight,albumBtnCentery]];
    
    //tag提示
    self.tagTipBtn = [[UIButton alloc] init];
    self.tagTipBtn.hidden = YES;
    self.tagTipBtn.userInteractionEnabled = NO;
    [self.tagTipBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_tag"] forState:UIControlStateNormal];
    [self.tagTipBtn setTitle:@"    想圈哪里圈哪里~    " forState:UIControlStateNormal];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cemareBtnDidTouchUpInside:(UIButton *)btn{
    
    
}

- (void)albumBtnClink:(UIButton *)btn{
    
}



@end
