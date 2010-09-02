/*
 * Copyright 2010 Manfred Kroehnert <mkroehnert@users.sourceforge.net>
 *
 * UrTunes is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * UrTunes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with UrTunes.  If not, see <http://www.gnu.org/licenses/>.
 */

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
