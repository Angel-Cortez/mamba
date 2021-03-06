//
//  PlaylistTypes.swift
//  mamba
//
//  Created by David Coufal on 11/3/16.
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

import Foundation

/// the playlist type (i.e. VOD vs Event/CDVR vs Live/Linear)
public enum PlaylistType {
    /// a playlist with a set begin time and set end time
    case vod
    /// a playlist with a set begin time but no set end time
    case event
    /// a playlist with no set begin or end
    case live
}

/// a protocol for objects that can report on a PlaylistType
public protocol PlaylistTypeDetermination {
    /// the playlist type (i.e. VOD vs Event/CDVR vs Live/Linear)
    var playlistType: PlaylistType { get }
}
