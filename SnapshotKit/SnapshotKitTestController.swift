//
//  SnapshotKitTestController.swift
//  SnapshotKit
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import FBSnapshotTestCase
import Foundation

/*
 TODO: ?
 view.snapshotTest.registerConfiguration { ... }
 view.snapshotTest.excludeNavigationBar().withAllPhoneSizes().verify()
 
 */


public class SnapshotKitTestController {
    
    let testCase: FBSnapshotTestCase
    var sizeType: SizeType = .unspecified
    var cropsNavigationBar = false
    
    init(testCase: FBSnapshotTestCase) {
        self.testCase = testCase
    }
    
    func excludeNavigationBar() -> SnapshotKitTestController {
        cropsNavigationBar = true
        return self
    }
    
    func withAllPhoneSizes() -> SnapshotKitTestController {
        let sizes = iPhoneDeviceSizes.allCases.flatMap { $0.resolution }
        return self.sizes(sizes)
    }
    
    func fixed(width: CGFloat) -> SnapshotKitTestController {
        sizeType = .fixedWidth(width)
        return self
    }

    func fixed(height: CGFloat) -> SnapshotKitTestController {
        sizeType = .fixedHeight(height)
        return self
    }

    func fixed(size: CGSize) -> SnapshotKitTestController {
        sizeType = .size(size)
        return self
    }
    
    func sizes(_ sizes: [CGSize]) -> SnapshotKitTestController {
        sizeType = .sizes(sizes)
        return self
    }
    
    func sizeToFit() -> SnapshotKitTestController {
        sizeType = .sizeToFit
        return self
    }

    func verify(_ viewController: UIViewController, file: StaticString = #file, line: UInt = #line) {
        verify(viewController.view, file: file, line: line)
    }
    
    // TODO: Do we need layer-based verification?
    func verify(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        switch sizeType {
        case .unspecified:
            testCase.FBSnapshotVerifyView(view, file: file, line: line)
        case .fixedWidth(let width):
            let container = makeContainerView(size: CGSize(width: 100, height: 100), cropNavigationBar: cropsNavigationBar)
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addConstraint(NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
            
            let name = "width-\(width)"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        case .fixedHeight(let height):
            let container = makeContainerView(size: CGSize(width: 100, height: 100), cropNavigationBar: cropsNavigationBar)
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            container.translatesAutoresizingMaskIntoConstraints = false
            
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            
            container.addConstraint(NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
            
            let name = "height-\(height)"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        case .sizes(let sizes):
            for size in sizes {
                runVerification(on: view, size: size, file: file, line: line)
            }
        case .size(let size):
            runVerification(on: view, size: size, file: file, line: line)
        case .sizeToFit:
            let container = makeContainerView(size: CGSize(width: 100, height: 100), cropNavigationBar: cropsNavigationBar)
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            container.translatesAutoresizingMaskIntoConstraints = false
            
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            
            let name = "sizeToFit"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        }
    }
    
    private func runVerification(on view: UIView, size: CGSize, file: StaticString, line: UInt) {
        let name = NSStringFromCGSize(size)
        
        let container = makeContainerView(size: size, cropNavigationBar: cropsNavigationBar)
        view.frame = container.bounds
        container.addSubview(view)
        
        testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
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


enum SizeType {
    case unspecified
    case fixedWidth(CGFloat)
    case fixedHeight(CGFloat)
    case size(CGSize)
    case sizes([CGSize])
    case sizeToFit
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
