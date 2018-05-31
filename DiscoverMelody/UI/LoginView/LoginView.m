//
//  LoginView.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/26.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "LoginView.h"
#import <Masonry.h>
#import "LessonCodeField.h"
#import "ColorButton.h"
#import "ProductConfig.h"

@interface LoginView()
@property (strong,nonatomic)NSImageView* imageViewBackgroud;
@property (strong,nonatomic)NSImageView* imageViewLogo;
@property (strong,nonatomic)LessonCodeField* lessonCodeField;
@property (strong,nonatomic)NSProgressIndicator* loadingAnimater;
@property (strong,nonatomic)ColorButton* buttonJoin;
@property (strong,nonatomic)NSTextField* textFieldVersion;
@end

@implementation LoginView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)setupSubViews {
    self.imageViewBackgroud = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
#if defined(PRODUCT_TYPE_WE_EDUCATION)
    [self.imageViewBackgroud setImage:[NSImage imageNamed:@"login_bg_we_education"]];
#elif defined(PRODUCT_TYPE_DISCOVER_MELODY)
    [self.imageViewBackgroud setImage:[NSImage imageNamed:@"login_bg_discover_melody"]];
#elif defined(PRODUCT_TYPE_WE_DESIGN)
    [self.imageViewBackgroud setImage:[NSImage imageNamed:@"login_bg_wedesign"]];
#endif
    [self.imageViewBackgroud setImageScaling:YES];
    [self addSubview:self.imageViewBackgroud];
    
    self.imageViewLogo = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
#if defined(PRODUCT_TYPE_WE_EDUCATION)
    [self.imageViewLogo setImage:[NSImage imageNamed:@"login_logo_we_education"]];
#elif defined(PRODUCT_TYPE_DISCOVER_MELODY)
    [self.imageViewLogo setImage:[NSImage imageNamed:NSLocalizedString(@"LOGIN_VIEW_LOGO_IMG_NAME_DISCOVER_MELODY", nil)]];
#elif defined(PRODUCT_TYPE_WE_DESIGN)
    [self.imageViewLogo setImage:[NSImage imageNamed:@"login_logo-we_design"]];
#endif
    [self.imageViewLogo setImageScaling:YES];
    [self addSubview:self.imageViewLogo];

    self.lessonCodeField = [[LessonCodeField alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [self.lessonCodeField.textFieldCode.window makeFirstResponder:nil];
    [self addSubview:self.lessonCodeField];
    
    self.cameraSelector = [[DeviceSelector alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [self.cameraSelector setLabel:NSLocalizedString(@"LOGIN_VIEW_CAMERA_SELECTOR_LABLE", nil)];
    [self addSubview:self.cameraSelector];
    
    self.recordingSelector = [[DeviceSelector alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [self.recordingSelector setLabel:NSLocalizedString(@"LOGIN_VIEW_MICROPHONE_SELECTOR_LABLE", nil)];
    [self addSubview:self.recordingSelector];
    
    self.buttonJoin = [[ColorButton alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_18R_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_18R_SIZE", nil).intValue],
                            NSFontAttributeName,
                            [NSColor whiteColor], NSForegroundColorAttributeName,
                            paragraphStyle, NSParagraphStyleAttributeName,
                            nil];
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LOGIN_VIEW_BUTTON_JOIN", nil) attributes:attrs];
    self.buttonJoin.displayString = attributedString;
    [self.buttonJoin setEnabled:NO];
    [self addSubview:self.buttonJoin];
    
    self.loadingAnimater = [[NSProgressIndicator alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [self.loadingAnimater setDisplayedWhenStopped:NO];
    [self.loadingAnimater setUsesThreadedAnimation:YES];
    [self.loadingAnimater setStyle:NSProgressIndicatorSpinningStyle];
    [self addSubview:self.loadingAnimater];
    
    self.textFieldVersion = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [self.textFieldVersion setStringValue:
     [NSString stringWithFormat:NSLocalizedString(@"LOGIN_VIEW_VERSION_PREFIX", nil), [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]]
    ];
    [self.textFieldVersion setEditable:NO];
    [self.textFieldVersion setSelectable:NO];
    [self.textFieldVersion setBordered:NO];
    [self.textFieldVersion setTextColor:[NSColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.f]];
    [self.textFieldVersion setAlignment:NSTextAlignmentCenter];
    [self.textFieldVersion setBackgroundColor:[NSColor controlColor]];
    [self.textFieldVersion setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_14_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_14_SIZE", nil).intValue]];
    [self addSubview:self.textFieldVersion];
}

- (void)textDidChange:(NSNotification *)notification {
    if ([notification.object isEqual:self.lessonCodeField.textFieldCode]) {
        if (0 == self.lessonCodeField.textFieldCode.stringValue.length) {
            if (YES == self.buttonJoin.isEnabled) {
                [self.buttonJoin setEnabled:NO];
            }
        } else {
            NSString* lessonCode = self.lessonCodeField.textFieldCode.stringValue;
            NSString* ripeCode = [lessonCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            ripeCode = [ripeCode stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            ripeCode = [ripeCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if (![ripeCode isEqualToString:lessonCode]) {
                self.lessonCodeField.textFieldCode.stringValue = ripeCode;
            }
            
            if ([ripeCode length] > 0) {
                if (NO == self.buttonJoin.isEnabled) {
                    [self.buttonJoin setEnabled:YES];
                }
            } else {
                if (YES == self.buttonJoin.isEnabled) {
                    [self.buttonJoin setEnabled:NO];
                }
            }
        }
    }
}

-(void)layoutSubViews {
    [self.imageViewBackgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.lessonCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-50);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    [self.imageViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        __block int logoWidth = NSLocalizedString(@"LOGIN_VIEW_LOGO_IMG_WIDTH",nil).intValue;
        __block int logoHeight = NSLocalizedString(@"LOGIN_VIEW_LOGO_IMG_HEIGHT",nil).intValue;
        __block int logoAboveOffset = NSLocalizedString(@"LOGIN_VIEW_LOGO_OFFSET_ABOVE_CODE_TEXT_FIELD",nil).intValue;
        make.top.mas_equalTo(self.lessonCodeField.mas_top).with.offset(-(logoAboveOffset + logoHeight));
        make.left.mas_equalTo(self.mas_centerX).with.offset(-(logoWidth / 2));
        make.width.mas_equalTo(logoWidth);
        make.height.mas_equalTo(logoHeight);
    }];
    
    [self.cameraSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lessonCodeField.mas_bottom).with.offset(26);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    [self.recordingSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cameraSelector.mas_bottom).with.offset(14);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    
    [self.buttonJoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordingSelector.mas_bottom).with.offset(58);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(166);
        make.height.mas_equalTo(55);
    }];
    
    [self.loadingAnimater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonJoin.mas_centerY).with.offset(-28);
        make.left.mas_equalTo(self.buttonJoin.mas_centerX).with.offset(-28);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.textFieldVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-45);
        make.left.mas_equalTo(self.mas_centerX).with.offset(-80);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(25);
    }];
}

-(NSString*)getLessonCode {
    return self.lessonCodeField.textFieldCode.stringValue;
}

-(void)setLatestLessonCode:(NSString*)code {
    [self.lessonCodeField.textFieldCode setStringValue:code];
}

-(void)setLoginAction:(SEL)action withTarget:(id)target{
    [self.buttonJoin setAction:action];
}

-(void)setLoginStatus:(enum LOGIN_STATUS)status {
    if (LOGIN_STATUS_NOT_READY == status) {
        [self.loadingAnimater stopAnimation:self];
        [self.buttonJoin setEnabled:NO];
        [self.cameraSelector setEnable:NO];
        [self.recordingSelector setEnable:NO];
        [self.lessonCodeField.textFieldCode setEnabled:NO];
    } else if (LOGIN_STATUS_WAIT_LESSON_CODE == status) {
        [self.loadingAnimater stopAnimation:self];
        [self.buttonJoin setEnabled:NO];
        [self.cameraSelector setEnable:YES];
        [self.recordingSelector setEnable:YES];
        [self.lessonCodeField.textFieldCode setEnabled:YES];
    } else if (LOGIN_STATUS_DOING == status) {
        [self.loadingAnimater startAnimation:self];
        [self.buttonJoin setEnabled:NO];
        [self.cameraSelector setEnable:NO];
        [self.recordingSelector setEnable:NO];
        [self.lessonCodeField.textFieldCode setEnabled:NO];
    } else {
        [self.loadingAnimater stopAnimation:self];
        [self.buttonJoin setEnabled:YES];
        [self.cameraSelector setEnable:YES];
        [self.recordingSelector setEnable:YES];
        [self.lessonCodeField.textFieldCode setEnabled:YES];
    }
}

@end
