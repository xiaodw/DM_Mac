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
@property NSInteger userType;
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

//-(void)resizeSubviewsWithOldSize:(NSSize)oldSize {
//    [super resizeSubviewsWithOldSize:oldSize];
//    if (self.layoutMode == LAYOUT_MODE_SL) {
//        [self layoutSmallLargeView];
//    } else {
//        [self layoutLeftRightView];
//    }
//}

-(void)layoutSubViews {
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

//
-(NSSize)maxSameRatioSizeIn:(NSSize)viewSize With:(NSSize)videoSize {
    NSSize roundSize = NSMakeSize(0, 0);
    
    roundSize.width = viewSize.width;
    roundSize.height = videoSize.height / videoSize.width * roundSize.width;
    
    if (roundSize.height > viewSize.height) {
        roundSize.height = viewSize.height;
        roundSize.width = videoSize.width / videoSize.height * roundSize.height;
    }
    
    return roundSize;
}

-(void)layoutSmallLargeView {
    __block float viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
    __block float viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
    __block float videoViewWidth_0 = 0;
    __block float videoViewHeight_0 = 0;
    __block float videoViewOffsetH_0 = 0;
    __block float videoViewOffsetV_0 = 0;
    __block float videoViewWidth_1 = 0;
    __block float videoViewHeight_1 = 0;
    __block float videoViewWidth_2 = 0;
    __block float videoViewHeight_2 = 0;
    __block float padding = 5;
    __block float fixWidth = 240;
    __block float fixHeight = 180;
    
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
        //[[self.slCanvasArray objectAtIndex:i] removeFromSuperview];
        [self addSubview:[self.slCanvasArray objectAtIndex:i]];
    }
//    [self.countDownClock removeFromSuperview];
    [self addSubview:self.countDownClock];
//    [self.statusBar removeFromSuperview];
    [self addSubview:self.statusBar];
//    [self.controlBar removeFromSuperview];
    [self addSubview:self.controlBar];
    [[self.slCanvasArray objectAtIndex:0]setShowBoarder:NO];
    [[self.slCanvasArray objectAtIndex:1]setShowBoarder:YES];
    [[self.slCanvasArray objectAtIndex:2]setShowBoarder:YES];
    
    enum COUNT_DOWN_STATUS countDownStatus = [self.countDownClock getCountDownStatus];
    NSLog(@"layoutSmallLargeView  ---> countDownStatus:%d teacher:%d assistant:%d student:%d", countDownStatus, [self.videoCanvasTeacher getUserOnline], [self.videoCanvasAssistant getUserOnline], [self.videoCanvasStudent getUserOnline]);
    
    // user-0
    if (![[self.slCanvasArray objectAtIndex:1]getUserOnline] ||
        [[self.slCanvasArray objectAtIndex:0]getUserOnline]) {
        
        // 计算videoView0的尺寸
        if ([[self.slCanvasArray objectAtIndex:0]getUserOnline] &&
            [[self.slCanvasArray objectAtIndex:0]getVideoSizeValid]) {
            videoViewWidth_0 = viewWidth;
            videoViewHeight_0 = [[self.slCanvasArray objectAtIndex:0]getVideoSize].height /
                                [[self.slCanvasArray objectAtIndex:0]getVideoSize].width *
                                videoViewWidth_0;
            if (videoViewHeight_0 > viewHeight) {
                videoViewHeight_0 = viewHeight;
                videoViewWidth_0 = [[self.slCanvasArray objectAtIndex:0]getVideoSize].width /
                [[self.slCanvasArray objectAtIndex:0]getVideoSize].height *
                videoViewHeight_0;
            }
            videoViewOffsetH_0 = (viewWidth - videoViewWidth_0) / 2;
            videoViewOffsetV_0 = (viewHeight - videoViewHeight_0) / 2;
        } else {
            videoViewWidth_0 = viewWidth;
            videoViewHeight_0 = viewHeight;
        }
        
        [[self.slCanvasArray objectAtIndex:0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(videoViewOffsetH_0);
            make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_0);
            make.width.mas_equalTo(videoViewWidth_0);
            make.height.mas_equalTo(videoViewHeight_0);
        }];
        BOOL bTest = [[self.slCanvasArray objectAtIndex:0] getUserOnline] || COUNT_DOWN_STATUS_STARTED == countDownStatus;
        NSLog(@"00000 -> %d", bTest);
        [[self.slCanvasArray objectAtIndex:0] setPlaceHolderHidden:[[self.slCanvasArray objectAtIndex:0] getUserOnline] || COUNT_DOWN_STATUS_STARTED == countDownStatus];
        [[self.slCanvasArray objectAtIndex:0]setHidden:NO];
    } else {
        [[self.slCanvasArray objectAtIndex:0]setHidden:YES];
    }

    // user-1
    if ([[self.slCanvasArray objectAtIndex:1]getUserOnline]) {
        if ([[self.slCanvasArray objectAtIndex:0]getUserOnline]) {
            videoViewWidth_1 = fixWidth;
            videoViewHeight_1 = fixHeight;
            if ([[self.slCanvasArray objectAtIndex:1]getVideoSizeValid]) {
                videoViewHeight_1 = [[self.slCanvasArray objectAtIndex:1]getVideoSize].height /
                                    [[self.slCanvasArray objectAtIndex:1]getVideoSize].width *
                                    videoViewWidth_1;
            }
            
            [[self.slCanvasArray objectAtIndex:1] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(padding);
                make.right.mas_equalTo(self.mas_right).with.offset(-padding);
                make.width.mas_equalTo(videoViewWidth_1);
                make.height.mas_equalTo(videoViewHeight_1);
            }];
        } else {
            [[self.slCanvasArray objectAtIndex:1] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
        }
        [[self.slCanvasArray objectAtIndex:1] setPlaceHolderHidden:[[self.slCanvasArray objectAtIndex:1] getUserOnline]];
        [[self.slCanvasArray objectAtIndex:1] setHidden:NO];
    } else {
        [[self.slCanvasArray objectAtIndex:1] setHidden:YES];
    }

    // user-2
    if ([[self.slCanvasArray objectAtIndex:0]getUserOnline] && [[self.slCanvasArray objectAtIndex:1]getUserOnline]) {
        videoViewWidth_2 = fixWidth;
        videoViewHeight_2 = fixHeight;
        if ([[self.slCanvasArray objectAtIndex:2]getVideoSizeValid]) {
            videoViewHeight_2 = ([[self.slCanvasArray objectAtIndex:2]getVideoSize].height /
                                 [[self.slCanvasArray objectAtIndex:2]getVideoSize].width) *
                                 videoViewWidth_2;
        }
        
        [[self.slCanvasArray objectAtIndex:2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(padding + videoViewHeight_1);
            make.right.mas_equalTo(self.mas_right).with.offset(-padding);
            make.width.mas_equalTo(videoViewWidth_2);
            make.height.mas_equalTo(videoViewHeight_2);
        }];
    } else {
        if ([[self.slCanvasArray objectAtIndex:2]getUserOnline]) {
            videoViewWidth_2 = fixWidth;
            videoViewHeight_2 = 180;
            if ([[self.slCanvasArray objectAtIndex:2]getVideoSizeValid]) {
                videoViewHeight_2 = [[self.slCanvasArray objectAtIndex:2]getVideoSize].height /
                                   [[self.slCanvasArray objectAtIndex:2]getVideoSize].width *
                                   videoViewWidth_2;
            }
        } else {
            videoViewWidth_2 = fixWidth;
            videoViewHeight_2 = fixHeight;
        }
        
        [[self.slCanvasArray objectAtIndex:2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(padding);
            make.right.mas_equalTo(self.mas_right).with.offset(-padding);
            make.width.mas_equalTo(videoViewWidth_2);
            make.height.mas_equalTo(videoViewHeight_2);
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
    __block NSSize videoViewSize_0 = NSMakeSize(0, 0);
    __block NSSize videoViewSize_1 = NSMakeSize(0, 0);
    __block NSSize videoViewSize_2 = NSMakeSize(0, 0);
    __block float videoViewOffsetH_0 = 0;
    __block float videoViewOffsetV_0 = 0;
    __block float videoViewOffsetH_1 = 0;
    __block float videoViewOffsetV_1 = 0;
    __block float videoViewOffsetH_2 = 0;
    __block float videoViewOffsetV_2 = 0;
    
    NSLog(@"layoutLeftRightView --> Other:%d Assistant:%d Mine:%d", [self.videoCanvasTeacher getUserOnline], [self.videoCanvasAssistant getUserOnline], [self.videoCanvasStudent getUserOnline]);
    
//    [self.videoCanvasTeacher removeFromSuperview];
    [self addSubview:self.videoCanvasTeacher];
//    [self.videoCanvasAssistant removeFromSuperview];
    [self addSubview:self.videoCanvasAssistant];
//    [self.videoCanvasStudent removeFromSuperview];
    [self addSubview:self.videoCanvasStudent];
//    [self.countDownClock removeFromSuperview];
    [self addSubview:self.countDownClock];
//    [self.statusBar removeFromSuperview];
    [self addSubview:self.statusBar];
//    [self.controlBar removeFromSuperview];
    [self addSubview:self.controlBar];
    
    int onlineUserCount = 0;
    for (int i = 0; i < [self.slCanvasArray count]; i++) {
        [[self.slCanvasArray objectAtIndex:0]setShowBoarder:NO];
        if ([[self.slCanvasArray objectAtIndex:i]getUserOnline]) {
            onlineUserCount++;
        }
    }
    
    VideoCanvas* vc0 = nil;
    VideoCanvas* vc1 = nil;
    VideoCanvas* vc2 = nil;
    if (self.userType == USER_TYPE_STUDENT) {
        vc0 = self.videoCanvasTeacher;
        vc1 = self.videoCanvasAssistant;
        vc2 = self.videoCanvasStudent;
    } else if (self.userType == USER_TYPE_TEACHER) {
        vc0 = self.videoCanvasStudent;
        vc1 = self.videoCanvasAssistant;
        vc2 = self.videoCanvasTeacher;
    } else {
        vc0 = self.videoCanvasTeacher;
        vc1 = self.videoCanvasStudent;
        vc2 = self.videoCanvasAssistant;
    }
    
    if (1 == onlineUserCount || 2 == onlineUserCount) {
        // user-0
        if ([vc0 getUserOnline]) {
            [vc0 setHidden:NO];
            if ([vc0 getVideoSizeValid]) {
                videoViewSize_0 = [self maxSameRatioSizeIn:NSMakeSize(viewWidth / 2, viewHeight) With:vc0.getVideoSize];
            }
            videoViewOffsetH_0 = viewWidth / 2 - videoViewSize_0.width;
            videoViewOffsetV_0 = (viewHeight - videoViewSize_0.height) / 2;
            
            [vc0 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_0);
                make.right.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(videoViewSize_0.width);
                make.height.mas_equalTo(videoViewSize_0.height);
            }];
        } else {
            [vc0 setHidden:YES];
        }
        
        // user-1
        if ([vc1 getUserOnline]) {
            [vc1 setHidden:NO];
            if ([vc1 getVideoSizeValid]) {
                videoViewSize_1 = [self maxSameRatioSizeIn:NSMakeSize(viewWidth / 2, viewHeight) With:vc1.getVideoSize];
            }
            videoViewOffsetH_1 = viewWidth / 2 - videoViewSize_1.width;
            videoViewOffsetV_1 = (viewHeight - videoViewSize_1.height) / 2;
            
            if ([vc0 getUserOnline]) {
                [vc1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_1);
                    make.left.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(videoViewSize_1.width);
                    make.height.mas_equalTo(videoViewSize_1.height);
                }];
            } else {
                [vc1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_1);
                    make.right.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(videoViewSize_1.width);
                    make.height.mas_equalTo(videoViewSize_1.height);
                }];
            }
        } else {
            if ([vc0 getUserOnline]) {
                [vc1 setHidden:YES];
            } else {
                [vc1 setHidden:NO];
                [vc1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    make.right.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(viewWidth / 2);
                    make.height.mas_equalTo(viewHeight);
                }];
            }
        }
        
        // user-2
        if ([vc0 getUserOnline] && [vc1 getUserOnline]) {
            [vc2 setHidden:YES];
        } else {
            [vc2 setHidden:NO];
            if ([vc2 getVideoSizeValid]) {
                videoViewSize_2 = [self maxSameRatioSizeIn:NSMakeSize(viewWidth / 2, viewHeight) With:vc2.getVideoSize];
            }
            videoViewOffsetH_2 = viewWidth / 2 - videoViewSize_2.width;
            videoViewOffsetV_2 = (viewHeight - videoViewSize_2.height) / 2;
            
            [vc2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_2);
                make.left.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(videoViewSize_2.width);
                make.height.mas_equalTo(videoViewSize_2.height);
            }];
        }
    } else if (3 == onlineUserCount) {
//        __block float videoViewWidth0 = viewWidth / 2;
//        __block float videoViewHeight0 = viewHeight;
//        __block float videoViewWidth1 = viewWidth / 2;
//        __block float videoViewHeight1 = ([[self.slCanvasArray objectAtIndex:1]getVideoSize].height / [[self.slCanvasArray objectAtIndex:1]getVideoSize].width) * videoViewWidth1;
//        __block float videoViewWidth2 = viewWidth / 2;
//        __block float videoViewHeight2 = ([[self.slCanvasArray objectAtIndex:2]getVideoSize].height / [[self.slCanvasArray objectAtIndex:2]getVideoSize].width) * videoViewWidth2;;
//        __block float rightOffsetV = (viewHeight - videoViewHeight1 - videoViewHeight2) / 2;
        
        videoViewSize_0.width = viewWidth / 2;
        videoViewSize_1.width = viewWidth / 2;
        videoViewSize_2.width = viewWidth / 2;
        __block float tempMaxWidth = viewWidth / 2;
        
        if ([vc1 getVideoSizeValid]) {
            videoViewSize_1.height = ([vc1 getVideoSize].height / [vc1 getVideoSize].width) * videoViewSize_1.width;
        }
        if ([vc2 getVideoSizeValid]) {
            videoViewSize_2.height = ([vc2 getVideoSize].height / [vc2 getVideoSize].width) * videoViewSize_2.width;
        }
        
        if (videoViewSize_1.height + videoViewSize_2.height < viewHeight) {
            videoViewOffsetV_1 = (viewHeight - videoViewSize_1.height - videoViewSize_2.height) / 2;
            videoViewOffsetV_2 = videoViewOffsetV_1 + videoViewSize_1.height;
        } else {
            __block float height1 = videoViewSize_1.height / (videoViewSize_1.height + videoViewSize_2.height) * viewHeight;
            __block float height2 = viewHeight - height1;
            __block float width1 = height1 / videoViewSize_1.height * videoViewSize_1.width;
            __block float width2 = width1;
            
            videoViewSize_1.height = height1;
            videoViewSize_2.height =height2;
            videoViewSize_1.width = width1;
            videoViewSize_2.width =width2;
//            videoViewSize_1.height = viewHeight * ([vc1 getVideoSize].height / ([vc1 getVideoSize].height + [vc2 getVideoSize].height));
//            videoViewSize_2.height = viewHeight - videoViewSize_1.height;
//
//            videoViewSize_1.width = ([vc1 getVideoSize].width / [vc1 getVideoSize].height) * videoViewSize_1.height;
//            videoViewSize_2.width = ([vc2 getVideoSize].width / [vc2 getVideoSize].height) * videoViewSize_2.height;
//
            tempMaxWidth =  (videoViewSize_1.width > videoViewSize_2.width) ? videoViewSize_1.width : videoViewSize_2.width;
            videoViewOffsetH_1 = (tempMaxWidth - videoViewSize_1.width) / 2;
            videoViewOffsetH_2 = (tempMaxWidth - videoViewSize_2.width) / 2;
            videoViewOffsetV_2 = videoViewSize_1.height;
        }
        
        if ([vc0 getVideoSizeValid]) {
            videoViewSize_0.width = viewWidth - tempMaxWidth;
            videoViewSize_0.height = ([vc0 getVideoSize].height / [vc0 getVideoSize].width) * videoViewSize_0.width;
            videoViewOffsetV_0 = (viewHeight - videoViewSize_0.height) / 2;
            
            if (videoViewSize_0.height > viewHeight) {
                videoViewSize_0.height = viewHeight;
                videoViewSize_0.width = ([vc0 getVideoSize].width / [vc0 getVideoSize].height) * videoViewSize_0.height;
                videoViewOffsetH_0 = ((viewWidth - tempMaxWidth) - videoViewSize_0.width) / 2;
                videoViewOffsetV_0 = 0;
            }
        }
        
        [vc0 setHidden:NO];
        [vc1 setHidden:NO];
        [vc2 setHidden:NO];
        
        [vc0 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_0);
            make.left.mas_equalTo(self.mas_left).with.offset(videoViewOffsetH_0);
            make.width.mas_equalTo(videoViewSize_0.width);
            make.height.mas_equalTo(videoViewSize_0.height);
        }];
        
        [vc1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_1);
            make.right.mas_equalTo(self.mas_right).with.offset(-videoViewOffsetH_1);
            make.width.mas_equalTo(videoViewSize_1.width);
            make.height.mas_equalTo(videoViewSize_1.height);
        }];
        
        [vc2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(videoViewOffsetV_2);
            make.right.mas_equalTo(self.mas_right).with.offset(-videoViewOffsetH_2);
            make.width.mas_equalTo(videoViewSize_2.width);
            make.height.mas_equalTo(videoViewSize_2.height);
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
    self.userType = type;
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
