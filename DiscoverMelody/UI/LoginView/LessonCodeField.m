//
//  LessonCodeField.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/31.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "LessonCodeField.h"
#import <Masonry.h>

@implementation LessonCodeField

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
    //[self.layer setBorderWidth:1.0f];
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    [self.layer setBackgroundColor:[NSColor whiteColor].CGColor];

    self.textFieldCode = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 64, 64)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LOGIN_VIEW_TEXT_FIELD_CODE_PLACEHOLDER", nil) attributes:
                                      @{NSForegroundColorAttributeName:[NSColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f],
                                        NSFontAttributeName:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_20_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_20_SIZE", nil).intValue],
                                            NSParagraphStyleAttributeName:paragraphStyle
                                        }];
    [self.textFieldCode setPlaceholderAttributedString:attrString];
    [self.textFieldCode setTextColor:[NSColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f]];
    [self.textFieldCode setStringValue:@""]; // bf3a0d4d7d4c566b
    [self.textFieldCode setAlignment:NSTextAlignmentCenter];
    [self.textFieldCode setFont:[NSFont fontWithName:NSLocalizedString(@"GLOBAL_FONT_20_NAME", nil) size:NSLocalizedString(@"GLOBAL_FONT_20_SIZE", nil).intValue]];
    [self.textFieldCode setBordered:NO];
    [[self.textFieldCode cell]setBordered:NO];
    [[self.textFieldCode cell]setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self.textFieldCode setFocusRingType:NSFocusRingTypeNone];
    self.textFieldCode.refusesFirstResponder = YES;
    
    //[self.textFieldCode setWantsLayer:YES];
    //[self.textFieldCode setBackgroundColor:[[NSColor whiteColor]colorWithAlphaComponent:0.013]];
    //[self.textFieldCode.layer setBorderWidth:0.5f];
    //[self.textFieldCode.layer setBorderColor:[NSColor whiteColor].CGColor];
    //self.textFieldCode.layer.masksToBounds = YES;
    //self.textFieldCode.layer.cornerRadius = 0.8f;
    //[[self.textFieldCode cell] setBezeled:NO];
    //[[self.textFieldCode cell] setBordered:NO];
    [self addSubview:self.textFieldCode];
}

-(void)layoutSubViews {
    [self.textFieldCode mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY).with.offset(-19);
        make.left.mas_equalTo(self).with.offset(24);
        make.right.mas_equalTo(self).with.offset(-24);
        make.bottom.mas_equalTo(self.mas_centerY).with.offset(17);
    }];
}


@end
