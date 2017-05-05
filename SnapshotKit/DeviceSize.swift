//
//  DeviceSize.swift
//  SnapshotKit
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import Foundation
import UIKit


public enum iPhoneDeviceSize {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6plus
    
    public var resolution: CGSize {
        switch self {
        case .iPhone4:
            return CGSize(width: 320.0, height: 480.0)
        case .iPhone5:
            return CGSize(width: 320.0, height: 568.0)
        case .iPhone6:
            return CGSize(width: 375.0, height: 667.0)
        case .iPhone6plus:
            return CGSize(width: 540.0, height: 960.0)
        }
    }
    
    // TODO: Replace with sourcery-generated
    public static var allCases: [iPhoneDeviceSize] {
        return [.iPhone4, .iPhone5, .iPhone6, .iPhone6plus]
    }
}
