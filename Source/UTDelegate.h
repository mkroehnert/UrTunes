/*
 * Copyright 2010, 2011 Manfred Kroehnert <mkroehnert@users.sourceforge.net>
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

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class UTiTunesController;

typedef enum {
    UT_PLAY = 1,
    UT_NEXT = 2,
    UT_PREV = 3
} UTHotkey;

@interface UTDelegate : NSObject
{
    NSStatusItem* statusItem;
    IBOutlet NSMenu* statusBarMenu;
    IBOutlet NSPanel* iTunesControlPanel;
    IBOutlet UTiTunesController* iTunesController;
    BOOL controllerVisible;
    NSString* showHideString;
}

- (void) setControllerVisible:(BOOL)newStatus;
- (void) setShowHideString:(NSString*) newString;
- (void) setShowHideStringTo:(BOOL)showPanel;
- (void) createStatusMenu;
- (IBAction) quitApplication:(id)sender;
- (IBAction) showHideITunesControlPanel:(id)sender;
- (IBAction) showPreferences:(id)sender;
- (IBAction) reportBug:(id)sender;
- (pid_t) getITunesProcessID;
- (void) registerForITunesNotifications;
- (void) handleApplicationStartupNotification:(NSNotification *)startupNotification;
- (void) handleApplicationTerminateNotification:(NSNotification *)terminateNotification;
- (void) handleITunesNotification:(NSNotification *)iTunesNotification;
- (void) panelWillClose:(NSNotification*)notification;
- (void) setupITunesControllerWithPID:(pid_t)iTunesProcessID;

@end

OSStatus UrTunesHotkeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void* userData);
