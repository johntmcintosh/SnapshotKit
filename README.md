# SnapshotKit

<!--[![CocoaPods compatible](https://img.shields.io/cocoapods/v/SnapshotKit.svg)](#cocoapods)-->
<!--[![CocoaPods](https://img.shields.io/cocoapods/dt/SnapshotKit.svg)]()-->
<!--[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)-->
[![Build Status](https://travis-ci.org/johntmcintosh/SnapshotKit.svg?branch=master)](https://travis-ci.org/johntmcintosh/SnapshotKit)
![CodeCov](https://img.shields.io/codecov/c/github/johntmcintosh/SnapshotKit.svg)
![Swift 3.1.0](https://img.shields.io/badge/Swift-3.1.0-orange.svg)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

## Why SnapshotKit?

SnapshotKit provides a set of wrappers around [FBSnapshotTestCase](https://github.com/facebook/ios-snapshot-test-case) to make it easier to test common use-cases for iOS apps.

## Work in Progress

This project is currently in an early state and the public interface is likely to change as it matures. Please provide and feedback or suggestions on what would work best for your use-case.

In particular, the projects I have been using this with so far are iPhone-only, so I have not yet added a built-in interface iPad sized screenshots.

I'd also like to provide a better interface for specifying which devices sizes you care about. For example, for apps supporting iOS 10 and later, there's really no need to be running screenshot tests against the iPhone 4s device size, although that size is still included with `allPhoneSizes` right now. Potentially this would look something like adding the ability to say `snapshot.registerSizes([.iPhone5, .iPhone6, .iPhone6plus])` from the test class's `setUp`. 

I'm not convinced that I'm satisfied with the naming convention of the screenshots that are currently generated, and need to evaluate whether additional controls need to be exposed for overriding the defualt behavior of screenshot naming.

## Installing SnapshotKit
<!--[![CocoaPods compatible](https://img.shields.io/cocoapods/v/SnapshotKit.svg)](#cocoapods)-->

The easiest way to install SnapshotKit is with [CocoaPods](https://github.com/cocoapods/cocoapods):

Once I get a little further along, I'll officially publish to the pod repo, but for now you can point directly to this repo.

```Ruby
pod 'SnapshotKit', :git => 'git@github.com:johntmcintosh/SnapshotKit.git', :branch => 'master'
```

## Overview

Make your test class a subclass of `SnapshotKitTestCase` and you will have access to a new `snapshot` property on the test class. This contains an instance of `SnapshotKitTestController` which provides the wrappers for the snapshot tests.

```swift
let view = CustomView()

// Basic usage
snapshot.verify(view)

// Automatically test the view on all phone all phone sizes
snapshot.allPhoneSizes().verify(view)

// Test a view that's auto-sized to its content
snapshot.sizeToFit().verify(view)

// Test a fixed width with auto-expanding height
snapshot.fixed(width: 400.0).verify(view)

// Test a fixed height with auto-expanding width
snapshot.fixed(height: 400.0).verify(view)

// Test the view at a fixed size
snapshot.fixed(size: CGSize(width: 400.0, height: 200.0)).verify(view)
```

Also works with view controllers:

```swift
let vc = CustomViewController()

// Test a view controller
snapshot.allPhoneSizes().verify(vc)

// Test a view controller, but shorten by the height of a navigation bar
snapshot.allPhoneSizes().excludeNavigationBar().verify(vc)
```

## Usage

Start by making your test file a subclass of `SnapshotKitTestCase` rather than `FBSnapshotTestCase`.

```swift
@testable import MyApp
import SnapshotKit
import XCTest

class CustomViewTests: SnapshotKitTestCase {
    ...
}
```

Next, control the recording mode just as you do with FBSnapshotTestCase (SnapshotKitTestCase is a subclass of FBSnapshotTestCase).

```swift
override func setUp() {
    super.setUp()
    recordMode = true
}
```

Finally, write your test cases. In this example, 

```swift
func testStandardContent() {
    let view = CustomView.makeWithStandardContent()   
    snapshot.allPhoneSizes().excludeNavigationBar().verify(view)
}

func testExtremeOverflow() {
    let view = CustomView.makeWithOverflowContent()
    snapshot.allPhoneSizes().excludeNavigationBar().verify(view)
}
```

See [example of a full test file](https://github.com/johntmcintosh/SnapshotKit/blob/master/SnapshotKitTests/SnapshotKitTests.swift) and the [generated snapshots](https://github.com/johntmcintosh/SnapshotKit/tree/master/SnapshotKitTests/ReferenceImages_64/SnapshotKitTests.SnapshotKitTests).


## Tips

If I have something like a table cell that needs to be tested with the same configuration multiple times, I like to add an extension on `SnapshotKitTestController` to be able to quickly apply that configuration on all tests:

```swift
extension SnapshotKitTestController {    

    func feedItemSize() -> SnapshotKitTestController {
        return fixed(size: CGSize(width: 375.0, height: 51.0))
    }
}

class FeedItemViewTests: SnapshotKitTestCase {

    func testStandardContent() {
        let view = FeedItemView.makeWithStandardContent()   
        snapshot.feedItemSize().verify(view)
    }

    func testImageContent() {
        let view = FeedItemView.makeWithImageContent()   
        snapshot.feedItemSize().verify(view)
    }
}
```

I have found it helpful to add some extensions to my test cases to remove some duplicate code from the cases themselves. For example, when I'll be using a similar view in multiple test cases, I'll add an extension on that view for generating the test instances.

```swift
extension CustomView {
    
    static func makeWithStandardContent() -> CustomView {
        let view = CustomView()
        view.text = "Lorem ipsum dolor."
        return view
    }
    
    static func makeWithOverflowContent() -> ScannerOverlayView {
        let view = CustomView()
        view.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis turpis eget elit porta efficitur at vel ante. Proin sit amet ipsum eget nibh varius accumsan eu ut leo."
        return view
    }
}
```

## Requirements

SnapshotKit requires iOS 9.0 or higher.


## Credits

SnapshotKit was created by [John McIntosh](http://twitter.com/johntmcintosh).

## License

SnapshotKit is available under the MIT license. See the LICENSE file for more info.
