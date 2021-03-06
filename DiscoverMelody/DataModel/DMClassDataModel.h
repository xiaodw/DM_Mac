//
//  DMClassDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMClassDataModel : DMBaseDataModel
@property (nonatomic, copy) NSString *channel_key;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, copy) NSString *signaling_key;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *other_uid;

@property (nonatomic, copy) NSString *start_time;//课程开始时间，时间戳，秒
@property (nonatomic, copy) NSString *duration;//课程时长，秒
@property (nonatomic, copy) NSString *countdown;//课程结束前的提前多久提醒，秒
@property (nonatomic, copy) NSString *forceclose;//视频强制关闭延迟时间，秒

@end
