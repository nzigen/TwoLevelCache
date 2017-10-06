//
//  TwoLevelCache.swift
//  Pods-TwoLevelCache_Example
//
//  Created by 澤良弘 on 2017/10/06.
//

import Foundation

open class TwoLevelCache<T: NSObject>: NSObject {
    
    public let name: String
    public var objectDecoder: ((Data) -> T)?
    public var objectEncoder: ((T) -> Data)?
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
    
    private func encodeFilePath(_ path: String) -> URL {
        let data: Data = path.data(using: .utf8)!
        let url = fileCacheDirectory
            .appendingPathComponent(data.base64EncodedString(options: [Data.Base64EncodingOptions.lineLength64Characters, Data.Base64EncodingOptions.endLineWithLineFeed]))
            .appendingPathExtension("cache")
        return url
    }
    
    private func loadFromFileCacheOfKey(_ key: String, callback: @escaping (T?) -> Void) {
        queue.async {
            let url = self.encodeFilePath(key)
            let data = try? Data(contentsOf: url)
            if let data = data {
                callback(self.objectDecoder?(data))
            } else {
                callback(nil)
            }
        }
    }
}
