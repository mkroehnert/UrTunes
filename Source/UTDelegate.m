//
//  UTDelegate.m
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UTiTunesController.h"
#import "UTDelegate.h"


@implementation UTDelegate

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
    [self createStatusMenu];
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [iTunesController setVolumeSliderPosition];
    [iTunesController updateTrackInfo];
    [iTunesController updateRating];
    // register for receiving iTunes notifications as described in
    // http://homepage.mac.com/simx/technonova/software_development/local_track_shared_track_or_itunes_stor.html
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(handleITunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
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

- (void) handleITunesNotification:(NSNotification *)iTunesNotification
{
    [iTunesController setVolumeSliderPosition];
    [iTunesController updateTrackInfo];
    [iTunesController updateRating];
}


@end
