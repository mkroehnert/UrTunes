/*
 * Copyright 2011 Manfred Kroehnert <mkroehnert@users.sourceforge.net>
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

#import "UTGrowlController.h"


@implementation UTGrowlController

- (id) init
{
    self = [super init];
    if (self)
    {
        if (![GrowlApplicationBridge isGrowlInstalled])
            NSLog(@"Growl is not installed! Get it at http://growl.info/");
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    return self;
}

- (NSString *) applicationNameForGrowl
{
	return @"UrTunes";
}

- (void) postNewTrackName:(NSString *)theTrackName withArtist:(NSString *)theArtist andAlbumArt:(NSImage *)theAlbumArt
{
    NSData* iconData = (theAlbumArt ? [theAlbumArt TIFFRepresentation] : nil);
    [GrowlApplicationBridge notifyWithTitle: theTrackName
                                description: theArtist
                           notificationName: @"CurrentTrack"
                                   iconData: iconData
                                   priority: 0
                                   isSticky: NO
                               clickContext: nil];
}



@end
