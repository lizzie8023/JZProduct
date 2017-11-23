//
//  NSString+NSString_Inflections.h
//  Fungo
//
//  Created by Jeff Zhao on 15/9/17.
//  Copyright © 2015年 Phantomex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Inflections)
- (NSString *)underscore;
- (NSString *)camelcase;
- (NSString *)classify;
- (NSString *)capitalize;
- (NSString *)decapitalize;
@end

NS_ASSUME_NONNULL_END
