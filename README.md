# TwoLevelCache

[![CI Status](http://img.shields.io/travis/Yoshihiro%20Sawa/TwoLevelCache.svg?style=flat)](https://travis-ci.org/Yoshihiro Sawa/TwoLevelCache)
[![Version](https://img.shields.io/cocoapods/v/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)
[![License](https://img.shields.io/cocoapods/l/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)
[![Platform](https://img.shields.io/cocoapods/p/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)

Customizable two-level cache for iOS (Swift). Level 1 is memory powered by NSCache and level 2 is filesystem which uses NSCachesDirectory.

All cache data are managed by OS level. Then you should not consider the number of objects and the usages of memory or storage.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TwoLevelCache is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TwoLevelCache'
```

## Author

Yoshihiro Sawa, yoshihirosawa at gmail.com

## License

TwoLevelCache is available under the MIT license. See the LICENSE file for more info.
