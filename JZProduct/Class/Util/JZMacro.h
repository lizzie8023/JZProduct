//
//  JZMacro.h
//  JZ Studio
//
//  Created by Jeff Zhao on 11-8-10.
//  Copyright 2011年 JZ Studio. All rights reserved.
//


#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

#define V_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define iPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define JZ_COLOR(r, g, b, a) \
        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define radians( degrees ) ( degrees * M_PI / 180 )

#define TRIM_STRING(string) \
    [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#define IS_EMPTY_STRING(string) \
    (string == nil || ![string isKindOfClass:[NSString class]] || [string length] == 0)

#define IS_SAME_COORD(coord1, coord2) \
    ((ABS(coord1.latitude-coord2.latitude) < 0.001) && ((ABS(coord1.longitude-coord2.longitude) < 0.001)))

#define NOT_NULL(obj) \
     ([obj isEqual:[NSNull null]] == NO && [obj isEqual:@"<null>"] == NO)

#define IS_VALID_STRING(str) \
        (str && ![str isEqual:[NSNull null]] && ![str isEqualToString:@""] && [str length] > 0 && ![str isEqualToString:@"<null>"])

// colors
// 默认导航颜色
#define COLOR_NAVIGATIONBAR_BACKGROUND JZ_COLOR(243, 103, 0, 1)
#define COLOR_NAVIGATIONBAR_TITLE V_COLOR(255, 255, 255, 1)
#define COLOR_TEXT_BLACK V_COLOR(71, 77, 83, 1)
#define COLOR_TEXT_BLACK_LIGHT V_COLOR(71, 77, 83, 0.5)
#define COLOR_CALENDAR_CELL_BG_S V_COLOR(133, 165, 235, 1.0)

#define run_sync_main(...) dispatch_sync(dispatch_get_main_queue(), ^{ __VA_ARGS__ });
#define run_async_main(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ });
#define run_async_background_priority(priority, ...) dispatch_async(dispatch_get_global_queue(priority, 0), ^{ __VA_ARGS__ });
#define run_async_background(...) run_async_background_priority(DISPATCH_QUEUE_PRIORITY_DEFAULT, __VA_ARGS__ )
#define run_async_delay(t, ...) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t * NSEC_PER_SEC), jz_dispatch_get_current_queue(), ^{__VA_ARGS__});
#define run_async_main_delay(t, ...) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t * NSEC_PER_SEC), dispatch_get_main_queue(), ^{__VA_ARGS__});
#define run_once(...) static dispatch_once_t oncePredicate; dispatch_once(&oncePredicate, ^{__VA_ARGS__});

#define jz_dispatch_get_current_queue() ([NSThread isMainThread] ? dispatch_get_main_queue() : jz_dispatch_get_default_priority_global_queue())
#define jz_dispatch_get_default_priority_global_queue() (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))

// Check OS version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//#define iOS6 [[[UIDevice currentDevice] systemVersion] floatValue]>=6.0
#define iOS5 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")
#define iOS6 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define iOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define iOS9 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
#define iOS10 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define iOS11 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")
#define iOS4Only (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0") && SYSTEM_VERSION_LESS_THAN(@"5.0"))
#define iOS5Only (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0") && SYSTEM_VERSION_LESS_THAN(@"6.0"))
#define iOS6Only (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0") && SYSTEM_VERSION_LESS_THAN(@"7.0"))
#define iOS7Only (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0"))
#define iOS8Only (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"9.0"))
#define iOS8Before (SYSTEM_VERSION_LESS_THAN(@"8.0"))
// Check device
#define IPHONE4 ((round([[UIScreen mainScreen] bounds].size.height) == 480)? YES:NO)
#define IPHONE5 ((round([[UIScreen mainScreen] bounds].size.height) == 568)? YES:NO)
#define IPHONE6 ((round([[UIScreen mainScreen] bounds].size.height) == 667)? YES:NO)
#define IPHONE6P ((round([[UIScreen mainScreen] bounds].size.height) == 736)? YES:NO)

#define isRetina ([UIScreen mainScreen].scale>=2.0?YES:NO)

#define $(...) ((NSString *)[NSString stringWithFormat:__VA_ARGS__, nil])

// Associated object, for adding ivar in category
#define ASSOCIATED_PROPERTY(IVAR_TYPE, IVAR, reference_type)                   \
@property (nonatomic, reference_type, setter=set##IVAR:) IVAR_TYPE IVAR;

#define ASSOCIATED_DYNAMIC(IVAR_TYPE, IVAR, associative_reference_type)     \
@dynamic IVAR;                                                 \
\
- (IVAR_TYPE)IVAR {                                            \
    return objc_getAssociatedObject(self, @ "key_" #IVAR);       \
}                                                                           \
\
- (void)set##IVAR:(IVAR_TYPE)object {                            \
    objc_setAssociatedObject(self, @ "key_" #IVAR, object, associative_reference_type); \
}

#define ASSOCIATED_DYNAMIC_SETTER(IVAR_TYPE, IVAR, IVAR_SETTER, associative_reference_type)     \
@dynamic IVAR;                                                 \
\
- (IVAR_TYPE)IVAR {                                            \
return objc_getAssociatedObject(self, @ "key_" #IVAR);       \
}                                                                           \
\
- (void)IVAR_SETTER:(IVAR_TYPE)object {                            \
objc_setAssociatedObject(self, @ "key_" #IVAR, object, associative_reference_type); \
}

#define ASSOCIATED_DYNAMIC_ONCE(IVAR_TYPE, IVAR, associative_reference_type)\
@dynamic IVAR;                                                 \
\
- (IVAR_TYPE)IVAR {                                            \
    static dispatch_once_t once;                                            \
    dispatch_once(&once, ^{                                                 \
        self.IVAR = [self get_##IVAR];                                      \
    });                                                                     \
    return objc_getAssociatedObject(self, @ "key_" #IVAR);       \
}                                                                           \
\
- (void)set##IVAR:(IVAR_TYPE)object {                            \
    objc_setAssociatedObject(self, @ "key_" #IVAR, object, associative_reference_type); \
}


typedef void (^ActionBlock)(void);
typedef void (^ActionBlockSender)(id sender);
typedef void (^ActionBlockData)(id data);
typedef void (^ActionBlockSenderInfo)(id sender, NSDictionary *info);
typedef void (^ActionBlockIndex)(NSInteger index);

typedef void (^DismissBlock)(NSInteger buttonIndex, NSInteger firstOtherButtonIndex);
typedef void (^DismissBlockSender)(NSInteger buttonIndex, id sender);
typedef void (^CancelBlock)(void);

typedef void (^SuccessBlock)(id data);
typedef void (^FailureBlock)(NSString *errorMessage, NSError *error);


// Singleton
#define SINGLETON_INTERFACE(CLASSNAME)              \
+ (CLASSNAME*)shared;

#define SINGLETON_IMPLEMENTATION(CLASSNAME)         \
\
static CLASSNAME* g_shared##CLASSNAME = nil;        \
\
+ (CLASSNAME*)shared                                \
{                                                   \
static dispatch_once_t oncePredicate;           \
dispatch_once(&oncePredicate, ^{                \
g_shared##CLASSNAME = [[self alloc] init];  \
});                                             \
return g_shared##CLASSNAME;                     \
}                                                   \
\
+ (id)allocWithZone:(NSZone*)zone                   \
{                                                   \
@synchronized(self) {                               \
if (g_shared##CLASSNAME == nil) {                   \
g_shared##CLASSNAME = [super allocWithZone:zone];   \
return g_shared##CLASSNAME;                         \
}                                                   \
}                                                   \
NSAssert(NO, @ "[" #CLASSNAME                       \
" alloc] explicitly called on singleton class.");   \
return nil;                                         \
}                                                   \
\
- (id)copyWithZone:(NSZone*)zone                    \
{                                                   \
return self;                                        \
}                                                   \



// Float Arithmetics
#define kFloatEpsilon 1e-3
#define fequal(f1, f2) fabs(f1 - f2) <= kFloatEpsilon
#define fgreat(f1, f2) f1 - f2 > kFloatEpsilon
#define fless(f1, f2) fgreat(f2, f1)

// Weak Self for Block
#define $weakify(Class, self) __weak Class *weakSelf = self
#define $weak(self) weakSelf

#define $url(urlString) [NSURL URLWithString:urlString]
#define $img(imageName) [UIImage imageNamed:imageName]

#define $obj(object) (object ? object : [NSNull null])
#define $val(object) (object == [NSNull null] ? nil : object)
