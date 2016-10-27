//
//  DGDrawImageViewController.m
//  DingGuangRobots
//
//  Created by Chris on 16/7/11.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "DGDrawImageViewController.h"
//#import <Masonry.h>
#import "BHBDrawBoarderView.h"
#import "BHBMyDrawer.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface DGDrawImageViewController ()

///提示
@property (nonatomic, strong) UIButton *tipBtn;
///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///拍照
@property (nonatomic, strong) UIButton *cemareBtn;
///相册
@property (nonatomic, strong) UIButton *albumBtn;
///tag提示
@property (nonatomic, strong) UIButton *tagTipBtn;
///录音提示
@property (nonatomic, strong) UIButton *luYinTipBtn;
///录音的图片
@property (nonatomic, strong) UIImageView *micImageView;
///播放按钮
@property (nonatomic, strong) UIButton *playBtn;
///删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

//相册选中的图片
@property (nonatomic, strong) NSMutableArray *albumSelectedImage;

///画板
@property (nonatomic,strong) BHBDrawBoarderView * drawBoarderView;


@end

@implementation DGDrawImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];//DGBjGrayColor;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self prepareUI];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareUI{
    
    //画板
     //self.drawBoarderView = [[BHBDrawBoarderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //self.drawBoarderView.hidden = YES;
    [self.view addSubview:self.drawBoarderView];
    
    //提示
    self.tipBtn = [[UIButton alloc] init];
    self.tipBtn.userInteractionEnabled = NO;
    self.tipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tipBtn];
//    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view).offset(150);
//    }];
    
    //拍照
    self.cemareBtn = [[UIButton alloc] init];
    [self.cemareBtn setTitle:@"拍照" forState:UIControlStateNormal];
    self.cemareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cemareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cemareBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_blue"] forState:UIControlStateNormal];
    [self.view addSubview:self.cemareBtn];
//    [self.cemareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).offset(-20);
//        make.width.height.mas_equalTo(75);
//    }];
    [self.cemareBtn addTarget:self action:@selector(cemareBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.cemareBtn addTarget:self action:@selector(cemareBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.cemareBtn addTarget:self action:@selector(cemareBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    //取消
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_green"] forState:UIControlStateNormal];
    [self.view addSubview:self.cancelBtn];
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view).offset(20);
//        make.centerY.mas_equalTo(self.cemareBtn);
//        //make.width.height.mas_equalTo(50);
//    }];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClink) forControlEvents:UIControlEventTouchUpInside];
    
    //相册
    self.albumBtn = [[UIButton alloc] init];
    self.albumBtn = [[UIButton alloc] init];
    [self.albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.albumBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.albumBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_orange"] forState:UIControlStateNormal];
    [self.view addSubview:self.albumBtn];
//    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view).offset(-20);
//        make.centerY.mas_equalTo(self.cemareBtn);
//       // make.width.height.mas_equalTo(50);
//    }];
    [self.albumBtn addTarget:self action:@selector(albumBtnClink:) forControlEvents:UIControlEventTouchUpInside];
    
    //tag提示
    self.tagTipBtn = [[UIButton alloc] init];
    self.tagTipBtn.hidden = YES;
    self.tagTipBtn.userInteractionEnabled = NO;
    [self.tagTipBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_tag"] forState:UIControlStateNormal];
    [self.tagTipBtn setTitle:@"    哪里坏了圈哪里~    " forState:UIControlStateNormal];
    self.tagTipBtn.titleLabel.numberOfLines = 0;
    self.tagTipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.tagTipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tagTipBtn];
//    [self.tagTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view).offset(150);
//    }];
    
    //录音提示
    self.luYinTipBtn = [[UIButton alloc] init];
    self.luYinTipBtn.hidden = YES;
    self.luYinTipBtn.userInteractionEnabled = NO;
    [self.luYinTipBtn setBackgroundImage:[UIImage imageNamed:@"take_phote_tip"] forState:UIControlStateNormal];
    [self.luYinTipBtn setTitle:@"    \"按住说话\"描述你的问题    " forState:UIControlStateNormal];
    self.luYinTipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.luYinTipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.luYinTipBtn];
//    [self.luYinTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.cemareBtn.mas_top).offset(-20);
//    }];
    
    //录音的图片
    self.micImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic_0"]];
    self.micImageView.hidden = YES;
    [self.view addSubview:self.micImageView];
//    [self.micImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
    
    //播放的按钮
    self.playBtn = [[UIButton alloc] init];
    self.playBtn.hidden = YES;
    [self.playBtn setImage:[UIImage imageNamed:@"reord_paly01_03"] forState:UIControlStateNormal];
    [self.view addSubview:self.playBtn];
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
    [self.playBtn addTarget:self action:@selector(playBtnClink:) forControlEvents:UIControlEventTouchUpInside];
    
    //删除按钮
    self.deleteBtn = [[UIButton alloc] init];
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setImage:[UIImage imageNamed:@"take_record_delete"] forState:UIControlStateNormal];
    [self.view addSubview:self.deleteBtn];
//    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.playBtn);
//        make.left.mas_equalTo(self.playBtn.mas_right).offset(20);
//    }];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClink:) forControlEvents:UIControlEventTouchUpInside];
     
}

#pragma mark -按钮点击
- (void)cancelBtnClink{
    
//    NSData *data = [NSData dataWithContentsOfFile:self.recordTool.filePath];
//    if (data && self.playBtn.hidden==NO) {
//        [self.recordTool destructionRecordingFile];
//        [self.cemareBtn setTitle:@"录音" forState:UIControlStateNormal];
//        self.playBtn.hidden = YES;
//        self.deleteBtn.hidden = YES;
//        return;
//    }
    
    
    if (self.drawBoarderView.myDrawer.lines.count > 0) {
        [self.drawBoarderView.myDrawer clearScreen];
        return;
    }
    
    if (self.albumSelectedImage.count > 0) {
        [self.drawBoarderView.myDrawer clearScreen];
        self.albumSelectedImage = nil;
        [self.drawBoarderView setBjImage:nil];
        self.drawBoarderView.hidden = YES;
        self.tipBtn.hidden = NO;
        self.albumBtn.hidden = NO;
        
        [self.cemareBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [self.albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        
        [self jumpTakePhoto];
        
        return;
    }
    
    [self jumpTakePhoto];
    
}


// 点击
- (void)cemareBtnDidTouchUpInside:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"下一步"]) {
        
        [btn setTitle:@"录音" forState:UIControlStateNormal];
        [self.albumBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.luYinTipBtn.hidden = NO;
        self.albumBtn.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                self.luYinTipBtn.alpha = 0;
            } completion:^(BOOL finished) {
                self.luYinTipBtn.hidden = YES;
                self.luYinTipBtn.alpha = 1;
            }];
        });
        
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"录音"]) {
        
        [self luYin];
        
        [btn setTitle:@"重新录音" forState:UIControlStateNormal];
        
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"重新录音"]) {
        
        [self luYin];
        
        return;
    }
    
    [self jumpTakePhoto];
}

//按下
- (void)cemareBtnDidTouchDown:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"录音"] || [btn.currentTitle isEqualToString:@"重新录音"]) {
        
        self.micImageView.hidden = NO;
        self.playBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    
}

// 手指从按钮上移除
- (void)cemareBtnDidTouchDragExit:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"录音"] || [btn.currentTitle isEqualToString:@"重新录音"]) {
        
        self.micImageView.image = [UIImage imageNamed:@"mic_0"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
//            [self.recordTool stopRecording];
//            [self.recordTool destructionRecordingFile];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:@"已取消录音"];
                self.micImageView.hidden = YES;
            });
        });
    }
    
}

- (void)albumBtnClink:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"完成"]) {
        
        UIImage *image = [self.drawBoarderView getDrawImage];
        
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        if (self.sendImageBlock) {
            self.sendImageBlock(image);
        }
        
//        NSData *data = [NSData dataWithContentsOfFile:self.recordTool.filePath];
//        if (data) {
//            if (self.sendVoiceBlock) {
//                
//                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.recordTool.filePath] error:NULL];
//                self.sendVoiceBlock(self.recordTool.filePath,player.duration);
//            }
//        }
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//            [self.recordTool destructionRecordingFile];
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        }];
        
        
        return;
    }
    
//    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
//    picker.maximumNumberOfSelection = 1;
//    picker.assetsFilter = [ALAssetsFilter allAssets];
//    picker.showEmptyGroups = NO;
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
}

- (void)playBtnClink:(UIButton *)btn{
    
//    NSData *data = [NSData dataWithContentsOfFile:self.recordTool.filePath];
//    
//    if (data) {
//        
//        static BOOL isPlay = NO;
//        
//        isPlay = !isPlay;
//        
//        if (isPlay) {
//            [self.recordTool playRecordingFile];
//        }else{
//            [self.recordTool stopPlaying];
//        }
//        
//    }
    
}

- (void)deleteBtnClink:(UIButton *)btn{
    
//    NSData *data = [NSData dataWithContentsOfFile:self.recordTool.filePath];
//    
//    if (data) {
//        
//        [self.recordTool destructionRecordingFile];
//        [self.cemareBtn setTitle:@"录音" forState:UIControlStateNormal];
//        self.playBtn.hidden = YES;
//        self.deleteBtn.hidden = YES;
//    }
    
}

- (void)luYin{
    
//    double currentTime = self.recordTool.recorder.currentTime;
//    DGLog(@"%lf", currentTime);
//    if (currentTime < 2) {
//        
//        [self alertWithMessage:@"说话时间太短"];
//        self.micImageView.hidden = YES;
//        self.playBtn.hidden = YES;
//        self.deleteBtn.hidden = YES;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            [self.recordTool stopRecording];
//            [self.recordTool destructionRecordingFile];
//        });
//    } else {
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            [self.recordTool stopRecording];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.micImageView.hidden = YES;
//                self.playBtn.hidden = NO;
//                self.deleteBtn.hidden = NO;
//            });
//        });
//        // 已成功录音
//        DGLog(@"已成功录音");
//    }
}

- (void)jumpTakePhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //        UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
        //
        //        pickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        pickVc.delegate = self;
        //        [self presentViewController:pickVc animated:YES completion:nil];
        
        DZCustomImagePickerController *imagepickerCtrl = [[DZCustomImagePickerController alloc] init];
        if (self.navigationController) {
            imagepickerCtrl.navigationController = self.navigationController;
        }
        imagepickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepickerCtrl.customDelegate = self;
        [self presentViewController:imagepickerCtrl animated:NO completion:NULL];
        
    }else{
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
}

#pragma mark - LVRecordToolDelegate
//- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
//    
//    if (no == 0) {
//        no = 1;
//    }
//    
//    DGLog(@"========>>>>%d",no);
//    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
//    self.micImageView.image = [UIImage imageNamed:imageName];
//}
//
//- (void)recordTool:(LVRecordTool *)recordTool didstartPlayRecoring:(int)no{
//    
//    NSString *imageName = [NSString stringWithFormat:@"reord_paly01_0%d", no];
//    [self.playBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    
//    NSMutableArray *marray = [NSMutableArray array];
//    
//    for(int i=0;i<assets.count;i++){
//        
//        ALAsset *asset = assets[i];
//        
//        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        
//        [marray addObject:image];
//        
//    }
//    
//    self.albumSelectedImage = nil;
//    self.albumSelectedImage = marray;
//}



#pragma mark CustomImagePickerControllerDelegate
- (void)cameraPhoto:(UIImage *)image{
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:image];
    
    self.albumSelectedImage = nil;
    self.albumSelectedImage = arrM;
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelCamera{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark -set,get方法
- (void)setAlbumSelectedImage:(NSMutableArray *)albumSelectedImage{
    
    _albumSelectedImage = albumSelectedImage;
    
    if (_albumSelectedImage.count > 0) {
        
        self.tipBtn.hidden = YES;
        self.tagTipBtn.hidden = NO;
        self.drawBoarderView.hidden = NO;
        
        [self.drawBoarderView setBjImage:_albumSelectedImage.lastObject];
        
        [self.cemareBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.albumBtn.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0 animations:^{
                self.tagTipBtn.alpha = 0;
            } completion:^(BOOL finished) {
                self.tagTipBtn.hidden = YES;
                self.tagTipBtn.alpha = 1;
            }];
        });
    }
    
}

//- (LVRecordTool *)recordTool{
//    
//    if (!_recordTool) {
//        _recordTool = [LVRecordTool sharedRecordTool];
//        _recordTool.delegate = self;
//    }
//    return _recordTool;
//}

- (BHBDrawBoarderView *)drawBoarderView{
    
    if (!_drawBoarderView) {
        
        _drawBoarderView = [[BHBDrawBoarderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _drawBoarderView.hidden = YES;
    }
    return _drawBoarderView;
}

@end
