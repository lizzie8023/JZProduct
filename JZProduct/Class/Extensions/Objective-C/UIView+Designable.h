//
//  UIView+Designable.h
//  JeffZhao
//
//  Created by Jeff Zhao on 15/10/30.
//  Copyright © 2015年 JZ Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface UIView (Designable)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;    // in pixel
@end
