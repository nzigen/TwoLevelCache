//
//  TwoLevelCache.swift
//  Pods-TwoLevelCache_Example
//
//  Created by 澤良弘 on 2017/10/06.
//

import Foundation

open class TwoLevelCache<T: NSObject>: NSObject {
    public typealias Callback = () -> Void
    public typealias ObjectCallback = (T?) -> Void
    public var downloader: ((String) -> Data?)!
    public let name: String
    public var objectDecoder: ((Data) -> T?)!
    public var objectEncoder: ((T) -> Data?)!
    let fileCacheDirectory: URL
    let fileManager = FileManager()
    let memoryCache = NSCache<NSString, T>()
    let queue = DispatchQueue(label: "com.nzigen.TwoLevelCache.queue", attributes: .concurrent)

    public init(_ name: String) throws {
        self.name = name
        self.memoryCache.name = name
        
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        fileCacheDirectory = url.appendingPathComponent("com.nzigen.TwoLevelCache/\(name)")
        
        try fileManager.createDirectory(at: fileCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func loadObjectForKey(_ key: String, callback: @escaping ObjectCallback) {
        queue.async {
            let keyString = key as NSString
            if let object = self.memoryCache.object(forKey: keyString) {
                callback(object)
                return
            }
            let url = self.encodeFilePath(key)
            let data = try? Data(contentsOf: url)
            if let data = data {
                if let object = self.objectDecoder(data) {
                    callback(object)
                    self.memoryCache.setObject(object, forKey: keyString)
                    return
                }
            }
            if let data = self.downloader(key) {
                if let object = self.objectDecoder(data) {
                    callback(object)
                    self.saveObject(object, forMemoryCacheKey: key)
                    self.saveData(data, forFileCacheKey: key)
                    return
                }
            }
            callback(nil)
        }
    }
    
    public func removeAllObjects(callback: Callback?) {
        queue.async {
            self.memoryCache.removeAllObjects()
            let urls = try? self.fileManager.contentsOfDirectory(at: self.fileCacheDirectory, includingPropertiesForKeys: nil, options: [])
            urls?.forEach({ (url) in
                try? self.fileManager.removeItem(at: url)
            })
            callback?()
        }
    }
    
    public func saveData(_ data: Data, forFileCacheKey key: String) {
        let url = self.encodeFilePath(key)
        try? data.write(to: url)
    }
    
    public func saveData(_ data: Data, forMemoryCacheKey key: String) {
        if let object = objectDecoder(data) {
            memoryCache.setObject(object, forKey: key as NSString)
        } else {
            memoryCache.removeObject(forKey: key as NSString)
        }
    }
    
    public func saveData(_ data: Data, forKey key: String) {
        saveData(data, forMemoryCacheKey: key)
        saveData(data, forFileCacheKey: key)
    }
    
    public func saveObject(_ object: T, forFileCacheKey key: String) {
        let url = self.encodeFilePath(key)
        if let data = self.objectEncoder(object) {
            try? data.write(to: url)
        } else {
            try? self.fileManager.removeItem(at: url)
        }
    }
    
    public func saveObject(_ object: T, forMemoryCacheKey key: String) {
        memoryCache.setObject(object, forKey: key as NSString)
    }
    
    public func saveObject(_ object: T, forKey key: String) {
        saveObject(object, forMemoryCacheKey: key)
        saveObject(object, forFileCacheKey: key)
    }
    
    private func encodeFilePath(_ path: String) -> URL {
        let data: Data = path.data(using: .utf8)!
        let url = fileCacheDirectory
            .appendingPathComponent(data.base64EncodedString(options: [Data.Base64EncodingOptions.lineLength64Characters, Data.Base64EncodingOptions.endLineWithLineFeed]))
            .appendingPathExtension("cache")
        return url
    }
}
