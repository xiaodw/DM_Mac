//
//  VideoStatusBar.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/25.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "VideoStatusBar.h"
#import <Masonry.h>
#import "DMConst.h"

@interface VideoStatusBar()
@property (strong,nonatomic)NSImageView* imageViewTime;
@property (strong,nonatomic)NSTextField* textViewTime;
@property (strong,nonatomic)NSTextField* textViewRecStatus;
@property (strong,nonatomic)NSTimer* timerCount;
@property (strong,nonatomic)NSColor* myRedColor;
@property (strong,nonatomic)NSImage* myRedClock;
@property double countBegin;
@property double countBeginWithRedColor;
@property double countBeginWithRedColorWarning;
@property double countEnd;
@end

@implementation VideoStatusBar

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:0.f green:0.f blue:0.f alpha:0.1f] endingColor:[NSColor colorWithRed:0.f green:0.f blue:0.f alpha:0.00001f]];
    NSRect viewFrame = [self frame];
    [gradient drawInRect:viewFrame angle:90];
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
        [self setHidden:YES];
        [self.textViewRecStatus setHidden:YES];
        self.countBegin = 0;
        self.countBeginWithRedColor = 0;
        self.countBeginWithRedColorWarning = 0;
        self.countEnd = 0;
        self.myRedColor = [NSColor colorWithRed:229/255.f green:57/255.f blue:59/255.f alpha:1.f];
        self.myRedClock = [NSImage imageNamed:@"redClock"];
    }
    return self;
}

- (void)setupSubViews {
    self.imageViewTime = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.imageViewTime setImage:[NSImage imageNamed:@"whiteClock"]];
    [self.imageViewTime setImageScaling:YES];
    [self addSubview:self.imageViewTime];
    
    self.textViewTime = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.textViewTime setWantsLayer:YES];
    [self.textViewTime setBackgroundColor:[NSColor clearColor]];
    [self.textViewTime setTextColor:[NSColor whiteColor]];
    [self.textViewTime setEditable:NO];
    [self.textViewTime setSelectable:NO];
    [self.textViewTime setBordered:NO];
    [self.textViewTime setStringValue:@"00:00:00"];
    [self.textViewTime setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_18_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_18_SIZE", nil).intValue]];
    [self addSubview:self.textViewTime];
    
    self.textViewRecStatus = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.textViewRecStatus setWantsLayer:YES];
    [self.textViewRecStatus setBackgroundColor:[NSColor clearColor]];
    [self.textViewRecStatus setTextColor:[NSColor colorWithRed:3/255.f green:213/255.f blue:42/255.f alpha:1.f]];
    [self.textViewRecStatus setEditable:NO];
    [self.textViewRecStatus setSelectable:NO];
    [self.textViewRecStatus setBordered:NO];
    [self.textViewRecStatus setStringValue:NSLocalizedString(@"VIDEO_VIEW_RECORD_STATUS", nil)];
    [self.textViewRecStatus setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_18_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_18_SIZE", nil).intValue]];
    [self addSubview:self.textViewRecStatus];
}

- (void)layoutSubViews {
    [self.imageViewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(132);
        make.left.mas_equalTo(self).with.offset(32);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.textViewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageViewTime.mas_centerY).with.offset(-12);
        make.left.mas_equalTo(self.imageViewTime.mas_right).with.offset(12);
        make.right.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.imageViewTime.mas_centerY).with.offset(12);
    }];
    
    [self.textViewRecStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageViewTime).with.offset(-4);
        make.left.mas_equalTo(self.mas_right).with.offset(-130);
        make.right.mas_equalTo(self.mas_right).with.offset(-32);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-28);
    }];
}

-(NSString*)fomattedDisplayWithInterval:(double)intervalSince1970 {
    int interval = intervalSince1970 - self.countBegin;
    int hours = interval / 3600 % 24;
    int minutes = interval / 60 % 60;
    int seconds = interval % 60;
    int leftMinutes = (self.countEnd - intervalSince1970 + 59) / 60;
    
    if (self.countBegin < intervalSince1970 && self.countBeginWithRedColorWarning > intervalSince1970) {
        return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"VIDEO_VIEW_COUNTDOWN_NOTICE", nil), hours, minutes, seconds, leftMinutes];
    }
}

-(void)handleTimer:(NSTimer*)timer {
    NSDate* dataNow = [[NSDate alloc]init];
    NSTimeInterval intervalSince1970 = [dataNow timeIntervalSince1970];
    if (intervalSince1970 < self.countBegin) {
        if (!self.isHidden) {
            [self setHidden:YES];
        }
        return;
    }
    
    if (self.countEnd < intervalSince1970) {
        [self.timerCount invalidate];
        [self setHidden:YES];
        if (nil != self.action) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
        return;
    }
    
    if (self.isHidden) {
        [self setHidden:NO];
    }
    
    if (self.countBeginWithRedColor < intervalSince1970) {
        if (![self.imageViewTime.image isEqual:self.myRedClock]) {
            [self.imageViewTime setImage:self.myRedClock];
        }
        if (![self.textViewTime.textColor isEqual:self.myRedColor]) {
            [self.textViewTime setTextColor:self.myRedColor];
        }
    }
    
    [self.textViewTime setStringValue:[self fomattedDisplayWithInterval:intervalSince1970]];
}

-(void)startCountBegin:(double)begin Red:(double)red Warning:(double)warn End:(double)end {
    
    self.countBegin = begin;
    self.countBeginWithRedColor = red;
    self.countBeginWithRedColorWarning = warn;
    self.countEnd = end;
    [self.textViewTime setBackgroundColor:[NSColor clearColor]];
    [self.imageViewTime setImage:[NSImage imageNamed:@"whiteClock"]];
    [self.textViewTime setTextColor:[NSColor whiteColor]];
    
    if (self.countEnd <= self.countBegin) {
        return;
    }
    
    if (self.countBeginWithRedColorWarning < self.countBegin) {
        self.countBeginWithRedColorWarning = self.countEnd;
    }
    
    if (self.countBeginWithRedColor < self.countBegin) {
        self.countBeginWithRedColor = self.countBeginWithRedColorWarning;
    }
    
    if ([self.timerCount isValid]) {
        [self.timerCount invalidate];
    }
    self.timerCount = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

-(void)setStopAction:(SEL)action withTarget:(id)target {
    self.action = action;
    self.target = target;
}

-(void)stopCount {
    [self.timerCount invalidate];
    [self setHidden:YES];
}

-(void)setRecStatusHidden:(BOOL)yesno {
    [self.textViewRecStatus setHidden:yesno];
}

@end
