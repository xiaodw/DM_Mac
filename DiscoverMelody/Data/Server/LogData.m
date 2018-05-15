//
//  LogData.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/7.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "LogData.h"
#import "UrlConfig.h"

static LogData *defaultLogData = nil;

@implementation LogData

+ (instancetype)defaultLogData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLogData = [[super allocWithZone:NULL] init];
    });
    return defaultLogData;
}

-(NSMutableDictionary*)buildCommonRequestField {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"ver"] = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    dic[@"app"] = @"mac";
    dic[@"lan"] = NSLocalizedString(@"GLOBAL_APP_LANGUAGE", nil);
#if defined(PRODUCT_TYPE_WE_EDUCATION)
    dic[@"business"] = @"weedu";
#elif defined(PRODUCT_TYPE_DISCOVER_MELODY)
    dic[@"business"] = @"discover-melody";
#elif defined(PRODUCT_TYPE_WE_DESIGN)
    dic[@"business"] = @"wedesign";
#endif
    return dic;
}

-(void)reportWithParams:(id)params {
    [self requestWithPath:URL_REPORT_AGORA_LOG method:HttpRequestPost parameters:params success:^(id responseObject) {
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@", responseObj);
        if (nil == responseObj) {
            NSLog(@"Report log failed");
            return;
        }
        
        NSString* retCode = [responseObj objectForKey:@"code"];
        if (0 != [retCode intValue]) {
            NSLog(@"Report log failed");
            return;
        }
        NSLog(@"Report log success");
    } failure:^(NSError *error) {
        NSLog(@"Report log failed,%@", [error localizedDescription]);
    }];
}

-(void)reportUserEnter:(NSString*)target Reporter:(NSString*)reporter MeetingId:(NSString*)meetingId Token:(NSString*)token {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    dic[@"token"] = token;
    dic[@"meeting_id"] = meetingId;
    dic[@"target_uid"] = target;
    dic[@"upload_uid"] = reporter;
    dic[@"action"] = @"enter";
    [self reportWithParams:dic];
}

-(void)reportUserExit:(NSString*)target Reporter:(NSString*)reporter MeetingId:(NSString*)meetingId Token:(NSString*)token {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    dic[@"token"] = token;
    dic[@"meeting_id"] = meetingId;
    dic[@"target_uid"] = target;
    dic[@"upload_uid"] = reporter;
    dic[@"action"] = @"exit";
    [self reportWithParams:dic];
}

-(void)reportNetError:(NSString*)target Reporter:(NSString*)reporter MeetingId:(NSString*)meetingId Token:(NSString*)token {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    dic[@"token"] = token;
    dic[@"meeting_id"] = meetingId;
    dic[@"target_uid"] = target;
    dic[@"upload_uid"] = reporter;
    dic[@"action"] = @"neterr";
    [self reportWithParams:dic];
}

@end
