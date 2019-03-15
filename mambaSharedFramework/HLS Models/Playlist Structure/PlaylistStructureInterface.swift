//
//  PlaylistStructureInterface.swift
//  mamba
//
//  Created by David Coufal on 3/11/19.
//  Copyright © 2019 Comcast Corporation.
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
//  limitations under the License. All rights reserved.
//

import Foundation

/**
 This protocol defines a minimal interface of a object that represents HLS playlist structure.
 */
public protocol PlaylistStructureInterface: class {
    
    init(withTags tags: [HLSTag])
    
    init(withStructure structure: Self)

    /**
     This array is a list of every line in a HLS playlist. Each line is defined by a `HLSTag` object.
     */
    var tags: [HLSTag] { get }
    
    /**
     Insert a single tag.
     
     - parameter tag: A `HLSTag` to be inserted into the playlist.
     
     - parameter atIndex: Position to insert the tag into the playlist. The tag will be added to an
     existing TagGroupProtocol unless `withStructureRebuild` is set to true.
     */
    func insert(tag: HLSTag, atIndex index: Int)
    
    /**
     Insert multiple tags.
     
     - parameter tags: A `HLSTag` array to be inserted into the playlist.
     
     - parameter atIndex: Position to insert the tags into the playlist. 
     */
    func insert(tags: [HLSTag], atIndex index: Int)
    
    /**
     Delete a single tag.
     
     - parameter atIndex: Position of the tag to delete.
     */
    func delete(atIndex index: Int)
    
    /**
     Delete multiple tags.
     
     - parameter atRange: Range of the tags to delete.
     */
    func delete(atRange range: HLSTagIndexRange)
    
    /**
     Perform a map on every tag in the tags array.
     
     - parameter: The mapping closure to use during the map.
     */
    func transform(_ mapping: (HLSTag) throws -> (HLSTag)) throws
}
