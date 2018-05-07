//
//  VideoControlBar.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "VideoControlBar.h"
#import <Masonry.h>

@interface VideoControlBar()
@property (strong,nonatomic) NSButton* buttonHangup;
@property (strong,nonatomic) NSButton* buttonMute;
@property (strong,nonatomic) NSButton* buttonChangeLayout;
@property (strong,nonatomic) NSButton* buttonShareScreen;
@end

@implementation VideoControlBar

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
        [self addTrackArea];
    }
    return self;
}

-(void)setupSubViews {
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:[NSColor clearColor].CGColor];
    //[self.layer setBackgroundColor:[NSColor colorWithRed:0.f green:0.f blue:0.f alpha:0.2f].CGColor];
    
    /*
    self.buttonMute = [[NSButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.buttonMute setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonMute setBezelStyle:NSRoundedBezelStyle];
    [self.buttonMute setTitle:@"静音"];
    self.buttonMute.bordered = NO;
    self.buttonMute.imageScaling = YES;
    [self.buttonMute setImage:[NSImage imageNamed:@"muteButton"]];
    //[self.buttonMute setAction:@selector(buttonMuteClicked:)];
    [self addSubview:self.buttonMute];
    */
    self.buttonHangup = [[NSButton alloc]initWithFrame:CGRectMake(64, 0, 64, 64)];
    [self.buttonHangup setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonHangup setBezelStyle:NSRoundedBezelStyle];
    [self.buttonHangup setTitle:@"挂断"];
    self.buttonHangup.bordered = NO;
    self.buttonHangup.imageScaling = YES;
    [self.buttonHangup setImage:[NSImage imageNamed:@"hangUpButton"]];
    [self addSubview:self.buttonHangup];
    
    self.buttonChangeLayout = [[NSButton alloc]initWithFrame:CGRectMake(128, 0, 64, 64)];
    [self.buttonChangeLayout setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonChangeLayout setBezelStyle:NSRoundedBezelStyle];
    [self.buttonChangeLayout setTitle:@"切换视图"];
    self.buttonChangeLayout.bordered = NO;
    self.buttonChangeLayout.imageScaling = YES;
    [self.buttonChangeLayout setImage:[NSImage imageNamed:@"changeLayoutButton"]];
    [self addSubview:self.buttonChangeLayout];
    
    self.buttonShareScreen = [[NSButton alloc]initWithFrame:CGRectMake(128, 0, 64, 64)];
    [self.buttonShareScreen setHidden:YES]; // 默认隐藏
    [self.buttonShareScreen setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonShareScreen setBezelStyle:NSRoundedBezelStyle];
    [self.buttonShareScreen setTitle:@"屏幕共享"];
    self.buttonShareScreen.bordered = NO;
    self.buttonShareScreen.imageScaling = YES;
    [self.buttonShareScreen setImage:[NSImage imageNamed:@"screenShareButton"]];
    [self addSubview:self.buttonShareScreen];
}

-(void)layoutSubViews {
    //__block CGFloat ctlInterval = 32;
    //__block CGFloat ctlWidth = 64;
    //__block CGFloat ctlHeight = 64;
    
    if ([self.buttonShareScreen isHidden]) {
        [self.buttonChangeLayout mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.left.mas_equalTo(self.mas_centerX).with.offset(30);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        
        [self.buttonHangup mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.right.mas_equalTo(self.mas_centerX).offset(-30);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
    } else {
        [self.buttonChangeLayout mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.left.mas_equalTo(self.mas_centerX).with.offset(-40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        
        [self.buttonHangup mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.left.mas_equalTo(self.buttonChangeLayout.mas_left).offset(-140);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        
        /*
        [self.buttonMute mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.left.mas_equalTo(self.buttonChangeLayout.mas_right).with.offset(60);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        */
        
        [self.buttonShareScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(60);
            make.left.mas_equalTo(self.buttonChangeLayout.mas_right).with.offset(60);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
    }
}

-(void)setHangupAction:(SEL)action {
    [self.buttonHangup setAction:action];
}

-(void)setMuteAction:(SEL)action {
    [self.buttonMute setAction:action];
}

-(void)setChangeLayoutAction:(SEL)action {
    [self.buttonChangeLayout setAction:action];
}

-(void)setShareScreenAction:(SEL)action {
    [self.buttonShareScreen setAction:action];
}

-(void)addTrackArea {
    [self addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.bounds
                                  options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
    [self addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.bounds
                                  options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.isMouseHover = YES;
    //NSLog(@"-->mouseEntered");
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.isMouseHover = NO;
    //NSLog(@"-->mouseExited");
}

-(void)setShareScreenEnable:(BOOL)yesno {
    [self.buttonShareScreen setHidden:!yesno];
    [self layoutSubViews];
}

@end
