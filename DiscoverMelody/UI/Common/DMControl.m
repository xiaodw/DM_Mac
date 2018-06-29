//
//  DMControl.m
//  Event
//
//  Created by My mac on 2018/6/7.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMControl.h"

//#define TESTDEBUG NO

#ifdef DEBUG
    #ifdef TESTDEBUG
    #define DMLog(...) NSLog(__VA_ARGS__);
    #else
    #define DMLog(...)
    #endif
#define NSLog(...)                      NSLog(__VA_ARGS__);
#define DMLogFunc                       NSLog(@"%s",__func__);
#else
#define DMLog(...)
#define NSLog(...)
#define DMLogFunc
#endif

@interface DMControl()

@property (strong, nonatomic) NSMutableDictionary *actions;
@property (strong, nonatomic) NSCursor *currentCursor;

@end

@implementation DMControl

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dm_addTarget:(nullable id)target action:(SEL)action forControlEvents:(DMControlEvents)controlEvents {
    __weak __typeof(&*target)weakSelf = target;
    self.actions[@(controlEvents)] = @{ kActionKey: NSStringFromSelector(action),
                                        kTargetKey: weakSelf
                                        };
}

- (void)sendEventResponseWithEvents:(DMControlEvents)controlEvents {
    NSDictionary *eventDict = self.actions[@(controlEvents)];
    SEL aSelector = NSSelectorFromString(eventDict[kActionKey]);
    id target = eventDict[kTargetKey];
    [NSApp sendAction:aSelector to:target from:self];
}

// 鼠标按下
- (void)mouseDown:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseDown];
    
    DMLog(@"%s", __func__);
}

// 鼠标右键按下
- (void)rightMouseDown:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventRightMouseDown];
    
    DMLog(@"%s", __func__);
}

// 鼠标其他按键按下: 滑轮按下
- (void)otherMouseDown:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventOtherMouseDown];
    
    DMLog(@"%s", __func__);
}

// 鼠标抬起
- (void)mouseUp:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseUp];
    
    DMLog(@"%s", __func__);
}

// 鼠标右键抬起
- (void)rightMouseUp:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventRightMouseUp];
    
    DMLog(@"%s", __func__);
}

// 鼠标其他按键抬起: 滑轮抬起
- (void)otherMouseUp:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventOtherMouseUp];
    
    DMLog(@"%s", __func__);
}

// 鼠标在内部移动
- (void)mouseMoved:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseMoved];
    
    DMLog(@"%s", __func__);
}

// 鼠标按住拖动ing
- (void)mouseDragged:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseDragged];
    
    DMLog(@"%s", __func__);
}

// 鼠标滑轮滚动
- (void)scrollWheel:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventScrollWheel];
    
    DMLog(@"%s", __func__);
}

// 鼠标右键拖拽ing
- (void)rightMouseDragged:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventRightMouseDragged];
    
    DMLog(@"%s", __func__);
}

// 鼠标其他按键拖拽ing: 滑轮按住拖拽ing
- (void)otherMouseDragged:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventOtherMouseDragged];
    
    DMLog(@"%s", __func__);
}

// 鼠标刚进入
- (void)mouseEntered:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseEntered];
    
    DMLog(@"%s", __func__);
    
    _currentCursor = [NSCursor currentCursor];
    [_dm_contentInsetCursor set];
}

// 鼠标离开
- (void)mouseExited:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventMouseExited];
    DMLog(@"%s", __func__);
    [_currentCursor set];
}

// 键盘按键抬起
- (void)keyUp:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventKeyUp];
    DMLog(@"%s", __func__);
}

// 特殊键按下
- (void)flagsChanged:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventFlagsChanged];
    DMLog(@"%s", __func__);
}

// 光标所在的视图发生改变
- (void)cursorUpdate:(NSEvent *)event {
    [self sendEventResponseWithEvents:DMControlEventCursorUpdate];
    DMLog(@"%s", __func__);
}

- (NSMutableDictionary *)actions {
    if (!_actions) {
        _actions = [NSMutableDictionary dictionary];
    }
    
    return _actions;
}

@end

