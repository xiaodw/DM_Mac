//
//  AppData.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/6.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalData.h"

@interface AppData : LocalData
+ (instancetype)defaultAppData;
-(void)setAgoraAppId:(NSString*)appId;
-(void)setAgoraVideoProfile:(NSInteger)profile;
-(NSString*)getAgoraAppId;
-(NSInteger)getAgoraVideoProfile;
@end
