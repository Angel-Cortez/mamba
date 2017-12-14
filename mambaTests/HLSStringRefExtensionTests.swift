//
//  HLSStringRefExtensionTests.swift
//  mamba
//
//  Created by Jesse on 4/14/17.
//  Copyright © 2017 Comcast Cable Communications Management, LLC
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
@testable import mamba

class HLSStringRefExtensionTests: XCTestCase {
    
    func testInitFromValueID() {
        let valueID = PantosValue.UnknownTag_Name
        let hlsStringRef = HLSStringRef(valueIdentifier: valueID)
        
        XCTAssertNotNil(hlsStringRef, "we should have an HLSStringRef")
        XCTAssertEqual(hlsStringRef.stringValue(), valueID.toString())
    }
    
    func testInitFromDescriptor() {
        let descriptor = PantosTag.UnknownTag
        let hlsStringRef = HLSStringRef(descriptor: descriptor)
        
        XCTAssertNotNil(hlsStringRef, "We should have an HLSStringRef")
        XCTAssertEqual(hlsStringRef.stringValue(), "#\(descriptor.toString())")
    }
    
    func testStringEquality() {
        let tagValue = "test"
        let stringRef = HLSStringRef(string: tagValue)
        XCTAssert(tagValue == stringRef)
    }
    
    func testStringInequality() {
        let stringRef = HLSStringRef(string: "test")
        XCTAssert(stringRef != "other")
        XCTAssert("other" != stringRef)
    }
    
    func testRelativeURL() {
        let url: URL = URL(string:"http://fake.server/manifest.m3u8")!
        let relativeUrlStringRef = HLSStringRef(string: "variant.m3u8")
        let fullUrlStringRef = HLSStringRef(hlsStringRef:relativeUrlStringRef, relativeTo:url)
        XCTAssert(fullUrlStringRef! == "http://fake.server/variant.m3u8")
    }
}
