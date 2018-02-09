//
//  ColorButton.h
//  DiscoverMelody
//
//  Created by xiaodw on 2018/2/1.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorButton : NSControl
@property (strong,nonatomic)IBInspectable NSString* textString;
@property (strong,nonatomic)IBInspectable NSFont* textFont;
@property (strong,nonatomic)IBInspectable NSColor* textColor;
@property (strong,nonatomic)IBInspectable NSColor* backgroudColor;
@property (nonatomic)IBInspectable NSTextAlignment textAlignment;
@property (nonatomic) NSAttributedString* displayString;
@end
