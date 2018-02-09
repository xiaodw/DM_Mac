//
//  AppData.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/6.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "AppData.h"

static AppData *defaultAppData = nil;

@implementation AppData

+ (instancetype)defaultAppData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultAppData = [[super allocWithZone:NULL] init];
    });
    return defaultAppData;
}

-(void)setAgoraAppId:(NSString*)appId {
    [self setObject:appId forKey:@"agoraAppId"];
}

-(void)setAgoraVideoProfile:(NSInteger)profile {
    [self setObject:[NSString stringWithFormat:@"%ld",(long)profile] forKey:@"agoraVideoProfile"];
}

-(NSString*)getAgoraAppId {
    NSString* appId = [self getObjectByKey:@"agoraAppId"];
    if (nil == appId) {
        appId = @"f8101ce899cc4da8807b3eb81bed86e3";
    }
    return appId;
}

-(NSInteger)getAgoraVideoProfile {
    NSString* profile = [self getObjectByKey:@"agoraVideoProfile"];
    if (nil == profile) {
        profile = @"55";
    }
    return [profile integerValue];
}

@end
