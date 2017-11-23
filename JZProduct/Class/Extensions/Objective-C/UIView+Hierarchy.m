//
//  UIView+Hierarchy.m
//  
//
//  Created by Jeff Zhao on 13-11-5.
//  Copyright (c) 2013年 JZ Studio. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

- (UIView *)ancestorView:(Class)viewClass {
    UIView *view = self;
    while (view && ![view isKindOfClass:viewClass])
        view = [view superview];
    if ([view isKindOfClass:viewClass]) {
        return view;
    }
    return nil;
}

- (UIView *)firstSubviewOfClass:(Class)clazz
{
    return [self firstSubviewOfClass:clazz maxDeepnessLevel:3];
}

- (UIView *)firstResponderSubView {
    if (self.isFirstResponder)
        return self;
    
    for (UIView *subView in self.subviews) {
        id responder = [subView firstResponderSubView];
        if (responder)
            return responder;
    }
    return nil;
}

- (UIView *)firstSubviewOfClass:(Class)clazz maxDeepnessLevel:(NSInteger)deepness {
    if (deepness == 0) {
        return nil;
    }
    
    NSInteger count = deepness;
    
    NSArray *subviews = self.subviews;
    
    while (count > 0) {
        for (UIView *v in subviews) {
            if ([v isKindOfClass:clazz]) {
                return v;
            }
        }
        
        count--;
        
        for (UIView *v in subviews) {
            UIView *retVal = [v firstSubviewOfClass:clazz maxDeepnessLevel:count];
            if (retVal) {
                return retVal;
            }
        }
    }
    
    return nil;
}

- (void)removeSubviews {
    for (UIView *subview in self.subviews)
        [subview removeFromSuperview];
}


- (UIViewController*)ancestorViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end

