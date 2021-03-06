//
//  DMMacros.h
//  DiscoverMelody
//

#define APP_DELEGATE ((AppDelegate *)[[NSApplication sharedApplication]delegate])
#define DMDelegate   ((AppDelegate *)[[NSApplication sharedApplication]delegate])
#define APP_WINDOW   [[NSApplication sharedApplication]mainWindow]
#define DMWindow     [[NSApplication sharedApplication]mainWindow]

#pragma mark - Font

#define DMFontPingFang_Light(fontSize) [UIFont fontWithName:@"PingFangSC-Light" size:fontSize]//细体
#define DMFontPingFang_UltraLight(fontSize) [UIFont fontWithName:@"PingFangSC-UltraLight" size:fontSize]//极细体
#define DMFontPingFang_Medium(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]//中黑体
#define DMFontPingFang_Thin(fontSize) [UIFont fontWithName:@"PingFangSC-Thin" size:fontSize]//纤细体
#define DMFontPingFang_Regular(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]//常规

#pragma mark - Color

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((((rgbValue) & 0xFF0000) >> 16))/255.f \
green:((((rgbValue) & 0xFF00) >> 8))/255.f \
blue:(((rgbValue) & 0xFF))/255.f alpha:1.0]

#define DMColorWithRGBA(red,green,blue,alpha) [UIColor colorWithR:red g:green b:blue a:alpha]

#define DMColorWithHexString(hex) [UIColor colorWithHexString:hex]

#define DMColorBaseMeiRed DMColorWithRGBA(246, 8, 112, 1)

#define DMColor102 DMColorWithRGBA(102, 102, 102, 1)
#define DMColor153 DMColorWithRGBA(153, 153, 153, 1)
#define DMColor33(alpha) DMColorWithRGBA(33, 33, 33, alpha)

#pragma mark - Numerical value
#define DMScreenHeight [UIScreen mainScreen].bounds.size.height
#define DMScreenWidth [UIScreen mainScreen].bounds.size.width

#define DMScaleWidth(w) (DMScreenWidth * w / 1024)
#define DMScaleHeight(h) (DMScreenHeight * h / 768)

#pragma mark - Log
#ifdef DEBUG
#define DMLog(...)                      NSLog(__VA_ARGS__);
#define NSLog(...)                      NSLog(__VA_ARGS__);
#define DMLogFunc                       DMLog(@"%s",__func__);
#define DMLogLine(arg1)                 DMLog(@"M:%s, L:%d.|\n%@",  __func__, __LINE__, arg1);
#else
#define DMLog(...)
#define DMLogLine(arg1)
#define NSLog(...)
#define DMLogFunc                       DMLog(...)
#endif

#pragma mark - Other

//系统版本是否大于等于11
#define DM_SystemVersion_11  (([[UIDevice currentDevice].systemVersion integerValue] >= 11)?1:0)

#define HeadPlaceholderName [UIImage imageNamed:@"image_head_placeholder_icon"]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define DMNotificationCenter [NSNotificationCenter defaultCenter]

//#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define STR_IS_NIL(key) (!!([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]))



