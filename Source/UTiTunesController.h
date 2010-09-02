//
//  UTiTunesController.h
//  UrTunes
//
//  Created by MK on 01.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iTunes.h"
#import <Cocoa/Cocoa.h>


@interface UTiTunesController : NSObject {
    iTunesApplication* iTunes;
    IBOutlet NSSlider* volumeSlider;
}

- (IBAction) log:(id)sender;
- (IBAction) playPause:(id)sender;
- (IBAction) previousTrack:(id)sender;
- (IBAction) nextTrack:(id)sender;
- (IBAction) setNewITunesVolume:(id)sender;

@end
