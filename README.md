# GitIt

<p align="center">
<img src="Screenshots/Banner.jpeg" width="600">
<br/>
GitIt is GitHub client iOS app with search and trending features.
<br/>
Written in Swift and MVVM architecture.
</p>

<p align="center">
    <a href="https://github.com/loay-ashraf/GitIt/actions/workflows/iosCI.yml">
        <img src="https://img.shields.io/github/workflow/status/loay-ashraf/GitIt/iOS%20CI">
    </a>
    <a href="https://github.com/loay-ashraf/GitIt/releases">
    <img src="https://img.shields.io/github/v/release/loay-ashraf/GitIt" alt="Version">
    </a>
    <img src="https://img.shields.io/github/release-date/loay-ashraf/GitIt">
    <a href="https://en.wikipedia.org/wiki/Model–view–viewmodel">
        <img src="https://img.shields.io/badge/architecture-MVVM-brightgreen">
    </a>
    <img src="https://img.shields.io/badge/swift-5.5-orange">
    <img src="https://img.shields.io/badge/iOS-13.0%2B-black">
</p>


|         | Features  |
----------|-----------------
:mag: | Search Users, Repositories and Organizations
:fire: | Explore Trending Repositories
:bookmark: | Save your Bookmarks for later
:walking: | Guest Mode
:zap: | Native Markdown Rendering 
:new_moon_with_face: | Dark Theme Support
:saudi_arabia: | Full Arabic (RTL Languages) Support
:octocat: | 100% Open source

## Screenshots

<p align="center">
<img src="Screenshots/Welcome Screen-Light.png" width="200" height="433">
</p>
<p align="center">
<img src="Screenshots/Home-Light.png" width="200" height="433">
<img src="Screenshots/Trending-Light.png" width="200" height="433">
<img src="Screenshots/Profile-Light.png" width="200" height="433">
<img src="Screenshots/Settings-Light.jpeg" width="200" height="433">
<img src="Screenshots/Bookmarks-Light.png" width="600" height="433">
</p>
<p align="center">
<img src="Screenshots/Users-Light.png" width="200" height="433">
<img src="Screenshots/Repositories-Light.png" width="200" height="433">
<img src="Screenshots/Organizations-Light.png" width="200" height="433">
</p>
<p align="center">
<img src="Screenshots/User Search-Light.png" width="200" height="433">
<img src="Screenshots/Repository Search-Light.png" width="200" height="433">
<img src="Screenshots/Organization Search-Light.png" width="200" height="433">
</p>
<p align="center">
<img src="Screenshots/Dark Theme.png" width="1400" height="433">
</p>
<p align="center">
<img src="Screenshots/Arabic Support.png" width="1400" height="433">
</p>


## Demo Video

[![GitIt V1 Demo](https://img.youtube.com/vi/wO6qcbHDJiQ/maxresdefault.jpg)](https://www.youtube.com/watch?v=wO6qcbHDJiQ)

## Installation

### Clone the Repository

```sh
git clone https://github.com/loay-ashraf/GitIt
```

### Install Required pods

```sh
cd GitIt
pod install
```

### (Optionally) Change Client ID and Secret to yours

go to ` GitIt > Commons > Model > Constants > Constants.swift `

```sh
ClientID = "YOUR CLIENT ID GOES HERE"
ClientSecret = "YOUR CLIENT SECRET GOES HERE"
```

## TODOs

### Networking
* use MOYA??

### Reactive 
* use RXSwift bindings

### Features
* Issues
* Pull Requests

## References

#### API
* [GitHub REST API v3](https://developer.github.com/v3/)

#### Third Party Libraries
* [AlamoFire](https://github.com/Alamofire/Alamofire)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [RealmSwift](https://github.com/realm/realm-swift)
* [InAppSettingsKit](https://github.com/futuretap/InAppSettingsKit)
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
* [SkeletonView](https://github.com/Juanpe/SkeletonView)
* [NotificationBannerSwift](https://github.com/Daltron/NotificationBanner)
* [MarkdownView](https://github.com/keitaoouchi/MarkdownView)

### Tools
* Xcode 13.2
* iPhone 12 Simulator (iOS 14.5)

