//
//  HLSExtensibleValidator.swift
//  mamba
//
//  Created by Mohan on 8/7/16.
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

/// A protocol for HLSManifestValidator that is a superset of other validators.
public protocol HLSExtensibleValidator: HLSManifestValidator {
    /// An array of HLSValidator types that will be used to validate manifests
    static var validators:[HLSValidator.Type] { get }
}

/**
 Default implementation of HLSExtensibleValidator.
 
 It will take a HLSManifestInterface, apply tag validators to all the tags, and then try to validate the
 entire manifest against all the validators in the `validators` array.
 */
public extension HLSExtensibleValidator {
    
    public static func validate(hlsManifest: HLSManifestInterface) -> [HLSValidationIssue]? {
        var validationIssueList:[HLSValidationIssue] = []
        
        // tags
        for tag in hlsManifest.tags{
            guard let validator = hlsManifest.registeredTags.validator(forTag: tag.tagDescriptor) else {
                continue
            }
            guard let validationResponse = validator.validate(tag: tag) else {
                continue
            }
            
            validationIssueList += validationResponse
        }
        
        // manifest
        if let validationIssues = validateInternal(hlsManifest: hlsManifest) {
            validationIssueList += validationIssues
        }
        
        return validationIssueList.isEmpty ? nil : validationIssueList
    }
    
    static fileprivate func validateInternal(hlsManifest: HLSManifestInterface) -> [HLSValidationIssue]? {
        var issues:[HLSValidationIssue] = []
        
        for validator in validators{
            if let manifestValidator = validator as? HLSManifestValidator.Type {
                guard let validatorIssues = manifestValidator.validate(hlsManifest: hlsManifest) else { continue }
                issues += validatorIssues
                continue
            }
        }
        
        return issues.isEmpty ? nil : issues
    }
}

/// Validator for master manifests
public class HLSMasterManifestValidator: HLSExtensibleValidator {
    public static let validators:[HLSValidator.Type] = [HLSManifestRenditionGroupValidator.self,
                                                EXT_X_STREAM_INFRenditionGroupAUDIOValidator.self,
                                                EXT_X_STREAM_INFRenditionGroupVIDEOValidator.self,
                                                EXT_X_STREAM_INFRenditionGroupSUBTITLESValidator.self]
}

/// Validator for variant manifests
public class HLSVariantManifestValidator: HLSExtensibleValidator {
    public static let validators:[HLSValidator.Type] = [HLSManifestAggregateTagCardinalityValidator.self,
                                                        EXT_X_TARGETDURATIONLengthValidator.self,
                                                        HLSManifestRenditionGroupMatchingPROGRAM_IDValidator.self,
                                                        HLSManifestRenditionGroupMatchingNAMELANGUAGEValidator.self,
                                                        EXT_X_STARTTimeOffsetValidator.self]
}

/// A general purpose validator that will validate either a variant or a master manifest
public class HLSCompleteManifestValidator: HLSManifestValidator {

    public static func validate(hlsManifest: HLSManifestInterface) -> [HLSValidationIssue]? {
        switch hlsManifest.type {
        case .media:
            return HLSVariantManifestValidator.validate(hlsManifest: hlsManifest)
        case .master:
            return HLSMasterManifestValidator.validate(hlsManifest: hlsManifest)
        default:
            return nil
        }
    }
}
