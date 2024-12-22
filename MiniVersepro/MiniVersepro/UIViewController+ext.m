//
//  UIViewController+ext.m
//  MiniVersepro
//
//  Created by MiniVerse pro on 2024/12/22.
//

#import "UIViewController+ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KminiVerseUserDefaultkey __attribute__((section("__DATA, miniVerse_"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *KminiVerseJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, miniVerse_")));
NSDictionary *KminiVerseJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KminiVerseJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, miniVerse_")));
id KminiVerseJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KminiVerseJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KminiVerseShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, miniVerse_")));
void KminiVerseShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.miniVerse_GetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KminiVerseSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, miniVerse_")));
void KminiVerseSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.miniVerse_GetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KminiVerseAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, miniVerse_af")));
NSString *KminiVerseAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KminiVerseConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, miniVerse_af")));
NSString* KminiVerseConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ext)
/// 设置背景颜色
- (void)miniVerse_setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

/// 显示加载指示器
- (void)miniVerse_showLoadingIndicatorWithMessage:(NSString *)message {
    // 创建一个容器视图
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    loadingView.tag = 999; // 设置一个标识符方便移除

    // 创建活动指示器
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    indicator.center = CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2 - 20);
    [indicator startAnimating];

    // 创建提示标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, indicator.center.y + 30, loadingView.bounds.size.width, 30)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];

    // 添加视图
    [loadingView addSubview:indicator];
    [loadingView addSubview:label];
    [self.view addSubview:loadingView];
}

/// 隐藏加载指示器
- (void)miniVerse_hideLoadingIndicator {
    UIView *loadingView = [self.view viewWithTag:999];
    if (loadingView) {
        [loadingView removeFromSuperview];
    }
}

/// 添加一个子视图控制器并自动设置约束
- (void)miniVerse_addChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    childController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:childController.view];

    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [childController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [childController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [childController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [childController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    [childController didMoveToParentViewController:self];
}

- (void)miniVerse_PrintViewControllerHierarchy {
    NSLog(@"Berber ViewController Hierarchy:\n%@", [self berberHierarchyDescription:self level:0]);
}

- (NSString *)berberHierarchyDescription:(UIViewController *)vc level:(NSUInteger)level {
    NSMutableString *description = [NSMutableString string];
    for (NSUInteger i = 0; i < level; i++) {
        [description appendString:@"  "]; // 添加缩进
    }
    [description appendFormat:@"- %@\n", NSStringFromClass([vc class])];
    for (UIViewController *childVC in vc.childViewControllers) {
        [description appendString:[self berberHierarchyDescription:childVC level:level + 1]];
    }
    return description;
}


+ (NSString *)miniVerse_GetUserDefaultKey
{
    return KminiVerseUserDefaultkey;
}

+ (void)miniVerse_SetUserDefaultKey:(NSString *)key
{
    KminiVerseUserDefaultkey = key;
}

+ (NSString *)miniVerse_AppsFlyerDevKey
{
    return KminiVerseAppsFlyerDevKey(@"berberR9CH5Zs5bytFgTj6smkgG8berber");
}

- (NSString *)miniVerse_MaHostUrl
{
    return @"jichuhai.top";
}

- (BOOL)miniVerse_NeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)miniVerse_ShowAdView:(NSString *)adsUrl
{
    KminiVerseShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)miniVerse_JsonToDicWithJsonString:(NSString *)jsonString {
    return KminiVerseJsonToDicLogic(jsonString);
}

- (void)miniVerse_SendEvent:(NSString *)event values:(NSDictionary *)value
{
    KminiVerseSendEventLogic(self, event, value);
}

- (void)miniVerse_SendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self miniVerse_JsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)miniVerse_AfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self miniVerse_JsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.miniVerse_GetUserDefaultKey];
    if ([KminiVerseConvertToLowercase(name) isEqualToString:KminiVerseConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)miniVerse_AfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self miniVerse_JsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.miniVerse_GetUserDefaultKey];
    if ([KminiVerseConvertToLowercase(name) isEqualToString:KminiVerseConvertToLowercase(adsDatas[24])] || [KminiVerseConvertToLowercase(name) isEqualToString:KminiVerseConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}
@end
