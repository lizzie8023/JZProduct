//
//  UIViewController+NBStyle.m
//  JeffZhao
//
//  Created by JeffZhao on 16/5/9.
//  Copyright © 2016年 JZ Studio. All rights reserved.
//

#import "UIViewController+NBStyle.h"
#import <objc/runtime.h>
#import "UIView+Hierarchy.h"
#import "JZMacro.h"
#import "UIFont+Addition.h"
#import <ConciseKit/ConciseKit.h>
#import "NavigationBarButtonStyleProtocol.h"

static NSString *NavigationBarShadeImageViewKey = @"NavigationBarShadeImageViewKey";
static NSString *NavigationBarBottomLineViewKey = @"NavigationBarBottomLineViewKey";
static NSString *NavigationBarTitleColorKey = @"NavigationBarTitleColorKey";
static NSString *NavigationBarTitleFontKey = @"NavigationBarTitleFontKey";


@implementation UIViewController (NBStyle)

#pragma mark - Public

- (void)updateNavigationBarAlpha:(CGFloat)alpha
{
    self.navigationBarShadeImageView.alpha = alpha;
    self.navigationBarBottomLineView.alpha = alpha;
}

- (void)updateNavigationBarBackgroundColor:(UIColor *)color
{
    self.navigationBarShadeImageView.backgroundColor = color;
    self.navigationBarShadeImageView.image = nil;
}

- (void)updateNavigationBarBackgroundImage:(UIImage *)image
{
    self.navigationBarShadeImageView.image = image;
}

- (void)updateNavigationBarBottomLineColor:(UIColor *)color
{
    [self.navigationBarBottomLineView setBackgroundColor:color];
}

- (void)makeNavigationBarBottomLineHidden:(BOOL)hidden
{
    [self.navigationBarBottomLineView setHidden:hidden];
}

- (void)updateNavigationBarTitleColor:(UIColor *)color
{
    [self setNavigationBarTitleColor:color];
    self.navigationBarDefaultTitleLabel.textColor = color;
}

- (void)updateNavigationBarTitleColor:(UIColor *)color font:(nonnull UIFont *)font
{
    [self setNavigationBarTitleColor:color];
    [self setNavigationBarTitleFont:font];
    self.navigationBarDefaultTitleLabel.textColor = color;
    self.navigationBarDefaultTitleLabel.font = font;
}

- (void)updateNavigationBarAlpha:(CGFloat)alpha titleColor:(nonnull UIColor *)color
{
    [self updateNavigationBarAlpha:alpha];
    [self updateNavigationBarTitleColor:color];
}

#pragma mark - Property

// MARK: - 导航栏背景颜色视图
- (void)setnavigationBarShadeImageView:(UIImageView *)navigationBarShadeImageView
{
    objc_setAssociatedObject(self, &NavigationBarShadeImageViewKey, navigationBarShadeImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)navigationBarShadeImageView
{
    UIImageView *view = objc_getAssociatedObject(self, &NavigationBarShadeImageViewKey);
    if (!view && ![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        view = self.parentViewController.navigationBarShadeImageView;
    }
    return view;
}

// MARK: - 导航栏底部分割线视图
- (void)setNavigationBarBottomLineView:(UIImageView *)navigationBarBottomLineView
{
    objc_setAssociatedObject(self, &NavigationBarBottomLineViewKey, navigationBarBottomLineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)navigationBarBottomLineView
{
    UIImageView *view = objc_getAssociatedObject(self, &NavigationBarBottomLineViewKey);
    if (!view && ![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        view = self.parentViewController.navigationBarBottomLineView;
    }
    return view;
}

// MARK: - 标题颜色
- (void)setNavigationBarTitleColor:(UIColor * _Nonnull)navigationBarTitleColor
{
    objc_setAssociatedObject(self, &NavigationBarTitleColorKey, navigationBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarTitleColor
{
    UIColor *color = objc_getAssociatedObject(self, &NavigationBarTitleColorKey);
    if (!color) {
        color = [self autoSplitedNavigationBarTitleColor];
        [self setNavigationBarTitleColor:color];
    }
    return color;
}

- (void)setNavigationBarTitleFont:(UIFont *)navigationBarTitleFont
{
    objc_setAssociatedObject(self, &NavigationBarTitleFontKey, navigationBarTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)navigationBarTitleFont
{
    UIFont *font = objc_getAssociatedObject(self, &NavigationBarTitleFontKey);
    if (!font) {
        font = [self autoSplitedNavigationBarTitleFont];
        [self setNavigationBarTitleFont:font];
    }
    return font;
}

#pragma mark - Hook Method

+ (void)load
{
    [$ swizzleMethod:@selector(viewDidLoad) with:@selector(nb_viewDidLoad) in:[UIViewController class]];
    [$ swizzleMethod:@selector(viewWillLayoutSubviews) with:@selector(nb_viewWillLayoutSubviews) in:[UIViewController class]];
}

#pragma mark - For BackgroundColor

- (void)nb_viewDidLoad
{
    [self addNavigationBarShadeImageViewIfNeeded];
    [self nb_viewDidLoad];
}

- (void)nb_viewWillLayoutSubviews
{
    [self nb_viewWillLayoutSubviews];
    [self resetNavigationBarShadeImageViewFrameIfNeeded];
}

#pragma mark - Private Method

- (void)addNavigationBarShadeImageViewIfNeeded
{
    if ([self ignoreHook]) {
        return;
    }
    if (self.shouldAddNavigationBarShadeImageView) {
        /// 导航栏背景颜色视图
        [self setnavigationBarShadeImageView:[UIImageView new]];
        [self.view addSubview:self.navigationBarShadeImageView];
        [self.view bringSubviewToFront:self.navigationBarShadeImageView];
        /// 导航栏底部分割线视图
        [self setNavigationBarBottomLineView:[UIImageView new]];
        [self.view addSubview:self.navigationBarBottomLineView];
        [self.view bringSubviewToFront:self.navigationBarBottomLineView];
        /// 布局
        [self resetNavigationBarShadeImageViewFrameIfNeeded];
        [self autoSplitNavigationBarShadeImageViewBackgroundColor];
    }
    [self hideSystemNavigationBarBackgroundColorView];
}

/// 隐藏系统的NavigationBar的背景
- (void)hideSystemNavigationBarBackgroundColorView
{
    if (iOS10) {
        ((UIView *)[self.navigationController.navigationBar firstSubviewOfClass:NSClassFromString(@"_UIBarBackground")]).alpha = 0;
        ((UIView *)[self.navigationController.navigationBar firstSubviewOfClass:NSClassFromString(@"UIVisualEffectView")]).alpha = 0;
    } else {
        ((UIView *)[self.navigationController.navigationBar firstSubviewOfClass:NSClassFromString(@"_UINavigationBarBackground")]).alpha = 0;
    }
}

- (void)resetNavigationBarShadeImageViewFrameIfNeeded
{
    if ([self ignoreHook]) {
        return;
    }
    if (!self.navigationController) {
        return;
    }
    
    if (![self shouldAddNavigationBarShadeImageView]) {
        return;
    }
    
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"backgroundView"];
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    rect.size.height += CGRectGetMinY(rect);
    rect.origin.y = 0;
    self.navigationBarShadeImageView.frame = rect;
    self.navigationBarBottomLineView.frame = CGRectMake(0, CGRectGetMaxY(rect), CGRectGetWidth(rect), 0.5);
    [self.view bringSubviewToFront:self.navigationBarShadeImageView];
    [self.view bringSubviewToFront:self.navigationBarBottomLineView];
}

- (BOOL)shouldAddNavigationBarShadeImageView
{
    /// UIImagePickerController需要添加
    if ([self.navigationController isKindOfClass:[UIImagePickerController class]] ) {
        if([NSStringFromClass([self class]) containsString:@"AlbumList"] ||
           [self isKindOfClass:NSClassFromString(@"PUUIPhotosAlbumViewController")] ||
           [self isKindOfClass:NSClassFromString(@"PUUIMomentsGridViewController")] ||
           [self isKindOfClass:NSClassFromString(@"PLUIPrivacyViewController")]){
            return YES;
        } else {
            return NO;
        }
    }
    
    /// 只有ViewController的子类才会添加ShadeImageView
    if (![self isKindOfClass:NSClassFromString(@"JZProduct.ViewController")]) {
        return NO;
    }
    
    /// 非UINavigationController的直接childViewController不用添加
    if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    
    if (!self.parentViewController) {
        return NO;
    }
    
    return YES;
}

/// 自动匹配NavigationBar的背景颜色
- (void)autoSplitNavigationBarShadeImageViewBackgroundColor
{
    self.navigationBarShadeImageView.backgroundColor = [self autoSplitedNavigationBarShadeImageViewBackgroundColor];
    self.navigationBarBottomLineView.backgroundColor = [self autoSplitedNavigationBarBottomLineViewBackgroundColor];
    if (![self conformsToProtocol:@protocol(NavigationBarButtonBlack)]) {
        [self updateNavigationBarBackgroundImage:[UIImage imageNamed:@"navbar_background"]];
    }
}

/// 自动匹配的NavigationBar的背景颜色
- (UIColor *)autoSplitedNavigationBarShadeImageViewBackgroundColor
{
    if ([self isKindOfClass:NSClassFromString(@"MWPhotoBrowser")]) {
        return [UIColor blackColor];
    } else {
        if ([self conformsToProtocol:@protocol(NavigationBarButtonBlack)]) {
            return [UIColor whiteColor];
        }
        // 默认导航颜色
        return COLOR_NAVIGATIONBAR_BACKGROUND;
    }
}

- (UIColor *)autoSplitedNavigationBarBottomLineViewBackgroundColor
{
    if ([self isKindOfClass:NSClassFromString(@"MWPhotoBrowser")]) {
        return [UIColor blackColor];
    } else {
        return [UIColor clearColor];
    }
}

/// 自动匹配的TitleColor
- (UIColor *)autoSplitedNavigationBarTitleColor
{
    if ([self conformsToProtocol:@protocol(NavigationBarButtonBlack)]) {
        return [UIColor blackColor];
    }
    return [UIColor whiteColor];
}

/// 自动匹配的TitleFont
- (UIFont *)autoSplitedNavigationBarTitleFont
{
    return [UIFont semiboldFontOfSize:17];
}

- (BOOL)ignoreHook
{
    /// Some uiview controller
    BOOL isIgnored = [NSStringFromClass([self class]) containsString: @"Some uiview controller"];
    return isIgnored;
}

- (UILabel *)navigationBarDefaultTitleLabel
{
    UINavigationItem *item = self.navigationItem;
    UILabel *label = [[item valueForKey:@"_defaultTitleView"] valueForKey:@"_label"];
    return label;
}

- (UIImage *)navigationBarBackIndicatorImageForState:(UIControlState)state
{
    if ([self conformsToProtocol:@protocol(NavigationBarButtonBlack)]) {
        if (state == UIControlStateNormal) {
            return [UIImage imageNamed:@"navbar_back_black_n"];
        } else {
            return [UIImage imageNamed:@"navbar_back_black_n_h"];
        }
    } else {
        if (state == UIControlStateNormal) {
            return [UIImage imageNamed:@"navbar_back_white_n"];
        } else {
            return [UIImage imageNamed:@"navbar_back_white_n_h"];
        }
    }
}

@end
