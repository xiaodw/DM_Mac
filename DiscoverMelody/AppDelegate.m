//
//  AppDelegate.m
//  DiscoverMelody
//
//  Created by xiaodw on 2018/1/23.
//  Copyright © 2018年 Beijing Discover Melody co., ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DMMacros.h"
#import "DMConfig.h"
#import "DMConfigManager.h"
#import <DevMateKit/DevMateKit.h>
#import "ProductConfig.h"

@interface AppDelegate ()
@property NSSize loginSize;
@property NSSize videoSize;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)Notification {
    // Insert code here to initialize your application
    self.window = [Notification.object mainWindow];
    if (nil == self.window) {
        self.window = [[Notification.object windows]objectAtIndex:0];
        NSLog(@"### system error ### try recover... ### result:%@", self.window);
    }
    
    [self.window setDelegate:self];
#if defined(PRODUCT_TYPE_WE_EDUCATION)
    [self.window setTitle:@"WeEducation"];
#elif defined(PRODUCT_TYPE_DISCOVER_MELODY)
    [self.window setTitle:NSLocalizedString(@"WINDOW_TITLE_DISCOVER_MELODY", nil)];
#elif defined(PRODUCT_TYPE_WE_DESIGN)
    [self.window setTitle:@"WeDesign"];
#endif
    
    [DevMateKit sendTrackingReport:nil delegate:nil];
    [DevMateKit setupIssuesController:nil reportingUnhandledIssues:YES];
}

- (IBAction)showFeedbackDialog:(id)sender {
    [DevMateKit showFeedbackDialog:nil inMode:DMFeedbackDefaultMode];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [NSApp activateIgnoringOtherApps:NO];
        [self.window makeKeyAndOrderFront:self];
    }
    return YES;
}

-(void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    NSLog(@"APP-URL:%@", urls);
    
    if (nil == application.mainWindow) {
        [NSApp activateIgnoringOtherApps:NO];
        [self.window makeKeyAndOrderFront:self];
    }
    if (urls != nil && urls.count > 0 &&
        (YES == [[[urls objectAtIndex:0]absoluteString]hasPrefix:@"dism://lesson"] ||
         YES == [[[urls objectAtIndex:0]absoluteString]hasPrefix:@"wljyedu://lesson"] ||
         YES == [[[urls objectAtIndex:0]absoluteString]hasPrefix:@"wedesign://lesson"])) {
        ViewController* controller = (ViewController *)self.window.contentViewController;
        if (nil == controller) {
            controller = (ViewController *)[application mainWindow].contentViewController;
        }
        [controller handleUrls:urls];
    }
}

- (CGFloat)titleBarHeight {
    NSRect fakeWindowFram = NSMakeRect (0, 0, 100, 100);
    NSRect fakeContentFram = [NSWindow contentRectForFrameRect:fakeWindowFram styleMask:NSWindowStyleMaskTitled];
    return (fakeWindowFram.size.height - fakeContentFram.size.height);
}

-(BOOL)windowShouldClose:(NSWindow *)sender {
    ViewController* controller = (ViewController*)sender.contentViewController;
    return [controller injectWindowShouldClose:sender];
}

@end
