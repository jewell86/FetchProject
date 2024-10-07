import XCTest
@testable import FetchApp

class ServiceTests: XCTestCase {
    var service: Service!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        service = Service(session: mockURLSession)
    }
    
    override func tearDown() {
        service = nil
        mockURLSession = nil
        
        super.tearDown()
    }
    
    func test_getRecipes() async throws {
        let mockData = """
        {
            "recipes": [
                {
                    "name": "Chocolate Cake",
                    "cuisine": "Dessert"
                }
            ]
        }
        """.data(using: .utf8)
        
        let recipesResponse = mockData
        mockURLSession.data = recipesResponse
        
        do {
            let recipes = try await service.getRecipes()
            
            XCTAssertEqual(recipes.count, 1)
        } catch {
            XCTFail("Test failed: \(error)")
        }
    }
    
    // TODO: create photo service tests
    func test_getPhotoSuccess() async throws { }
    
    func test_getPhotoFailure() async throws { }
}
