//
//  CountDownClock.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/25.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "CountDownClock.h"
#import <Masonry.h>
#import "DMConst.h"

@interface CountDownClock()
@property (strong,nonatomic)NSImageView* imageViewAlarm;
@property (strong,nonatomic)NSTextView* textViewNotice;
@property (strong,nonatomic)NSTimer* timerCount;
@property double countDownEnd;
@property enum COUNT_DOWN_STATUS countDownStatus;
@end

@implementation CountDownClock

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
        [self setHidden:YES];
        self.countDownStatus = COUNT_DOWN_STATUS_NOT_START;
    }
    return self;
}

- (void)setupSubViews {
    self.imageViewAlarm = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 160, 160)];
    [self.imageViewAlarm setImage:[NSImage imageNamed:@"grayAlarm"]];
    [self.imageViewAlarm setImageScaling:YES];
    [self.imageViewAlarm.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [self addSubview:self.imageViewAlarm];
    
    self.textViewNotice = [[NSTextView alloc]initWithFrame:NSMakeRect(0, 0, 176, 176)];
    [self.textViewNotice setWantsLayer:YES];
    [self.textViewNotice setBackgroundColor:[NSColor clearColor]];
    [self.textViewNotice setTextColor:[NSColor whiteColor]];
    [self.textViewNotice setEditable:NO];
    [self.textViewNotice setSelectable:NO];
    [self.textViewNotice setString:@"- - -"];
    [self.textViewNotice setAlignment:NSTextAlignmentCenter];
    [self addSubview:self.textViewNotice];
}

- (void)layoutSubViews {
    [self.imageViewAlarm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [self.textViewNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
    }];
}

-(NSString*)fomattedNotice:(double)intervalSince1970 {
    int leftMinutes = (self.countDownEnd - intervalSince1970 + 59) / 60;
    if (leftMinutes < 0) {
        leftMinutes = 0;
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"VIDEO_VIEW_COUNT_DOWN_CLOCK_NOTICE", nil), leftMinutes];
}

-(void)handleTimer:(NSTimer*)timer {
    NSDate* dataNow = [[NSDate alloc]init];
    NSTimeInterval intervalSince1970 = [dataNow timeIntervalSince1970];
    if (self.countDownEnd < intervalSince1970) {
        if (nil != self.action) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
        [self stopCount];
        return;
    }
    
    [self.textViewNotice setString:[self fomattedNotice:intervalSince1970]];
}

-(void)startCountDownUntil:(double)utcEnd {
    self.countDownEnd = utcEnd;
    self.countDownStatus = COUNT_DOWN_STATUS_STARTED;
    self.timerCount = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [self setHidden:NO];
}

-(void)setStopAction:(SEL)action withTarget:(id)target {
    self.action = action;
    self.target = target;
}

-(void)stopCount {
    [self.timerCount invalidate];
    self.action = nil;
    self.countDownStatus = COUNT_DOWN_STATUS_STOPPED;
    [self setHidden:YES];
}

-(enum COUNT_DOWN_STATUS)getCountDownStatus {
    return self.countDownStatus;
}

@end
