//
//  UIView+Hierarchy.h
//  
//
//  Created by Jeff Zhao on 13-11-5.
//  Copyright (c) 2013年 JZ Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Hierarchy)
- (nullable UIView *)ancestorView:(Class)viewClass;
- (nullable UIViewController *)ancestorViewController;
- (nullable UIView *)firstResponderSubView;
- (nullable UIView *)firstSubviewOfClass:(Class)clazz;
- (nullable UIView *)firstSubviewOfClass:(Class)clazz maxDeepnessLevel:(NSInteger)deepness;
- (void)removeSubviews;
@end

NS_ASSUME_NONNULL_END
