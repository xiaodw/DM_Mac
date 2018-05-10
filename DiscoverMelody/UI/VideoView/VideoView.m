//
//  VideoView.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/26.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "VideoView.h"
#import <Masonry.h>
#import "DMConst.h"
#import "DMRequestModel.h"
#import "ViewController.h"

enum CANVAS_TYPE_ {
    CANVAS_TYPE_OTHER = 0,
    CANVAS_TYPE_ASSISTANT,
    CANVAS_TYPE_MINE
} CANVAS_TYPE;
// 0对方、1自己、2助教

@interface VideoView()
@property enum LAYOUT_MODE layoutMode;
@property NSMutableArray* slCanvasArray;   // 大小布局时，画布位置
@property (strong,nonatomic) CountDownClock* countDownClock;
@end

@implementation VideoView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSmallLargeView];
        self.layoutMode = LAYOUT_MODE_SL;
        self.slCanvasArray = [[NSMutableArray alloc]init];
        
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
        
        //[self handleDragAndMove];
    }
    return self;
}

-(void)handleDragAndMove {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDragged handler:^NSEvent *(NSEvent *event) {
        if (event.window == [self window]) {
//            NSView* targetView = nil;
//            NSPoint point =  [self convertPoint:[NSEvent mouseLocation] toView:self];
//            if (NSPointInRect(point, [self.videoCanvasStudent convertRect:self.frame toView:self])) {
//                NSLog(@"in videoCanvasStudent");
//                targetView = self.videoCanvasStudent;
//            } else if (NSPointInRect(point, [self.videoCanvasAssistant convertRect:self.frame toView:self])) {
//                NSLog(@"in videoCanvasAssistant");
//                targetView = self.videoCanvasAssistant;
//            } else if (NSPointInRect(point, [self.videoCanvasOther convertRect:self.frame toView:self])) {
//                NSLog(@"in videoCanvasOther");
//                targetView = self.videoCanvasOther;
//            }
            
            NSRect viewFram = self.frame;
            if (viewFram.size.height - event.locationInWindow.y < viewFram.size.height) {
                [[NSCursor arrowCursor] set];

                NSPoint where = [NSEvent mouseLocation];
                NSPoint origin = viewFram.origin;

                CGFloat deltaX = 0.0;
                CGFloat deltaY = 0.0;
                while ((event = [NSApp nextEventMatchingMask:NSEventMaskLeftMouseDown | NSEventMaskLeftMouseDragged | NSEventMaskLeftMouseUp untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES]) && (event.type != NSEventTypeLeftMouseUp)) {
                    @autoreleasepool {
                        NSPoint now = [NSEvent mouseLocation]; //[window_ convertBaseToScreen:event.locationInWindow];
                        deltaX += now.x - where.x;
                        deltaY += now.y - where.y;
                        if (fabs(deltaX) >= 1 || fabs(deltaY) >= 1) {
                            // This part is only called if drag occurs on container view!
                            origin.x += deltaX;
                            origin.y += deltaY;
                            self.videoCanvasStudent.frameOrigin = origin;
                            deltaX = 0.0;
                            deltaY = 0.0;
                        }
                        where = now; // this should be inside above if but doing that results in jittering while moving the window...
                    }
                }
            }
        }
        return event;
    }];
}

-(void)viewDidUnhide {
    if (self.layoutMode == LAYOUT_MODE_SL) {
        [self layoutSmallLargeView];
    } else {
        [self layoutLeftRightView];
    }
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [super resizeSubviewsWithOldSize:oldSize];
    if (self.layoutMode == LAYOUT_MODE_SL) {
        [self layoutSmallLargeView];
    } else {
        [self layoutLeftRightView];
    }
}

-(NSView *)subViewFrom:(NSPoint)point {
    for (NSView *subView in [self subviews]) {
        if (![subView isHidden] && [subView hitTest:point]) {
            return subView;
        }
    }
    return nil;
}

-(void)mouseDown:(NSEvent *)event {
    
}

#pragma mark ##### setup views #####
-(NSUInteger)indexOfCanvas:(VideoCanvas*)vc InArray:(NSMutableArray*)array {
    NSUInteger index = 0;
    for (index = 0; index < [array count]; index++) {
        if ([vc isEqual:[array objectAtIndex:index]]) {
            break;
        }
    }
    return index;
}

-(void)videoCanvasClicked:(id)sender {
    if (sender == self.videoCanvasTeacher) {
        NSLog(@"subViewClicked  videoCanvasTeacher");
    } else if (sender == self.videoCanvasAssistant) {
        NSLog(@"subViewClicked  videoCanvasAssistant");
    } else if (sender == self.videoCanvasStudent) {
        NSLog(@"subViewClicked  videoCanvasStudent");
    }

    if (self.layoutMode == LAYOUT_MODE_SL && ![[self.slCanvasArray objectAtIndex:0] isEqual:sender]) {
        NSUInteger canvasIndex = [self indexOfCanvas:sender InArray:self.slCanvasArray];
        if (canvasIndex != 0) {
            [self.slCanvasArray replaceObjectAtIndex:canvasIndex withObject:[self.slCanvasArray objectAtIndex:0]];
            [self.slCanvasArray replaceObjectAtIndex:0 withObject:sender];
            
            [self layoutSmallLargeView];
        }
    }
}

-(void)setupVideoView {
    self.videoCanvasTeacher = [[VideoCanvas alloc]initWithFrame:self.frame];
    [self.videoCanvasTeacher setUserOnline:NO];
    [self.videoCanvasTeacher setClickAction:@selector(videoCanvasClicked:) withTarget:self];
    [self addSubview:self.videoCanvasTeacher];
    
    self.videoCanvasAssistant = [[VideoCanvas alloc]initWithFrame:NSMakeRect(0, 0, self.frame.size.width/4, self.frame.size.height/4)];
    [self.videoCanvasAssistant setUserOnline:NO];
    [self.videoCanvasAssistant setClickAction:@selector(videoCanvasClicked:) withTarget:self];
    [self addSubview:self.videoCanvasAssistant];
    
    self.videoCanvasStudent = [[VideoCanvas alloc]initWithFrame:NSMakeRect(0, 0, self.frame.size.width/4, self.frame.size.height/4)];
    [self.videoCanvasStudent setUserOnline:NO];
    [self.videoCanvasStudent setClickAction:@selector(videoCanvasClicked:) withTarget:self];
    [self addSubview:self.videoCanvasStudent];
}

-(void)setupControlBar {
    self.controlBar = [[VideoControlBar alloc]initWithFrame:NSMakeRect(0, 0, 500, 64)];
    [self addSubview:self.controlBar];
}

-(void)setupCountDownClock {
    self.countDownClock = [[CountDownClock alloc]initWithFrame:NSMakeRect(0, 0, 128, 128)];
    [self addSubview:self.countDownClock];
}

-(void)setupStatusBar {
    self.statusBar = [[VideoStatusBar alloc]initWithFrame:NSMakeRect(0, 0, 500, 32)];
    [self addSubview:self.statusBar];
}

-(void)setupSubViews {
    [self setupVideoView];
    [self setupCountDownClock];
    [self setupStatusBar];
    [self setupControlBar];
}

-(int)getOnlineUserCount {
    int onlineUserCount = 0;
    for (int i = 0; i < [self.slCanvasArray count]; i++) {
        if ([[self.slCanvasArray objectAtIndex:i]getUserOnline]) {
            onlineUserCount++;
        }
    }
    return onlineUserCount;
}

-(void)layoutSmallLargeView {
    __block int viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
    __block int viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
    __block int videoWidth = viewWidth;
    __block int videoHeight = viewHeight;
    __block int verticalOffset = 0;
    __block int horizontalOffset = 0;
    __block int padding = 5;
    
    if (videoWidth / 4 >= videoHeight / 3) {    // 左右留黑
        videoWidth = videoHeight * 4 / 3;
        horizontalOffset = (viewWidth - videoWidth) / 2;
    } else {                                    // 上下留黑
        videoHeight = videoWidth * 3 / 4;
        verticalOffset = (viewHeight - videoHeight) / 2;
    }
    
    for (NSUInteger i = 0; i < [self.slCanvasArray count]; i++) {
        NSLog(@"=====%@ | %d", [self.slCanvasArray objectAtIndex:i], [[self.slCanvasArray objectAtIndex:i]getUserOnline]);
    }
    
    if (0 == [self.slCanvasArray count]) {
        [self.slCanvasArray addObject:self.videoCanvasTeacher];
        [self.slCanvasArray addObject:self.videoCanvasAssistant];
        [self.slCanvasArray addObject:self.videoCanvasStudent];
    }
    
    //NSViewAnimation* viewAnimation;
    for (NSUInteger i = 0; i < [self.slCanvasArray count]; i++) {
        [[self.slCanvasArray objectAtIndex:i] removeFromSuperview];
        [self addSubview:[self.slCanvasArray objectAtIndex:i]];
    }
    [self.countDownClock removeFromSuperview];
    [self addSubview:self.countDownClock];
    [self.statusBar removeFromSuperview];
    [self addSubview:self.statusBar];
    [self.controlBar removeFromSuperview];
    [self addSubview:self.controlBar];
    [[self.slCanvasArray objectAtIndex:0]setShowBoarder:NO];
    [[self.slCanvasArray objectAtIndex:1]setShowBoarder:YES];
    [[self.slCanvasArray objectAtIndex:2]setShowBoarder:YES];
    
    enum COUNT_DOWN_STATUS countDownStatus = [self.countDownClock getCountDownStatus];
    NSLog(@"layoutSmallLargeView  ---> countDownStatus:%d teacher:%d assistant:%d student:%d", countDownStatus, [self.videoCanvasTeacher getUserOnline], [self.videoCanvasAssistant getUserOnline], [self.videoCanvasStudent getUserOnline]);
    
    if (![[self.slCanvasArray objectAtIndex:1]getUserOnline] || [[self.slCanvasArray objectAtIndex:0]getUserOnline]) {
        [[self.slCanvasArray objectAtIndex:0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
            make.left.mas_equalTo(self.mas_left).with.offset(horizontalOffset);
            make.width.mas_equalTo(videoWidth);
            make.height.mas_equalTo(videoHeight);
        }];
        [[self.slCanvasArray objectAtIndex:0] setPlaceHolderHidden:[[self.slCanvasArray objectAtIndex:0] getUserOnline] || COUNT_DOWN_STATUS_STARTED == countDownStatus];
        [[self.slCanvasArray objectAtIndex:0]setHidden:NO];
    } else {
        [[self.slCanvasArray objectAtIndex:0]setHidden:YES];
    }

    if ([[self.slCanvasArray objectAtIndex:1]getUserOnline]) {
        if ([[self.slCanvasArray objectAtIndex:0]getUserOnline]) {
            [[self.slCanvasArray objectAtIndex:1] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset + padding);
                make.left.mas_equalTo(self.mas_right).with.offset(-(horizontalOffset + videoWidth / 4 + padding));
                make.width.mas_equalTo(videoWidth / 4);
                make.height.mas_equalTo(videoHeight / 4);
            }];
        } else {
            [[self.slCanvasArray objectAtIndex:1] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                make.left.mas_equalTo(self.mas_left).with.offset(horizontalOffset);
                make.width.mas_equalTo(videoWidth);
                make.height.mas_equalTo(videoHeight);
            }];
        }
        [[self.slCanvasArray objectAtIndex:1] setPlaceHolderHidden:[[self.slCanvasArray objectAtIndex:1] getUserOnline]];
        [[self.slCanvasArray objectAtIndex:1] setHidden:NO];
    } else {
        [[self.slCanvasArray objectAtIndex:1] setHidden:YES];
    }

    if ([[self.slCanvasArray objectAtIndex:0]getUserOnline] && [[self.slCanvasArray objectAtIndex:1]getUserOnline]) {
        [[self.slCanvasArray objectAtIndex:2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(padding + verticalOffset + videoHeight / 4);
            make.right.mas_equalTo(self.mas_right).with.offset(-(padding + horizontalOffset));
            make.width.mas_equalTo(videoWidth / 4);
            make.height.mas_equalTo(videoHeight / 4);
        }];
    } else {
        [[self.slCanvasArray objectAtIndex:2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(padding + verticalOffset);
            make.right.mas_equalTo(self.mas_right).with.offset(-(padding + horizontalOffset));
            make.width.mas_equalTo(videoWidth / 4);
            make.height.mas_equalTo(videoHeight / 4);
        }];
    }
    [[self.slCanvasArray objectAtIndex:2] setPlaceHolderHidden:[[self.slCanvasArray objectAtIndex:2] getUserOnline]];
    [[self.slCanvasArray objectAtIndex:2] setHidden:[[self.slCanvasArray objectAtIndex:1]getUserOnline] && ![[self.slCanvasArray objectAtIndex:2]getUserOnline]];

    
    // ---
    [self.countDownClock mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-80);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(160);
    }];

    [self.statusBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];

    [self.controlBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];
}

-(void)layoutLeftRightView {
    __block float viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] floatValue];
    __block float viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] floatValue];
    __block float videoWidth = [[NSNumber numberWithFloat:self.frame.size.width / 2] floatValue];
    __block float videoHeight = [[NSNumber numberWithFloat:self.frame.size.height] floatValue];
    __block float verticalOffset = 0;
    __block float horizontalOffset = 0;
    
    NSLog(@"layoutLeftRightView --> Other:%d Assistant:%d Mine:%d", [self.videoCanvasTeacher getUserOnline], [self.videoCanvasAssistant getUserOnline], [self.videoCanvasStudent getUserOnline]);
    
    [self.videoCanvasTeacher removeFromSuperview];
    [self addSubview:self.videoCanvasTeacher];
    [self.videoCanvasAssistant removeFromSuperview];
    [self addSubview:self.videoCanvasAssistant];
    [self.videoCanvasStudent removeFromSuperview];
    [self addSubview:self.videoCanvasStudent];
    [self.countDownClock removeFromSuperview];
    [self addSubview:self.countDownClock];
    [self.statusBar removeFromSuperview];
    [self addSubview:self.statusBar];
    [self.controlBar removeFromSuperview];
    [self addSubview:self.controlBar];
    
    int onlineUserCount = 0;
    for (int i = 0; i < [self.slCanvasArray count]; i++) {
        [[self.slCanvasArray objectAtIndex:0]setShowBoarder:NO];
        if ([[self.slCanvasArray objectAtIndex:i]getUserOnline]) {
            onlineUserCount++;
        }
    }
    
    if (1 == onlineUserCount || 2 == onlineUserCount) {
        viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
        viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
        videoWidth = [[NSNumber numberWithFloat:self.frame.size.width / 2] intValue];
        videoHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
        verticalOffset = 0; horizontalOffset = 0;
        if (videoWidth / 4 >= videoHeight / 3) {    // 左右留黑
            videoWidth = videoHeight * 4 / 3;
            horizontalOffset = viewWidth / 2 - videoWidth;
        } else {                                    // 上下留黑
            videoHeight = videoWidth * 3 / 4;
            verticalOffset = (viewHeight - videoHeight) / 2;
        }
        
        if ([self.videoCanvasTeacher getUserOnline]) {
            [self.videoCanvasTeacher setHidden:NO];
            [self.videoCanvasTeacher mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                make.right.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(videoWidth);
                make.height.mas_equalTo(videoHeight);
            }];
        } else {
            [self.videoCanvasTeacher setHidden:YES];
        }
        
        if ([self.videoCanvasAssistant getUserOnline]) {
            [self.videoCanvasAssistant setHidden:NO];
            if ([self.videoCanvasTeacher getUserOnline]) {
                [self.videoCanvasAssistant mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                    make.left.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(videoWidth);
                    make.height.mas_equalTo(videoHeight);
                }];
            } else {
                [self.videoCanvasAssistant mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                    make.right.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(videoWidth);
                    make.height.mas_equalTo(videoHeight);
                }];
            }
        } else {
            if ([self.videoCanvasTeacher getUserOnline]) {
                [self.videoCanvasAssistant setHidden:YES];
            } else {
                [self.videoCanvasAssistant setHidden:NO];
                [self.videoCanvasAssistant mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                    make.right.mas_equalTo(self.mas_centerX).with.offset(-videoWidth);;
                    make.width.mas_equalTo(videoWidth);
                    make.height.mas_equalTo(videoHeight);
                }];
            }
        }
        
        if ([self.videoCanvasTeacher getUserOnline] && [self.videoCanvasAssistant getUserOnline]) {
            [self.videoCanvasStudent setHidden:YES];
        } else {
            [self.videoCanvasStudent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
                make.left.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(videoWidth);
                make.height.mas_equalTo(videoHeight);
            }];
        }
    } else if (3 == onlineUserCount) {
        viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
        viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
        videoWidth = [[NSNumber numberWithFloat:self.frame.size.width / 2] intValue];
        videoHeight = [[NSNumber numberWithFloat:self.frame.size.height / 2] intValue];
        verticalOffset = 0; horizontalOffset = 0;
        
        if (videoWidth / 4 >= videoHeight / 3) {    // 左右留黑
            videoWidth = videoHeight * 4 / 3;
            horizontalOffset = viewWidth / 2 - videoWidth;
        } else {                                    // 上下留黑
            videoHeight = videoWidth * 3 / 4;
            verticalOffset = (viewHeight - 2 * videoHeight) / 2;
        }
        
        [self.videoCanvasTeacher setHidden:NO];
        [self.videoCanvasAssistant setHidden:NO];
        [self.videoCanvasStudent setHidden:NO];
        
        [self.videoCanvasTeacher mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset + videoHeight / 2);
            make.right.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(videoWidth);
            make.height.mas_equalTo(videoHeight);
        }];
        
        [self.videoCanvasAssistant mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).with.offset(-videoHeight);
            make.left.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(videoWidth);
            make.height.mas_equalTo(videoHeight);
        }];
        
        [self.videoCanvasStudent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(videoWidth);
            make.height.mas_equalTo(videoHeight);
        }];
    }
    
    [self.countDownClock mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-80);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(160);
    }];

    [self.statusBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];

    [self.controlBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];
}

-(void)changeViewLayoutMode {
    if (self.layoutMode == LAYOUT_MODE_SL) self.layoutMode = LAYOUT_MODE_LR;
    else                                   self.layoutMode = LAYOUT_MODE_SL;
    
    if (self.layoutMode == LAYOUT_MODE_SL) {
        [self layoutSmallLargeView];
    } else {
        [self layoutLeftRightView];
    }
}

-(void)invalidateViewLayout {
    if (self.layoutMode == LAYOUT_MODE_SL) {
        [self layoutSmallLargeView];
    } else {
        [self layoutLeftRightView];
    }
}

-(void)setAssistantOnline:(BOOL)yesno {
    [self.videoCanvasAssistant setUserOnline:yesno];
}

-(void)setTeacherOnline:(BOOL)yesno {
    [self.videoCanvasTeacher setUserOnline:yesno];
}

-(void)setStudentOnline:(BOOL)yesno {
    [self.videoCanvasStudent setUserOnline:yesno];
}

-(void)setUserTypeMine:(NSInteger)type {
    [self.slCanvasArray removeAllObjects];
    if (0 == type) {
        [self.slCanvasArray addObject:self.videoCanvasTeacher];
        [self.slCanvasArray addObject:self.videoCanvasAssistant];
        [self.slCanvasArray addObject:self.videoCanvasStudent];
    } else if (1 == type) {
        [self.slCanvasArray addObject:self.videoCanvasStudent];
        [self.slCanvasArray addObject:self.videoCanvasAssistant];
        [self.slCanvasArray addObject:self.videoCanvasTeacher];
    } else { //if (2 == type) {
        [self.slCanvasArray addObject:self.videoCanvasTeacher];
        [self.slCanvasArray addObject:self.videoCanvasStudent];
        [self.slCanvasArray addObject:self.videoCanvasAssistant];
    }
}

// -- countdown --
-(void)startCountDownUntil:(double)utcEnd {
    [self.countDownClock startCountDownUntil:utcEnd];
    if (self.layoutMode == LAYOUT_MODE_SL) {
        NSDate* dataNow = [[NSDate alloc]init];
        NSTimeInterval intervalSince1970 = [dataNow timeIntervalSince1970];
        if (utcEnd < intervalSince1970) {
            [[self.slCanvasArray objectAtIndex:0]setPlaceHolderHidden:NO];
        } else {
            [[self.slCanvasArray objectAtIndex:0]setPlaceHolderHidden:YES];
        }
    }
}

-(void)setStopAction:(SEL)action withTarget:(id)target {
    [self.countDownClock setStopAction:action withTarget:target];
}


@end
