import UIKit
import XCTest
import TwoLevelCache

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let cache = try? TwoLevelCache<UIImage>("cache")
        XCTAssertNotNil(cache)
    }
    
    func testLoadWithDownloaderOrCaches() {
        let cache = try! TwoLevelCache<UIImage>("cache")
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
        let expectation0 =
            self.expectation(description: "downloading an image")
        let expectation1 =
            self.expectation(description: "finding an image from memory cache")
        let expectation2 =
            self.expectation(description: "finding an image from file cache")
        let url = "https://nzigen.com/static/img/common/logo.png?v=\(Date().timeIntervalSince1970)"
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
}
