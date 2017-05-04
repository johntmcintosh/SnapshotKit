//
//  SnapshotKitTestController.swift
//  SnapshotKit
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

import FBSnapshotTestCase
import Foundation


enum SizeType {
    case unspecified
    case fixedWidth(CGFloat)
    case fixedHeight(CGFloat)
    case size(CGSize)
    case sizes([CGSize])
    case sizeToFit
}


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
    
    func allPhoneSizes() -> SnapshotKitTestController {
        let sizes = iPhoneDeviceSize.allCases.flatMap { $0.resolution }
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
            let container = UIView.makeAutolayoutContainer(wrapping: view)
            container.pin(width: width)
            let name = "width-\(width)"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        case .fixedHeight(let height):
            let container = UIView.makeAutolayoutContainer(wrapping: view)
            container.pin(height: height)
            let name = "height-\(height)"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        case .sizeToFit:
            let container = UIView.makeAutolayoutContainer(wrapping: view)
            let name = "sizeToFit"
            testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
        case .sizes(let sizes):
            for size in sizes {
                runVerification(on: view, size: size, file: file, line: line)
            }
        case .size(let size):
            runVerification(on: view, size: size, file: file, line: line)
        }
    }
    
    private func runVerification(on view: UIView, size: CGSize, file: StaticString, line: UInt) {
        let name = NSStringFromCGSize(size)
        
        let container = UIView.makeContainer(size: size, cropNavigationBar: cropsNavigationBar)
        view.frame = container.bounds
        container.addSubview(view)
        
        testCase.FBSnapshotVerifyView(container, identifier: name, file: file, line: line)
    }
}


private extension UIView {

    static func makeAutolayoutContainer(wrapping subview: UIView) -> UIView {
        let container = makeAutolayoutContainer()
        container.addSubviewForAutolayout(subview)
        subview.pinEdgesToSuperviewEdges()
        return container
    }

    static func makeAutolayoutContainer() -> UIView {
        let view = makeContainer(width: 100.0, height: 100.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func makeContainer(size: CGSize, cropNavigationBar: Bool = false) -> UIView {
        let defaultHeight: CGFloat = size.height
        let height = (cropNavigationBar) ? defaultHeight - 64.0 : defaultHeight
        return makeContainer(width: size.width, height: height)
    }

    static func makeContainer(width: CGFloat, height: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }

    func addSubviewForAutolayout(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinEdgesToSuperviewEdges() {
        guard let superview = superview else {
            fatalError("View must have a superview")
        }
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0))
    }
    
    func pin(width: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
    }

    func pin(height: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
    }
}
