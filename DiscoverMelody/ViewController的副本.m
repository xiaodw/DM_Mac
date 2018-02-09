//
//  ViewController.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "DMClassDataModel.h"
#import "DMSecretKeyManager.h"
#import "DMApiModel.h"
#import "DMTools.h"
#import "DMAccount.h"
#import "AppDelegate.h"
#import "VideoControlBar.h"
#import "VideoCanvas.h"
#import "DMHttpClient.h"
#import "DMRequestModel.h"

enum VIEW_STATUS {
    VIEW_STATUS_LOGIN = 0,
    VIEW_STATUS_VIDEO
};

@interface ViewController()
@property NSInteger viewType;
@property (strong,nonatomic) NSButton* buttonConfirm;
@property (strong,nonatomic) NSTextField* lableInvitationCode;
@property (strong,nonatomic) NSTextField* textInvitationCode;

@property bool localSmall;   // 标记本地视频流是否在小窗口显示
@property (strong,nonatomic) NSView* smallVideo;
@property (strong,nonatomic) NSView* largeVideo;

@property (strong,nonatomic) VideoCanvas* smallVideoCanvas;
@property (strong,nonatomic) VideoCanvas* largeVideoCanvas;

@property (strong,nonatomic) VideoControlBar* controlBar;

@property (strong,nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong,nonatomic) AgoraRtcVideoCanvas *localVideoCanvas;
@property (strong,nonatomic) AgoraRtcVideoCanvas *remoteVideoCanvas;
@property (strong,nonatomic) NSString* channelKey;
@property (strong,nonatomic) NSString* channelName;
@property (strong,nonatomic) NSString* signalKey;
@property (strong,nonatomic) NSString* userId;
@property (strong,nonatomic) NSString* userType;

@property BOOL screenShare;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.wantsLayer = YES;
    self.smallVideo.wantsLayer = YES;
    self.largeVideo.wantsLayer = YES;
    
    self.viewType = VIEW_STATUS_VIDEO;
    self.screenShare = NO;
    [self setupView];
    [self switchToVideoView];
    [self updateViewConstraints];
    [self addTrackArea];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)viewWillAppear {
    [super viewWillAppear];
    
    //if (self.viewType == VIEW_STATUS_VIDEO) {
        self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
        self.smallVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
        self.largeVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
    //}
}

-(void)windowDidResize:(NSNotification *)notification {
    [self updateViewConstraints];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"mouseDown");
    NSRect smallRect = self.smallVideoCanvas.frame;
    CGFloat x = theEvent.locationInWindow.x;
    CGFloat y = theEvent.locationInWindow.y;
    if (x > smallRect.origin.x && x < smallRect.origin.x + smallRect.size.width &&
        y > smallRect.origin.y && y < smallRect.origin.y + smallRect.size.height) {
        [self switchVieo];
    }
}

- (void)hideControlBar {
    self.controlBar.hidden = YES;
}

-(void)addTrackArea {
    [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
    /*
    [self.smallVideoCanvas addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.smallVideoCanvas.bounds
                                  options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
    [self.largeVideoCanvas addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.largeVideoCanvas.bounds
                                  options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
     */
    [self.smallVideo addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.smallVideo.bounds
                                  options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
    [self.largeVideo addTrackingArea:
     [[NSTrackingArea alloc] initWithRect:self.largeVideo.bounds
                                  options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                    owner:self
                                 userInfo:nil]];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (self.controlBar.hidden) {
        self.controlBar.hidden = NO;
        [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
    } else {
        [ViewController cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [ViewController cancelPreviousPerformRequestsWithTarget:self];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [ViewController cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
}

-(void)handleUrls:(NSArray<NSURL *> *)urls {
    self.textInvitationCode.stringValue = [urls componentsJoinedByString:@","];
    NSURL* url = [urls objectAtIndex:0];
    NSString* param = [url parameterString];
    self.textInvitationCode.stringValue = param;
}

#pragma mark ##### setup views #####
-(void)setupLoginView {
    self.lableInvitationCode = [[NSTextField alloc]initWithFrame:CGRectMake(0, 130, 100, 25)];
    [self.lableInvitationCode setEditable:NO];
    [self.lableInvitationCode setBordered:NO];
    [self.lableInvitationCode setTextColor:[NSColor controlTextColor]];
    [self.lableInvitationCode setBackgroundColor:[NSColor controlColor]];
    [self.lableInvitationCode setStringValue:@"邀请码："];
    [self.view addSubview:self.lableInvitationCode];
    
    self.textInvitationCode = [[NSTextField alloc]initWithFrame:CGRectMake(0, 130, 100, 25)];
    [self.view addSubview:self.textInvitationCode];
    
    self.buttonConfirm = [[NSButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [self.buttonConfirm setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonConfirm setBezelStyle:NSRoundedBezelStyle];
    [self.buttonConfirm setTitle:@"登录"];
    [self.buttonConfirm setAction:@selector(buttonLoginClicked:)];
    [self.view addSubview:self.buttonConfirm];
}

-(void)setupVideoView {
    self.localSmall = true;

    self.smallVideo = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width/4, self.view.frame.size.height/4)];
    [self.view addSubview:self.smallVideo];
    
    self.largeVideo = [[NSView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.largeVideo];
    
    /*
    self.smallVideoCanvas = [[VideoCanvas alloc]initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width/4, self.view.frame.size.height/4)];
    [self.view addSubview:self.smallVideoCanvas];
    
    self.largeVideoCanvas = [[VideoCanvas alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.largeVideoCanvas];
    */
    self.view.wantsLayer = YES;
    self.smallVideo.wantsLayer = YES;
    self.largeVideo.wantsLayer = YES;
}

-(void)setupControlBar {
    self.controlBar = [[VideoControlBar alloc]initWithFrame:NSMakeRect(0, 0, 500, 64)];
    [self.controlBar setHangupAction:@selector(buttonHangupClicked:)];
    [self.controlBar setMuteAction:@selector(buttonMuteClicked:)];
    [self.controlBar setChangeLayoutAction:@selector(buttonChangeLayoutClicked:)];
    [self.controlBar setShareScreenAction:@selector(buttonScreenShareClicked:)];
    [self.view addSubview:self.controlBar];
}

-(void)setupView {
    [self setupLoginView];
    [self setupVideoView];
    [self setupControlBar];
}

-(void)switchToLoginView {
    self.viewType = VIEW_STATUS_LOGIN;
    
    [self.largeVideoCanvas setHidden:YES];
    [self.smallVideoCanvas setHidden:YES];
    [self.controlBar setHidden:YES];
    [self.lableInvitationCode setHidden:NO];
    [self.textInvitationCode setHidden:NO];
    [self.buttonConfirm setHidden:NO];
    
    self.view.layer.backgroundColor = nil;
    
    __block CGFloat offsetLeft = 80;
    __block CGFloat offsetTop = 60;
    
    [self.lableInvitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(offsetTop);
        make.left.mas_equalTo(self.view).with.offset(offsetLeft);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.textInvitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(offsetTop);
        make.left.mas_equalTo(self.lableInvitationCode).with.offset(offsetLeft);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [self.buttonConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(offsetTop);
        make.left.mas_equalTo(self.textInvitationCode.mas_right).with.offset(offsetLeft);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.controlBar setHidden:YES];
}

-(void)switchToVideoView {
    self.viewType = VIEW_STATUS_VIDEO;
    
    [self.largeVideoCanvas setHidden:NO];
    [self.smallVideoCanvas setHidden:NO];
    [self.controlBar setHidden:NO];
    [self.lableInvitationCode setHidden:YES];
    [self.textInvitationCode setHidden:YES];
    [self.buttonConfirm setHidden:YES];
    
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.smallVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.largeVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    [self.largeVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.smallVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = self.view.frame.size.width/4;
        CGFloat heigth= self.view.frame.size.height/4;
        make.size.mas_equalTo(CGSizeMake(width,heigth));
        make.right.mas_equalTo(self.view).inset(20);
        make.top.mas_equalTo(self.view).inset(20);
    }];
    
    /*
    [self.largeVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.smallVideoCanvas mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = self.view.frame.size.width/4;
        CGFloat heigth= self.view.frame.size.height/4;
        make.size.mas_equalTo(CGSizeMake(width,heigth));
        make.right.mas_equalTo(self.view).inset(20);
        make.top.mas_equalTo(self.view).inset(20);
    }];
    */
    // ---
    [self.controlBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).with.offset(-100);
        make.left.mas_equalTo(self.view).with.offset(100);
        make.width.mas_equalTo(600);
        make.height.mas_equalTo(64);
    }];
}

-(void)updateViewConstraints {
    switch (self.viewType) {
        case 0:
            [self switchToLoginView];
            break;
        case 1:
            [self switchToVideoView];
            break;
        default:
            break;
    }
    [super updateViewConstraints];
}

#pragma mark #####  actions #####
-(void)buttonLoginClicked:(id)sender {
    NSLog(@"Login");
    [self switchToVideoView];
    NSString* url = self.textInvitationCode.stringValue;
    if (YES == [url hasPrefix:@"dism://lesson"]) {
        NSLog(@"has...");
    } else {
        NSLog(@"has not...");
    }
}

-(void)buttonHangupClicked:(id)sender {
    NSLog(@"Hangup");
    [self leaveChannel];
}

-(void)buttonMuteClicked:(id)sender {
    NSLog(@"Mute");
    [self getLessonInfo];
    //[self.smallVideoCanvas setVideoViewMode:![self.smallVideoCanvas getVideoViewMode]];
}

-(void)buttonChangeLayoutClicked:(id)sender {
    NSLog(@"buttonChangeLayoutClicked");
    [self switchToLoginView];
}

-(void)buttonScreenShareClicked:(id)sender {
    [self toggleScreenShare];
}

#pragma mark #####  agoraKit operation #####
-(void)getLessonInfo {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//:account, @"account", password, @"password", nil];
    dic[@"lesson_id"] = @"2285";
    dic[@"uname"] = @"test202";
    dic[@"app_type"] = @"phone";
    
    [[DMRequestModel sharedInstance]requestWithPath:@"http://test.api.cn.discovermelody-app.com/lessonTest/accessing" method:DMHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(id responseObject) {
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        if (OBJ_IS_NIL(responseObj)) {
            return;
        }
        
        self.channelKey = [responseObj objectForKey:@"channel_key"];
        self.channelName = [responseObj objectForKey:@"channel_name"];
        NSLog(@"success %@  %@", self.channelName, self.channelKey);
        
        [self initializeAgoraEngine];   // Tutorial Step 1
        [self setupVideo];              // Tutorial Step 2
        [self setupLocalVideo];         // Tutorial Step 3
        [self joinChannel];             // Tutorial Step 4
    } failure:^(NSError *error) {
        
    }];
}
-(void)userLogin {
    [DMApiModel loginSystem:@"test101" psd:@"123456" block:^(BOOL result) {
        if (!result) { //登录失败
            //[DMDelegate showMessageBox:@"登录失败" withTitle:@"提示"];
            return;
        }
        
        NSString *type = [DMAccount getUserIdentity];
        
        [DMApiModel getHomeCourseData:type block:^(BOOL result, NSArray *array) {
            if (result) {
                if (!OBJ_IS_NIL(array) && array.count > 0) {
                     ((AppDelegate *)([NSApplication sharedApplication].delegate)).courseObj = [array objectAtIndex:0];
                    [self initializeAgoraEngine];   // Tutorial Step 1
                    [self setupVideo];              // Tutorial Step 2
                    [self setupLocalVideo];         // Tutorial Step 3
                    [self joinChannel];             // Tutorial Step 4
                }
            }
        }];
        
        //登录成功
        //[DMDelegate showLiveView];
        
        
    }];
}

// Tutorial Step 1
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:@"d475f5e1e99648c5b31a1321d5cf2dc5" delegate:self];
}

// Tutorial Step 2
- (void)setupVideo {
    [self.agoraKit enableVideo];
    // Default mode is disableVideo
    
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_720P swapWidthAndHeight:false];
    // Default video profile is 360P
}

// Tutorial Step 3
- (void)setupLocalVideo {
    self.localVideoCanvas.uid = 0; // UID = 0 means we let Agora pick a UID for us
    [self.largeVideoCanvas setVideoViewMode:YES];
    self.localVideoCanvas.view = self.largeVideo; //self.smallVideoCanvas.videoView;
    self.localVideoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraKit setupLocalVideo:self.localVideoCanvas];
}

// Tutorial Step 4
- (void)joinChannel {
    [self.agoraKit joinChannelByKey:self.channelKey channelName:self.channelName info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        // Join channel "demoChannel1"
        NSLog(@"Join channel %@ success", self.channelName);
        //[self.largeVideoCanvas setVideoViewMode:YES];
    }];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if (self.largeVideoCanvas.hidden) {
        self.largeVideoCanvas.hidden = false;
    }
    
    self.remoteVideoCanvas.uid = uid;
    self.remoteVideoCanvas.view = self.largeVideoCanvas.videoView;
    self.remoteVideoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraKit setupRemoteVideo:self.remoteVideoCanvas];
}

-(void)toggleScreenShare {
    self.screenShare = !self.screenShare;
    if (self.screenShare) {
        //[sender setImage:[NSImage imageNamed:@"screenShareButtonSelected"]];
        [self.agoraKit startScreenCapture:0 withCaptureFreq:15 AndRect:CGRectZero];
    } else {
        //[sender setImage:[NSImage imageNamed:@"screenShareButton"]];
        [self.agoraKit stopScreenCapture];
    }
}

- (void)leaveChannel {
    [self.agoraKit leaveChannel:nil];
    [self.agoraKit setupLocalVideo:nil];
    //[self.remoteVideo removeFromSuperview];
    //[self.localVideo removeFromSuperview];
    self.agoraKit = nil;
    //[self.view.window close];
}

-(void)switchVieo {
    if (self.localSmall) {
        self.localSmall = false;
        self.localVideoCanvas.view = self.smallVideoCanvas.videoView;
        self.remoteVideoCanvas.view = self.largeVideoCanvas.videoView;
        
        //self.smallVideo.layer.backgroundColor = [NSColor greenColor].CGColor;
        //self.largeVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
        
    } else {
        self.localSmall = true;
        self.localVideoCanvas.view = self.largeVideoCanvas.videoView;
        self.remoteVideoCanvas.view = self.smallVideoCanvas.videoView;
        
        //self.smallVideo.layer.backgroundColor = [NSColor clearColor].CGColor;
        //self.largeVideo.layer.backgroundColor = [NSColor greenColor].CGColor;
    }
    /*
    [self.agoraKit setupLocalVideo:self.localVideoCanvas];
    [self.agoraKit setupRemoteVideo:self.remoteVideoCanvas];
    */
}

@end
