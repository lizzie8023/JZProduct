//
//  Hook.m
//  Pods
//
//  Created by JeffZhao on 2016/12/2.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaptainHook.h"
#import "MLBlackTransition.h"
#import "NavigationBarButtonStyleProtocol.h"
#import "UIViewController+NBStyle.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

CHDeclareClass(UINavigationItemView);

CHMethod0(void, UINavigationItemView, _updateLabelColor)
{
    CHSuper0(UINavigationItemView, _updateLabelColor);
    UIView *obj = (id)self;
    UINavigationItem *item = [obj valueForKey:@"_item"];
    UINavigationBar *bar = [item valueForKeyPath:@"_navigationBar"];
    if ([bar.delegate isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (id)bar.delegate;
        UILabel *label = [[bar valueForKey:@"titleView"] valueForKey:@"label"];
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor = navc.topViewController.navigationBarTitleColor;
        }
    }
}

CHMethod1(void, UINavigationItemView, setFrame, CGRect, rect)
{
    CHSuper1(UINavigationItemView, setFrame, rect);
    UIView *obj = (id)self;
    UINavigationItem *item = [obj valueForKey:@"_item"];
    /// 返回按钮的Label的文案
    [item setValue:@"" forKey:@"_backButtonTitle"];
    //    obj.backgroundColor = [UIColor blueColor];
    //    obj.superview.backgroundColor = [UIColor blueColor];
    /// 返回按钮的Label
    //    UILabel *label = [obj valueForKey:@"_label"];
    //    label.backgroundColor = [UIColor yellowColor];
    /// 返回按钮的ImageView
    UIImageView *imageView = [item valueForKeyPath:@"_backButtonView.backgroundImageView"];
    UINavigationBar *bar = [item valueForKeyPath:@"_navigationBar"];
    if (imageView && [bar.delegate isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (id)bar.delegate;
        UIEdgeInsets insets = UIEdgeInsetsMake(0, -7, 0, -10);
        if ([navc.topViewController conformsToProtocol:@protocol(NavigationBarButtonBlack)]) {
            imageView.image = [[UIImage imageNamed:@"navbar_back_black_n"] imageWithAlignmentRectInsets:insets];
            imageView.highlightedImage = [[UIImage imageNamed:@"navbar_back_black_n_h"] imageWithAlignmentRectInsets:insets];
        } else {
            imageView.image = [[UIImage imageNamed:@"navbar_back_white_n"] imageWithAlignmentRectInsets:insets];
            imageView.highlightedImage = [[UIImage imageNamed:@"navbar_back_white_n_h"] imageWithAlignmentRectInsets:insets];
        }
    }
}

CHDeclareClass(_UINavigationBarContentView);

CHMethod2(void, _UINavigationBarContentView, _applyTitleAttributesToLabel, id, arg1, withString, id, arg2)
{
    CHSuper2(_UINavigationBarContentView, _applyTitleAttributesToLabel, arg1, withString, arg2);
    UINavigationBar *bar = (UINavigationBar *)[(id)self superview];
    if ([arg1 isKindOfClass:[UILabel class]] && [bar isKindOfClass:[UINavigationBar class]] && [bar.delegate isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (id)bar.delegate;
        UILabel *label = (id)arg1;
        label.textColor = navc.topViewController.navigationBarTitleColor;
    }
}

CHDeclareClass(_UIButtonBarButtonVisualProviderIOS);

CHMethod2(void, _UIButtonBarButtonVisualProviderIOS, buttonLayoutSubviews, id, arg1, baseImplementation, id, arg2)
{
    CHSuper2(_UIButtonBarButtonVisualProviderIOS, buttonLayoutSubviews, arg1, baseImplementation, arg2);
    UINavigationBar *bar = (UINavigationBar *)[(id)self valueForKeyPath:@"appearanceDelegate.superview"];
    UIButton *button = [(id)self valueForKey:@"_backIndicatorButton"];
    if ([button isKindOfClass:[UIButton class]] && [bar isKindOfClass:[UINavigationBar class]] && [bar.delegate isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (id)bar.delegate;
        [button performSelector:@selector(setDisabledDimsImage:) withObject:@(YES)];
        [button setImage:[navc.topViewController navigationBarBackIndicatorImageForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button setImage:[navc.topViewController navigationBarBackIndicatorImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    }
}

CHMethod2(void, _UIButtonBarButtonVisualProviderIOS, configureButton, id, arg1, fromBarButtonItem, UIBarButtonItem *, arg2)
{
    arg2.title = @"";
    CHSuper2(_UIButtonBarButtonVisualProviderIOS, configureButton, arg1, fromBarButtonItem, arg2);
}

CHDeclareClass(UINavigationBar);

CHMethod2(UIView *, UINavigationBar, hitTest, CGPoint, point, withEvent, UIEvent *, event)
{
    UINavigationBar *bar = (id)CHSuper2(UINavigationBar, hitTest, point, withEvent, event);
    if ([bar isKindOfClass:[UINavigationBar class]] && [bar.delegate isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (id)bar.delegate;
        if ([navc valueForKey:@"_disappearingViewController"] != nil) {
            navc.interactivePopGestureRecognizer.enabled = NO;
            return nil;
        }
    }
    return bar;
}

__attribute__((constructor)) static void Hook()
{
    /// 修改系统默认返回按钮的文案
    /// 修改Title的颜色
    {
        if (([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)) {
            /// iOS11
            CHLoadLateClass(_UINavigationBarContentView);
            CHHook2(_UINavigationBarContentView, _applyTitleAttributesToLabel, withString);
            CHLoadLateClass(_UIButtonBarButtonVisualProviderIOS);
            CHHook2(_UIButtonBarButtonVisualProviderIOS, configureButton, fromBarButtonItem);
            CHHook2(_UIButtonBarButtonVisualProviderIOS, buttonLayoutSubviews, baseImplementation);
        } else {
            CHLoadLateClass(UINavigationItemView);
            CHHook1(UINavigationItemView, setFrame);
            /// iOS10及更低版本
            CHHook0(UINavigationItemView, _updateLabelColor);
        }
    }
    
    /// 滑动返回时NavigationBar上的按钮不可点击
    CHLoadLateClass(UINavigationBar);
    CHClassHook2(UINavigationBar, hitTest, withEvent);
    /// 全局滑动返回
    [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypeScreenEdgePan];
}

#pragma clang diagnostic pop

