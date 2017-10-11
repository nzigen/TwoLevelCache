import UIKit
import XCTest
import TwoLevelCache

fileprivate let TestsSampleImagePath = "1x1.png"
fileprivate let TestsSampleImageUrl = "https://nzigen.com/static/img/common/logo.png"

class Tests: XCTestCase {
    
    func testFindingWithDownloaderOrCaches() {
        let cache = generateImageCache()
        let expectation0 =
            self.expectation(description: "downloading an image")
        let expectation1 =
            self.expectation(description: "finding an image from memory cache")
        let expectation2 =
            self.expectation(description: "finding an image from file cache")
        let url = TestsSampleImageUrl + "?v=\(Date().timeIntervalSince1970)"
        cache.findObject(forKey: url) { (image, status) in
            XCTAssertNotNil(image)
            XCTAssertEqual(status, TwoLevelCacheLoadStatus.downloader)
            expectation0.fulfill()
            cache.findObject(forKey: url) { (image, status) in
                XCTAssertNotNil(image)
                XCTAssertEqual(status, TwoLevelCacheLoadStatus.memory)
                expectation1.fulfill()
                cache.removeObject(forMemoryCacheKey: url)
                cache.findObject(forKey: url) { (image, status) in
                    XCTAssertNotNil(image)
                    XCTAssertEqual(status, TwoLevelCacheLoadStatus.file)
                    expectation2.fulfill()
                }
            }
        }
        wait(for: [expectation0, expectation1, expectation2], timeout: 30)
    }
    
    func testInitialization() {
        let cache = try? TwoLevelCache<UIImage>("cache")
        XCTAssertNotNil(cache)
    }
    
    func testRemovingCaches() {
        let cache = generateImageCache()
        let expectation0 =
            self.expectation(description: "downloading an image")
        let url = TestsSampleImageUrl + "?v=\(Date().timeIntervalSince1970)"
        cache.findObject(forKey: url) { (image, status) in
            XCTAssertNotNil(image)
            XCTAssertEqual(status, TwoLevelCacheLoadStatus.downloader)
            sleep(1)
            cache.removeObject(forMemoryCacheKey: url)
            XCTAssertNil(cache.object(forMemoryCacheKey: url))
            XCTAssertNotNil(cache.object(forFileCacheKey: url))
            cache.removeObject(forFileCacheKey: url)
            XCTAssertNil(cache.object(forMemoryCacheKey: url))
            XCTAssertNil(cache.object(forFileCacheKey: url))
            expectation0.fulfill()
        }
        wait(for: [expectation0], timeout: 30)
    }
    
    func testRemovingObjects() {
        let cache = generateImageCache()
        let expectation0 =
            self.expectation(description: "downloading an image")
        let url = TestsSampleImageUrl + "?v=\(Date().timeIntervalSince1970)"
        cache.findObject(forKey: url) { (image, status) in
            XCTAssertNotNil(image)
            XCTAssertEqual(status, TwoLevelCacheLoadStatus.downloader)
            sleep(1)
            cache.removeObject(forKey: url)
            XCTAssertNil(cache.object(forMemoryCacheKey: url))
            XCTAssertNil(cache.object(forFileCacheKey: url))
            expectation0.fulfill()
        }
        wait(for: [expectation0], timeout: 30)
    }
    
    func testSettingData() {
        let cache = generateImageCache()
        let image = UIImage(named: TestsSampleImagePath)!
        cache.setData(UIImagePNGRepresentation(image)!, forKey: TestsSampleImagePath)
        let memoryCached = cache.object(forMemoryCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(memoryCached)
        XCTAssertEqual(memoryCached!.size, image.size)
        let fileCached = cache.object(forFileCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(fileCached)
        XCTAssertEqual(fileCached!.size, image.size)
    }
    
    func testSettingDataForFileCache() {
        let cache = generateImageCache()
        let image = UIImage(named: TestsSampleImagePath)!
        cache.setData(UIImagePNGRepresentation(image)!, forFileCacheKey: TestsSampleImagePath)
        let memoryCached = cache.object(forMemoryCacheKey: TestsSampleImagePath)
        XCTAssertNil(memoryCached)
        let fileCached = cache.object(forFileCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(fileCached)
        XCTAssertEqual(fileCached!.size, image.size)
    }
    
    func testSettingDataForMemoryCache() {
        let cache = generateImageCache()
        let image = UIImage(named: TestsSampleImagePath)!
        cache.setData(UIImagePNGRepresentation(image)!, forMemoryCacheKey: TestsSampleImagePath)
        let memoryCached = cache.object(forMemoryCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(memoryCached)
        XCTAssertEqual(memoryCached!.size, image.size)
        let fileCached = cache.object(forFileCacheKey: TestsSampleImagePath)
        XCTAssertNil(fileCached)
    }
    
    func testSettingObjects() {
        let cache = generateImageCache()
        let image = UIImage(named: TestsSampleImagePath)!
        cache.setObject(image, forKey: TestsSampleImagePath)
        let memoryCached = cache.object(forMemoryCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(memoryCached)
        XCTAssertEqual(memoryCached!.size, image.size)
        let fileCached = cache.object(forFileCacheKey: TestsSampleImagePath)
        XCTAssertNotNil(fileCached)
        XCTAssertEqual(fileCached!.size, image.size)
    }
    
    private func generateImageCache() -> TwoLevelCache<UIImage> {
        let cache = try! TwoLevelCache<UIImage>("test-cache")
        cache.downloader = { (key, callback) in
            let url = URL(string: key)!
            URLSession.shared.dataTask(with: url) { data, response, error in
                callback(data)
                }.resume()
        }
        cache.objectDecoder = { (data) in
            return UIImage(data: data)
        }
        cache.objectEncoder = { (object) in
            return UIImagePNGRepresentation(object)
        }
        cache.removeAllObjects()
        return cache
    }
}

extension Tests {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
