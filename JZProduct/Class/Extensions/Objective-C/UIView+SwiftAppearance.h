//
//  UIView+SwiftAppearance.h
//  JeffZhao
//
//  Created by JeffZhao on 15/12/17.
//  Copyright © 2015年 JZ Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SwiftAppearance)
// Swift没有支持iOS9一下版本的相应的方法
+ (instancetype)appearanceWhenContainedWithin:(Class<UIAppearanceContainer>)containerClass;
@end
