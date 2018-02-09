//
//  LoginView.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/26.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DeviceSelector.h"
#import "YRKSpinningProgressIndicator.h"

enum LOGIN_STATUS {
    LOGIN_STATUS_NOT_READY = 0,
    LOGIN_STATUS_WAIT_LESSON_CODE,
    LOGIN_STATUS_READY,
    LOGIN_STATUS_DOING,
    LOGIN_STATUS_DONE
};

@interface LoginView : NSView
@property (strong,nonatomic)DeviceSelector* cameraSelector;
@property (strong,nonatomic)DeviceSelector* recordingSelector;

-(NSString*)getLessonCode;
-(void)setLatestLessonCode:(NSString*)code;
-(void)setLoginStatus:(enum LOGIN_STATUS)status;
-(void)setLoginAction:(SEL)action withTarget:(id)target;
@end
