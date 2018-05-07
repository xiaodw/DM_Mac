//
//  VideoView.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/26.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VideoControlBar.h"
#import "VideoCanvas.h"
#import "CountDownClock.h"
#import "VideoStatusBar.h"

enum LAYOUT_MODE {
    LAYOUT_MODE_LR = 0, // left-right
    LAYOUT_MODE_SL      // small-large
};

@interface VideoView : NSView
@property (strong,nonatomic) VideoCanvas* videoCanvasStudent;
@property (strong,nonatomic) VideoCanvas* videoCanvasTeacher;
@property (strong,nonatomic) VideoCanvas* videoCanvasAssistant;
@property (strong,nonatomic) VideoControlBar* controlBar;

@property (strong,nonatomic) VideoStatusBar* statusBar;
-(void)setUserTypeMine:(NSInteger)type;
-(void)setAssistantOnline:(BOOL)yesno;
-(void)setTeacherOnline:(BOOL)yesno;
-(void)setStudentOnline:(BOOL)yesno;
-(void)changeViewLayoutMode;
-(void)invalidateViewLayout;
// -- interface for countdown --
-(void)startCountDownUntil:(double)utcEnd;
-(void)setStopAction:(SEL)action withTarget:(id)target;

@end
