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
        iTunesRunning = NO;
        [self resetTrackInformation];
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


- (void) setITunesRunning:(BOOL)newState
{
	iTunesRunning = newState;
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
    [iTunes setSoundVolume: iTunesVolume];
}


- (void) updatePlayPauseTitle
{
    if (iTunesEPlSPlaying == [iTunes playerState])
        [self setPlayPauseString: @"Pause"];
    else
        [self setPlayPauseString: @"Play"];
}


- (void) createITunesControllerWithPID:(pid_t)pid
{
	iTunes = [SBApplication applicationWithProcessIdentifier: pid];
    [self setITunesRunning:YES];
}


- (void) tearDownITunesController
{
	iTunes = nil;
    [self resetTrackInformation];
    [self setITunesRunning:NO];
}


- (void) resetTrackInformation
{
    [self setITunesTrackName: @"Trackname"];
    [self setITunesArtistName:@"Artistname"];
    [self setITunesAlbumArt:nil];
    [self setITunesTrackRating: 3];
}


- (void) updateAlbumArt
{
    if (![iTunes isRunning])
        return;

    SBElementArray* artworks = [[iTunes currentTrack] artworks];
    NSImage* newAlbumArt = (0 >= [artworks count]) ? nil : (NSImage*)[[artworks objectAtIndex: 0] data];
    [self setITunesAlbumArt: newAlbumArt];
}


- (void) updateControllerStatus
{
    if (![iTunes isRunning])
        return;

    [self setITunesVolume: [iTunes soundVolume]];
    
    // omit apple script error if no track is currently selected
    if (![[iTunes currentTrack] exists])
    {
        [self resetTrackInformation];
        return;
    }
    [self setITunesTrackName: [[iTunes currentTrack] name]];
    [self setITunesArtistName:[[iTunes currentTrack] artist]];
    // returned rating is between 0 and 100, the method expects values between 0 and 5
    [self setITunesTrackRating: ([[iTunes currentTrack] albumRating] / 20)];

    [self updatePlayPauseTitle];
    [self updateAlbumArt];
}

@end
