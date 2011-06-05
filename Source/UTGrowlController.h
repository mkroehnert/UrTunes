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

#import <Growl/GrowlApplicationBridge.h>
#import <Cocoa/Cocoa.h>


@interface UTGrowlController : NSObject <GrowlApplicationBridgeDelegate>
{

}

- (NSString *) applicationNameForGrowl;
- (void) postNewTrackName:(NSString *)theTrackName withArtist:(NSString *)theArtist andAlbumArt:(NSImage *)theAlbumArt;

@end
