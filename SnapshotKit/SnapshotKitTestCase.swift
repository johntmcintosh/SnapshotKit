//
//  SnapshotKitTestCase.swift
//  SnapshotKit
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import Foundation
import FBSnapshotTestCase


class SnapshotKitTestCase: FBSnapshotTestCase {
    
    var snapshot: SnapshotKitTestController!
    
    override func setUp() {
        super.setUp()
        snapshot = SnapshotKitTestController(testCase: self)
    }
    
    override func tearDown() {
        snapshot = nil
        super.tearDown()
    }
}
