//
//  UIFont+Addition.h
//  
//
//  Created by JeffZhao on 2017/7/20.
//  Copyright © 2017年 JeffZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition)
+ (UIFont *)UltraLightFontWithSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)thinFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)lightFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)regularFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)mediumFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)semiboldFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)heavyFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
+ (UIFont *)blackFontOfSize:(CGFloat)fontSize NS_AVAILABLE_IOS(8_2);
@end

NS_ASSUME_NONNULL_END
