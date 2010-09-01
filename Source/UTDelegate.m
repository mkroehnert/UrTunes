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
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    NSStatusItem* theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [theItem retain];
    
    [theItem setTitle: NSLocalizedString(@"UT",@"")];
    [theItem setHighlightMode:YES];
//    [theItem setMenu:theMenu];
}

@end
