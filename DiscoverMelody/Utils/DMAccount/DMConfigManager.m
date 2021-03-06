//
//  DMConfigManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMConfigManager.h"

#import "DMMacros.h"
#import "DMUserDefaults.h"
#import "DMServerApiConfig.h"

#define DMConfig_Api_Host @"DMConfig_Api_Host"
#define DMConfig_Log_Host @"DMConfig_Log_Host"
#define DMConfig_AgoraAppId @"DMConfig_AgoraAppId"
#define DMConfig_UploadMaxSize @"DMConfig_UploadMaxSize"
#define DMConfig_AgoraVideoProfile @"DMConfig_AgoraVideoProfile"

static DMConfigManager *configInstance = nil;

@implementation DMConfigManager

- (void)initConfigInformation {
    self.apiHost = [self getApiHost];
    self.logHost = [self getLogHost];
    self.agoraAppId = [self getAgoraAppID];
    self.uploadMaxSize = [self getUploadMaxSize];
    self.agoraVideoProfile = [self getAgoraVideoProfile];
}

- (void)saveConfigInfo:(DMSetConfigData *)configObj {
    if (!OBJ_IS_NIL(configObj)) {
        
        [DMConfigManager saveApiHost:configObj.apiHost];
        [DMConfigManager saveLogHost:configObj.logHost];
        [DMConfigManager saveAgoraAppID:configObj.agoraAppId];
        [DMConfigManager saveUploadMaxSize:configObj.uploadMaxSize];
        [DMConfigManager saveAgoraVideoProfile:configObj.agoraVideoProfile];
        
        self.apiHost = configObj.apiHost;
        self.logHost = configObj.logHost;
        self.agoraAppId = configObj.agoraAppId;
        self.uploadMaxSize = configObj.uploadMaxSize;
        self.agoraVideoProfile = configObj.agoraVideoProfile;
    }
}

- (NSString *)getApiHost {
    NSString *host = [DMUserDefaults getValueWithKey:DMConfig_Api_Host];
    return STR_IS_NIL(host) ? DM_Local_Url: host;
}

- (NSString *)getLogHost {
    NSString *host = [DMUserDefaults getValueWithKey:DMConfig_Log_Host];
    return STR_IS_NIL(host) ? DMLog_Local_Url: host;
}

- (NSString *)getAgoraAppID {
    NSString *pid = [DMUserDefaults getValueWithKey:DMConfig_AgoraAppId];
    return STR_IS_NIL(pid) ? DMAgoraAppID_Local_Config: pid;
}

- (NSString *)getAgoraVideoProfile {
    NSString *aP = [DMUserDefaults getValueWithKey:DMConfig_AgoraVideoProfile];
    return STR_IS_NIL(aP) ? DMAgoraVideoProfile_Config: aP;
}

- (NSString *)getUploadMaxSize {
    NSString *ms = [DMUserDefaults getValueWithKey:DMConfig_UploadMaxSize];
    return STR_IS_NIL(ms) ? [NSString stringWithFormat:@"%d",DMImage_Size_Config]: ms;
}

//保存APi Url
+ (void)saveApiHost:(NSString *)host {
    [DMUserDefaults setValue:host forKey:DMConfig_Api_Host];
}
//保存Log Url
+ (void)saveLogHost:(NSString *)host {
    [DMUserDefaults setValue:host forKey:DMConfig_Log_Host];
}
//保存agora id
+ (void)saveAgoraAppID:(NSString *)agoID {
    [DMUserDefaults setValue:agoID forKey:DMConfig_AgoraAppId];
}
//保存
+ (void)saveAgoraVideoProfile:(NSString *)vProfile {
    [DMUserDefaults setValue:vProfile forKey:DMConfig_AgoraVideoProfile];
}
//保存Upload Image Max Size
+ (void)saveUploadMaxSize:(NSString *)maxSize {
    [DMUserDefaults setValue:maxSize forKey:DMConfig_UploadMaxSize];
}


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configInstance = [[super allocWithZone:NULL] init];
    });
    return configInstance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [DMConfigManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [DMConfigManager shareInstance];
}
@end
