//
//  UTiTunesController.h
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class iTunesApplication;

@interface UTiTunesController : NSObject {
    iTunesApplication* iTunes;
    IBOutlet NSTextField* trackNameLabel;
    IBOutlet NSTextField* artistNameLabel;
    IBOutlet NSSlider* volumeSlider;
    IBOutlet NSLevelIndicator* trackRating;
}

- (IBAction) playPause:(id)sender;
- (IBAction) previousTrack:(id)sender;
- (IBAction) nextTrack:(id)sender;
- (IBAction) setNewITunesVolume:(id)sender;
- (void) setVolumeSliderPosition;
- (void) updateTrackInfo;
- (void) setTrack:(NSString*) newTrackName andArtist:(NSString*) newArtistName;

@end
