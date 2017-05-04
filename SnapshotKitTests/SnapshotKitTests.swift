//
//  SnapshotKitTests.swift
//  SnapshotKitTests
//
//  Created by John McIntosh on 5/4/17.
//  Copyright © 2017 John T McIntosh. All rights reserved.
//

@testable import SnapshotKit
import FBSnapshotTestCase
import PureLayout
import XCTest


class SnapshotKitTests: SnapshotKitTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = true
    }
    
    func testViewsDefaultSizeSize() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.verify(view)
    }
    
    func testDeviceSizes() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.withAllPhoneSizes().verify(view)
    }
    
    func testFixedWidth() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.fixed(width: 400.0).verify(view)
    }
    
    func testFixedHeight() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.fixed(height: 400.0).verify(view)
    }

    func testFixedSize() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.fixed(size: CGSize(width: 500.0, height: 500.0)).verify(view)
    }
    
    func testDynamicSize() {
        let view = UIView.makeViewWithPinnedLabel()
        snapshot.sizeToFit().verify(view)
    }
}


extension UIView {
    
    static func makeViewWithPinnedLabel() -> UIView {
        return makeViewWithPinnedLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ac velit bibendum, pulvinar ligula a, luctus diam. Quisque ipsum sapien, suscipit eu lacus vitae, porttitor dapibus nulla. Donec eu lectus porttitor, aliquam magna suscipit, ullamcorper dui. Mauris ipsum ligula, lacinia id fermentum non, vestibulum sed dui. Donec aliquam ante vel massa convallis, eget feugiat urna viverra. Maecenas in tortor eget tortor porttitor volutpat feugiat ac purus. Fusce blandit fermentum massa, vitae euismod velit bibendum a. In arcu turpis, viverra aliquam lacus ac, pharetra porttitor purus. Morbi semper mi dapibus lorem aliquam, semper tincidunt arcu ultricies. Phasellus tristique nisi at dolor pulvinar commodo. Nullam mattis diam id vestibulum ultricies. Sed nec tellus condimentum, pretium felis non, vehicula libero. Duis ut sagittis sapien, sit amet fermentum lorem. Quisque ac mauris tortor. Nulla facilisi. Etiam vestibulum tempor arcu, ut malesuada dui porttitor at.\n\nPellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque fermentum urna enim, sit amet commodo massa fringilla eget. Suspendisse efficitur scelerisque dignissim. Nullam accumsan nisi dui, at placerat felis ultrices id. Sed aliquam malesuada nulla nec luctus. In a erat sit amet lacus fringilla cursus lobortis ac orci. Nunc eros orci, vestibulum dictum dui vitae, gravida semper diam. Suspendisse fringilla enim ac tortor posuere finibus. Pellentesque vulputate ante velit, ac vulputate purus bibendum gravida. Duis accumsan magna eget sem lacinia, nec iaculis eros pulvinar. Nunc non venenatis nisl. Mauris sed nunc gravida, vehicula ipsum rhoncus, ultricies lacus. Ut vel iaculis risus, at bibendum ligula. Nam ut massa dui. Nunc molestie nibh metus, ac convallis justo luctus ac. Morbi luctus aliquam urna at consectetur.\n\nDonec pellentesque consequat tempus. Integer ut arcu a augue rutrum sollicitudin ac et tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum mattis ullamcorper dolor. Sed at felis vel neque placerat sagittis. Donec suscipit facilisis justo sed malesuada. Nulla a faucibus quam. Vivamus fermentum euismod lacus ut pharetra. Phasellus sodales justo sit amet mollis condimentum. Ut vitae neque velit. Ut tempor eros in posuere feugiat. Sed at porttitor enim. Fusce commodo ultrices neque, et volutpat lectus gravida in.")
    }

    static func makeViewWithPinnedLabel(text: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        view.backgroundColor = .green
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let inset: CGFloat = 0.0
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        
        return view
    }
}
