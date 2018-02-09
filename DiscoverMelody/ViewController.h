//
//  ViewController.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DMMacros.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface ViewController : NSViewController<AgoraRtcEngineDelegate>
-(void)handleUrls:(NSArray<NSURL *> *)urls;
-(BOOL)injectWindowShouldClose:(NSWindow *)sender;
@end

