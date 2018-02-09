//
//  OverlayView.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/8.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "OverlayView.h"
#import <Masonry.h>

@interface OverlayView()
@property BOOL isOverlay;
@property NSSize labelSize;
@property (strong,nonatomic) NSString* labelString;
@end

@implementation OverlayView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.isOverlay) {
        [self drawBezel];
        [self drawLabel];
    }
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setHidden:YES];
        self.labelSize = NSMakeSize(0, 0);
        self.labelString = @"";
    }
    return self;
}

- (void)drawBezel {
    NSRect rectToDraw = NSMakeRect((self.bounds.size.width - self.labelSize.width) / 2,
                                   (self.bounds.size.height - self.labelSize.height) / 2,
                                   self.labelSize.width, self.labelSize.height);
    [[NSColor colorWithDeviceWhite:0.0 alpha:0.8] set];
    NSBezierPath *bezelPath = [NSBezierPath bezierPathWithRoundedRect:rectToDraw
                                                              xRadius:4.f
                                                              yRadius:4.f];
    [[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceOver];
    [bezelPath fill];
}

-(void)drawLabel {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont systemFontOfSize:NSLocalizedString(@"OVERLAY_MSG_FONT_SIZE", nil).floatValue],
                                NSFontAttributeName,
                                [NSColor whiteColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSAttributedString *labelToDraw = [[NSAttributedString alloc] initWithString:self.labelString
                                                                      attributes:attributes];
    NSRect rectLabel = [self.labelString boundingRectWithSize:NSMakeSize(NSLocalizedString(@"OVERLAY_MAX_WIDTH", nil).floatValue, NSLocalizedString(@"OVERLAY_MAX_HEIGHT", nil).floatValue) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes];
    
    NSRect centeredRect;
    centeredRect.size = rectLabel.size;
    centeredRect.origin.x = (self.bounds.size.width - centeredRect.size.width) / 2.0;
    centeredRect.origin.y = (self.bounds.size.height - centeredRect.size.height) / 2.0;
    [labelToDraw drawInRect:centeredRect];
    [self setHidden:NO];
}

- (void)beginOverlayWithLabel:(NSString *)label {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont systemFontOfSize:NSLocalizedString(@"OVERLAY_MSG_FONT_SIZE", nil).floatValue],
                                NSFontAttributeName,
                                [NSColor whiteColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSRect rectLabel = [label boundingRectWithSize:NSMakeSize(NSLocalizedString(@"OVERLAY_MAX_WIDTH", nil).floatValue, NSLocalizedString(@"OVERLAY_MAX_HEIGHT", nil).floatValue) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes];

    self.labelString = label;
    self.labelSize = NSMakeSize(rectLabel.size.width + 50, rectLabel.size.height + 50);
    self.isOverlay = YES;
    [self setNeedsDisplay:YES];
}

- (void)endOverlay {
    self.isOverlay = NO;
    [self setHidden:YES];
}

@end
