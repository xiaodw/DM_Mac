//
//  DeviceSelectionViewController.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/30.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "DeviceSelectionViewController.h"
#import <Masonry.h>

@interface DeviceSelectionViewController ()
@property (strong,nonatomic) NSTextField* labelTitle;
@property (strong,nonatomic) NSTextField* labelMicrophone;
@property (strong,nonatomic) NSTextField* labelSpeaker;
@property (strong,nonatomic) NSTextField* labelCamera;
@property (strong,nonatomic) NSPopUpButton *microphoneSelection;
@property (strong,nonatomic) NSPopUpButton *speakerSelection;
@property (strong,nonatomic) NSPopUpButton *cameraSelection;
@property (strong,nonatomic) NSButton *buttonConfirm;

@property (strong,nonatomic) NSArray* connectedRecordingDevices;
@property (strong,nonatomic) NSArray* connectedPlaybackDevices;
@property (strong,nonatomic) NSArray* connectedVideoCaptureDevices;

@end

@implementation DeviceSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupSubViews];
    [self layoutSubViews];
    [self loadDevicesInPopUpButtons];
}

-(void)setupSubViews {
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[NSColor grayColor].CGColor];
    
    NSFont* font =  [NSFont systemFontOfSize:24];
    
    self.labelTitle = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.labelTitle setStringValue:NSLocalizedString(@"SELECT_DEVICE_VIEW_LABEL_TITLE", nil)];
    [self.labelTitle setEditable:NO];
    [self.labelTitle setSelectable:NO];
    [self.labelTitle setBordered:NO];
    [self.labelTitle setTextColor:[NSColor controlTextColor]];
    [self.labelTitle setBackgroundColor:[NSColor controlColor]];
    [self.labelTitle setFont:font];
    [self.labelTitle setTextColor:[NSColor systemBlueColor]];
    [self.view addSubview:self.labelTitle];
    
    self.labelMicrophone = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.labelMicrophone setStringValue:NSLocalizedString(@"SELECT_DEVICE_VIEW_LABEL_MICROPHONE", nil)];
    [self.labelMicrophone setEditable:NO];
    [self.labelMicrophone setSelectable:NO];
    [self.labelMicrophone setBordered:NO];
    [self.labelMicrophone setTextColor:[NSColor controlTextColor]];
    [self.labelMicrophone setBackgroundColor:[NSColor controlColor]];
    [self.view addSubview:self.labelMicrophone];
    
    self.labelSpeaker = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.labelSpeaker setStringValue:NSLocalizedString(@"SELECT_DEVICE_VIEW_LABEL_SPEAKER", nil)];
    [self.labelSpeaker setEditable:NO];
    [self.labelSpeaker setSelectable:NO];
    [self.labelSpeaker setBordered:NO];
    [self.labelSpeaker setTextColor:[NSColor controlTextColor]];
    [self.labelSpeaker setBackgroundColor:[NSColor controlColor]];
    [self.view addSubview:self.labelSpeaker];
    
    self.labelCamera = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.labelCamera setStringValue:NSLocalizedString(@"SELECT_DEVICE_VIEW_LABEL_CAMERA", nil)];
    [self.labelCamera setEditable:NO];
    [self.labelCamera setSelectable:NO];
    [self.labelCamera setBordered:NO];
    [self.labelCamera setTextColor:[NSColor controlTextColor]];
    [self.labelCamera setBackgroundColor:[NSColor controlColor]];
    [self.view addSubview:self.labelCamera];

    self.microphoneSelection = [[NSPopUpButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.view addSubview:self.microphoneSelection];
  
    self.speakerSelection = [[NSPopUpButton alloc]initWithFrame:CGRectMake(64, 0, 64, 64)];
    [self.view addSubview:self.speakerSelection];
    
    self.cameraSelection = [[NSPopUpButton alloc]initWithFrame:CGRectMake(64, 0, 64, 64)];
    [self.cameraSelection setBordered:NO];
    [self.cameraSelection setFont:[NSFont systemFontOfSize:16]];
    [self.view addSubview:self.cameraSelection];
    
    self.buttonConfirm = [[NSButton alloc]initWithFrame:CGRectMake(64, 0, 64, 64)];
    [self.buttonConfirm setButtonType:NSButtonTypeMomentaryPushIn];
    [self.buttonConfirm setBezelStyle:NSRoundedBezelStyle];
    [self.buttonConfirm setTitle:NSLocalizedString(@"SELECT_DEVICE_VIEW_BUTTON_CONFIRM", nil)];
    [self.buttonConfirm setAction:@selector(didClickConfirmButton:)];
    [self.view addSubview:self.buttonConfirm];
}

-(void)layoutSubViews {
    __block int offsetX = 80;
    __block int offsetY = 15;
    __block int intervalX = 5;
    __block int controlWidth = 60;
    __block int controlHeight = 24;
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(2*offsetY);
        make.left.mas_equalTo(self.view.mas_centerX).with.offset(-(2*controlWidth));
        make.width.mas_equalTo(4*controlWidth);
        make.height.mas_equalTo(controlHeight + 6);
    }];
    
    [self.labelMicrophone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelTitle.mas_bottom).with.offset(2*offsetY);
        make.left.mas_equalTo(self.view.mas_left).with.offset(offsetX);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.labelSpeaker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelMicrophone.mas_bottom).with.offset(offsetY);
        make.left.mas_equalTo(self.view.mas_left).with.offset(offsetX);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.labelCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelSpeaker.mas_bottom).with.offset(offsetY);
        make.left.mas_equalTo(self.view.mas_left).with.offset(offsetX);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.microphoneSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelMicrophone).with.offset(-2);
        make.left.mas_equalTo(self.labelMicrophone.mas_right).with.offset(intervalX);
        make.right.mas_equalTo(self.view).with.offset(-offsetX);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.speakerSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelSpeaker).with.offset(-2);
        make.left.mas_equalTo(self.labelSpeaker.mas_right).with.offset(intervalX);
        make.right.mas_equalTo(self.view).with.offset(-offsetX);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.cameraSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelCamera).with.offset(-2);
        make.left.mas_equalTo(self.labelCamera.mas_right).with.offset(intervalX);
        make.right.mas_equalTo(self.view).with.offset(-offsetX);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.buttonConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cameraSelection.mas_bottom).with.offset(2*offsetY);
        make.left.mas_equalTo(self.view.mas_centerX).with.offset(-40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(controlHeight);
    }];
}

- (void)loadDevicesInPopUpButtons {
    [self.microphoneSelection removeAllItems];
    [self.speakerSelection removeAllItems];
    [self.cameraSelection removeAllItems];
    
    self.connectedRecordingDevices = [self.agoraKit enumerateDevices:0];
    for (id device in self.connectedRecordingDevices) {
        [self.microphoneSelection addItemWithTitle:([device deviceName])];
    }
    
    //[[self.microphoneSelection.menu itemAtIndex:0]setImage:[NSImage imageNamed:@"screenShareButtonSelected"]];
    
    self.connectedPlaybackDevices = [self.agoraKit enumerateDevices:1];
    for (id device in self.connectedPlaybackDevices) {
        [self.speakerSelection addItemWithTitle:([device deviceName])];
    }
    
    self.connectedVideoCaptureDevices = [self.agoraKit enumerateDevices:3];
    for (id device in self.connectedVideoCaptureDevices) {
        [self.cameraSelection addItemWithTitle:([device deviceName])];
        // Populate the NSPopUpButtons with the enumerated device list
    }
}

-(void)rtcEngine:(AgoraRtcEngineKit *)engine device:(NSString * _Nonnull)deviceId type:(AgoraMediaDeviceType)deviceType stateChanged:(NSInteger)state {
    [self loadDevicesInPopUpButtons];
}

- (void)didClickConfirmButton:(NSButton *)button {
    [self.agoraKit setDevice:0 deviceId:[self.connectedRecordingDevices[self.microphoneSelection.indexOfSelectedItem] deviceId]];
    [self.agoraKit setDevice:1 deviceId:[self.connectedPlaybackDevices[self.speakerSelection.indexOfSelectedItem] deviceId]];
    [self.agoraKit setDevice:3 deviceId:[self.connectedVideoCaptureDevices[self.cameraSelection.indexOfSelectedItem] deviceId]];
    // Set the devices
    [self dismissViewController:self];
}

@end
