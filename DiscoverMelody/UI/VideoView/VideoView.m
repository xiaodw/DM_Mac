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

@interface VideoView()
@property enum LAYOUT_MODE layoutMode;
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
        
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return self;
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
    if (self.layoutMode == LAYOUT_MODE_SL)
        [self layoutSmallLargeView];
    else
        [self layoutLeftRightView];
}

#pragma mark ##### setup views #####
-(void)setupVideoView {
    self.largeVideoCanvas = [[VideoCanvas alloc]initWithFrame:self.frame];
    [self addSubview:self.largeVideoCanvas];
    
    self.smallVideoCanvas = [[VideoCanvas alloc]initWithFrame:NSMakeRect(0, 0, self.frame.size.width/4, self.frame.size.height/4)];
    [self addSubview:self.smallVideoCanvas];
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

-(void)layoutSmallLargeView {
    __block int viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
    __block int viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
    __block int videoWidth = viewWidth;
    __block int videoHeight = viewHeight;
    __block int verticalOffset = 0;
    __block int horizontalOffset = 0;
    
    if (videoWidth / 4 >= videoHeight / 3) {    // 左右留黑
        videoWidth = videoHeight * 4 / 3;
        horizontalOffset = (viewWidth - videoWidth) / 2;
    } else {                                    // 上下留黑
        videoHeight = videoWidth * 3 / 4;
        verticalOffset = (viewHeight - videoHeight) / 2;
    }
    
    [self.largeVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
        make.left.mas_equalTo(self.mas_left).with.offset(horizontalOffset);
        make.width.mas_equalTo(videoWidth);
        make.height.mas_equalTo(videoHeight);
    }];
    [self.largeVideoCanvas setPlaceHolderHidden:[self.largeVideoCanvas getVideoViewMode] || COUNT_DOWN_STATUS_STARTED == [self.countDownClock getCountDownStatus]];

    [self.smallVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.largeVideoCanvas.mas_top).with.offset(10);
        make.left.mas_equalTo(self.largeVideoCanvas.mas_right).with.offset(-videoWidth / 4 - 10);
        make.width.mas_equalTo(videoWidth / 4);
        make.height.mas_equalTo(videoHeight / 4);
    }];
    
    [self.countDownClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-80);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(160);
    }];
    
    [self.statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];
    
    [self.controlBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];
}

-(void)layoutLeftRightView {
    __block int viewWidth = [[NSNumber numberWithFloat:self.frame.size.width] intValue];
    __block int viewHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
    __block int videoWidth = [[NSNumber numberWithFloat:self.frame.size.width / 2] intValue];
    __block int videoHeight = [[NSNumber numberWithFloat:self.frame.size.height] intValue];
    __block int verticalOffset = 0;
    __block int horizontalOffset = 0;
    
    if (videoWidth / 4 >= videoHeight / 3) {    // 左右留黑
        videoWidth = videoHeight * 4 / 3;
        horizontalOffset = viewWidth / 2 - videoWidth;
    } else {                                    // 上下留黑
        videoHeight = videoWidth * 3 / 4;
        verticalOffset = (viewHeight - videoHeight) / 2;
    }
    
    [self.largeVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
        make.left.mas_equalTo(self.mas_left).with.offset(horizontalOffset);
        make.right.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-verticalOffset);
    }];
    if ([self.largeVideoCanvas getVideoViewMode]) {
        [self.largeVideoCanvas setPlaceHolderHidden:YES];
    } else {
        [self.largeVideoCanvas setPlaceHolderHidden:NO];
    }
    
    [self.smallVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(verticalOffset);
        make.left.mas_equalTo(self.mas_centerX);
        make.right.mas_equalTo(self.mas_right).with.offset(-horizontalOffset);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-verticalOffset);
    }];
    
    [self.countDownClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-80);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(160);
    }];
    
    [self.statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-180);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(180);
    }];
    
    [self.controlBar mas_makeConstraints:^(MASConstraintMaker *make) {
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

@end
