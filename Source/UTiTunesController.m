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
    {
        iTunes = nil;
        playPauseString = @"Play";
    }

    return self;
}


- (void) setITunesVolume:(NSInteger)newVolume
{
	iTunesVolume = newVolume;
}


- (void) setITunesTrackName:(NSString*)newTrackName
{
	[iTunesTrackName autorelease];
    iTunesTrackName = [newTrackName retain];
}


- (void) setITunesArtistName:(NSString*)newArtistName
{
	[iTunesArtistName autorelease];
    iTunesArtistName = [newArtistName retain];
}


- (void) setITunesTrackRating:(NSInteger)newRating
{
    iTunesTrackRating = newRating;
}


- (void) setITunesAlbumArt:(NSImage*)newAlbumArt
{
	[iTunesAlbumArt autorelease];
    iTunesAlbumArt = [newAlbumArt copy];
}


- (void) setPlayPauseString:(NSString*)newString
{
	[playPauseString autorelease];
    playPauseString = [newString retain];
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
    iTunesVolume = [volumeSlider integerValue];
    [iTunes setSoundVolume: iTunesVolume];
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
    [albumArtView setImage: nil];
    [trackRating setIntegerValue: 3];
}


- (void) updateVolumeSliderPosition
{
    if (![iTunes isRunning])
        return;
    iTunesVolume = [iTunes soundVolume];
    [volumeSlider setIntegerValue: iTunesVolume];
}


- (void) updateTrackInfo
{
    if (![iTunes isRunning])
        return;
    iTunesTrackName = [[iTunes currentTrack] name];
    iTunesArtistName = [[iTunes currentTrack] artist];
    [self setTrack: iTunesTrackName andArtist: iTunesArtistName];
}


- (void) setTrack:(NSString*) newTrackName andArtist:(NSString*) newArtistName
{
	[trackNameLabel setStringValue: newTrackName];
    [artistNameLabel setStringValue: newArtistName];
}


- (void) updateRating
{
    if (![iTunes isRunning])
        return;
    iTunesTrackRating = [[iTunes currentTrack] albumRating];
	[trackRating setIntegerValue: iTunesTrackRating];
}


- (void) updateAlbumArt
{
    SBElementArray* artworks = [[iTunes currentTrack] artworks];
    iTunesAlbumArt = nil;
    if (0 < [artworks count])
        iTunesAlbumArt = (NSImage*)[[artworks objectAtIndex: 0] data];
	[albumArtView setImage: iTunesAlbumArt];
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
    [self updateAlbumArt];
}

@end
