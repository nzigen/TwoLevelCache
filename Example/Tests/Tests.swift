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
        // This is an example of a functional test case.
        var cache: TwoLevelCache<UIImage>!
        do {
            cache = try TwoLevelCache<UIImage>("cache")
        } catch {
            
        }
        XCTAssertEqual(cache.name, "cache")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
