//
//  ColorButton.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/1.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "ColorButton.h"

@interface ColorButton()
{
    BOOL mouseDown;
    BOOL mouseIn;
    SEL mouseDownAction;
    id actionTarget;
}
@property (retain) NSTrackingArea * trackingArea;
@end

@implementation ColorButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
    NSRect rectFill = NSInsetRect(self.bounds, 3, 3);
    NSBezierPath * bezier = [NSBezierPath bezierPathWithRoundedRect:rectFill xRadius:6 yRadius:6];
    [self.effectBackgroundColor setFill];
    [bezier fill];
    
    [self.displayString drawAtPoint:NSMakePoint((NSWidth(self.bounds) - self.displayString.size.width) / 2 + 1, (NSHeight(self.bounds) - self.displayString.size.height) / 2 + 3)];
}

- (NSColor *)effectBackgroundColor {
    NSColor * color = [NSColor clearColor];
    if (self.isEnabled) {
        if (mouseDown) {
            color = [self.backgroudColor blendedColorWithFraction:0.3 ofColor:[NSColor blackColor]];
        } else {
            color = self.backgroudColor;
        }
    } else {
        color = [NSColor colorWithRed:144/255.f green:144/255.f blue:144/255.f alpha:1.f];
    }
    
    return color;
}


- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (backgroundColor != self.backgroudColor) {
        self.backgroudColor = backgroundColor;
        self.needsDisplay = YES;
    }
}

- (NSAttributedString *)displayString
{
    NSMutableAttributedString * attibutedTitle = [[NSMutableAttributedString alloc] initWithString:self.textString attributes:@{NSForegroundColorAttributeName:self.textColor, NSFontAttributeName:self.textFont}];
    return attibutedTitle;
}

- (void)setDisplayString:(NSAttributedString *)displayString
{
    NSDictionary * dicAttibutes = [displayString attributesAtIndex:0 effectiveRange:NULL];
    self.textString = displayString.string;
    for (NSString * key in dicAttibutes.allKeys) {
        if ([key isEqualToString:NSForegroundColorAttributeName]) {
            self.textColor = dicAttibutes[NSForegroundColorAttributeName];
        }
    }
}

- (void)setup
{
    self.textFont = [NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_20_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_20_SIZE", nil).intValue];
    self.textColor = [NSColor whiteColor];
    self.backgroudColor = [NSColor colorWithRed:234/255.f green:29/255.f blue:118/255.f alpha:1.f];
    self.textAlignment = NSTextAlignmentCenter;
    self.textString = @"";
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)setButtonType:(NSButtonType)aType
{
    [self setButtonType:NSToggleButton];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    mouseDown = YES;
    self.needsDisplay = YES;
}

-(void)mouseUp:(NSEvent *)theEvent
{
    if (mouseDown) {
        mouseDown = NO;
        self.needsDisplay = YES;
        if (self.isEnabled && mouseIn) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    mouseIn = YES;
    //self.needsDisplay = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    mouseIn = NO;
    //self.needsDisplay = YES;
}

- (void)updateTrackingAreas
{
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
}

@end
