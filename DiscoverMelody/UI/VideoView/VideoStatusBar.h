//
//  VideoStatusBar.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/25.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VideoStatusBar : NSControl
-(void)startCountBegin:(double)begin Red:(double)red Warning:(double)warn End:(double)end;
-(void)setStopAction:(SEL)action withTarget:(id)target;
-(void)stopCount;
@end
