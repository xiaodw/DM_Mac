//
//  DeviceSelectionViewController.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/30.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface DeviceSelectionViewController : NSViewController<AgoraRtcEngineDelegate>
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@end
