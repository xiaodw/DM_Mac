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
@property BOOL isShowBoarder;
@property BOOL isUserOnline;
@property (nullable, weak) id target;
@property (nullable) SEL action;
@end;

@implementation VideoCanvas

- (void)drawRect:(NSRect)dirtyRect {
//    if (self.isShowBoarder) {
//        [[NSColor colorWithRed:(float)182/255 green:(float)182/255 blue:(float)182/255 alpha:1.0] setFill];
//        NSRectFill(dirtyRect);
//
//        NSRect rectToFill;
//        rectToFill.origin.x = dirtyRect.origin.x + 1;
//        rectToFill.origin.y = dirtyRect.origin.y + 1;
//        rectToFill.size.width = dirtyRect.size.width - 2;
//        rectToFill.size.height = dirtyRect.size.height - 2;
//
//        [[NSColor blackColor] setFill];
//        NSRectFill(rectToFill);
//    } else {
        [[NSColor blackColor] setFill];
        NSRectFill(dirtyRect);
//    }
    
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
        self.isUserOnline = NO;
        self.isShowBoarder = NO;
        [self.layer setBackgroundColor:[NSColor blueColor].CGColor];
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
//    if (self.isShowBoarder) {
//        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(self.mas_width).with.offset(-4);
//            make.height.mas_equalTo(self.mas_height).with.offset(-4);
//            make.centerX.mas_equalTo(self.mas_centerX);
//            make.centerY.mas_equalTo(self.mas_centerY);
////            make.right.mas_equalTo(self.mas_right).with.offset(-1);
////            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-1);
//        }];
//    } else {
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
//    }
    
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-64);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-64);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(128);
    }];
}

-(void)mouseDown:(NSEvent *)event {
    if (nil != self.action && nil != self.target) {
        [self.target performSelector:self.action withObject:self];
    }
}

-(void)setPlaceHolderHidden:(BOOL)hidden {
    [self.videoView setHidden:!hidden];
    [self.placeholderView setHidden:hidden];
}

-(BOOL)getPlaceHolderHidden {
    return self.placeholderView.hidden;
}

-(void)setUserOnline:(BOOL)yesno {
    self.isUserOnline = yesno;
    
    [self.videoView setHidden:!yesno];
    [self.placeholderView setHidden:yesno];
}

-(BOOL)getUserOnline {
    return self.isUserOnline;
}

-(void)setShowBoarder:(BOOL)yesno {
    self.isShowBoarder = yesno;
    [self layoutSubViews];
}

-(BOOL)getShowBoarder {
    return self.isShowBoarder;
}

-(void)setClickAction:(SEL)action withTarget:(id)target {
    self.action = action;
    self.target = target;
}

@end
