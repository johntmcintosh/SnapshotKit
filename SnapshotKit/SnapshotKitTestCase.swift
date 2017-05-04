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
    
    var snapshot: SnapshotConfiguration!
    
    override func setUp() {
        super.setUp()
        snapshot = SnapshotConfiguration(testCase: self)
    }
    
    override func tearDown() {
        snapshot = nil
        super.tearDown()
    }
}


/*
 
 view.snapshotTest.registerConfiguration { ... }
 view.snapshotTest.excludeNavigationBar().withAllPhoneSizes().verify()
 
 */

class SnapshotConfiguration {
    
    let testCase: FBSnapshotTestCase
    var sizes: [CGSize] = []
    var cropsNavigationBar = false
    
    init(testCase: FBSnapshotTestCase) {
        self.testCase = testCase
    }
    
    func excludeNavigationBar() -> SnapshotConfiguration {
        cropsNavigationBar = true
        return self
    }
    
    func withAllPhoneSizes() -> SnapshotConfiguration {
        sizes = iPhoneDeviceSizes.allCases.flatMap { $0.resolution }
        return self
    }
    
    func verify(_ viewController: UIViewController, file: StaticString = #file, line: UInt = #line) {
        verify(viewController.view, file: file, line: line)
    }
    
    // TODO: Do we need layer-based verification?
    func verify(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        for size in sizes {
            let name = NSStringFromCGSize(size)
            
            let container = makeContainerView(size: size, cropNavigationBar: cropsNavigationBar)
            view.frame = container.bounds
            container.addSubview(view)
            
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        }
    }
    
    private func makeContainerView(size: CGSize, cropNavigationBar: Bool = false) -> UIView {
        let defaultHeight: CGFloat = size.height
        let height = (cropNavigationBar) ? defaultHeight - 64.0 : defaultHeight
        return makeContainerView(width: size.width, height: height)
    }
    
    private func makeContainerView(width: CGFloat, height: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
}


enum iPhoneDeviceSizes {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6plus
    
    var resolution: CGSize {
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
    static var allCases: [iPhoneDeviceSizes] {
        return [.iPhone4, .iPhone5, .iPhone6, .iPhone6plus]
    }
}
