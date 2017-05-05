//
//  SnapshotKitTestCase.swift
//  SnapshotKit
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import Foundation
import FBSnapshotTestCase


open class SnapshotKitTestCase: FBSnapshotTestCase {
    
    public var snapshot: SnapshotKitTestController!
    
    override open func setUp() {
        super.setUp()
        snapshot = SnapshotKitTestController(testCase: self)
    }
    
    override open func tearDown() {
        snapshot = nil
        super.tearDown()
    }
}
