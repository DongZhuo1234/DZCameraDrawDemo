//
//  BHBDrawBoarderView.m
//  BHBDrawBoarder
//
//  Created by bihongbo on 16/1/4.
//  Copyright © 2016年 bihongbo. All rights reserved.
//
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#import "BHBDrawBoarderView.h"
#import "BHBScrollView.h"
#import "BHBMyDrawer.h"
@interface BHBDrawBoarderView ()
{
    
    /** 工具条的view */
    UIView *_toolView;

    /** 画板view */
//    BHBScrollView *_boardView;
    
}

/** 按钮图片 */
@property (nonatomic, strong) NSArray   * buttonImgNames;
/** 按钮不可用图片 */
@property (nonatomic, strong) NSArray   * btnEnableImgNames;

@property (nonatomic, strong)BHBMyDrawer * myDrawer;

@property (nonatomic, strong)UIButton * delAllBtn;//删除
@property (nonatomic, strong)UIButton * fwBtn;//上一步
@property (nonatomic, strong)UIButton * ntBtn;//下一步

///背景图片
@property (nonatomic, strong) UIImageView *photoImage;

@end


@implementation BHBDrawBoarderView

- (BHBMyDrawer *)myDrawer
{
    if (_myDrawer == nil) {
        _myDrawer = [[BHBMyDrawer alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width*5, SCREEN_SIZE.height*2)];
        _myDrawer.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _myDrawer;
    
}


- (NSArray *)btnEnableImgNames
{
    if (_btnEnableImgNames == nil) {
        _btnEnableImgNames = @[@"close_draft_enable",@"delete_draft_enable",@"undo_draft_enable",@"redo_draft_enable"];
    }
    return _btnEnableImgNames;
}


- (NSArray *)buttonImgNames
{
    if (_buttonImgNames == nil) {
        _buttonImgNames = @[@"close_draft",@"delete_draft",@"undo_draft",@"redo_draft"];
    }
    return _buttonImgNames;
}

- (void)dealloc{
    
    [self.myDrawer removeObserver:self forKeyPath:@"lines" context:nil];
    [self.myDrawer removeObserver:self forKeyPath:@"canceledLines" context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.myDrawer addObserver:self forKeyPath:@"lines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.myDrawer addObserver:self forKeyPath:@"canceledLines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        //画板view
        CGRect boardFrame = CGRectZero;
        
        boardFrame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        
        BHBScrollView * boardV = [[BHBScrollView alloc] initWithFrame:boardFrame];
        
        ///背景图片
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = boardV.bounds;
        [boardV addSubview:imgView];
        self.photoImage = imgView;
        
        boardV.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [boardV setUserInteractionEnabled:YES];
        [boardV setScrollEnabled:YES];
        [boardV setMultipleTouchEnabled:YES];
        [boardV addSubview:self.myDrawer];
        [boardV setContentSize:self.myDrawer.frame.size];
        [boardV setDelaysContentTouches:NO];
        [boardV setCanCancelContentTouches:NO];
        [self addSubview:boardV];
        
        _boardView = boardV;
        
    }
    return self;
}


- (void)show {
    
    _myDrawer.lines = [NSMutableArray arrayWithArray:self.linesInfo];
    for (CALayer * layer in _myDrawer.lines) {
        [_myDrawer.layer addSublayer:layer];
    }
    
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y -= frame.size.height ;
                         [self setFrame:frame];
                         
                     }completion:nil];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y += frame.size.height ;
                         [self setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (finished) {
                             if (self.draftInfoBlock) {
                                 self.draftInfoBlock(self.num, _myDrawer.lines, _myDrawer.canceledLines);
                             }
                         }
                         
                         [self removeFromSuperview];
                         
                         [self.myDrawer removeObserver:self forKeyPath:@"canceledLines"];
                         [self.myDrawer removeObserver:self forKeyPath:@"lines"];
                     }];
}


- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self dismiss];
            break;
        case 101:
            [_myDrawer clearScreen];
            break;
        case 102:
            [_myDrawer undo];
            break;
        case 103:
            [_myDrawer redo];
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"lines"]){
        NSMutableArray * lines = [_myDrawer mutableArrayValueForKey:@"lines"];
        if (lines.count) {
            [self.delAllBtn setEnabled:YES];
            [self.fwBtn setEnabled:YES];
            
        }else{
            [self.delAllBtn setEnabled:NO];
            [self.fwBtn setEnabled:NO];
        }
    }else if([keyPath isEqualToString:@"canceledLines"]){
        NSMutableArray * canceledLines = [_myDrawer mutableArrayValueForKey:@"canceledLines"];
        if (canceledLines.count) {
            [self.ntBtn setEnabled:YES];
        }else{
            [self.ntBtn setEnabled:NO];
            
        }
        
    }
}


///设置背景图片
- (void)setBjImage:(UIImage *)image{
    
    if (image == nil) {
        self.photoImage.image = nil;
        return;
    }
    
    CGSize imageSize = image.size;
    
    _boardView.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    CGFloat imageScaleHeight = imageSize.height/imageSize.width;
    
    imageSize.width = SCREEN_SIZE.width;
    imageSize.height = imageScaleHeight*SCREEN_SIZE.width;
    
    
    self.photoImage.image = image;
    self.photoImage.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.myDrawer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _boardView.contentSize = imageSize;
}

///获取绘制的图片
- (UIImage *)getDrawImage{
    
    CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    if (self.photoImage.image) {
        CGSize imageSize = self.photoImage.image.size;
        
        CGFloat imageScaleHeight = imageSize.height/imageSize.width;
        
        size.width = SCREEN_SIZE.width;
        size.height = imageScaleHeight*SCREEN_SIZE.width;
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.photoImage.image) {
        
        [self.myDrawer.layer renderInContext:context];
        
    }else{
        
        [self.layer renderInContext:context];
    }
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.photoImage.image) {
        
        CGSize originalSize = self.photoImage.image.size;
        
        UIImageView *originalImageView = [[UIImageView alloc] initWithImage:self.photoImage.image];
        originalImageView.frame = CGRectMake(0, 0, originalSize.width, originalSize.height);
        UIImageView *drawImageView = [[UIImageView alloc] initWithImage:getImage];
        drawImageView.frame = CGRectMake(0, 0, originalSize.width, originalSize.height);
        
        UIView *tempView = [[UIView alloc] init];
        [tempView addSubview:originalImageView];
        [tempView addSubview:drawImageView];
        
        UIGraphicsBeginImageContext(originalSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [tempView.layer renderInContext:context];
        getImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return getImage;
}



@end
