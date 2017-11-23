//
//  UIViewController+NBStyle.h
//  JeffZhao
//
//  Created by JeffZhao on 16/5/9.
//  Copyright © 2016年 JZ Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 添加navigationBarShadeImageView的原则
///
/// NavigationController的“直接”子控制器
///
/// 也就是如果控制器是通过addChildViewController的方式添加的，它本身不需要拥有navigationBarShadeImageView。
///
/// 特殊情况:
/// RootViewController除外, 因为RootViewController的子视图本身都需要有独立的navigationBarShadeImageView来显示相应的背景颜色

@interface UIViewController (NBStyle)
/// 如果当前视图的parentViewController为UINavigationController类型则直接返回本身的navigationBarShadeImageView
/// 否则返回其parentViewController的navigationBarShadeImageView
@property(nonatomic, readonly, nullable) UIImageView *navigationBarShadeImageView;
@property(nonatomic, readonly, nullable) UIImageView *navigationBarBottomLineView;
@property(nonatomic, readonly, null_resettable) UIColor *navigationBarTitleColor;
/// 配置导航栏背景颜色
- (void)updateNavigationBarAlpha:(CGFloat)alpha;
- (void)updateNavigationBarBackgroundColor:(nonnull UIColor *)color;
- (void)updateNavigationBarBackgroundImage:(nullable UIImage *)image;
/// 配置导航栏底部的分割线
- (void)updateNavigationBarBottomLineColor:(nonnull UIColor *)color;
- (void)makeNavigationBarBottomLineHidden:(BOOL)hidden;
/// 配置T导航栏标题颜色
- (void)updateNavigationBarTitleColor:(nonnull UIColor *)color;
- (void)updateNavigationBarTitleColor:(nonnull UIColor *)color font:(nonnull UIFont *)font;
/// 同时设置导航栏的背景颜色和标题颜色
- (void)updateNavigationBarAlpha:(CGFloat)alpha titleColor:(nonnull UIColor *)color;
- (nullable UILabel *)navigationBarDefaultTitleLabel;
/// 配置返回按钮的图标
- (nullable UIImage *)navigationBarBackIndicatorImageForState:(UIControlState)state;
//- (void)setNavigationBarBackIndicatorImage:(nullable UIImage *)img forState:(UIControlState)state;
@end
