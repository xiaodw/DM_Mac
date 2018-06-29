//
//  DMImageView.m
//  Event
//
//  Created by My mac on 2018/6/28.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMImageView.h"

@implementation DMImageView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dm_backgroundColor = [NSColor clearColor];
    }
    return self;
}

- (void)setDm_image:(NSImage *)dm_image {
    _dm_image = dm_image;
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    if (_dm_image) {
        CGRect rect = NSMakeRect(0, 0, selfWidth, selfHeight);
        [_dm_image drawInRect:rect];
    }
}

@end
