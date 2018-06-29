//
//  DMControl.h
//  Event
//
//  Created by My mac on 2018/6/7.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMView.h"

#define kTargetKey @"targetKey"
#define kActionKey @"actionKey"

typedef NS_OPTIONS(NSUInteger, DMControlEvents) {
    // 1098 7654 3210 9876 5432 1098 7654 3210
    // 0000 0000 0000 0000 0000 0000 0000 0001
    DMControlEventMouseEntered        = 1 << 0, // 鼠标刚进入
    // 0000 0000 0000 0000 0000 0000 0000 0010
    DMControlEventMouseExited         = 1 << 1, // 鼠标离开
    
    // 0000 0000 0000 0000 0000 0000 0000 0100
    DMControlEventMouseDown           = 1 << 2, // 鼠标左键按下
    // 0000 0000 0000 0000 0000 0000 0000 1000
    DMControlEventMouseDragged        = 1 << 3, //  鼠标左键按住拖动ing
    // 0000 0000 0000 0000 0000 0000 0001 0000
    DMControlEventMouseUp             = 1 << 4, //  鼠标左键抬起
    
    // 0000 0000 0000 0000 0000 0000 0010 0000
    DMControlEventRightMouseDown      = 1 << 5, // 鼠标右键按下
    // 0000 0000 0000 0000 0000 0000 0100 0000
    DMControlEventRightMouseDragged   = 1 << 6, //  鼠标右键拖拽ing
    // 0000 0000 0000 0000 0000 0000 1000 0000
    DMControlEventRightMouseUp        = 1 << 7, // 鼠标右键抬起
    
    // 0000 0000 0000 0000 0000 0001 0000 0000
    DMControlEventOtherMouseDown      = 1 << 8, // 鼠标其他按键按下: 滑轮按下
    // 0000 0000 0000 0000 0000 0010 0000 0000
    DMControlEventOtherMouseDragged   = 1 << 9, // 鼠标其他按键拖拽ing: 滑轮按住拖拽ing
    // 0000 0000 0000 0000 0000 0100 0000 0000
    DMControlEventOtherMouseUp        = 1 << 10, //  鼠标其他按键抬起: 滑轮抬起
    
    // 0000 0000 0000 0000 0000 1000 0000 0000
    DMControlEventMouseMoved          = 1 << 11, // 鼠标在内部移动
    // 0000 0000 0000 0000 0001 0000 0000 0000
    DMControlEventScrollWheel         = 1 << 12, // 鼠标滑轮滚动
    
    // 0000 0000 0000 0000 0010 0000 0000 0000
    DMControlEventKeyUp               = 1 << 13, // 键盘按键抬起
    // 0000 0000 0000 0000 0100 0000 0000 0000
    DMControlEventFlagsChanged        = 1 << 14, // 特殊键按下
    
    // 0000 0000 0000 0000 1000 0000 0000 0000
    DMControlEventCursorUpdate     NS_AVAILABLE_MAC(10_5)   = 1 << 15, // 光标所在的视图发生改变
    
    // 1111 1111 1111 1111 1111 1111 1111 1111
    DMControlEventAllEvents           = 0xFFFFFFFF  // 全部事件
};

typedef NS_OPTIONS(NSUInteger, DMControlState) {
    DMControlStateNormal       = 0,
    DMControlStateHighlighted  = 1 << 0,
    DMControlStateDisabled     = 1 << 1,
    DMControlStateSelected     = 1 << 2
};


@interface DMControl : DMView

@property (strong, nonatomic, nonnull, readonly) NSMutableDictionary *actions;
@property (strong, nonatomic, nullable) NSCursor *dm_contentInsetCursor;

- (void)dm_addTarget:(nullable id)target action:(SEL _Nonnull)action forControlEvents:(DMControlEvents)controlEvents;

@end

