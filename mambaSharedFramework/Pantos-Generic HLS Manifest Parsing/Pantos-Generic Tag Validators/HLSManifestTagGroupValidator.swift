//
//  HLSManifestTagGroupValidator.swift
//  mamba
//
//  Created by Philip McMahon on 10/19/16.
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

protocol HLSManifestTagGroupValidator: HLSManifestCollectionValidator {
}

extension HLSManifestTagGroupValidator {
    internal static func groupBy(tags: [HLSTag]) -> [String:[HLSTag]] {
        var groups:[String:[HLSTag]] = [:]
        for tag in tags {
            for pair in Self.tagIdentifierPairs {
                if pair.tagDescriptor == tag.tagDescriptor {
                    if let groupId: String = tag.value(forValueIdentifier: pair.valueIdentifier) {
                        var group = groups[groupId] ?? [HLSTag]()
                        group.append(tag)
                        groups[groupId] = group
                        break
                    }
                }
            }
        }
        return groups
    }
    
    static func validate(hlsManifest: HLSManifestInterface) -> [HLSValidationIssue]? {
        let tags = (try? hlsManifest.tags.filter(self.filter)) ?? []
        let groups = groupBy(tags: tags)
        var issues:[HLSValidationIssue] = []
        for group in groups {
            if let groupIssues = validation(group.value) { issues += groupIssues }
        }
        return issues.isEmpty ? nil : issues
    }
}

protocol HLSManifestTagCrossGroupValidator:HLSManifestTagGroupValidator {
    static var crossGroupValidation: ([String:[HLSTag]]) -> [HLSValidationIssue]? { get }
}

extension HLSManifestTagCrossGroupValidator {
    static func validate(hlsManifest: HLSManifestInterface) -> [HLSValidationIssue]? {
        let tags = (try? hlsManifest.tags.filter(self.filter)) ?? []
        let groups = groupBy(tags: tags)
        return crossGroupValidation(groups)
    }
    
    static var validation: ([HLSTag]) -> [HLSValidationIssue]? {
        return { _ in return nil }
    }
}
