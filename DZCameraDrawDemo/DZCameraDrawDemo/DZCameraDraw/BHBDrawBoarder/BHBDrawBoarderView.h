//
//  BHBDrawBoarderView.h
//  BHBDrawBoarder
//
//  Created by bihongbo on 16/1/4.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHBMyDrawer,BHBScrollView;

typedef void(^draftInfoBlock)(NSInteger num, NSArray * linesInfo, NSArray * canceledLinesInfo);

@interface BHBDrawBoarderView : UIView

@property (nonatomic, strong)NSIndexPath *index;
@property (nonatomic, assign)NSInteger num;
@property (nonatomic, strong)NSArray * linesInfo;
@property (nonatomic, strong)NSArray * canceledLinesInfo;
@property (nonatomic, copy)draftInfoBlock draftInfoBlock;

@property (nonatomic, strong, readonly)BHBMyDrawer * myDrawer;

/** 画板view */
@property (nonatomic, weak) BHBScrollView *boardView;

- (void)show;

- (void)dismiss;

///设置背景图片
- (void)setBjImage:(UIImage *)image;

///获取绘制的图片
- (UIImage *)getDrawImage;



@end
