//
//  VideoCanvas.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "VideoCanvas.h"
#import <Masonry.h>

@interface VideoCanvas()
@end;

@implementation VideoCanvas

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [super resizeSubviewsWithOldSize:oldSize];
    [self layoutSubViews];
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.videoView = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.videoView setHidden:YES];
    [self.videoView setWantsLayer:YES];
    [self.videoView.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [self addSubview:self.videoView];

    self.placeholderView = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.placeholderView setImage:[NSImage imageNamed:@"userNotEnter"]];
    [self.placeholderView setImageScaling:YES];
    [self addSubview:self.placeholderView];
}

- (void)layoutSubViews {
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-64);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-64);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(128);
    }];
}

-(void)setPlaceHolderHidden:(BOOL)hidden {
    [self.placeholderView setHidden:hidden];
}

-(BOOL)getPlaceHolderHidden {
    return self.placeholderView.hidden;
}

-(void)setVideoViewMode:(BOOL)yesno {
    [self.videoView setHidden:!yesno];
    [self.placeholderView setHidden:yesno];
}

-(BOOL)getVideoViewMode {
    return !self.videoView.hidden;
}

@end
