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

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    const pid_t iTunesProcessID = [self getITunesProcessID];
    // create iTunes controller if program is running
    // otherwise register for iTunes startup notification
    if (0 < iTunesProcessID)
    {
        [self setupITunesControllerWithPID: iTunesProcessID];
    }
    else
    {
        NSNotificationCenter* workspaceNotificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
        [workspaceNotificationCenter addObserver:self
                                        selector:@selector(handleApplicationStartupNotification:)
                                            name:NSWorkspaceDidLaunchApplicationNotification
                                          object:nil];
        [workspaceNotificationCenter addObserver:self
                                        selector:@selector(handleApplicationTerminateNotification:)
                                            name:NSWorkspaceDidTerminateApplicationNotification
                                          object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(panelWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:iTunesControlPanel];
}


- (void) createStatusMenu
{
    NSStatusBar* bar = [NSStatusBar systemStatusBar];
    
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    
    [statusItem setTitle: NSLocalizedString(@"UT",@"")];
    [statusItem setHighlightMode:YES];
    [statusItem setToolTip: @"UrTunes - Control iTunes with one Click"];
    [statusItem setMenu: statusBarMenu];
//    [statusItem setImage: [NSImage imageNamed:@"statusBarIcon"]];
//    [statusItem setAlternateImage: [NSImage imageNamed:@"statusBarIcon"]];
}


- (IBAction) quitApplication:(id)sender
{
    [NSApp terminate:nil];
}


- (IBAction) showHideITunesControlPanel:(id)sender
{
	if ([iTunesControlPanel isVisible])
    {
        [iTunesControlPanel orderOut:sender];
        [showHideMenuEntry setTitle: @"Show Controlpanel"];
    }
    else
    {
        [iTunesControlPanel orderFront:sender];
        [showHideMenuEntry setTitle: @"Hide Controlpanel"];
    }
}


- (IBAction) showPreferences:(id)sender
{
	if (![NSBundle loadNibNamed:@"Preferences" owner:self])
        NSLog(@"Error loading preferences");
}


- (pid_t) getITunesProcessID
{
    NSArray* runningApplications = [[NSWorkspace sharedWorkspace] launchedApplications];
    for (int i = 0; i < [runningApplications count]; ++i) {
        NSDictionary* currentApplication = [runningApplications objectAtIndex: i];
        if (NSOrderedSame == [[currentApplication objectForKey: @"NSApplicationBundleIdentifier"] compare: @"com.apple.iTunes"])
            return [[currentApplication objectForKey: @"NSApplicationProcessIdentifier"] intValue];
    }
    return -1;
}


- (void) registerForITunesNotifications
{
    // register for receiving iTunes notifications as described in
    // http://homepage.mac.com/simx/technonova/software_development/local_track_shared_track_or_itunes_stor.html
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(handleITunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
}


- (void) handleApplicationStartupNotification:(NSNotification *)startupNotification
{
    NSDictionary* startedApplication = [startupNotification userInfo];
    if (NSOrderedSame == [[startedApplication objectForKey: @"NSApplicationBundleIdentifier"] compare: @"com.apple.iTunes"])
    {
        const pid_t iTunesProcessID = [[startedApplication objectForKey: @"NSApplicationProcessIdentifier"] intValue];
        [self setupITunesControllerWithPID: iTunesProcessID];
    }
}


- (void) handleApplicationTerminateNotification:(NSNotification *)terminateNotification
{
    NSString* terminatedApplicationIdentifier = [[terminateNotification userInfo] objectForKey: @"NSApplicationBundleIdentifier"];
    if (NSOrderedSame == [terminatedApplicationIdentifier compare: @"com.apple.iTunes"])
    {
        [iTunesController tearDownITunesController];
    }
}


- (void) handleITunesNotification:(NSNotification *)iTunesNotification
{
    NSString* playerState = [[iTunesNotification userInfo] objectForKey: @"Player State"];
    
    // if iTunes is quitting the dictionary contains only the "Player State" key
    if (NSOrderedSame == [playerState compare: @"Stopped"] && 1 == [[iTunesNotification userInfo] count])
    {
        [iTunesController resetTrackInformation];
    }
    else
        [iTunesController updateControllerStatus];
}


- (void) panelWillClose:(NSNotification*)notification
{
	[self showHideITunesControlPanel: nil];
}


- (void) setupITunesControllerWithPID:(pid_t)iTunesProcessID
{
    [self registerForITunesNotifications];
    [iTunesController createITunesControllerWithPID: iTunesProcessID];
    [iTunesController updateControllerStatus];
}

@end
