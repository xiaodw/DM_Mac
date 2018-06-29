//
//  DMView.h
//  Event
//
//  Created by My mac on 2018/6/5.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMView : NSView

@property (strong, nonatomic) NSColor *dm_backgroundColor;

@property (assign, nonatomic) CGFloat dm_borderWidth;
@property (strong, nonatomic) NSColor *dm_borderColor;

@property (assign, nonatomic, getter=dm_isRound) BOOL dm_round;
@property (assign, nonatomic) CGFloat dm_roundRadius;


@end
