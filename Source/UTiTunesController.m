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
#import "iTunes.h"


@implementation UTiTunesController

- (id) init
{
    self = [super init];
    if (self)
        iTunes = nil;

    return self;
}


- (IBAction) playPause:(id)sender
{
    if (![iTunes isRunning])
        return;
    [self updatePlayPauseTitle];

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


- (void) updatePlayPauseTitle
{
    NSString* titleString = @"Play";
    if (iTunesEPlSPlaying == [iTunes playerState])
        titleString = @"Pause";
    
    [playPauseMenuItem setTitle: titleString];
    [playPauseButton setTitle: titleString];
}


- (void) createITunesControllerWithPID:(pid_t)pid
{
	iTunes = [SBApplication applicationWithProcessIdentifier: pid];
}


- (void) tearDownITunesController
{
	iTunes = nil;
    [self resetTrackInformation];
}


- (void) resetTrackInformation
{
    [self setTrack:@"Trackname" andArtist:@"Artistname"];
}


- (void) updateVolumeSliderPosition
{
    if ([iTunes isRunning])
        [volumeSlider setIntegerValue: [iTunes soundVolume]];

}

- (void) updateTrackInfo
{
    [self setTrack: [[iTunes currentTrack] name] andArtist: [[iTunes currentTrack] artist]];
}


- (void) setTrack:(NSString*) newTrackName andArtist:(NSString*) newArtistName
{
	[trackNameLabel setStringValue: newTrackName];
    [artistNameLabel setStringValue: newArtistName];
}

- (void) updateRating
{
	[trackRating setIntegerValue: [[iTunes currentTrack] albumRating]];
}

- (void) updateControllerStatus
{
    [self updateVolumeSliderPosition];
    // omit apple script error if no track is currently selected
    if (![[iTunes currentTrack] exists])
    {
        [self resetTrackInformation];
        return;
    }
    [self updateTrackInfo];
    [self updateRating];
    [self updatePlayPauseTitle];
}

@end
