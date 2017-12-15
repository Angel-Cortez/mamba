//
//  HLSManifestTimelineAndSequencingTests.swift
//  mamba
//
//  Created by David Coufal on 10/14/16.
//  Copyright © 2016 Comcast Cable Communications Management, LLC
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
import CoreMedia
import mamba

class HLSManifestTimelineAndSequencingTests: XCTestCase {
    
    func testMediaSequenceMissing() {
        // ***
        // *** Setup
        
        let manifest = parseManifest(inString: sampleVariantManifest_mediaSequenceMissing)
        
        XCTAssert(manifest.tags.count == 19, "Unexpected number of tags")
        
        let versionIndex = 0
        let playlisttypeIndex = 1
        let targetdurationIndex = 2
        let endplaylistIndex = 18
        
        let versiontag = manifest.tags[versionIndex]
        let playlisttypetag = manifest.tags[playlisttypeIndex]
        let targetdurationtag = manifest.tags[targetdurationIndex]
        let endplaylisttag = manifest.tags[endplaylistIndex]
        XCTAssert(versiontag.tagDescriptor == PantosTag.EXT_X_VERSION, "The playlist must have changed")
        XCTAssert(playlisttypetag.tagDescriptor == PantosTag.EXT_X_PLAYLIST_TYPE, "The playlist must have changed")
        XCTAssert(targetdurationtag.tagDescriptor == PantosTag.EXT_X_TARGETDURATION, "The playlist must have changed")
        XCTAssert(endplaylisttag.tagDescriptor == PantosTag.EXT_X_ENDLIST, "The playlist must have changed")
        
        // ***
        // *** Test media sequence to time range conversion
        
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 0, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 1, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 2, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 3, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 4, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 5, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        
        let timeRange = manifest.timeRange(forMediaSequence: 6)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        // ***
        // *** Test tag to media sequence conversion
        
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 3, isPartOfMediaSequence: 0), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 4, isPartOfMediaSequence: 0), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 5, isPartOfMediaSequence: 1), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 6, isPartOfMediaSequence: 1), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 7, isPartOfMediaSequence: 1), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 8, isPartOfMediaSequence: 1), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 9, isPartOfMediaSequence: 1), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 10, isPartOfMediaSequence: 2), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 11, isPartOfMediaSequence: 2), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 12, isPartOfMediaSequence: 3), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 13, isPartOfMediaSequence: 3), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 14, isPartOfMediaSequence: 4), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 15, isPartOfMediaSequence: 4), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 16, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 17, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        
        XCTAssertNil(manifest.mediaSequence(forTagIndex: versionIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: playlisttypeIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: targetdurationIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: endplaylistIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        
        // ***
        // *** Test tag to time range conversion
        
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 3, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 4, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 5, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 6, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 7, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 8, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 9, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 10, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 11, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 12, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 13, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 14, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 15, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 16, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 17, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        
        XCTAssertNil(manifest.timeRange(forTagIndex: versionIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: playlisttypeIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: targetdurationIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: endplaylistIndex), "Tags that do not belong to fragments should not have time ranges")
        
        // ***
        // *** Test time to media sequence conversion
        
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 0, belongsToMediaSequence: 0), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 500, belongsToMediaSequence: 0), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2001, belongsToMediaSequence: 0), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2002, belongsToMediaSequence: 1), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2500, belongsToMediaSequence: 1), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3001, belongsToMediaSequence: 1), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3002, belongsToMediaSequence: 2), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 4000, belongsToMediaSequence: 2), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5003, belongsToMediaSequence: 2), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5004, belongsToMediaSequence: 3), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 6000, belongsToMediaSequence: 3), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7005, belongsToMediaSequence: 3), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7006, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 8100, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9007, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9008, belongsToMediaSequence: 5), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9900, belongsToMediaSequence: 5), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 11000, belongsToMediaSequence: 5), "Unexpected media sequence")
        
        XCTAssertNil(manifest.mediaSequence(forTime: CMTime(seconds: -0.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times before the start of the clip should not return media sequences")
        XCTAssertNil(manifest.mediaSequence(forTime: CMTime(seconds: 11.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times after the end of the clip should not return media sequences")
        
        // ***
        // *** Test media sequence to tag conversion
        
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 0, shouldMatchBeginTagIndex: 3, andEndTagIndex: 4), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 1, shouldMatchBeginTagIndex: 5, andEndTagIndex: 9), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 2, shouldMatchBeginTagIndex: 10, andEndTagIndex: 11), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 3, shouldMatchBeginTagIndex: 12, andEndTagIndex: 13), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 4, shouldMatchBeginTagIndex: 14, andEndTagIndex: 15), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 5, shouldMatchBeginTagIndex: 16, andEndTagIndex: 17), "Unexpected tags returned")
        
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 6), "Should return no tags for nonexistant media sequence")
        
        // ***
        // *** Test time to tag conversion
        
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 0, shouldMatchBeginTagIndex: 3, andEndTagIndex: 4), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 500, shouldMatchBeginTagIndex: 3, andEndTagIndex: 4), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2001, shouldMatchBeginTagIndex: 3, andEndTagIndex: 4), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2002, shouldMatchBeginTagIndex: 5, andEndTagIndex: 9), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2500, shouldMatchBeginTagIndex: 5, andEndTagIndex: 9), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3001, shouldMatchBeginTagIndex: 5, andEndTagIndex: 9), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3002, shouldMatchBeginTagIndex: 10, andEndTagIndex: 11), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 4000, shouldMatchBeginTagIndex: 10, andEndTagIndex: 11), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5003, shouldMatchBeginTagIndex: 10, andEndTagIndex: 11), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5004, shouldMatchBeginTagIndex: 12, andEndTagIndex: 13), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 6000, shouldMatchBeginTagIndex: 12, andEndTagIndex: 13), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7005, shouldMatchBeginTagIndex: 12, andEndTagIndex: 13), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7006, shouldMatchBeginTagIndex: 14, andEndTagIndex: 15), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 8100, shouldMatchBeginTagIndex: 14, andEndTagIndex: 15), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9007, shouldMatchBeginTagIndex: 14, andEndTagIndex: 15), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9008, shouldMatchBeginTagIndex: 16, andEndTagIndex: 17), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9900, shouldMatchBeginTagIndex: 16, andEndTagIndex: 17), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 11000, shouldMatchBeginTagIndex: 16, andEndTagIndex: 17), "Unexpected tags returned")
        
        XCTAssertNil(manifest.tagIndexes(forTime: CMTime(seconds: -0.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times before the start of the clip should not return tags")
        XCTAssertNil(manifest.tagIndexes(forTime: CMTime(seconds: 11.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times after the end of the clip should not return tags")
    }
    
    func testMediaSequence4() {
        // ***
        // *** Setup
        
        let manifest = parseManifest(inString: sampleVariantManifest_mediaSequence4)
        
        XCTAssert(manifest.tags.count == 20, "Unexpected number of tags")
        
        let versionIndex = 0
        let playlisttypeIndex = 1
        let targetdurationIndex = 2
        let mediasequencetagIndex = 3
        let endplaylistIndex = 19
        
        let versiontag = manifest.tags[versionIndex]
        let playlisttypetag = manifest.tags[playlisttypeIndex]
        let targetdurationtag = manifest.tags[targetdurationIndex]
        let mediasequencetag = manifest.tags[mediasequencetagIndex]
        let endplaylisttag = manifest.tags[endplaylistIndex]
        XCTAssert(versiontag.tagDescriptor == PantosTag.EXT_X_VERSION, "The playlist must have changed")
        XCTAssert(playlisttypetag.tagDescriptor == PantosTag.EXT_X_PLAYLIST_TYPE, "The playlist must have changed")
        XCTAssert(targetdurationtag.tagDescriptor == PantosTag.EXT_X_TARGETDURATION, "The playlist must have changed")
        XCTAssert(mediasequencetag.tagDescriptor == PantosTag.EXT_X_MEDIA_SEQUENCE, "The playlist must have changed")
        XCTAssert(endplaylisttag.tagDescriptor == PantosTag.EXT_X_ENDLIST, "The playlist must have changed")
        
        // ***
        // *** Test media sequence to time range conversion
        
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 4, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 5, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 6, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 7, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 8, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 9, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        
        var timeRange = manifest.timeRange(forMediaSequence: 0)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        timeRange = manifest.timeRange(forMediaSequence: 1)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        timeRange = manifest.timeRange(forMediaSequence: 2)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        timeRange = manifest.timeRange(forMediaSequence: 3)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        timeRange = manifest.timeRange(forMediaSequence: 10)
        XCTAssertNil(timeRange, "Invalid mediasequence, expecting nil")
        
        // ***
        // *** Test tag to media sequence conversion
        
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 4, isPartOfMediaSequence: 4), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 5, isPartOfMediaSequence: 4), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 6, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 7, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 8, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 9, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 10, isPartOfMediaSequence: 5), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 11, isPartOfMediaSequence: 6), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 12, isPartOfMediaSequence: 6), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 13, isPartOfMediaSequence: 7), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 14, isPartOfMediaSequence: 7), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 15, isPartOfMediaSequence: 8), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 16, isPartOfMediaSequence: 8), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 17, isPartOfMediaSequence: 9), "Tag and Media Sequence did not match")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 18, isPartOfMediaSequence: 9), "Tag and Media Sequence did not match")
        
        XCTAssertNil(manifest.mediaSequence(forTagIndex: versionIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: playlisttypeIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: targetdurationIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: mediasequencetagIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        XCTAssertNil(manifest.mediaSequence(forTagIndex: endplaylistIndex), "Tags that do not belong to fragments should not have media sequence numbers")
        
        // ***
        // *** Test tag to time range conversion
        
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 4, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 5, hasStartTimeInMilliseconds: 0, andHasEndTimeInMilliseconds: 2002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 6, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 7, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 8, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 9, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 10, hasStartTimeInMilliseconds: 2002, andHasEndTimeInMilliseconds: 3002), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 11, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 12, hasStartTimeInMilliseconds: 3002, andHasEndTimeInMilliseconds: 5004), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 13, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 14, hasStartTimeInMilliseconds: 5004, andHasEndTimeInMilliseconds: 7006), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 15, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 16, hasStartTimeInMilliseconds: 7006, andHasEndTimeInMilliseconds: 9008), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 17, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        XCTAssert(runTest(forTimeline: manifest, tagAtIndex: 18, hasStartTimeInMilliseconds: 9008, andHasEndTimeInMilliseconds: 11010), "Unexpected time range")
        
        XCTAssertNil(manifest.timeRange(forTagIndex: versionIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: playlisttypeIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: targetdurationIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: mediasequencetagIndex), "Tags that do not belong to fragments should not have time ranges")
        XCTAssertNil(manifest.timeRange(forTagIndex: endplaylistIndex), "Tags that do not belong to fragments should not have time ranges")
        
        // ***
        // *** Test time to media sequence conversion
        
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 0, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 500, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2001, belongsToMediaSequence: 4), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2002, belongsToMediaSequence: 5), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2500, belongsToMediaSequence: 5), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3001, belongsToMediaSequence: 5), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3002, belongsToMediaSequence: 6), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 4000, belongsToMediaSequence: 6), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5003, belongsToMediaSequence: 6), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5004, belongsToMediaSequence: 7), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 6000, belongsToMediaSequence: 7), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7005, belongsToMediaSequence: 7), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7006, belongsToMediaSequence: 8), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 8100, belongsToMediaSequence: 8), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9007, belongsToMediaSequence: 8), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9008, belongsToMediaSequence: 9), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9900, belongsToMediaSequence: 9), "Unexpected media sequence")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 11000, belongsToMediaSequence: 9), "Unexpected media sequence")
        
        XCTAssertNil(manifest.mediaSequence(forTime: CMTime(seconds: -0.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times before the start of the clip should not return media sequences")
        XCTAssertNil(manifest.mediaSequence(forTime: CMTime(seconds: 11.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times after the end of the clip should not return media sequences")
        
        // ***
        // *** Test media sequence to tag conversion
        
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 4, shouldMatchBeginTagIndex: 4, andEndTagIndex: 5), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 5, shouldMatchBeginTagIndex: 6, andEndTagIndex: 10), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 6, shouldMatchBeginTagIndex: 11, andEndTagIndex: 12), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 7, shouldMatchBeginTagIndex: 13, andEndTagIndex: 14), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 8, shouldMatchBeginTagIndex: 15, andEndTagIndex: 16), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, mediaSequence: 9, shouldMatchBeginTagIndex: 17, andEndTagIndex: 18), "Unexpected tags returned")
        
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 0), "Should return no tags for nonexistant media sequence")
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 1), "Should return no tags for nonexistant media sequence")
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 2), "Should return no tags for nonexistant media sequence")
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 3), "Should return no tags for nonexistant media sequence")
        XCTAssertNil(manifest.tagIndexes(forMediaSequence: 10), "Should return no tags for nonexistant media sequence")
        
        // ***
        // *** Test time to tag conversion
        
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 0, shouldMatchBeginTagIndex: 4, andEndTagIndex: 5), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 500, shouldMatchBeginTagIndex: 4, andEndTagIndex: 5), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2001, shouldMatchBeginTagIndex: 4, andEndTagIndex: 5), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2002, shouldMatchBeginTagIndex: 6, andEndTagIndex: 10), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 2500, shouldMatchBeginTagIndex: 6, andEndTagIndex: 10), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3001, shouldMatchBeginTagIndex: 6, andEndTagIndex: 10), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 3002, shouldMatchBeginTagIndex: 11, andEndTagIndex: 12), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 4000, shouldMatchBeginTagIndex: 11, andEndTagIndex: 12), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5003, shouldMatchBeginTagIndex: 11, andEndTagIndex: 12), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 5004, shouldMatchBeginTagIndex: 13, andEndTagIndex: 14), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 6000, shouldMatchBeginTagIndex: 13, andEndTagIndex: 14), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7005, shouldMatchBeginTagIndex: 13, andEndTagIndex: 14), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 7006, shouldMatchBeginTagIndex: 15, andEndTagIndex: 16), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 8100, shouldMatchBeginTagIndex: 15, andEndTagIndex: 16), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9007, shouldMatchBeginTagIndex: 15, andEndTagIndex: 16), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9008, shouldMatchBeginTagIndex: 17, andEndTagIndex: 18), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 9900, shouldMatchBeginTagIndex: 17, andEndTagIndex: 18), "Unexpected tags returned")
        XCTAssert(runTest(forTimeline: manifest, timeInMilliseconds: 11000, shouldMatchBeginTagIndex: 17, andEndTagIndex: 18), "Unexpected tags returned")
        
        XCTAssertNil(manifest.tagIndexes(forTime: CMTime(seconds: -0.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times before the start of the clip should not return tags")
        XCTAssertNil(manifest.tagIndexes(forTime: CMTime(seconds: 11.5, preferredTimescale: CMTimeScale.defaultMambaTimeScale)), "times after the end of the clip should not return tags")
    }
    
    
    // MARK: Utilities
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, mediaSequence: MediaSequence, hasStartTimeInMilliseconds startTimeInMilliseconds: Int64, andHasEndTimeInMilliseconds endTimeInMilliseconds: Int64) -> Bool {
        guard let timeRange = timeline.timeRange(forMediaSequence: mediaSequence) else {
            return false
        }
        return timeRange.start == CMTime(value: startTimeInMilliseconds, timescale: 1000) &&
            timeRange.end == CMTime(value: endTimeInMilliseconds, timescale: 1000)
    }
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, tagAtIndex index: Int, isPartOfMediaSequence mediaSequence: MediaSequence) -> Bool {
        return timeline.mediaSequence(forTagIndex: index) == mediaSequence
    }
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, tagAtIndex index: Int, hasStartTimeInMilliseconds startTimeInMilliseconds: Int64, andHasEndTimeInMilliseconds endTimeInMilliseconds: Int64) -> Bool {
        guard let timeRange = timeline.timeRange(forTagIndex: index) else {
            return false
        }
        return timeRange.start == CMTime(value: startTimeInMilliseconds, timescale: 1000) &&
            timeRange.end == CMTime(value: endTimeInMilliseconds, timescale: 1000)
    }
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, timeInMilliseconds: Int64, belongsToMediaSequence mediaSequence: MediaSequence) -> Bool {
        let mediaSequenceCalculated = timeline.mediaSequence(forTime: CMTime(value: timeInMilliseconds, timescale: 1000))
        return mediaSequenceCalculated == mediaSequence
    }
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, mediaSequence: MediaSequence, shouldMatchBeginTagIndex beginTagIndex: Int, andEndTagIndex endtagIndex: Int) -> Bool {
        guard let tagIndexes = timeline.tagIndexes(forMediaSequence: mediaSequence) else { return false }
        
        return tagIndexes.lowerBound == beginTagIndex && tagIndexes.upperBound == endtagIndex
    }
    
    func runTest(forTimeline timeline: HLSManifestTimelineTranslator, timeInMilliseconds: Int64, shouldMatchBeginTagIndex beginTagIndex: Int, andEndTagIndex endtagIndex: Int) -> Bool {
        guard let tagIndexes = timeline.tagIndexes(forTime: CMTime(value: timeInMilliseconds, timescale: 1000)) else { return false }
        
        return tagIndexes.lowerBound == beginTagIndex && tagIndexes.upperBound == endtagIndex
    }
}

/*
 Here's the expected structure of the HLS manifest file(s)
 
 -                         | Fragment 1       | Fragment 2       | Fragment 3       | Fragment 4       | Fragment 5       | Fragment 6       |
 ---------------------------------------------------------------------------------------------------------------------------------------------
 - Duration                | 2.002            | 1.0              | 2.002            | 2.002            | 2.002            | 2.002            |
 ---------------------------------------------------------------------------------------------------------------------------------------------
 - Time Range              | 0.0 - 2.002      | 2.002 - 3.002    | 3.002 - 5.004    | 5.004 - 7.006    | 7.006 - 9.008    | 9.008 - 11.01    |
 ---------------------------------------------------------------------------------------------------------------------------------------------
 - MediaSequence (Missing) | 1                | 2                | 3                | 4                | 5                | 6                |
 ---------------------------------------------------------------------------------------------------------------------------------------------
 - MediaSequence (4)       | 4                | 5                | 6                | 7                | 8                | 9                |
 ---------------------------------------------------------------------------------------------------------------------------------------------
 - Index Start and End *   | 3 - 4            | 5 - 9            | 10 - 11          | 12 - 13          | 14 - 15          | 16 - 17          |
                             4 - 5              6 - 10             11 - 12            13 - 14            15 - 16            17 - 18
 
 (*) These values are +1 for MediaSequence4 due to the #EXT-X-MEDIASEQUENCE tag!
 */


fileprivate let sampleVariantManifest_mediaSequenceMissing = sampleVariantManifest_begin + sampleVariantManifest_end
fileprivate let sampleVariantManifest_mediaSequence4 = sampleVariantManifest_begin + "#EXT-X-MEDIA-SEQUENCE:4\n" + sampleVariantManifest_end

fileprivate let sampleVariantManifest_begin = """
#EXTM3U\n
#EXT-X-VERSION:4\n
#EXT-X-PLAYLIST-TYPE:VOD\n
#EXT-X-TARGETDURATION:2\n
"""

fileprivate let sampleVariantManifest_end = """
#EXTINF:2.002,\n
http://not.a.server.nowhere/fragment1.ts\n
#EXTINF:1.0,\n
#EXT-X-DISCONTINUITY\n
#EXT-X-KEY:METHOD=AES-128,URI=\"https://not.a.server.nowhere/key.php?r=52\",IV=0x9c7db8778570d05c3177c349fd9236aa/\n
#EXT-X-BYTERANGE:82112@752321\n
http://not.a.server.nowhere/fragment2.ts\n
#EXTINF:2.002,\n
http://not.a.server.nowhere/fragment3.ts\n
#EXTINF:2.002,\n
http://not.a.server.nowhere/fragment4.ts\n
#EXTINF:2.002,\n
http://not.a.server.nowhere/fragment5.ts\n
#EXTINF:2.002,\n
http://not.a.server.nowhere/fragment6.ts\n
#EXT-X-ENDLIST\n"
"""