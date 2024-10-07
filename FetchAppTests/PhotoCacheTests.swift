import XCTest

@testable import FetchApp

final class PhotoCacheTests: XCTestCase {
    var photoCache: PhotoCache!
    var mockService: MockService!
    
    override func setUp() {
        super.setUp()
        mockService = MockService()
        photoCache = PhotoCache(service: mockService)
    }
    
    override func tearDown() {
        photoCache = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_getPhoto() async {
        let cutePuppiesURLString = "https://tinyurl.com/2emu8me3"
        
        // Given
        do {
            if let photo = try await mockService.getPhoto(from: cutePuppiesURLString) {
                
                // When
                photoCache.cache.setObject(photo, forKey: cutePuppiesURLString as NSString)
                let cachedPhoto = try await photoCache.getPhoto(from: cutePuppiesURLString)
                
                // Then
                XCTAssertNotNil(cachedPhoto)
                XCTAssertEqual(cachedPhoto, photo)
            }
        }
        catch {
            XCTFail("Test failed: \(error)")
        }
    }
}
