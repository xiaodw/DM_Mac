//
//  DeviceSelector.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/30.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DeviceSelector : NSView
-(void)setEnable:(BOOL)enabled;
-(void)setLabel:(NSString*)text;
-(void)setSelections:(NSArray*)selections;
-(NSString*)getSelect;
@end
