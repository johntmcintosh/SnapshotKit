//
//  SnapshotKitTests.swift
//  SnapshotKitTests
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import XCTest
@testable import SnapshotKit


class SnapshotKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let controller = SnapshotKitTestController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}


class SampleTest: SnapshotKitTestCase {
    
    func testSample() {
        XCTFail()
    }
}
