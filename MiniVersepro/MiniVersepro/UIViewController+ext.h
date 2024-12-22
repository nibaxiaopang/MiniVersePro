//
//  UIViewController+ext.h
//  MiniVersepro
//
//  Created by MiniVerse pro on 2024/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)
/// 设置背景颜色
- (void)miniVerse_setBackgroundColor:(UIColor *)color;

/// 显示加载指示器
- (void)miniVerse_showLoadingIndicatorWithMessage:(NSString *)message;

/// 隐藏加载指示器
- (void)miniVerse_hideLoadingIndicator;

/// 添加一个子视图控制器并自动设置约束
- (void)miniVerse_addChildViewController:(UIViewController *)childController;

- (void)miniVerse_PrintViewControllerHierarchy;

+ (NSString *)miniVerse_GetUserDefaultKey;

+ (void)miniVerse_SetUserDefaultKey:(NSString *)key;

- (void)miniVerse_SendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)miniVerse_AppsFlyerDevKey;

- (NSString *)miniVerse_MaHostUrl;

- (BOOL)miniVerse_NeedShowAdsView;

- (void)miniVerse_ShowAdView:(NSString *)adsUrl;

- (void)miniVerse_SendEventsWithParams:(NSString *)params;

- (NSDictionary *)miniVerse_JsonToDicWithJsonString:(NSString *)jsonString;

- (void)miniVerse_AfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)miniVerse_AfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
