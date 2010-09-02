//
//  UTiTunesController.m
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UTiTunesController.h"
#import "iTunes.h"


@implementation UTiTunesController

- (id) init
{
    self = [super init];
    if (self)
        iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    return self;
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

- (IBAction) nextTrack:(id)sender
{
    if (![iTunes isRunning])
        return;
    [iTunes nextTrack];
}

- (IBAction) setNewITunesVolume:(id)sender
{
    if (![iTunes isRunning])
        return;
    [iTunes setSoundVolume: [volumeSlider integerValue]];
}

- (void) setVolumeSliderPosition
{
    if ([iTunes isRunning])
        [volumeSlider setIntegerValue: [iTunes soundVolume]];

}

- (void) setTrack:(NSString*) newTrackName andArtist:(NSString*) newArtistName
{
	[trackNameLabel setStringValue: newTrackName];
    [artistNameLabel setStringValue: newArtistName];
}


@end
