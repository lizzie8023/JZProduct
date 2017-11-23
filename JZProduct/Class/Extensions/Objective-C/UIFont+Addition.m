//
//  UIFont+Addition.m
//  
//
//  Created by JeffZhao on 2017/7/20.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

#import "UIFont+Addition.h"

@implementation UIFont (Addition)

+ (UIFont *)UltraLightFontWithSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightUltraLight];
}

+ (UIFont *)thinFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightThin];
}

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightLight];
}

+ (UIFont *)regularFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightRegular];
}

+ (UIFont *)mediumFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightMedium];
}

+ (UIFont *)semiboldFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightSemibold];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightBold];
}

+ (UIFont *)heavyFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightHeavy];
}

+ (UIFont *)blackFontOfSize:(CGFloat)fontSize
{
    return [self systemFontOfSize:fontSize weight:UIFontWeightBlack];
}

@end
