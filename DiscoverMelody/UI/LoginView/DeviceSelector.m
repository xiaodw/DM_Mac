//
//  DeviceSelector.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/30.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "DeviceSelector.h"
#import <Masonry.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface DeviceSelector()
@property (strong,nonatomic) NSTextField* textFieldLable;
@property (strong,nonatomic) NSView* viewSplitLine;
@property (strong,nonatomic) NSPopUpButton* popupButtonSelection;
@property (strong,nonatomic) NSArray* arraySelections;
@end

@implementation DeviceSelector

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setupSubViews];
        [self layoutSubViews];
    }
    return self;
}

-(void)setupSubViews {
    [self setWantsLayer:YES];
    //[self.layer setBorderColor:[NSColor whiteColor].CGColor];
    //[self.layer setBorderWidth:0.3f];
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    [self.layer setBackgroundColor:[NSColor colorWithRed:1.f green:1.f blue:1.f alpha:0.4f].CGColor];
    
    self.textFieldLable = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.textFieldLable setEditable:NO];
    [self.textFieldLable setSelectable:NO];
    [self.textFieldLable setBordered:NO];
    [self.textFieldLable setTextColor:[NSColor controlTextColor]];
    [self.textFieldLable setAlignment:NSLocalizedString(@"DEVICE_SELECTOR_LABEL_TEXT_ALIGNMENT", nil).intValue];
    NSLog(@"%lu", (unsigned long)NSTextAlignmentLeft);
    [self.textFieldLable setBackgroundColor:[NSColor controlColor]];
    [self.textFieldLable setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_14T_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_14T_SIZE", nil).intValue]];
    //[self.textFieldLable setTextColor:[NSColor whiteColor]];
    [self addSubview:self.textFieldLable];
    
    self.viewSplitLine = [[NSView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.viewSplitLine setWantsLayer:YES];
    [self.viewSplitLine.layer setBackgroundColor:[NSColor colorWithRed:1.f green:1.f blue:1.f alpha:0.2f].CGColor];
    [self addSubview:self.viewSplitLine];
    
    self.popupButtonSelection = [[NSPopUpButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.popupButtonSelection setBordered:NO];
    [self.popupButtonSelection setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_16R_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_16R_SIZE", nil).intValue]];
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_18_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_18_SIZE", nil).intValue],
                            NSFontAttributeName,
                            [NSColor whiteColor], NSForegroundColorAttributeName,
                            paragraphStyle, NSParagraphStyleAttributeName,
                            nil];
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LOGIN_VIEW_BUTTON_JOIN", nil) attributes:attrs];
    [self.popupButtonSelection setAttributedTitle:attributedString];
    //self.popupButtonSelection.attributedTitle = attributedString;
    NSLog(@"xxxx%@",  self.popupButtonSelection.attributeKeys);
    NSLog(@"xxxx%@", self.popupButtonSelection.menu.attributeKeys);
    */
    [self addSubview:self.popupButtonSelection];
}

-(void)layoutSubViews {
    [self.textFieldLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-15);
        make.left.mas_equalTo(self).with.offset(10);
        make.width.mas_equalTo(NSLocalizedString(@"DEVICE_SELECTOR_LABEL_WIDTH", nil).intValue);
        make.height.mas_equalTo(22);
    }];
    
    [self.viewSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).with.offset(NSLocalizedString(@"DEVICE_SELECTOR_SPLITLINE_OFFSET", nil).intValue);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self);
    }];
    
    [self.popupButtonSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).with.offset(-22);
        make.left.mas_equalTo(self).with.offset(NSLocalizedString(@"DEVICE_SELECTOR_POPUPBUTTON_LEFT_OFFSET", nil).intValue);
        make.right.mas_equalTo(self.mas_right).with.offset(-16);
        make.bottom.mas_equalTo(self.mas_centerY).with.offset(18);
    }];
}

-(void)setLabel:(NSString*)text {
    [self.textFieldLable setStringValue:text];
}

-(void)setSelections:(NSArray*)selections {
    self.arraySelections = [[NSArray alloc]initWithArray:selections];
    for (id device in self.arraySelections) {
        //self.popupButtonSelection addItemsWithTitles:<#(nonnull NSArray<NSString *> *)#>
        [self.popupButtonSelection addItemWithTitle:([device deviceName])];
    }
}

-(NSString*)getSelect {
    return [self.arraySelections[self.popupButtonSelection.indexOfSelectedItem] deviceId];
}

-(void)setEnable:(BOOL)enabled {
    [self.popupButtonSelection setEnabled:enabled];
}

@end
