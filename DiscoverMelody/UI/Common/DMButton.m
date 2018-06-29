//
//  DMButton.m
//  Event
//
//  Created by My mac on 2018/6/4.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMButton.h"
#import "NSString+Extension.h"

#define kStateTitleKey @"stateTitleKey"
#define kStateTitleColorKey @"stateTitleColorKey"
#define kStateImageKey @"stateImageKey"
#define kStateBackgroundImageKey @"stateBackgroundImageKey"

typedef NS_OPTIONS(NSUInteger, DMMouseControlState) {
    DMMouseControlStateEntered      = 1 << 0, // 0001
    DMMouseControlStateDown         = 1 << 1, // 0011
    DMMouseControlStateExited       = 1 << 1, // 0010
    DMMouseControlStateUp           = 1 << 0, // 0001
    DMMouseControlStateOutset       = 0,      // 0000
    DMMouseControlStateInset        = 0x3     // 0011
};

@interface DMButton()

@property (copy, nonatomic) NSString *dm_title;
@property (strong, nonatomic) NSColor *dm_titleColor;
@property (strong, nonatomic) NSImage *dm_image;
@property (strong, nonatomic) NSImage *dm_backgroundImage;

@property (strong, nonatomic) NSMutableDictionary *titleAttributes;
@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (strong, nonatomic) NSTrackingArea * trackingArea;

@property (assign, nonatomic) DMControlState dm_state;
@property (assign, nonatomic) DMMouseControlState mouseState;

@property (strong, nonatomic) NSMutableDictionary *attributes; // 文字的渲染属性
@property (strong, nonatomic) NSMutableDictionary *stateAttributes; // 文字状态

@end

@implementation DMButton

- (void)sendEventResponseWithEvents:(DMControlEvents)controlEvents {
    NSDictionary *eventDict = self.actions[@(controlEvents)];
    SEL aSelector = NSSelectorFromString(eventDict[kActionKey]);
    id target = eventDict[kTargetKey];
    if (aSelector == nil || target == nil) return;
    [NSApp sendAction:aSelector to:target from:self];
}

- (void)setDm_enabled:(BOOL)dm_enabled {
    _dm_enabled = dm_enabled;
    self.dm_state = dm_enabled ? (_dm_selected ? DMControlStateSelected :DMControlStateNormal) : DMControlStateDisabled;
}

- (void)setDm_selected:(BOOL)dm_selected {
    _dm_selected = dm_selected;
    
    DMControlState state = DMControlStateNormal;
    if (!self.dm_enabled) state = DMControlStateDisabled;
    if (dm_selected) state = DMControlStateSelected;
    self.dm_state = state;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (!self.dm_enabled) return;
    self.mouseState = self.mouseState | DMMouseControlStateEntered;
    self.dm_state = self.dm_highlighted ? DMControlStateHighlighted : (_dm_selected ? DMControlStateSelected :DMControlStateNormal);
    [self sendEventResponseWithEvents:DMControlEventMouseExited];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (!self.dm_enabled) return;
    
    self.mouseState = self.mouseState | DMMouseControlStateDown;
    self.dm_state = self.dm_highlighted ? DMControlStateHighlighted : (_dm_selected ? DMControlStateSelected :DMControlStateNormal);
    [self sendEventResponseWithEvents:DMControlEventMouseExited];
}

-(void)mouseUp:(NSEvent *)event {
    if (!self.dm_enabled) return;
    
    self.mouseState = self.mouseState & DMMouseControlStateUp;
    
    DMControlState state = DMControlStateNormal;
    if (_dm_selected) state = DMControlStateSelected;
    bool isContains = CGRectContainsPoint(self.frame, [event locationInWindow]);
    if (isContains) {
        state = _dm_highlighted ? DMControlStateHighlighted : state;
    }
    self.dm_state = state;
    
    if (isContains) { [self sendEventResponseWithEvents:DMControlEventMouseUp]; }
}

- (void)mouseExited:(NSEvent *)event {
    if (!self.dm_enabled) return;
    
    self.mouseState = self.mouseState & DMMouseControlStateExited;
    
    if (self.mouseState & DMMouseControlStateInset) return; // 还是在按住的情况
    
    // 松开并且已经 离开view
    DMControlState state = DMControlStateNormal;
    if (_dm_selected) state = DMControlStateSelected;
    self.dm_state = state;
    [self sendEventResponseWithEvents:DMControlEventMouseExited];
}

- (void)setDm_state:(DMControlState)dm_state {
    _dm_state = dm_state;
    
    NSMutableDictionary *stateAttribute = self.stateAttributes[@(dm_state)];
    if (stateAttribute == nil) {
        stateAttribute = self.stateAttributes[@(DMControlStateNormal)];
    }
    
    NSString *textString = stateAttribute[kStateTitleKey];
    if (textString.length == 0 && dm_state != DMControlStateNormal) {
        NSMutableDictionary *tmpAttribute = self.stateAttributes[@(DMControlStateNormal)];
        textString = tmpAttribute[kStateTitleKey];
    }
    self.dm_title = textString;
    
    NSColor *stateColor = stateAttribute[kStateTitleColorKey];
    if (stateColor == nil && dm_state != DMControlStateNormal) {
        NSMutableDictionary *tmpAttribute = self.stateAttributes[@(DMControlStateNormal)];
        stateColor = tmpAttribute[kStateTitleColorKey];
    }
    self.dm_titleColor = stateColor;
    
    NSImage *stateImage = stateAttribute[kStateImageKey];
    if (stateImage == nil && dm_state != DMControlStateNormal) {
        NSMutableDictionary *tmpAttribute = self.stateAttributes[@(DMControlStateNormal)];
        stateImage = tmpAttribute[kStateImageKey];
    }
    self.dm_image = stateImage;
    
    NSImage *stateBackgroundImage = stateAttribute[kStateBackgroundImageKey];
    if (stateBackgroundImage == nil && dm_state != DMControlStateNormal) {
        NSMutableDictionary *tmpAttribute = self.stateAttributes[@(DMControlStateNormal)];
        stateBackgroundImage = tmpAttribute[kStateBackgroundImageKey];
    }
    self.dm_backgroundImage = stateBackgroundImage;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_titleFont:(NSFont *)dm_titleFont {
    _dm_titleFont = dm_titleFont;
    self.titleAttributes[NSFontAttributeName] = dm_titleFont;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_strikethrough:(BOOL)dm_strikethrough {
    _dm_strikethrough = dm_strikethrough;
    self.titleAttributes[NSStrikethroughStyleAttributeName] = dm_strikethrough ? @1 : @0;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_alignment:(NSTextAlignment)dm_alignment {
    _dm_alignment = dm_alignment;
    
    self.paragraphStyle.alignment = dm_alignment;
    self.titleAttributes[NSParagraphStyleAttributeName] = self.paragraphStyle;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_lineBreakMode:(NSLineBreakMode)dm_lineBreakMode {
    _dm_lineBreakMode = dm_lineBreakMode;
    
    self.paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleAttributes[NSParagraphStyleAttributeName] = self.paragraphStyle;
    
    [self setNeedsDisplay:YES];
}

- (void)setDm_titleAlignment:(DMTitleAlignment)dm_titleAlignment {
    _dm_titleAlignment = dm_titleAlignment;
    
    [self setNeedsDisplay:YES];
}

- (NSMutableDictionary *)getAttributeForState:(DMControlState)state {
    NSMutableDictionary *stateAttribute = self.stateAttributes[@(state)];
    if (!stateAttribute)  {
        stateAttribute = [NSMutableDictionary dictionary];
        self.stateAttributes[@(state)] = stateAttribute;
    }
    return stateAttribute;
}

- (void)dm_setTitle:(NSString *)title forState:(DMControlState)state {
    NSMutableDictionary *stateAttribute = [self getAttributeForState:state];
    stateAttribute[kStateTitleKey]= title;
    if (self.dm_state != DMControlStateNormal) return;
    self.dm_state = DMControlStateNormal;
}

- (void)dm_setTitleColor:(NSColor *)color forState:(DMControlState)state {
    NSMutableDictionary *stateAttribute = [self getAttributeForState:state];
    stateAttribute[kStateTitleColorKey]= color;
    if (self.dm_state != DMControlStateNormal) return;
    self.dm_state = DMControlStateNormal;
}

- (void)dm_setImage:(NSImage *_Nullable)image forState:(DMControlState)state {
    NSMutableDictionary *stateAttribute = [self getAttributeForState:state];
    stateAttribute[kStateImageKey]= image;
    if (self.dm_state != DMControlStateNormal) return;
    self.dm_state = DMControlStateNormal;
}

- (void)dm_setBackgroundImage:(NSImage *_Nullable)image forState:(DMControlState)state {
    NSMutableDictionary *stateAttribute = [self getAttributeForState:state];
    stateAttribute[kStateBackgroundImageKey]= image;
    if (self.dm_state != DMControlStateNormal) return;
    self.dm_state = DMControlStateNormal;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dm_backgroundColor = [[NSColor whiteColor] colorWithAlphaComponent:0.003];
        
        self.paragraphStyle.alignment = NSTextAlignmentCenter;
        self.paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.titleAttributes[NSParagraphStyleAttributeName] = self.paragraphStyle;
        
        self.dm_titleAlignment = NSTextAlignmentCenter;
        _dm_enabled = YES;
        _dm_highlighted = YES;
        _dm_titleFont = [NSFont systemFontOfSize:15];
//        [self addTrackingArea:self.trackingArea];
        // self.dm_titleBackgroundColor = [NSColor greenColor];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat contentWidth = selfWidth - self.dm_borderWidth * 2;
    CGFloat contentHeight = selfHeight - self.dm_borderWidth * 2;
    NSRect rect = NSMakeRect(0, 0, selfWidth, selfHeight);
    if (_dm_backgroundImage) {
        [_dm_backgroundImage drawInRect:rect];
    }
    
    if (_dm_title.length || _dm_image) {
        // title
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleWidth = 0;
        CGFloat titleHeight = 0;
        
        // image
        CGFloat imageX = self.dm_borderWidth;
        CGFloat imageY = self.dm_borderWidth;
        CGFloat imageWidth = self.dm_image.size.width > contentWidth ? contentWidth : self.dm_image.size.width;
        CGFloat imageHeight = self.dm_image.size.height > contentHeight ? contentHeight : self.dm_image.size.height;
        
        // 上下
        if (_dm_titleAlignment == DMTitleTypeTop ||
            _dm_titleAlignment == DMTitleTypeBottom) {
            // title
            titleWidth = contentWidth;
            titleHeight = self.dm_title.length == 0 ? 0 : [self.dm_title stringHeightWithFont:self.dm_titleFont maxWidth:contentWidth]; // height
            
            if (titleHeight > contentWidth - imageHeight - _dm_spacing) {
                titleHeight = contentWidth - imageHeight - _dm_spacing;
            }
            
            titleX = self.dm_borderWidth;
            imageX = (contentWidth - imageWidth) * 0.5 + self.dm_borderWidth;
            CGFloat totalVHeight = titleHeight + _dm_spacing + imageHeight;
            
            if (_dm_titleAlignment == DMTitleTypeTop) {
                imageY = (contentHeight - totalVHeight) * 0.5 + self.dm_borderWidth;
                titleY = imageY + imageHeight + _dm_spacing;
            }
            if (_dm_titleAlignment == DMTitleTypeBottom) {
                titleY = (contentHeight - totalVHeight) * 0.5 + self.dm_borderWidth;
                imageY = titleY + titleHeight + _dm_spacing;
            }
        }
        
        // 左右
        if (_dm_titleAlignment == DMTitleTypeRight ||
            _dm_titleAlignment == DMTitleTypeLeft) {
            // title
            titleWidth = self.dm_title.length == 0 ? 0 : [self.dm_title stringWidthWithFont:self.dm_titleFont maxHeight:1];
            titleHeight = [@"..." stringHeightWithFont:self.dm_titleFont maxWidth:contentHeight]; // height
            
            if (titleWidth > contentWidth - imageWidth - _dm_spacing) {
                titleWidth = contentWidth - imageWidth - _dm_spacing;
            }
            
            imageY = (contentHeight - imageHeight) * 0.5 + self.dm_borderWidth;
            titleY = (contentHeight - titleHeight) * 0.5 + self.dm_borderWidth;
            CGFloat totalVWidth = titleWidth + _dm_spacing + imageWidth;
            
            if (_dm_titleAlignment == DMTitleTypeLeft) {
                titleX = self.dm_borderWidth + (contentWidth - totalVWidth) * 0.5;
                imageX = titleX + titleWidth + _dm_spacing;
                
            }
            if (_dm_titleAlignment == DMTitleTypeRight) {
                imageX = self.dm_borderWidth + (contentWidth - totalVWidth) * 0.5;
                titleX = imageX + imageWidth + _dm_spacing;
            }
        }
        
        // 下面不变
        if (_dm_title.length) {
            rect = NSMakeRect(titleX, titleY, titleWidth, titleHeight);
            NSDictionary *dictAttributes = self.dm_titleAttributes ? _dm_titleAttributes : self.titleAttributes;
            [_dm_title drawInRect:rect withAttributes:dictAttributes];
        }
        
        if (_dm_image) {
            rect = NSMakeRect(imageX, imageY, imageWidth, imageHeight);
            [_dm_image drawInRect:rect];
        }
    }
}

- (NSMutableDictionary *)titleAttributes {
    if (!_titleAttributes) {
        _titleAttributes = [NSMutableDictionary dictionary];
    }
    
    return _titleAttributes;
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [NSMutableParagraphStyle new];
    }
    
    return _paragraphStyle;
}

- (void)updateTrackingAreas {
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
    }
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:
                         NSTrackingMouseEnteredAndExited |
                         NSTrackingMouseMoved |
                         NSTrackingActiveAlways owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];

}

- (NSTrackingArea *)trackingArea {
    if (!_trackingArea) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                      options: NSTrackingMouseEnteredAndExited |
                                                               NSTrackingMouseMoved |
                                                               NSTrackingActiveAlways
                                                        owner:self userInfo:nil];
    }
    
    return _trackingArea;
}

- (NSMutableDictionary *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    
    return _attributes;
}

- (NSMutableDictionary *)stateAttributes {
    if (!_stateAttributes) {
        _stateAttributes = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *stateAttribute = [NSMutableDictionary dictionary];
        stateAttribute[kStateTitleColorKey]= [NSColor whiteColor];
        
        _stateAttributes[@(DMControlStateNormal)] = stateAttribute;
    }
    
    return _stateAttributes;
}

@end
