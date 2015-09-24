
![image](https://raw.githubusercontent.com/zhuchaowe/EasyIOS/gh-pages/images/logo.png)

EasyIOS Swift 2.0版本新鲜出炉！ 
=======

[![Version](https://img.shields.io/cocoapods/v/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![License](https://img.shields.io/cocoapods/l/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![Platform](https://img.shields.io/cocoapods/p/EasyIOS-Swift.svg?style=flat)](http://cocoapods.org/pods/EasyIOS-Swift)
[![qq](http://img.shields.io/badge/QQ%E7%BE%A4-340906744-green.svg)](http://shang.qq.com/wpa/qunwpa?idkey=562d002e275a8199081313b00580fb7111a4faf694216a239064d29f5238bc91)

## Star不可少啊！

* [IOSX - EasyIOS官方论坛](http://www.iosx.me)
* [EasyIOS-ObjC版本](https://github.com/EasyIOS/EasyIOS)
* [EasyIOS-Swift教程](http://zhuchaowe.gitbooks.io/easyios-swift/content/)

## DEMO Video
[![ScreenShot](http://g3.tdimg.com/0d239f40817111df0dfe941cbc6f9d5e/b0_2.jpg)](http://www.tudou.com/v/aWwPwUhdt5E/&rpid=6059352&resourceId=6059352_04_05_99/v.swf)

## 新版特性

* MVVM : `Model-View-ViewModel` 实现代码分离，分离ViewController中的大量逻辑代码，解决ViewController承担了过多角色而造成的代码质量低下。增加视图与模型的绑定特性。 
* HTML To Native : 利用类似HTML的语言来对UI进行布局，简单易学，可重用
* DataBinding : 采用了第三方库`SwiftBond`,可以实现数据绑定操作，同样HTML里也可以进行数据绑定操作，识别标签是双大括号比如`{{title}}`
* Reflect Cocoa Touch : 可以反射所有Cocoa Touch中UIKit的所有属性，目前实现了一部分，后面大家一起来维护，增加更多API
* AutoLayout : 在HTML进行`Autolayout`布局，真的很简单！
* Live Load : 在模拟器中运行app，在修改HTML之后进行保存，模拟器中会自动更新UI布局，不需要重新编译APP
* Cryptographic HTML : 为了保证HTML代码的安全，我们提供了`AES Encryption`对HTML进行加密
* URLManager : 我们可以利用URL来push或者present一个视图
* Elegant PullToRefresh : 可以利用HTML轻松的添加下拉刷新和上拉加载控件

## HTML To Native

* UITableView With PullReflash
* `align`,`margin` 来控制UIView的布局
* `pull-to-refresh="handlePullRefresh." `,`infinite-scrolling="handleInfinite. PullFooter"` 来添加下拉刷新和上拉加载
* `handlePullRefresh.` handle the event by `func handlePullRefresh (tableView:UITableView)` ,you can define it by yourself.
* `PullFooter` can load the custom PullReflashView 

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
* Use the CSS by `@` for example `@contentAlign`.

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

* HTML Label and reusable html
* `@import(LabelHtml)` to import the `LabelHtml.xml` 
*  When span set `style="color:#ACACAC;font-size:18px;"` node ,we can use the origin html inner the span tag.

```HTML
<style>
<!--支持css 样式设置，html中利用@的方式进行调用-->
.contentAlign{
edge:0 0 0 0;left:0 root;right:0 root;
}
</style>

<body>
<div align="0 0 0 0" type="UIScrollView" background-color="#F3F3F3">
<div align="@contentAlign">
<!--span标签设置了style属性则启用富文本模式，span内部可以支持原生HTML的所有属性，具体请看LabelHtml.xml文件-->
<span align="64 0 0 0" style="color:#ACACAC;font-size:18px;" link-style="color:green;" number-of-lines="0">
<!--import the xml -->
@import(LabelHtml)
</span>
</div>
</div>
</body>
```


* UICollectionView with FlowLayout

```HTML
<body>
<div id="collectionView" align="0 0 0 0" type="UICollectionView" flow-layout="scroll-direction:Vertical;item-size:{300,50};section-inset:{3,3,0,3};minimum-interitem-spacing:3;minimum-line-spacing:3" content-inset="{64,0,0,0}" background-color="white" pull-to-refresh="handlePullRefresh." infinite-scrolling="handleInfinite.">
<div align="0 0 0 0" type="cell"  id="cell"  background-color="red">
<span align="10 10 -10 -10" font="10 system">{{name}}</span>
</div>
</div>
</body>
```


## MVVM

The MVVM based on the Swift binding framework [SwiftBond](https://github.com/SwiftBond/Bond)

Bond is a Swift binding framework that takes binding concept to a whole new level - boils it down to just one operator. It's simple, powerful, type-safe and multi-paradigm - just like Swift.


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
pod "EasyIOS-Swift" :git => 'https://github.com/EasyIOS/EasyIOS-Swift'
```

import the EasyIOS

```swift
import EasyIOS
```
## Author

zhuchao, zhuchao@iosx.me

## License

EasyIOS-Swift is available under the MIT license. See the LICENSE file for more info.
