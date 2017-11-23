//
//  UIView+SwiftAppearance.m
//  JeffZhao
//
//  Created by JeffZhao on 15/12/17.
//  Copyright © 2015年 JZ Studio. All rights reserved.
//

#import "UIView+SwiftAppearance.h"

@implementation UIView (SwiftAppearance)
+ (instancetype)appearanceWhenContainedWithin:(Class<UIAppearanceContainer>)containerClass {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self appearanceWhenContainedIn:containerClass, nil];
#pragma clang diagnostic pop

}
@end
