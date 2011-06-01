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

+ (void) initialize
{
    NSDictionary* initialValuesDict = [NSDictionary dictionaryWithObject: [NSNumber numberWithBool:YES] forKey: @"showPanelOnStartup"];
    // Set the initial values
    [[NSUserDefaults standardUserDefaults] registerDefaults:initialValuesDict];
}


- (void) setControllerVisible:(BOOL)newStatus
{
	controllerVisible = newStatus;
}


- (void) setShowHideString:(NSString*) newString
{
	[showHideString autorelease];
    showHideString = [newString retain];
}


- (void) setShowHideStringTo:(BOOL)showPanel
{
    // if the panel is shown the entry must be named hide and the other way around
    NSString* entryString = @"Show Controlpanel";
	if (showPanel)
        entryString = @"Hide Controlpanel";

    [self setShowHideString: entryString];
}


-(void) awakeFromNib
{
    EventHotKeyRef globalHotkeyRef;
    EventHotKeyID globalHotkeyID;
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    
    InstallApplicationEventHandler(&UrTunesHotkeyHandler, 1, &eventType, iTunesController, NULL);
        
    UInt32 spacebarRefNumber = 49;
    UInt32 rightArrowRefNumber = 124;
    UInt32 leftArrowRefNumber = 123;
    UInt32 modifierKeymask = cmdKey | controlKey;
    
    globalHotkeyID.signature = 'play';
    globalHotkeyID.id = UT_PLAY;
    RegisterEventHotKey(spacebarRefNumber, modifierKeymask, globalHotkeyID,
                        GetApplicationEventTarget(), 0, &globalHotkeyRef);
    globalHotkeyID.signature = 'next';
    globalHotkeyID.id = UT_NEXT;
    RegisterEventHotKey(rightArrowRefNumber, modifierKeymask, globalHotkeyID,
                        GetApplicationEventTarget(), 0, &globalHotkeyRef);
    globalHotkeyID.signature = 'prev';
    globalHotkeyID.id = UT_PREV;
    RegisterEventHotKey(leftArrowRefNumber, modifierKeymask, globalHotkeyID,
                        GetApplicationEventTarget(), 0, &globalHotkeyRef);
}


- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
    BOOL panelVisible = [[NSUserDefaults standardUserDefaults] boolForKey:@"showPanelOnStartup"];
    [self setControllerVisible: panelVisible];
    [self setShowHideStringTo: panelVisible];
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
    BOOL panelVisible = ![iTunesControlPanel isVisible];
    [self setControllerVisible: panelVisible];
    [self setShowHideStringTo: panelVisible];
}


- (IBAction) showPreferences:(id)sender
{
	if (![NSBundle loadNibNamed:@"Preferences" owner:self])
        NSLog(@"Error loading preferences");
}


- (IBAction) reportBug:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://github.com/mkroehnert/UrTunes/issues"]];
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

OSStatus UrTunesHotkeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void* userData)
{
    if (NULL == userData)
        return noErr;

    UTiTunesController* controller = (UTiTunesController*) userData;

    EventHotKeyID hotkeyID;
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL,
                      sizeof(hotkeyID), NULL, &hotkeyID);
    UInt32 selectedKey = hotkeyID.id;

    switch (selectedKey) {
        case UT_PLAY:
            [controller playPause: nil];
            break;
        case UT_NEXT:
            [controller nextTrack: nil];
            break;
        case UT_PREV:
            [controller previousTrack: nil];
            break;
    }
    return noErr;
}
