//
//  VideoControlBar.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VideoControlBar : NSView
-(void)setHangupAction:(SEL)action;
-(void)setMuteAction:(SEL)action;
-(void)setChangeLayoutAction:(SEL)action;
-(void)setShareScreenAction:(SEL)action;
@property BOOL isMouseHover;
@end
