//
//  UTiTunesController.m
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UTiTunesController.h"


@implementation UTiTunesController

- (id) init
{
    self = [super init];
    if (self)
        iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    return self;
}

- (IBAction) log:(id)sender
{    
    if ( [iTunes isRunning] ) {
        if (iTunesEPlSPlaying == [iTunes playerState])
            NSLog(@"Current song is %@", [[iTunes currentTrack] name]);
        else
            NSLog(@"iTunes is currently not playing");
    }
    else
        NSLog(@"No iTunes Running");
}

- (IBAction) playPause:(id)sender
{
    if (![iTunes isRunning])
        return;
    [iTunes playpause];
}

- (IBAction) previousTrack:(id)sender
{
    if (![iTunes isRunning])
        return;
    [iTunes previousTrack];
}

@end
