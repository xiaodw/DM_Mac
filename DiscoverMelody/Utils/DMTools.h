//
//  DMTools.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#import "UIView+Toast.h"
@interface DMTools : NSObject
/*
 * 是否包含某个字体
 */
+ (BOOL)isHaveFont:(NSString *)postScriptName;

/**
 * 获取当前时间戳
 */
+ (NSString *)getCurrentTimestamp;
/*
 * 时间戳 转 时间
 */
+ (NSString *)timeFormatterYMDFromTs:(NSString *)ts format:(NSString *)formatStr;
/**
 * 秒 转 分钟
 */
+ (NSString *)secondsConvertMinutes:(NSString *)seconds;
/**
 * 根据时长，计算时间段
 */
+ (NSString *)computationsPeriodOfTime:(NSString *)startTime duration:(NSString *)duration;
/**
 * 距离上课时间差
 */
+ (NSTimeInterval)computationsClassTimeDifference:(NSString *)startTime accessTime:(NSString *)accessTime;
/**
 * 摄像头，麦克风权限授权
 */
+ (void)requestAccessForMediaVideoAndAudio;

/**
 * 显示提示框
 */
//+ (void)showMessageToast:(NSString *)msg duration:(NSTimeInterval)duration position:(id)style;

//获取纯色图片


+ (NSImage *)imageWithColor:(NSColor *)color size:(CGSize)size alpha:(float)alpha;

//进行图片压缩
+ (NSData *)compressedImageForUpload:(NSImage *)sourceImage;
+ (NSData *)compressedImageDataForUpload:(NSData *)sourceData;

//计算文字对应的label高度
+(CGFloat)getContactHeight:(NSString*)contact font:(NSFont *)font width:(CGFloat)width;

//计算文字宽度
+(CGFloat)getContactWidth:(NSString*)contact font:(NSFont *)font height:(CGFloat)height;

//成功/失败 提示框
+(void)showSVProgressHudCustom:(NSString *)imageName title:(NSString *)title;

@end






