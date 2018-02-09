//
//  CountDownClock.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/25.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum COUNT_DOWN_STATUS {
    COUNT_DOWN_STATUS_NOT_START = 0,
    COUNT_DOWN_STATUS_STARTED,
    COUNT_DOWN_STATUS_STOPPED
};

@interface CountDownClock : NSControl
-(void)startCountDownUntil:(double)utcEnd;
-(void)setStopAction:(SEL)action withTarget:(id)target;
-(enum COUNT_DOWN_STATUS)getCountDownStatus;
@end
