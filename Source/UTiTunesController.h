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

#import <Cocoa/Cocoa.h>

@class iTunesApplication;
@class UTGrowlController;

@interface UTiTunesController : NSObject {
    iTunesApplication* iTunes;
    UTGrowlController* growlController;
    NSInteger iTunesVolume;
    NSString* iTunesTrackName;
    NSString* iTunesArtistName;
    NSInteger iTunesTrackRating;
    NSImage* iTunesAlbumArt;
    NSString* playPauseString;
    BOOL iTunesRunning;
}

// KVC methods
- (void) setITunesVolume:(NSInteger)newVolume;
- (void) setITunesTrackName:(NSString*)newTrackName;
- (void) setITunesArtistName:(NSString*)newArtistName;
- (void) setITunesTrackRating:(NSInteger)newRating;
- (void) setITunesAlbumArt:(NSImage*)newAlbumArt;
- (void) setPlayPauseString:(NSString*)newString;
- (void) setITunesRunning:(BOOL)newState;
// IBActions
- (IBAction) playPause:(id)sender;
- (IBAction) previousTrack:(id)sender;
- (IBAction) nextTrack:(id)sender;
- (IBAction) setNewITunesVolume:(id)sender;
//
- (void) createITunesControllerWithPID:(pid_t)pid;
- (void) tearDownITunesController;
- (void) resetTrackInformation;
- (void) updatePlayPauseTitle;
- (void) updateAlbumArt;
- (void) updateControllerStatus;

@end
