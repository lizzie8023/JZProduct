//
//  QMUIZoomImageView.h
//  qmui
//
//  Created by ZhoonChen on 14-9-14.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QMUIZoomImageView;

@protocol QMUIZoomImageViewDelegate <NSObject>
@optional
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)doubleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)longPressInZoomingImageView:(QMUIZoomImageView *)zoomImageView;

/// 是否支持缩放，默认为 YES
- (BOOL)enabledZoomViewInZoomImageView:(QMUIZoomImageView *)zoomImageView;
@end

/**
 *  支持缩放查看图片（包括 Live Photo）的控件，默认显示完整图片，可双击查看原始大小，再次双击查看放大后的大小，第三次双击恢复到初始大小。
 *
 *  支持通过修改 contentMode 来控制图片默认的显示模式，目前仅支持 UIViewContentModeCenter、UIViewContentModeScaleAspectFill、UIViewContentModeScaleAspectFit，默认为 UIViewContentModeCenter。
 *
 *  QMUIZoomImageView 提供最基础的图片预览和缩放功能以及 loading、错误等状态的展示支持，其他功能请通过继承来实现。
 */
@interface QMUIZoomImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, weak) id<QMUIZoomImageViewDelegate> delegate;

@property(nonatomic, assign) CGFloat maximumZoomScale;

/// 设置当前要显示的图片，会把 livePhoto 相关内容清空，因此注意不要直接通过 imageView.image 来设置图片。
@property(nonatomic, strong, nullable) UIImage *image;

/// 用于显示图片的 UIImageView，注意不要通过 imageView.image 来设置图片，请使用 image 属性。
@property(nonatomic, strong, readonly) UIImageView *imageView;

/**
 *  获取当前正在显示的图片在整个 QMUIZoomImageView 坐标系里的 rect（会按照当前的缩放状态来计算）
 */
- (CGRect)imageViewRectInZoomImageView;

/**
 *  重置图片的大小，使用的场景例如：相册控件，放大当前图片，划到下一张，再回来，当前的图片应该恢复到原来大小。
 *  注意子类重写需要调一下super。
 */
- (void)revertZooming;

@end

NS_ASSUME_NONNULL_END