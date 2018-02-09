//
//  OverlayView.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/8.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OverlayView : NSView
- (void)beginOverlayWithLabel:(NSString *)label;
- (void)endOverlay;
@end
