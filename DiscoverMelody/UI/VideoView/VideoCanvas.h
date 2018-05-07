//
//  VideoCanvas.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VideoCanvas : NSView

@property (strong, nonatomic) NSView *videoView; // 播放的view
@property (strong, nonatomic) NSImageView *placeholderView; // 占位图标
-(void)setPlaceHolderHidden:(BOOL)hidden;
-(BOOL)getPlaceHolderHidden;
-(void)setUserOnline:(BOOL)yesno;
-(BOOL)getUserOnline;
-(void)setShowBoarder:(BOOL)yesno;
-(BOOL)getShowBoarder;
-(void)setClickAction:(SEL)action withTarget:(id)target;
@end
