//
//  UTDelegate.m
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UTDelegate.h"


@implementation UTDelegate

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
    [self createStatusMenu];
}

- (void) createStatusMenu
{
    NSStatusBar* bar = [NSStatusBar systemStatusBar];
    
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    
    [statusItem setTitle: NSLocalizedString(@"UT",@"")];
    [statusItem setHighlightMode:YES];
    [statusItem setTarget: self];
    [statusItem setAction: @selector(statusBarAction)];
    [statusItem setToolTip: @"UrTunes - Control iTunes with one Click"];
//    [statusItem setImage: [NSImage imageNamed:@"statusBarIcon"]];
//    [statusItem setAlternateImage: [NSImage imageNamed:@"statusBarIcon"]];
//    [statusItem setMenu: theMenu];
}

- (void) statusBarAction
{
    NSLog(@"StatusBar clicked!");
    [NSApp terminate:nil];
}

@end
