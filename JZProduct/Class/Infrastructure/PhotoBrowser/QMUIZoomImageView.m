//
//  QMUIZoomImageView.m
//  qmui
//
//  Created by ZhoonChen on 14-9-14.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QMUIZoomImageView.h"

/// 传入size，返回一个x/y为0的CGRect
CG_INLINE CGRect
CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/// 判断一个size是否为空（宽或高为0）
CG_INLINE BOOL
CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

#define QMUIViewAnimationOptionsCurveOut (7<<16)
#define QMUIViewAnimationOptionsCurveIn (8<<16)

@interface QMUIZoomImageView ()

@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation QMUIZoomImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.maximumZoomScale = 2.0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = true;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 0;
    self.scrollView.maximumZoomScale = self.maximumZoomScale;
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureWithPoint:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureWithPoint:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
    
    // 双击失败后才出发单击
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    self.scrollView.frame = self.bounds;
}

#pragma mark - Normal Image

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    // 更新 imageView 的大小时，imageView 可能已经被缩放过，所以要应用当前的缩放
    self.imageView.frame = CGRectApplyAffineTransform(CGRectMakeWithSize(image.size), self.imageView.transform);
    [self revertZooming];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (UIView *)currentContentImageView {
    return self.imageView;
}

#pragma mark - Image Scale

- (void)setContentMode:(UIViewContentMode)contentMode {
    BOOL isContentModeChanged = self.contentMode != contentMode;
    [super setContentMode:contentMode];
    if (isContentModeChanged) {
        [self revertZooming];
    }
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _maximumZoomScale = maximumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
}

- (CGFloat)minimumZoomScale {
    CGRect viewport = self.bounds;
    if (CGRectIsEmpty(viewport)) {
        return 1;
    }
    
    CGSize imageSize = self.image.size;
    
    CGFloat minScale = 1;
    if (CGSizeIsEmpty(imageSize)) {
        return minScale;
    }
    
    CGFloat scaleX = CGRectGetWidth(viewport) / imageSize.width;
    CGFloat scaleY = CGRectGetHeight(viewport) / imageSize.height;
    if (self.contentMode == UIViewContentModeScaleAspectFit) {
        minScale = fminf(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeScaleAspectFill) {
        minScale = fmaxf(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeCenter) {
        if (scaleX >= 1 && scaleY >= 1) {
            minScale = 1;
        } else {
            minScale = fminf(scaleX, scaleY);
        }
    }
    return minScale;
}

- (void)revertZooming {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL enabledZoomImageView = [self enabledZoomImageView];
    CGFloat minimumZoomScale = [self minimumZoomScale];
    CGFloat maximumZoomScale = enabledZoomImageView ? self.maximumZoomScale : minimumZoomScale;
    maximumZoomScale = fmaxf(minimumZoomScale, maximumZoomScale);// 可能外部通过 contentMode = UIViewContentModeScaleAspectFit 的方式来让小图片撑满当前的 zoomImageView，所以算出来 minimumZoomScale 会很大（至少比 maximumZoomScale 大），所以这里要做一个保护
    CGFloat zoomScale = minimumZoomScale;
    BOOL shouldFireDidZoomingManual = zoomScale == self.scrollView.zoomScale;
    self.scrollView.panGestureRecognizer.enabled = enabledZoomImageView;
    self.scrollView.pinchGestureRecognizer.enabled = enabledZoomImageView;
    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    [self setZoomScale:zoomScale animated:NO];
    // 只有前后的 zoomScale 不相等，才会触发 UIScrollViewDelegate scrollViewDidZoom:，因此对于相等的情况要自己手动触发
    if (shouldFireDidZoomingManual) {
        [self handleDidEndZooming];
    }
}

- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.scrollView.zoomScale = zoomScale;
        } completion:nil];
    } else {
        self.scrollView.zoomScale = zoomScale;
    }
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            [self.scrollView zoomToRect:rect animated:NO];
        } completion:nil];
    } else {
        [self.scrollView zoomToRect:rect animated:NO];
    }
}

- (CGRect)imageViewRectInZoomImageView {
    UIView *imageView = [self currentContentImageView];
    return [self convertRect:imageView.frame fromView:imageView.superview];
}

- (void)handleDidEndZooming {
    UIView *imageView = [self currentContentImageView];
    CGRect imageViewFrame = (!self.image) ? CGRectZero : [self convertRect:imageView.frame fromView:imageView.superview];
    CGSize viewportSize = self.bounds.size;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    if (!CGRectIsEmpty(imageViewFrame) && !CGSizeIsEmpty(viewportSize)) {
        if (CGRectGetWidth(imageViewFrame) < viewportSize.width) {
            // 用 floorf 而不是 flatf，是因为 flatf 本质上是向上取整，会导致 left + right 比实际的大，然后 scrollView 就认为可滚动了
            contentInset.left = contentInset.right = floorf((viewportSize.width - CGRectGetWidth(imageViewFrame)) / 2.0);
        }
        if (CGRectGetHeight(imageViewFrame) < viewportSize.height) {
            // 用 floorf 而不是 flatf，是因为 flatf 本质上是向上取整，会导致 top + bottom 比实际的大，然后 scrollView 就认为可滚动了
            contentInset.top = contentInset.bottom = floorf((viewportSize.height - CGRectGetHeight(imageViewFrame)) / 2.0);
        }
    }
    self.scrollView.contentInset = contentInset;
    self.scrollView.contentSize = imageView.frame.size;
    
    if (self.scrollView.contentInset.top > 0) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top);
    }
    
    if (self.scrollView.contentInset.left > 0) {
        self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.left, self.scrollView.contentOffset.y);
    }
}

- (BOOL)enabledZoomImageView {
    BOOL enabledZoom = YES;
    if ([self.delegate respondsToSelector:@selector(enabledZoomViewInZoomImageView:)]) {
        enabledZoom = [self.delegate enabledZoomViewInZoomImageView:self];
    } else if (!self.image) {
        enabledZoom = NO;
    }
    return enabledZoom;
}

#pragma mark - GestureRecognizers

- (void)handleSingleTapGestureWithPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint gesturePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.delegate respondsToSelector:@selector(singleTouchInZoomingImageView:location:)]) {
        [self.delegate singleTouchInZoomingImageView:self location:gesturePoint];
    }
}

- (void)handleDoubleTapGestureWithPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint gesturePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.delegate respondsToSelector:@selector(doubleTouchInZoomingImageView:location:)]) {
        [self.delegate doubleTouchInZoomingImageView:self location:gesturePoint];
    }
    
    if ([self enabledZoomImageView]) {
        // 如果图片被压缩了，则第一次放大到原图大小，第二次放大到最大倍数
        if (self.scrollView.zoomScale >= self.scrollView.maximumZoomScale) {
            [self setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        } else {
            CGFloat newZoomScale = 0;
            if (self.scrollView.zoomScale < 1) {
                // 如果目前显示的大小比原图小，则放大到原图
                newZoomScale = 1;
            } else {
                // 如果当前显示原图，则放大到最大的大小
                newZoomScale = self.scrollView.maximumZoomScale;
            }
            
            CGRect zoomRect = CGRectZero;
            CGPoint tapPoint = [[self currentContentImageView] convertPoint:gesturePoint fromView:gestureRecognizer.view];
            zoomRect.size.width = CGRectGetWidth(self.bounds) / newZoomScale;
            zoomRect.size.height = CGRectGetHeight(self.bounds) / newZoomScale;
            zoomRect.origin.x = tapPoint.x - CGRectGetWidth(zoomRect) / 2;
            zoomRect.origin.y = tapPoint.y - CGRectGetHeight(zoomRect) / 2;
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if ([self enabledZoomImageView] && longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressInZoomingImageView:)]) {
            [self.delegate longPressInZoomingImageView:self];
        }
    }
}

#pragma mark - <UIScrollViewDelegate>

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self currentContentImageView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self handleDidEndZooming];
}



@end
