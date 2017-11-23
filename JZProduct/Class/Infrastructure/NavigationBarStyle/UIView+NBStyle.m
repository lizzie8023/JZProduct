//
//  UIView+NBStyle.m
//  JeffZhao
//
//  Created by JeffZhao on 16/5/9.
//  Copyright © 2016年 JZ Studio. All rights reserved.
//

#import "UIView+NBStyle.h"
#import <ConciseKit/ConciseKit.h>

@implementation UIView (NBStyle)

+ (void)load
{
    [$ swizzleMethod:@selector(setClipsToBounds:) with:@selector(nb_setClipsToBounds:) in:[UIView class]];
}

- (void)nb_setClipsToBounds:(BOOL)clipsToBounds
{
    UIViewController *vc = (UIViewController *)[self nextResponder];
    if ([vc isKindOfClass:[UIViewController class]] && [vc.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self nb_setClipsToBounds:false];
    } else {
        [self nb_setClipsToBounds:clipsToBounds];
    }
}

@end
