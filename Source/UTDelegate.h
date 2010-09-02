//
//  UTDelegate.h
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UTiTunesController;

@interface UTDelegate : NSObject
{
    NSStatusItem* statusItem;
    IBOutlet UTiTunesController* iTunesController;
}

- (void) createStatusMenu;
- (void) statusBarAction;
- (void) handleITunesNotification:(NSNotification *)iTunesNotification;

@end
