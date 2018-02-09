//
//  LogData.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/7.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerData.h"

@interface LogData : ServerData
+ (instancetype)defaultLogData;
-(void)reportUserEnter:(NSString*)target Reporter:(NSString*)reporter LessonId:(NSString*)lessonId Token:(NSString*)token;
-(void)reportUserExit:(NSString*)target Reporter:(NSString*)reporter LessonId:(NSString*)lessonId Token:(NSString*)token;
-(void)reportNetError:(NSString*)target Reporter:(NSString*)reporter LessonId:(NSString*)lessonId Token:(NSString*)token;
@end

