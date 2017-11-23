//
//  UIView+Designable.m
//  JeffZhao
//
//  Created by Jeff Zhao on 15/10/30.
//  Copyright © 2015年 JZ Studio. All rights reserved.
//

#import "UIView+Designable.h"
#import <objc/runtime.h>

@implementation UIView (Designable)
    
@dynamic borderWidth, borderColor, cornerRadius;

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end
