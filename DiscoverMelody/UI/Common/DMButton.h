//
//  DMButton.h
//  Event
//
//  Created by My mac on 2018/6/4.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMControl.h"

typedef NS_ENUM(NSInteger, DMTitleAlignment) {
    DMTitleTypeTop,
    DMTitleTypeLeft,
    DMTitleTypeBottom,
    DMTitleTypeRight
};

@interface DMButton : DMControl

@property (assign, nonatomic) BOOL dm_selected;
@property (assign, nonatomic) BOOL dm_enabled;
@property(assign, nonatomic, readonly) BOOL dm_highlighted;
@property (assign, nonatomic, readonly) DMControlState dm_state;

@property (copy, nonatomic, readonly, nullable) NSString *dm_title;
@property (strong, nonatomic, readonly, nullable) NSColor *dm_titleColor;
@property (strong, nonatomic, readonly, nullable) NSImage *dm_image;
@property (strong, nonatomic, readonly, nullable) NSImage *dm_backgroundImage;

@property (strong, nonatomic, nonnull) NSFont *dm_titleFont;
@property (assign, nonatomic, getter=dm_isStrikethrough) BOOL dm_strikethrough; // 文字是否有删除线
@property (strong, nonatomic, nonnull) NSDictionary *dm_titleAttributes;
@property (assign, nonatomic) CGFloat dm_spacing; // 文字 与 图片间距
@property (assign, nonatomic) DMTitleAlignment dm_titleAlignment; // 文字在图片的列序
@property (assign, nonatomic) NSTextAlignment dm_alignment; // 文字的列序
@property (assign, nonatomic) NSLineBreakMode dm_lineBreakMode; // a... or a...b or ...a 等

- (void)dm_setTitle:(NSString *_Nullable)title forState:(DMControlState)state;
- (void)dm_setTitleColor:(NSColor *_Nullable)color forState:(DMControlState)state;
- (void)dm_setImage:(NSImage *_Nullable)image forState:(DMControlState)state;
- (void)dm_setBackgroundImage:(NSImage *_Nullable)image forState:(DMControlState)state;

@end
