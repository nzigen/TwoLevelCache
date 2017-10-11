# TwoLevelCache

[![CI Status](http://img.shields.io/travis/ysawa/TwoLevelCache.svg?style=flat)](https://travis-ci.org/ysawa/TwoLevelCache)
[![Version](https://img.shields.io/cocoapods/v/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)
[![License](https://img.shields.io/cocoapods/l/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)
[![Platform](https://img.shields.io/cocoapods/p/TwoLevelCache.svg?style=flat)](http://cocoapods.org/pods/TwoLevelCache)

Customizable two-level cache for iOS (Swift). Level 1 is memory powered by NSCache and level 2 is filesystem which uses NSCachesDirectory.

All cache data are managed by OS level. Then you don't have to consider the number of objects and the usage of memory or storage.

## Usage

You can make an effective PNG cache with downloader as follows:

```swift
let cache = try! TwoLevelCache<UIImage>("effective-png-cache")
cache.downloader = { (key, callback) in
    let url = URL(string: key)!
    URLSession.shared.dataTask(with: url) { data, response, error in
        callback(data)
    }.resume()
}
cache.deserializer = { (data) in
    return UIImage(data: data)
}
cache.serializer = { (object) in
    return UIImagePNGRepresentation(object)
}

cache.findObject(forKey: "https://nzigen.com/static/img/common/logo.png") { (image, status) in
    DispatchQueue.main.sync {
        imageView.image = image
    }
}
```

### TwoLevelCacheHitStatus

You can use enum TwoLevelCacheHitStatus to know how the object has been found.

```swift
.memory  // Level 1 (NSCache)
.file  // Level 2 (NSCachesDirectory)
.downloader  // Cache miss (your device has downloaded the object)
.error  // All caches return nil and downloading data has been failed
```

### removing caches

System will remove unused resources automatically. However, you can also remove caches as follows:

```swift
cache.removeAllObjects()
cache.removeObject(forKey: "https://nzigen.com/static/img/common/logo.png")
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TwoLevelCache is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TwoLevelCache'
```

## Author

Yoshihiro Sawa (Nzigen, Inc), yoshihirosawa at gmail.com

## License

TwoLevelCache is available under the MIT license. See the LICENSE file for more info.
