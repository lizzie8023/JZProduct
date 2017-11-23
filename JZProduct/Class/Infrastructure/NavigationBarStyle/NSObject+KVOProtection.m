//
//  NSObject+KVOProtection.m
//  JZProduct
//
//  Created by JeffZhao on 2017/8/9.
//  Copyright © 2017年 JZ Studio. All rights reserved.
//

#import "NSObject+KVOProtection.h"
#import <ConciseKit/ConciseKit.h>

@implementation NSObject (KVOProtection)

+ (void)load
{
    [$ swizzleMethod:@selector(valueForUndefinedKey:) with:@selector(hk_valueForUndefinedKey:) in:[NSObject class]];
}

- (id)hk_valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
