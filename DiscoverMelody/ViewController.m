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
#import "DMHttpClient.h"
#import "DMRequestModel.h"

#import "AppData.h"
#import "LogData.h"
#import "LoginView.h"
#import "VideoView.h"
#import "OverlayView.h"
#import "DeviceSelectionViewController.h"
#import "UrlConfig.h"
//#import "STOverlayController.h"

enum VIEW_STATUS {
    VIEW_STATUS_LOGIN = 0,
    VIEW_STATUS_VIDEO
};

enum APP_DATA_STATUS {
    APP_DATA_STATUS_UNHANDLED = 0,
    APP_DATA_STATUS_HANDLED
};

#define DM_GET_APP_CONFIG_DONE @"DmGetAppConfigDone"
#define DM_HANDLE_APP_CONFIG_DONE @"DmHandleAppConfigDone"
#define DMLOGIN_STEP_1_DONE @"DmLoginStep1Done"
#define DMLOGIN_STEP_2_DONE @"DmLoginStep2Done"

@interface ViewController()
@property (strong,nonatomic) LoginView* loginView;
@property (strong,nonatomic) VideoView* videoView;
@property (strong,nonatomic) OverlayView* overlayView;
@property (strong,atomic) NSTimer* overlayTimer;

@property (strong,nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong,nonatomic) AgoraRtcVideoCanvas *localVideoCanvas;
@property (strong,nonatomic) AgoraRtcVideoCanvas *remoteVideoCanvas;

@property (strong,nonatomic) NSString* userId;
@property (strong,nonatomic) NSString* userType;
@property (strong,nonatomic) NSString* userToken;
@property (strong,nonatomic) NSString* meetingId;
@property (strong,nonatomic) NSString* lessonCode;
@property (strong,nonatomic) NSString* lessonStartTime;
@property (strong,nonatomic) NSString* lessonDuration;
@property (strong,nonatomic) NSString* lessonCountDown;
@property (strong,nonatomic) NSString* lessonForceClose;
@property (strong,nonatomic) NSString* agoraAppId;
@property NSInteger agoraVideoProfile;
@property NSInteger playVolume;
@property NSInteger recordVolume;
@property NSInteger audioScenario;
@property NSInteger audioProfile;
@property BOOL enableScreenSharing;
@property BOOL enableShowRecodingStatus;
@property (strong,nonatomic) NSString* signalKey;
@property (strong,nonatomic) NSString* channelKey;
@property (strong,nonatomic) NSString* channelName;
@property (strong,nonatomic) NSString* channelUidMine;
@property (strong,nonatomic) NSString* channelUidStudent;
@property (strong,nonatomic) NSString* channelUidTeacher;
@property (strong,nonatomic) NSString* channelUidAssistant;

@property (strong,nonatomic) NSString* updateType;
@property (strong,nonatomic) NSString* updateVer;
@property (strong,nonatomic) NSString* updateMsg;
@property (strong,nonatomic) NSString* updateUrl;

@property BOOL needHide;
@property BOOL localSmall;
@property BOOL screenShare;
@property enum VIEW_STATUS viewStatus;
@property enum APP_DATA_STATUS appDataStatus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.appDataStatus = APP_DATA_STATUS_UNHANDLED;
    self.needHide = NO;
    
    [self loadLatestConfig];
    [self setupSubViews];
    [self layoutSubViews];
    [self addTrackArea];
    [self getAppConfig];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAppConfigDone:) name:DM_GET_APP_CONFIG_DONE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAppConfigDone:) name:DM_HANDLE_APP_CONFIG_DONE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStep1Done:) name:DMLOGIN_STEP_1_DONE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStep2Done:) name:DMLOGIN_STEP_2_DONE object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark ### window customize ###
- (void)hideControlBar {
    if (![self.videoView.controlBar isMouseHover]) {
        self.videoView.controlBar.hidden = YES;
    }
}

-(void)addTrackArea {
    [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
    NSTrackingArea* trackArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
                                                             options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect
                                                               owner:self
                                                            userInfo:nil];
    [self.view addTrackingArea:trackArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSRect smallRect = self.videoView.videoCanvasStudent.frame;
    CGFloat x = theEvent.locationInWindow.x;
    CGFloat y = theEvent.locationInWindow.y;
    if (x > smallRect.origin.x && x < smallRect.origin.x + smallRect.size.width &&
        y > smallRect.origin.y && y < smallRect.origin.y + smallRect.size.height) {
        [self switchVieo];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (self.viewStatus == VIEW_STATUS_VIDEO) {
        if (self.videoView.controlBar.hidden) {
            self.videoView.controlBar.hidden = NO;
            [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
        } else {
            [ViewController cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.viewStatus == VIEW_STATUS_VIDEO) {
        [ViewController cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.viewStatus == VIEW_STATUS_VIDEO) {
        [ViewController cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:3];
    }
}

-(void)windowDidResize:(NSNotification *)notification {
    [self updateViewConstraints];
    [self.videoView layoutSubViews];
}

-(BOOL)injectWindowShouldClose:(NSWindow *)sender {
    if (VIEW_STATUS_LOGIN == self.viewStatus) {
        [NSApp terminate:sender];
    } else {
        [self alertMsg:NSLocalizedString(@"ALERT_LIVE_AUTO_CLOSE", nil) Title:NSLocalizedString(@"ALERT_EXIT_LIVE_ROOM", nil) ButtonOk:NSLocalizedString(@"ALERT_BUTTON_OK", nil) ButtonCancel:NSLocalizedString(@"ALERT_BUTTON_CANCEL", nil) OnOk:^{
            [self leaveChannel];
            //[self changeViewStatus:VIEW_STATUS_LOGIN];
            [NSApp terminate:sender];
        } OnCancel:^{
        }];
    }
    return NO;
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self layoutSubViews];
}

#pragma mark ### url handler ###
-(void)handleUrls:(NSArray<NSURL *> *)urls {
    if (VIEW_STATUS_VIDEO == self.viewStatus) {
        [self leaveChannel];
        [self changeViewStatus:VIEW_STATUS_LOGIN];
    }
    
    NSURL* url = [urls objectAtIndex:0];
    NSString* urlString = [url absoluteString];
    
    NSArray *array = [urlString componentsSeparatedByString:@"="];
    NSLog(@"Url from browser:%@ Parsed code:%@", urlString, [array objectAtIndex:1]);
    [self.loginView setLatestLessonCode:[array objectAtIndex:1]];
    if (APP_DATA_STATUS_HANDLED == self.appDataStatus) {
        [self buttonLoginClicked:self];
    }
}

#pragma mark ### setup and layout subviews ###
-(void)loadLatestConfig {
    self.enableScreenSharing = NO;
    self.enableShowRecodingStatus = NO;
    self.agoraAppId = [[AppData defaultAppData] getAgoraAppId];
    self.agoraVideoProfile = [[AppData defaultAppData]getAgoraVideoProfile];
}

-(void)setupSubViews {
    self.viewStatus = VIEW_STATUS_LOGIN;
    
    self.loginView = [[LoginView alloc]initWithFrame:self.view.frame];
    [self.loginView setLoginAction:@selector(buttonLoginClicked:) withTarget:self];
    [self.loginView setLoginStatus:LOGIN_STATUS_NOT_READY];
    [self.view addSubview:self.loginView];
    
    self.videoView = [[VideoView alloc]initWithFrame:self.view.frame];
    [self.videoView setHidden:YES];
    [self.videoView.controlBar setHangupAction:@selector(buttonHangupClicked:)];
    [self.videoView.controlBar setMuteAction:@selector(buttonMuteClicked:)];
    [self.videoView.controlBar setChangeLayoutAction:@selector(buttonChangeLayoutClicked:)];
    [self.videoView.controlBar setShareScreenAction:@selector(buttonScreenShareClicked:)];
    [self.view addSubview:self.videoView];
    
    self.overlayView = [[OverlayView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.overlayView];
}

-(void)layoutSubViews {
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)changeViewStatus:(enum VIEW_STATUS)status {
    self.viewStatus = status;
    
    if (VIEW_STATUS_LOGIN == self.viewStatus) {
        [self.loginView setHidden:NO];
        [self.videoView setHidden:YES];
    } else if (VIEW_STATUS_VIDEO == self.viewStatus) {
        [self.loginView setHidden:YES];
        [self.videoView setHidden:NO];
    }
}

#pragma mark ### notice ###
-(void)handleOverlayTimer:(NSTimer*)timer {
    if ([self.overlayTimer isValid]) {
        [self.overlayTimer invalidate];
    }
    [self.overlayView endOverlay];
    [self.loginView setLoginStatus:LOGIN_STATUS_READY];
}

-(void)startOverlay:(NSString*)label {
    [self.overlayView beginOverlayWithLabel:label];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(handleOverlayTimer:) userInfo:nil repeats:NO];
}

-(void)alertMsg:(NSString*)msg
          Title:(NSString*)title
       ButtonOk:(NSString*)ok
   ButtonCancel:(NSString*)cancel
           OnOk:(void(^)(void))okHandler
       OnCancel:(void(^)(void))cancelHandler {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:ok];
    [alert addButtonWithTitle:cancel];
    [alert setMessageText:title];
    [alert setInformativeText:msg];
    alert.icon = nil;//[NSImage imageNamed:@"redClock"];
    [alert.window setStyleMask:NSWindowStyleMaskBorderless];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (1000 == returnCode) {
            okHandler();
        } else {
            cancelHandler();
        }
    }];
}

#pragma mark ###  actions ###
-(void)countDownClockStopped:(id)sender {
    NSLog(@"countDownClockStopped");
    [self.videoView.videoCanvasTeacher setPlaceHolderHidden:[self.videoView.videoCanvasTeacher getUserOnline]];
}

-(void)lessonEndReached:(id)sender {
    [self leaveChannel];
    [self changeViewStatus:VIEW_STATUS_LOGIN];
}

-(void)buttonLoginClicked:(id)sender {
    self.lessonCode = [self.loginView getLessonCode];
    
    [self.loginView setLoginStatus:LOGIN_STATUS_DOING];
    [self getUserInfoByCode:self.lessonCode];
}

-(void)buttonselectDeviceClicked:(id)sender {
    DeviceSelectionViewController *deviceSelectionViewController = [self.storyboard instantiateControllerWithIdentifier:@"DeviceSelectionViewController"];
    deviceSelectionViewController.agoraKit = self.agoraKit;
    // Pass in AgoraRtcEngineKit
    [self presentViewControllerAsSheet:deviceSelectionViewController];
}

-(void)rightDeleteAction:(id)sender {
    
}

-(void)buttonHangupClicked:(id)sender {
    [self alertMsg:NSLocalizedString(@"ALERT_LIVE_AUTO_CLOSE", nil) Title:NSLocalizedString(@"ALERT_EXIT_LIVE_ROOM", nil) ButtonOk:NSLocalizedString(@"ALERT_BUTTON_OK", nil) ButtonCancel:NSLocalizedString(@"ALERT_BUTTON_CANCEL", nil) OnOk:^{
        [self leaveChannel];
        [self changeViewStatus:VIEW_STATUS_LOGIN];
    } OnCancel:^{
        
    }];
}

-(void)buttonMuteClicked:(id)sender {
    NSLog(@"Mute");
}

-(void)buttonChangeLayoutClicked:(id)sender {
    [self.videoView changeViewLayoutMode];
}

-(void)buttonScreenShareClicked:(id)sender {
    [self alertMsg:self.screenShare ? NSLocalizedString(@"ALERT_STOP_SHARE_SCREEN_MSG", nil) : NSLocalizedString(@"ALERT_START_SHARE_SCREEN_MSG", nil)
             Title:self.screenShare ? NSLocalizedString(@"ALERT_STOP_SHARE_SCREEN_TITLE", nil) : NSLocalizedString(@"ALERT_START_SHARE_SCREEN_TITLE", nil) ButtonOk:NSLocalizedString(@"ALERT_BUTTON_OK", nil) ButtonCancel:NSLocalizedString(@"ALERT_BUTTON_CANCEL", nil) OnOk:^{
        [self toggleScreenShare];
    } OnCancel:^{
        
    }];
}

-(void)switchVieo {
    if (self.localSmall) {
        self.localSmall = NO;
        self.localVideoCanvas.view = self.videoView.videoCanvasTeacher.videoView;
        self.remoteVideoCanvas.view = self.videoView.videoCanvasStudent.videoView;
    } else {
        self.localSmall = YES;
        self.localVideoCanvas.view = self.videoView.videoCanvasStudent.videoView;
        self.remoteVideoCanvas.view = self.videoView.videoCanvasTeacher.videoView;
    }
    
    //[self.agoraKit setupLocalVideo:self.localVideoCanvas];
    //[self.agoraKit setupRemoteVideo:self.remoteVideoCanvas];
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

#pragma mark #####  Communicate with Server #####
-(NSMutableDictionary*)buildCommonRequestField {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"ver"] = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    dic[@"app"] = @"mac";
    dic[@"lan"] = NSLocalizedString(@"GLOBAL_APP_LANGUAGE", nil);
#if defined(PRODUCT_TYPE_WE_EDUCATION)
    dic[@"business"] = @"weedu";
#elif defined(PRODUCT_TYPE_DISCOVER_MELODY)
    dic[@"business"] = @"discover-melody";
#elif defined(PRODUCT_TYPE_WE_DESIGN)
    dic[@"business"] = @"wedesign";
#endif
    return dic;
}

-(void)getAppConfig {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    [[DMRequestModel sharedInstance]requestWithPath:URL_GET_APP_CONFIG method:DMHttpRequestPost parameters:dic prepareExecute:^{
    } success:^(id responseObject) {
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        if (OBJ_IS_NIL(responseObj)) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DM_GET_APP_CONFIG_DONE object:@"failed"];
            return;
        }
        
        NSString* retCode = [responseObj objectForKey:@"code"];
        if (0 != [retCode intValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DM_GET_APP_CONFIG_DONE object:@"failed"];
            return;
        }
        
        NSDictionary* dataObj = [responseObj objectForKey:@"data"];
        self.agoraAppId = [dataObj objectForKey:@"agoraAppId"];
        
        NSDictionary* appObj = [dataObj objectForKey:@"app"];
        self.updateType = [appObj objectForKey:@"update"];
        self.updateVer = [appObj objectForKey:@"newVer"];
        self.updateMsg = [appObj objectForKey:@"updateMsg"];
        self.updateUrl = [appObj objectForKey:@"updateUrl"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:DM_GET_APP_CONFIG_DONE object:@"success"];
    } failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:DM_GET_APP_CONFIG_DONE object:@"failed"];
    }];
}

-(void)getUserInfoByCode:(NSString*)code {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    dic[@"code"] = code;
    
    [[DMRequestModel sharedInstance]requestWithPath:URL_GET_USER_INFO method:DMHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(id responseObject) {
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        if (OBJ_IS_NIL(responseObj)) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_1_DONE object:NSLocalizedString(@"OVERLAY_MSG_UNKOWN_REASON", nil)];
            return;
        }
        
        NSString* retCode = [responseObj objectForKey:@"code"];
        NSString* retMsg = [responseObj objectForKey:@"msg"];
        if (0 != [retCode intValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_1_DONE object:retMsg];
            return;
        }
        
        NSDictionary* dataObj = [responseObj objectForKey:@"data"];
        self.userToken = [dataObj objectForKey:@"token"];
        self.meetingId = [dataObj objectForKey:@"meeting_id"];
        self.userId = [dataObj objectForKey:@"user_id"];
        self.userType = [dataObj objectForKey:@"user_type"];
        
        NSDictionary* configObj = [dataObj objectForKey:@"config"];
        self.agoraVideoProfile = [[configObj objectForKey:@"agora_video_profile"]integerValue];
        self.enableScreenSharing = [[configObj objectForKey:@"screen_sharing"]boolValue];
        self.enableShowRecodingStatus = [[configObj objectForKey:@"recording"]boolValue];
        self.playVolume = [[configObj objectForKey:@"play_volume"]integerValue];
        self.recordVolume = [[configObj objectForKey:@"record_volume"]integerValue];
        self.audioScenario = [[configObj objectForKey:@"audio_scenario"]integerValue];
        self.audioProfile = [[configObj objectForKey:@"audio_profile"]integerValue];
        
        [self.videoView setUserTypeMine:self.userType.integerValue];
        
        [self.videoView.statusBar setRecStatusHidden:!self.enableShowRecodingStatus];
        [self.videoView.controlBar setShareScreenEnable:self.enableScreenSharing];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_1_DONE object:@"success"];
    } failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_1_DONE object:[error localizedDescription]];
    }];
}

-(void)getMeetingInfoById:(NSString*)meetingId withToken:(NSString*)token andUserType:(NSString*)type {
    NSMutableDictionary *dic = [self buildCommonRequestField];
    dic[@"token"] = token;
    dic[@"meeting_id"] = meetingId;
    
    NSString* requestUrl = @"";
    if (0 == type.intValue) {
        requestUrl = URL_GET_LESSON_INFO_STUDENT;
    } else if (1 == type.intValue) {
        requestUrl = URL_GET_LESSON_INFO_TEACHER;
    } else { //if (2 == type.intValue) {
        requestUrl = URL_GET_LESSON_INFO_ASSISTANT;
    }
    
    [[DMRequestModel sharedInstance]requestWithPath:requestUrl method:DMHttpRequestPost parameters:dic prepareExecute:^{
    } success:^(id responseObject) {
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        if (OBJ_IS_NIL(responseObj)) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_2_DONE object:NSLocalizedString(@"OVERLAY_MSG_UNKOWN_REASON", nil)];
            return;
        }
        
        NSString* retCode = [responseObj objectForKey:@"code"];
        NSString* retMsg = [responseObj objectForKey:@"msg"];
        if (0 != [retCode intValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_2_DONE object:retMsg];
            return;
        }
        
        NSDictionary* dataObj = [responseObj objectForKey:@"data"];
        self.signalKey = [dataObj objectForKey:@"signaling_key"];
        self.channelKey = [dataObj objectForKey:@"channel_key"];
        self.channelName = [dataObj objectForKey:@"channel_name"];
        self.channelUidMine = [dataObj objectForKey:@"uid"];
        self.channelUidStudent = [dataObj objectForKey:@"student_id"];
        self.channelUidTeacher = [dataObj objectForKey:@"teacher_id"];
        self.channelUidAssistant = [dataObj objectForKey:@"assistant_id"];
        self.lessonStartTime = [dataObj objectForKey:@"start_time"];
        self.lessonDuration = [dataObj objectForKey:@"duration"];
        self.lessonCountDown = [dataObj objectForKey:@"countdown"];
        self.lessonForceClose = [dataObj objectForKey:@"forceclose"];
        self.playVolume = [[dataObj objectForKey:@"play_volume"]integerValue];
        self.recordVolume = [[dataObj objectForKey:@"record_volume"]integerValue];
        self.audioScenario = [[dataObj objectForKey:@"audio_scenario"]integerValue];
        self.audioProfile = [[dataObj objectForKey:@"audio_profile"]integerValue];

        [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_2_DONE object:@"success"];
    } failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:DMLOGIN_STEP_2_DONE object:[error localizedDescription]];
    }];
}

-(void)getAppConfigDone:(NSNotification *)notification {
    if ([@"success" isEqualToString:notification.object]) {
        [[AppData defaultAppData]setAgoraAppId:self.agoraAppId];
        [[AppData defaultAppData]setAgoraVideoProfile:self.agoraVideoProfile];
        
        if (0 == self.updateType.intValue) {
        } else if (1 == self.updateType.intValue) {
            [self alertMsg:self.updateMsg Title:NSLocalizedString(@"ALERT_UPDATE_TITLE", nil) ButtonOk:NSLocalizedString(@"ALERT_BUTTON_OK", nil) ButtonCancel:NSLocalizedString(@"ALERT_BUTTON_CANCEL", nil) OnOk:^{
                [[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:self.updateUrl]];
            } OnCancel:^{
            }];
        } else if (2 == self.updateType.intValue) {
            [self alertMsg:self.updateMsg Title:NSLocalizedString(@"ALERT_UPDATE_TITLE", nil) ButtonOk:NSLocalizedString(@"ALERT_BUTTON_OK", nil) ButtonCancel:nil OnOk:^{
                [[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:self.updateUrl]];
                [NSApp terminate:self];
            } OnCancel:^{
            }];
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DM_HANDLE_APP_CONFIG_DONE object:@"done"];
}

-(void)handleAppConfigDone:(NSNotification *)notification {
    NSLog(@"handleAppConfigDone");
    [self initializeAgoraEngine];
    [self setupVideo];
    
    [self.loginView.cameraSelector setSelections:[self.agoraKit enumerateDevices:3]];
    [self.loginView.recordingSelector setSelections:[self.agoraKit enumerateDevices:0]];
    if (0 == self.loginView.getLessonCode.length) {
        [self.loginView setLoginStatus:LOGIN_STATUS_WAIT_LESSON_CODE];
    } else {
        //[self.loginView setLoginStatus:LOGIN_STATUS_READY];
        [self buttonLoginClicked:self];
    }
    
    self.appDataStatus = APP_DATA_STATUS_HANDLED;
}

-(void)loginStep1Done:(NSNotification *)notification {
    if ([@"success" isEqualToString:notification.object]) {
        [self getMeetingInfoById:self.meetingId withToken:self.userToken andUserType:self.userType];
    } else {
        [self startOverlay:notification.object];
        [self.loginView setLoginStatus:LOGIN_STATUS_NOT_READY];
    }
}

-(void)loginStep2Done:(NSNotification *)notification {
    if ([@"success" isEqualToString:notification.object]) {
        if (self.channelName.length  > 0 &&
            self.channelKey.length > 0 &&
            self.channelUidMine > 0 &&
            self.channelUidStudent > 0 &&
            self.channelUidTeacher > 0 &&
            self.channelUidAssistant > 0) {
            [self setupLocalVideo];
            [self joinChannel];
            self.screenShare = NO;
            [self.loginView setLoginStatus:LOGIN_STATUS_DONE];
            [self changeViewStatus:VIEW_STATUS_VIDEO];
        
            NSDate* dataNow = [[NSDate alloc]init];
            NSTimeInterval intervalSince1970 = [dataNow timeIntervalSince1970];
            if (self.lessonStartTime.doubleValue > intervalSince1970) {
                [self.videoView startCountDownUntil:self.lessonStartTime.doubleValue];
                [self.videoView setStopAction:@selector(countDownClockStopped:) withTarget:self];
                [self.videoView.videoCanvasTeacher setPlaceHolderHidden:YES];
            }
            
            double utcBegin = self.lessonStartTime.doubleValue;
            double utcRed = self.lessonStartTime.doubleValue + self.lessonDuration.doubleValue - self.lessonCountDown.doubleValue;
            double utcRedWarn = self.lessonStartTime.doubleValue + self.lessonDuration.doubleValue;
            double utcEnd = self.lessonStartTime.doubleValue + self.lessonDuration.doubleValue + self.lessonForceClose.doubleValue;
            
            [self.videoView.statusBar stopCount];
            if (1 == self.userType.intValue) {// 老师用户倒计时
                [self.videoView.statusBar startCountBegin:utcBegin Red:utcRed Warning:utcRedWarn End:utcEnd];
            } else {
                [self.videoView.statusBar startCountBegin:utcBegin Red:utcEnd Warning:utcEnd End:utcEnd];
            }
            [self.videoView.statusBar setStopAction:@selector(lessonEndReached:) withTarget:self];
        
        } else {
            [self startOverlay:NSLocalizedString(@"OVERLAY_MSG_UNEXPECTED_DATA", nil)];
            [self.loginView setLoginStatus:LOGIN_STATUS_NOT_READY];
        }
    } else {
        [self startOverlay:notification.object];
        [self.loginView setLoginStatus:LOGIN_STATUS_NOT_READY];
    }
}

#pragma mark ### Agora operate detail ###
-(void)updateUser:(NSUInteger)userId OnlineStatus:(BOOL)yesno {
    NSLog(@"updateUser %lu %d", (unsigned long)userId, yesno);
    if (userId == self.channelUidStudent.integerValue) {
        [self.videoView.videoCanvasStudent setUserOnline:yesno];
    } else if (userId == self.channelUidTeacher.integerValue) {
        [self.videoView.videoCanvasTeacher setUserOnline:yesno];
    } else if (userId == self.channelUidAssistant.integerValue) {
        [self.videoView.videoCanvasAssistant setUserOnline:yesno];
    }
}

-(NSView*)canvasViewForUser:(NSUInteger)userId {
    if (userId == self.channelUidStudent.integerValue) {
        return self.videoView.videoCanvasStudent.videoView;
    } else if (userId == self.channelUidTeacher.integerValue) {
        return self.videoView.videoCanvasTeacher.videoView;
    } else if (userId == self.channelUidAssistant.integerValue) {
        return self.videoView.videoCanvasAssistant.videoView;
    }
    return nil;
}

-(VideoCanvas*) videoCanvasForUser:(NSUInteger)userId {
    if (userId == self.channelUidStudent.integerValue) {
        return self.videoView.videoCanvasStudent;
    } else if (userId == self.channelUidTeacher.integerValue) {
        return self.videoView.videoCanvasTeacher;
    } else if (userId == self.channelUidAssistant.integerValue) {
        return self.videoView.videoCanvasAssistant;
    }
    return nil;
}

- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.agoraAppId delegate:self];
}

- (void)setupVideo {
    [self.agoraKit enableVideo];
    [self.agoraKit setVideoProfile:self.agoraVideoProfile swapWidthAndHeight:false];
}

- (void)setupLocalVideo {
    if (self.playVolume > 0) [self.agoraKit adjustPlaybackSignalVolume:100];
    if (self.recordVolume > 0) [self.agoraKit adjustRecordingSignalVolume:100];
    if (self.audioProfile > 0 && self.audioScenario > 0) [self.agoraKit setAudioProfile:4 scenario:2];
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // UID = 0 means we let Agora pick a UID for us
    
    // 0-学生，1-老师，2-管理员，3-助教
    if (USER_TYPE_STUDENT == self.userType.intValue) {
        [self.videoView.videoCanvasStudent setUserOnline:YES];
        videoCanvas.view = self.videoView.videoCanvasStudent.videoView;
    } else if (USER_TYPE_TEACHER == self.userType.intValue) {
        [self.videoView.videoCanvasTeacher setUserOnline:YES];
        videoCanvas.view = self.videoView.videoCanvasTeacher.videoView;
    } else if (USER_TYPE_ASSISTANT == self.userType.integerValue) {
        [self.videoView.videoCanvasAssistant setUserOnline:YES];
        videoCanvas.view = self.videoView.videoCanvasAssistant.videoView;
    }
    
    videoCanvas.renderMode = AgoraRtc_Render_Fit;
    [self.agoraKit setupLocalVideo:videoCanvas];
    NSLog(@"setupLocalVideo");
    // Bind local video stream to view
}

- (void)joinChannel {
    [self.agoraKit joinChannelByKey:self.channelKey channelName:self.channelName info:nil uid:self.userId.integerValue joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        [self updateUser:self.userId.integerValue OnlineStatus:YES];
    }];
    
    [[LogData defaultLogData]reportUserEnter:self.channelUidMine Reporter:self.channelUidMine MeetingId:self.meetingId Token:self.userToken];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    [[self videoCanvasForUser:[self.userId integerValue]] setVideoSize:size];
    [self.videoView invalidateViewLayout];
    NSLog(@"firstLocalVideoFrameWithSize");
}

//- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if (uid != self.channelUidStudent.intValue &&
        uid != self.channelUidTeacher.integerValue &&
        uid != self.channelUidAssistant.integerValue) {
        return;
    }

    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = [self canvasViewForUser:uid];
    videoCanvas.renderMode = AgoraRtc_Render_Fit;
    [self.agoraKit setupRemoteVideo:videoCanvas];

    [self updateUser:uid OnlineStatus:YES];
    [[self videoCanvasForUser:uid]setVideoSize:size];
    [self.videoView invalidateViewLayout];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine videoSizeChangedOfUid:(NSUInteger)uid size:(CGSize)size rotation:(NSInteger)rotation {
    if (uid != self.channelUidStudent.intValue &&
        uid != self.channelUidTeacher.integerValue &&
        uid != self.channelUidAssistant.integerValue) {
        return;
    }
    [[self videoCanvasForUser:uid]setVideoSize:size];
    [self.videoView invalidateViewLayout];
}

- (void)leaveChannel {
    [self.agoraKit leaveChannel:nil];
    [self.agoraKit setupLocalVideo:nil];
    
    [self.videoView.videoCanvasStudent setUserOnline:NO];
    [self.videoView.videoCanvasTeacher setUserOnline:NO];
    [self.videoView.videoCanvasAssistant setUserOnline:NO];
    [self.videoView invalidateViewLayout];
    //self.agoraKit = nil;
    [[LogData defaultLogData]reportUserExit:self.channelUidMine Reporter:self.channelUidMine MeetingId:self.meetingId Token:self.userToken];
}

- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    [[LogData defaultLogData]reportNetError:self.channelUidMine Reporter:self.channelUidMine MeetingId:self.meetingId Token:self.userToken];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [[LogData defaultLogData]reportUserEnter:[NSString stringWithFormat:@"%lu",uid] Reporter:self.channelUidMine MeetingId:self.meetingId Token:self.userToken];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = nil;
    videoCanvas.renderMode = AgoraRtc_Render_Fit;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    
    [self updateUser:uid OnlineStatus:NO];
    [self.videoView invalidateViewLayout];
    
    [[LogData defaultLogData]reportUserExit:[NSString stringWithFormat:@"%lu",uid] Reporter:self.channelUidMine MeetingId:self.meetingId Token:self.userToken];
}

@end
