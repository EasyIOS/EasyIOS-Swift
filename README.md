
![image](https://raw.githubusercontent.com/zhuchaowe/EasyIOS/gh-pages/images/logo.png)

EasyIOS For Swift
=======

[![Version](https://img.shields.io/cocoapods/v/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![License](https://img.shields.io/cocoapods/l/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![Platform](https://img.shields.io/cocoapods/p/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![qq](http://img.shields.io/badge/QQ%E7%BE%A4-340906744-green.svg)](http://shang.qq.com/wpa/qunwpa?idkey=562d002e275a8199081313b00580fb7111a4faf694216a239064d29f5238bc91)

## Star is the Best Way to Support EasyIOS !

* [IOSX - EasyIOS Official Forum](http://www.iosx.me)
* [EasyIOS-ObjC](https://github.com/EasyIOS/EasyIOS)

## Features

* MVVM : `Model-View-ViewModel` inspired by [Functional Reactive Programming](http://en.wikipedia.org/wiki/Functional_reactive_programming) 
* HTML To Native : Transform HTML&CSS to Native Control,
* Reflect Cocoa Touch : Reflect all the Cocoa Touch Api ,we can use the Cocoa Touch Api via HTML 
* AutoLayout : The HTML layout based on the `AutoLayout`
* Live Load : Edit the HTML and the view in smulator will update automaticly without rebuild your app
* Cryptographic HTML : To make the HTML be safety,we provide the `AES Encryption` to encrypt the HTML
* URLManager : Push or Present the Controller by the custom URL 
* Elegant PullToRefresh : Add  PullToRefresh or InfiniteScrolling by HTML

## Usage

To run the example project, clone the repo, and run `pod install` from the Demo directory first.

## Requirements

* Swift
* IOS8

## Installation

EasyIOS-Swift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!
pod "EasyIOS-Swift", :git => "https://github.com/EasyIOS/EasyIOS-Swift"
```

import the EasyIOS

```swift
import EasyIOS
```
## Author

zhuchao, zhuchao@iosx.me

## License

EasyIOS-Swift is available under the MIT license. See the LICENSE file for more info.
