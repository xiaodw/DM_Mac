//
//  DMView.m
//  Event
//
//  Created by My mac on 2018/6/5.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMView.h"

@implementation DMView

- (void)setDm_backgroundColor:(NSColor *)dm_backgroundColor {
    if (_dm_backgroundColor == dm_backgroundColor) return;
    _dm_backgroundColor = dm_backgroundColor;
    [self setNeedsDisplay:YES];
}

- (void)setDm_borderColor:(NSColor *)dm_borderColor {
    if (_dm_borderColor == dm_borderColor) return;
    _dm_borderColor = dm_borderColor;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_borderWidth:(CGFloat)dm_borderWidth {
    if (_dm_borderWidth == dm_borderWidth) return;
    _dm_borderWidth = dm_borderWidth;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_round:(BOOL)dm_round {
    _dm_round = dm_round;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_roundRadius:(CGFloat)dm_roundRadius {
    if (_dm_roundRadius == dm_roundRadius) return;
    _dm_roundRadius = dm_roundRadius;
    self.dm_round = dm_roundRadius > 0;
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dm_borderColor = [NSColor blackColor];
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
     CGFloat radius = self.bounds.size.width * 0.5;
     if (_dm_roundRadius > 0) { radius = _dm_roundRadius; }
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    NSRect rect = NSMakeRect(0, 0, width, height);
    NSBezierPath *bezier = [self setupBesierPath:rect xRadius:radius yRadius:radius];
    
    if (_dm_borderWidth > 0) {
        [_dm_borderColor set];
        [bezier fill];
        [bezier setClip];
    }

    width = width - _dm_borderWidth * 2;
    height = height - _dm_borderWidth * 2;
    rect = NSMakeRect(_dm_borderWidth, _dm_borderWidth, width, height);
    bezier = [self setupBesierPath:rect xRadius:radius yRadius:radius];
    [bezier fill];
    [bezier setClip];
	
    [self.dm_backgroundColor set];
    NSRectFill(rect);
}

- (NSBezierPath *)setupBesierPath:(NSRect)rect xRadius:(CGFloat)xRadius yRadius:(CGFloat)yRadius {
    NSBezierPath *bezier = [NSBezierPath bezierPathWithRect:rect];
    
    if (_dm_round) {
        bezier = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:xRadius yRadius:yRadius];
    }
    
    return bezier;
}

@end
