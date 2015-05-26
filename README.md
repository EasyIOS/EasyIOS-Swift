
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

## HTML To Native
* UITableView With PullReflash

```HTML
<body>
    <div id="tableview" align="64 0 0 0" content-inset="{0,0,0,0}" type="UITableView"  estimated-row-height="100"  separator-style="None" pull-to-refresh="handlePullRefresh." infinite-scrolling="handleInfinite. PullFooter">
        <div align="0 0 0 0" type="cell" id="cell" >
            <img id="avatar" align="10 10 -10 *" clips-to-bounds="YES" width="45" height="45" layer_corner-radius="5" src="{{srcUrl}}" />
            <span align="top:2 avatar;right:-10" margin="left:12 avatar"  font="15 system" id="title">{{title}}</span>
            <span align="bottom:0 avatar;right:-10" margin="left:12 avatar" font="13 system" text-color="#ACACAC" id="subTitle" style="color:#ACACAC;" link-style="color:green;" >{{subTitle}}</span>
        </div>
        <div type="section" id="bgView" background-color="#F2F1F6" >
            <span align="left:15;center-y:0" font="14 system">{{title}}</span>
        </div>
    </div>
</body>
```

* UIScrollView With CSS
```HTML
<style>
    .contentAlign{
    edge:0 0 0 0;left:0 root;right:0 root;
    }
    .inputStyle{
    font-size:15;color:#999999;
    }
</style>
<body>
    <div align="0 0 0 0" type="UIScrollView" background-color="#F3F3F3">
        <div align="@contentAlign">
            <img id="logo" image="login-logo" user-interaction-enabled="YES" present="demo://login" align="center-x:0;top:110;"/>
            <div id="username" layer_corner-radius="8" background-color="white" align="* 15 * -15" margin="top:30 logo" height="45">
                <input class="userTextField" id="userTextField" align="edge:10 10 -10 -10;" placeholder-style="@inputStyle" keyboard-type="EmailAddress" style="@inputStyle" placeholder="上面的logo可以被点击"/>
            </div>
            <div id="password" layer_corner-radius="8" background-color="white" align="* 15 * -15" margin="top:13 username" height="45">
                <input id="passwordTextField" secure-text-entry="YES" align="10 10 -10 -10" placeholder="密码" placeholder-style="@inputStyle" style="@inputStyle" />
            </div>
            <button id="submit" style="color:white;font-size:20;" background-color="#3FBCFB" align="* 15 -10 -15" margin="top:25 password" height="45" layer_corner-radius="8" onEvent="touch-up-inside:login">登陆</button>
        </div>
    </div>
</body>
```

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
pod "EasyIOS-Swift"
```

import the EasyIOS

```swift
import EasyIOS
```
## Author

zhuchao, zhuchao@iosx.me

## License

EasyIOS-Swift is available under the MIT license. See the LICENSE file for more info.
